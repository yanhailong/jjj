---
---Create by Administrator
---DateTime: 2025-07-11 09:39:31
---
---@class FishPrawnCrabGameCtrl:BaseCtrl
local FishPrawnCrabGameCtrl=Class("FishPrawnCrabGameCtrl",BaseCtrl)
local FishPrawnCrabConfig = require("SingleGames/FishPrawnCrab/FishPrawnCrabConfig")
local FishPrawnCrabChipManager = require("SingleGames/FishPrawnCrab/FishPrawnCrabChipManager")
local SimulationServer = require("SingleGames/FishPrawnCrab/SimulationServer")
local Ease = CS.DG.Tweening.Ease

---构造函数
function FishPrawnCrabGameCtrl:ctor(ctrlName,param)
    self.layer=2;
    self.abName="SingleGames/FishPrawnCrab/prefabs/FishPrawnCrabGamePanel";
    self.prefabName="FishPrawnCrabGamePanel"
    self.super.ctor(self,ctrlName,param);
	---@type FishPrawnCrabGameView
	self.view = self.view
	---@type FishPrawnCrabGameModel
	self.model = self.model
end

---初始化
function FishPrawnCrabGameCtrl:CtrlInit(args)
	self.super.CtrlInit(self,args);
	self:InitData()
end

---初始化数据
function FishPrawnCrabGameCtrl:InitData()
	---当前选中的底注
	self.betIndex = 1;
	---当前是否可以下注
	self.allowBet = false
	---当前总底注
	self.totalBets = {0,0,0,0,0,0}
	---当前个人底注
	self.selfBets = {0,0,0,0,0,0}
	self.selfBetInfo = {}
	---玩家真实金币数量
	self.goldRealNum = 1000000000
	self.curStatus = FishPrawnCrabConfig.GameState.Bet
	---当前状态剩余秒数 13
	self.statusRemainingSeconds = 3

	---复投
	self.lastBetInfo = {}
	---本局是否使用了复投
	self.isRepeatBet = false
	---本局下注数据
	self.allBetData = {{}, {}, {}, {}, {}, {}}
	self.lookOnBetData = {{}, {}, {}, {}, {}, {}}
	self.recordData = {}
	
	self.view.selfPlayer:UpdatePlayer({ id = FishPrawnCrabConfig.selfTestPlayerId, coin = self.goldRealNum})
	
	--刷新底注界面
	self.view:UpdateBetBtnStatus()
	self.view:ChangeAnte(self.betIndex)
	self.view:UpdateTotalBetAreaInfo(-1)
	self.view:UpdateSelfBetAreaInfo(-1)
end

---刷新菜单显示隐藏
function FishPrawnCrabGameCtrl:RefreshMenuShow()
	if self.view.btn_touch.gameObject.activeSelf then
		self.view.trans_menu_panel:DOLocalMoveY(self.view.trans_menu_panel.sizeDelta.y+100,0.5):SetEase(Ease.InBack)
		self.view.btn_touch.gameObject:SetActive(false)
	else
		self.view.trans_menu_panel:DOLocalMoveY(0,0.5):SetEase(Ease.OutBack)
		self.view.btn_touch.gameObject:SetActive(true)
	end

end

function FishPrawnCrabGameCtrl:Close()
    self.super.Close(self);
end

---添加UI事件
function FishPrawnCrabGameCtrl:AddUIEvent()
	self.uiEventListener:AddClick(self.view.btn_muen,function()
		self:RefreshMenuShow()
	end)
	self.uiEventListener:AddClick(self.view.btn_touch,function()
		self:RefreshMenuShow()
	end)
	self.uiEventListener:AddClick(self.view.btn_help,function()
		CtrlManager.SingleShow(CtrlNames.FishPrawnCrabHelp)
	end)
	self.uiEventListener:AddClick(self.view.btn_close,function()
		self:Close();
	end)
	self.uiEventListener:AddClick(self.view.btn_setting,function()
		look("打开设置界面")
	end)

	self.uiEventListener:AddClick(self.view.btn_players,function(obj)
		CtrlManager.SingleShow(CtrlNames.FishPrawnCrabPlayers)
	end)
	self.uiEventListener:AddClick(self.view.btn_1,function(obj)
		SimulationServer:StartServer()
	end)

	---压注按钮
	for i=1,#self.view.chipInfos do
		self.uiEventListener:AddClick(self.view.chipInfos[i].obj,function()
			if self.allowBet then
				self.view:ChangeAnte(i)
				--look("btn 抵住数值"..FishPrawnCrabGameConfig.dizhuNumArr[FishPrawnCrabGameConfig.anteIndex])
				---测试数据生成 龙虎和 对应前三个币
				--GlobalEvent.Notify("UPDATE_HIS_ITEMS",i)
			end
		end)
	end
	---下注区域
	for i=1,self.view.clickRect.childCount do
		self.uiEventListener:AddClick(self.view.clickRect:GetChild(i-1),function()
			self:OnClickCenterBetArea(i)
		end)
	end
	self.uiEventListener:AddClick(self.view.btn_repeat,function()
		if self:AllowRepeatBet() then
			self.isRepeatBet = true
			for i = 1, #self.lastBetInfo do
				if self.allowBet == false or self.curStatus ~= FishPrawnCrabConfig.GameState.Bet 
						or FishPrawnCrabConfig.betValuesArr[self.lastBetInfo[i].chip] > self.goldRealNum then
					break
				end

				--发送消息
				local betMsg = { playerid = self.view.selfPlayer.id,
								 area = self.lastBetInfo[i].area,
								 chip = self.lastBetInfo[i].chip }
				GlobalEvent.Notify(FishPrawnCrabConfig.GameEventName.REQUEST_BET, betMsg)
				--self:OnSelfBet(self.lastBetInfo[i])
				----飞筹码
				--FishPrawnCrabChipManager:AnimateChip(self.lastBetInfo[i].chip, self.view.selfPlayer.transform.position, self.view.betAreas[self.lastBetInfo[i].area])
			end
			self.view.btn_repeat.interactable = false
		end
	end)
end

---移除UI事件
function FishPrawnCrabGameCtrl:RemoveEvent()
	self.super.RemoveEvent(self);
end

--region UI事件方法

--endregion


---销毁UI
function FishPrawnCrabGameCtrl:RealCloseDestroy()
	self.super.RealCloseDestroy(self);
	FishPrawnCrabChipManager:Destroy()
	TimerManager.StopAllTimer(self)
	CorManager.StopAll(self)
	GlobalEvent.Notify(FishPrawnCrabConfig.GameEventName.STOP_SIMULATION_SERVER)
end

---进入到准备阶段
function FishPrawnCrabGameCtrl:SwitchToPrepareState(message)
	---当前总底注
	self.totalBets = {0,0,0,0,0,0}
	---当前个人底注
	self.selfBets = {0,0,0,0,0,0}
	self.selfBetInfo = {}
	self.allowBet = false
	self.allBetData = {{}, {}, {}, {}, {}, {}}
	self.lookOnBetData = {{}, {}, {}, {}, {}, {}}
	self.curStatus = FishPrawnCrabConfig.GameState.Prepare
	--重置筹码数据
	self.view.selfPlayer:ResetBetData()
	for i = 1, #self.view.AllOtherPlayerHeads do
		self.view.AllOtherPlayerHeads[i]:ResetBetData()
	end
	--筹码是否回收完
	local chipsArr = FishPrawnCrabChipManager:GetChipArr()
	if #chipsArr > 0 then
		logError("筹码未回收完")
		FishPrawnCrabChipManager:CleanAllChipAnim()
		FishPrawnCrabChipManager:CleanChip()
	end
	
	self.view:UpdateTotalBetAreaInfo(-1)
	self.view:UpdateSelfBetAreaInfo(-1)
	self.view.btn_repeat.interactable = false
	self.view:UpdateBetBtnStatus()

	--tip
	self.view.tipsStartToBet:SetActive(false)
	self.view.tipsStopBetting:SetActive(false)

	--骰子
	self.view.diceBowl:SetActive(true)
	
	--倒计时
	self.view.colockStateTimePrepare:SetActive(true)
	self.view.colockStateTimeBet:SetActive(false)
	self.view.colockStateTimeSettlement:SetActive(false)
	self.view.colockStateTimeTrs.gameObject:SetActive(true)
	self.statusRemainingSeconds = message.remaining_time
	local timeInterval = 0.5
	TimerManager.StartTimer(self,function()
		self.statusRemainingSeconds = self.statusRemainingSeconds - timeInterval
		self.view.colockStateTimeNum.text = math.max(0, math.floor(self.statusRemainingSeconds + 0.1))
	end, timeInterval, math.floor(self.statusRemainingSeconds / timeInterval),true)
end

function FishPrawnCrabGameCtrl:AllowRepeatBet()
	local allReBet = false
	if self.allowBet and #self.lastBetInfo > 0 then
		-- 判断钱是否足够
		local lastBetAmount = 0
		for i = 1, #self.lastBetInfo do
			lastBetAmount = lastBetAmount + FishPrawnCrabConfig.betValuesArr[self.lastBetInfo[i].chip]
		end
		if lastBetAmount <= self.goldRealNum then
			allReBet = true
		end
	end
	
	return allReBet
end

---进入到下注阶段
function FishPrawnCrabGameCtrl:SwitchToBetState(message)
	self.curStatus = FishPrawnCrabConfig.GameState.Bet
	self.allowBet = true
	self.isRepeatBet = false

	self.view.btn_repeat.interactable = self:AllowRepeatBet()
	self.view:UpdateBetBtnStatus()
	
	--tip
	self.view.tipsStartToBet:SetActive(true)
	self.view.tipsStopBetting:SetActive(false)
	TimerManager.StartTimer(self,function()
		self.view.tipsStartToBet:SetActive(false)
	end,1.5,1,true)

	--倒计时
	self.view.colockStateTimePrepare:SetActive(false)
	self.view.colockStateTimeBet:SetActive(true)
	self.view.colockStateTimeSettlement:SetActive(false)
	self.view.colockStateTimeTrs.gameObject:SetActive(true)
	self.statusRemainingSeconds = message.remaining_time
	local timeInterval = 0.5
	TimerManager.StartTimer(self,function()
		self.statusRemainingSeconds = self.statusRemainingSeconds - timeInterval
		self.view.colockStateTimeNum.text = math.max(0, math.floor(self.statusRemainingSeconds + 0.1))
		--倒计时3s
		if math.abs(self.statusRemainingSeconds - 3) <= 0.1 then
			self.view.colockStateTimeTrs.gameObject:SetActive(false)
			self.view:PlayDaoJiShiEffect()
		end
	end, timeInterval, math.floor(self.statusRemainingSeconds / timeInterval),true)
end

---进入到结算阶段
function FishPrawnCrabGameCtrl:SwitchToSettlementState(message)
	self.curStatus = FishPrawnCrabConfig.GameState.Settlement
	self.allowBet = false
	self.lastBetInfo = self.selfBetInfo

	self.view.btn_repeat.interactable = false
	self.view:UpdateBetBtnStatus()

	self.view.three.gameObject:SetActive(false)

	--tip
	self.view.tipsStartToBet:SetActive(false)
	self.view.tipsStopBetting:SetActive(true)
	TimerManager.StartTimer(self,function()
		self.view.tipsStopBetting:SetActive(false)
	end,1.5,1,true)

	--倒计时
	self.view.colockStateTimeTrs.gameObject:SetActive(true)
	self.view.colockStateTimePrepare:SetActive(false)
	self.view.colockStateTimeBet:SetActive(false)
	self.view.colockStateTimeSettlement:SetActive(true)
	self.statusRemainingSeconds = message.remaining_time
	local timeInterval = 0.5
	TimerManager.StartTimer(self,function()
		self.statusRemainingSeconds = self.statusRemainingSeconds - timeInterval
		self.view.colockStateTimeNum.text = math.max(0, math.floor(self.statusRemainingSeconds + 0.1))
	end, timeInterval, math.floor(self.statusRemainingSeconds / timeInterval),true)
end

---游戏结算数据
function FishPrawnCrabGameCtrl:OnGameSettlementMsg(message)
	--{"dices":[2,4,6],
	--"dice_result":[{"odd":1,"anim_index":2},{"odd":1,"anim_index":4},{"odd":1,"anim_index":6}],
	--"win_info":[{"winAmount":6000,"win_info":[{"anim_index":2,"betAmount":1000,"oddAmount":1000},{"anim_index":4,"betAmount":1000,"oddAmount":1000},{"anim_index":6,"betAmount":1000,"oddAmount":1000}],"playerid":1314}]}
	if message == nil then
		return
	end 
	
	function isAreaWin(index)
		local isWin = false
		for i = 1, #message.dice_result do
			if index == message.dice_result[i].anim_index then
				isWin = true
				break
			end
		end
		
		return isWin
	end
	
	CorManager.StartCor(self, function()
		coroutine.wait(1.5)
		--播放骰子动画
		self.view.diceBowl:SetActive(true)
		coroutine.wait(1.5)
		--设置结果
		for i = 1, FishPrawnCrabConfig.diceCount do 
			local diceSideIndex = message.dices[i]
			self.view.diceTexts[i].text = FishPrawnCrabConfig.animalShowData[diceSideIndex].name
			local diceColor = FishPrawnCrabConfig.animalShowData[diceSideIndex].color
			self.view.diceTexts[i].color = Color.New(diceColor.r, diceColor.g, diceColor.b, diceColor.a)
		end
		self.view.diceBowl:SetActive(false)
		coroutine.wait(0.5)
		--高亮中奖区域
		for i = 1, #message.dice_result do
			local index = message.dice_result[i].anim_index
			self.view.winHighLights[index].gameObject:SetActive(true)
			Tools.DOFade_Repeat(self.view.winHighLights[index],0.2,3,0,function()
				self.view.winHighLights[index].gameObject:SetActive(false)
			end)
		end
		--添加记录
		self:AddNewRecord(message.dices)
		self:UpdateRecordUI()
		coroutine.wait(1)
		--回收筹码到荷官处
		for areaIndex = 1, FishPrawnCrabConfig.diceSideCount do
			if not isAreaWin(areaIndex) then
				local chipsArr = self.allBetData[areaIndex]
				--while #chipsArr > 0 do
				--	FishPrawnCrabChipManager:DestroyChipFly(chipsArr[#chipsArr], self.view.btn_dealer.transform.position)
				--	table.remove(chipsArr,#chipsArr)
				--end
				for chipIndex = 1, #chipsArr do
					FishPrawnCrabChipManager:DestroyChipFly(chipsArr[chipIndex], self.view.btn_dealer.transform.position)
				end
				chipsArr = {}
			end
		end
		
		coroutine.wait(2)
		--荷官赔下中的筹码到桌面上
		for playerIndex = 1, #message.win_info do
			local playerWinInfo = message.win_info[playerIndex]
			local targetChipArr = nil
			local targetPlayer = self.view:FindPlayer(playerWinInfo.playerid)
			if targetPlayer ~= nil then
				targetChipArr = targetPlayer.chipInfo
			else
				targetChipArr = self.lookOnBetData
			end
			
			for winIndex = 1, #playerWinInfo.win_info do
				local oddAmount = playerWinInfo.win_info[winIndex].oddAmount
				local winAreaIndex = playerWinInfo.win_info[winIndex].anim_index
				local chipList = self:GetChilIndexArrByAmount(oddAmount)
				for chipIndex = 1, #chipList do
					--飞筹码
					local newChipObj = FishPrawnCrabChipManager:AnimateChip(chipList[chipIndex], self.view.btn_dealer.transform.position, self.view.betAreas[winAreaIndex])
					table.insert(targetChipArr[winAreaIndex], newChipObj)
				end
			end
		end

		coroutine.wait(2)
		--把桌面上的筹码分到对应的人身上
		for areaIndex = 1, #message.dice_result do
			--自己
			local chipsArr = self.view.selfPlayer.chipInfo[message.dice_result[areaIndex].anim_index]
			--for chipIndex = 1, #chipsArr do
			--	FishPrawnCrabChipManager:DestroyChipFly(chipsArr[chipIndex], self.view.selfPlayer.transform.position)
			--end
			--chipsArr = {}
			CorManager.StartCor(self, function()
				for chipIndex = 1, #chipsArr do
					FishPrawnCrabChipManager:DestroyChipFly(chipsArr[chipIndex], self.view.selfPlayer.transform.position)
					if #chipsArr - chipIndex < 3 then
						coroutine.wait(0.2)
					end
				end
				chipsArr = {}
			end)
			--旁观的人
			local lookOnChipsArr = self.lookOnBetData[message.dice_result[areaIndex].anim_index]
			--for chipIndex = 1, #lookOnChipsArr do
			--	FishPrawnCrabChipManager:DestroyChipFly(lookOnChipsArr[chipIndex], self.view.btn_players.transform.position)
			--end
			--lookOnChipsArr = {}
			CorManager.StartCor(self, function()
				for chipIndex = 1, #lookOnChipsArr do
					FishPrawnCrabChipManager:DestroyChipFly(lookOnChipsArr[chipIndex], self.view.btn_players.transform.position)
					if #lookOnChipsArr - chipIndex < 3 then
						coroutine.wait(0.2)
					end
				end
				lookOnChipsArr = {}
			end)
			
			--座位上的人
			for playerIndex = 1, #self.view.AllOtherPlayerHeads do
				local otherPlayer = self.view.AllOtherPlayerHeads[playerIndex]
				local chipsArr = otherPlayer.chipInfo[message.dice_result[areaIndex].anim_index]
				--for chipIndex = 1, #chipsArr do
				--	FishPrawnCrabChipManager:DestroyChipFly(chipsArr[chipIndex], otherPlayer.transform.position)
				--end
				--chipsArr = {}
				CorManager.StartCor(self, function()
					for chipIndex = 1, #chipsArr do
						FishPrawnCrabChipManager:DestroyChipFly(chipsArr[chipIndex], otherPlayer.transform.position)
						if #chipsArr - chipIndex < 3 then
							coroutine.wait(0.2)
						end
					end
					chipsArr = {}
				end)
			end
		end
		
		coroutine.wait(2)
		--显示结果
		for playerIndex = 1, #message.win_info do
			local playerWinInfo = message.win_info[playerIndex]
			local targetChipArr = nil
			local targetPlayer = self.view:FindPlayer(playerWinInfo.playerid)
			if targetPlayer ~= nil then
				targetPlayer:ShowResultCount(playerWinInfo.winAmount)
			end
		end
	end)
end

function FishPrawnCrabGameCtrl:AddNewRecord(dices)
	if dices ~= nil and #dices == FishPrawnCrabConfig.diceCount then
		--删除多余的记录
		while #self.recordData >= FishPrawnCrabConfig.showRecordCount do
			table.remove(self.recordData, 1)
		end
		
		--添加新的记录
		table.insert(self.recordData, dices)
	end
end

function FishPrawnCrabGameCtrl:UpdateRecordUI()
	local recordCount = #self.recordData
	self.view.recordsRootObj:SetActive(recordCount > 0)
	self.view.latestRecordIconObj:SetActive(recordCount > 0)
	for i = 1, FishPrawnCrabConfig.showRecordCount do
		--有数据就显示
		if i <= recordCount then
			self.view.recordUIDatas[i].rootObj:SetActive(true)
			local showDicesData = self.recordData[recordCount - i + 1]
			for diceIndex = 1, FishPrawnCrabConfig.diceCount do
				local diceSideIndex = showDicesData[diceIndex]
				self.view.recordUIDatas[i].diceTexts[diceIndex].text = FishPrawnCrabConfig.animalShowData[diceSideIndex].name
				local diceColor = FishPrawnCrabConfig.animalShowData[diceSideIndex].color
				self.view.recordUIDatas[i].diceTexts[diceIndex].color = Color.New(diceColor.r, diceColor.g, diceColor.b, diceColor.a)
			end
		else
			--无数据就隐藏
			self.view.recordUIDatas[i].rootObj:SetActive(false)
		end
	end
end

function FishPrawnCrabGameCtrl:GetChilIndexArrByAmount(goldAmount)
	local chipList = {}
	local tmpGold = goldAmount
	for i = 1, #FishPrawnCrabConfig.betValuesArr do
		local index = #FishPrawnCrabConfig.betValuesArr - i + 1
		local curChipValue = FishPrawnCrabConfig.betValuesArr[index]
		while tmpGold >= curChipValue do
			tmpGold = tmpGold - curChipValue
			table.insert(chipList, index)
		end
	end
	if tmpGold ~= 0 then
		logError("GetChilIndexArrByAmount err!! goldAmount:" .. goldAmount .. " >>Remaining:" .. tmpGold)
	end
	
	return chipList
end

---中心下注区域
function FishPrawnCrabGameCtrl:OnClickCenterBetArea(areaIndex)
	--look("点击了下注区域：" .. areaIndex)
	if self.allowBet == false or self.curStatus ~= FishPrawnCrabConfig.GameState.Bet 
			or FishPrawnCrabConfig.betValuesArr[self.betIndex] > self.goldRealNum then
		return
	end

	--高亮点击的区域
	local targetAreaHighLight = self.view.winHighLights[areaIndex]
	targetAreaHighLight.gameObject:SetActive(true)
	Tools.DoColor_Alpha(targetAreaHighLight,1,0,0.1)
	
	--发送消息
	local betMsg = { playerid = self.view.selfPlayer.id,
					 area = areaIndex,
					 chip = self.betIndex }
	GlobalEvent.Notify(FishPrawnCrabConfig.GameEventName.REQUEST_BET, betMsg)
end

function FishPrawnCrabGameCtrl:OnPlayerBetMsg(message)
	local targetPlayer = self.view:FindPlayer(message.playerid) 
	--飞筹码
	if targetPlayer ~= nil then
		local newChipObj = FishPrawnCrabChipManager:AnimateChip(message.chip, targetPlayer.transform.position, self.view.betAreas[message.area])
		table.insert(self.allBetData[message.area], newChipObj)
		targetPlayer:AddChip(message.area, newChipObj)
	else
		local newChipObj = FishPrawnCrabChipManager:AnimateChip(message.chip, self.view.btn_players.transform.position, self.view.betAreas[message.area])
		table.insert(self.allBetData[message.area], newChipObj)
		table.insert(self.lookOnBetData[message.area], newChipObj)
	end
end

function FishPrawnCrabGameCtrl:OnBetRusultMsg(message)
	--local message = {area = areaIndex,
	--			  chip = self.betIndex,
	--              remaining_coin = 0,
	--				result = 0}
	if message ~= nil and message.result == 0 then
		self:OnSelfBet(message)
		--飞筹码
		local newChipObj = FishPrawnCrabChipManager:AnimateChip(message.chip, self.view.selfPlayer.transform.position, self.view.betAreas[message.area])
		table.insert(self.allBetData[message.area], newChipObj)
		self.view.selfPlayer:AddChip(message.area, newChipObj)
		--更新自身金币
		self.goldRealNum = message.remaining_coin

		self.view:UpdateBetBtnStatus()
		self.view:UpdateSelfGoldCount()
	else
		logError("下注失败:" .. message.result)
	end
end

function FishPrawnCrabGameCtrl:OnSelfBet(data)
	local areaIndex = data.area
	local betMoney = FishPrawnCrabConfig.betValuesArr[data.chip]
	self.selfBets[areaIndex] = self.selfBets[areaIndex] + betMoney
	--self.totalBets[areaIndex] = self.totalBets[areaIndex] + betMoney
	self.goldRealNum = self.goldRealNum - betMoney
	table.insert(self.selfBetInfo, data)
	
	self.view:UpdateSelfBetAreaInfo(data.area)
end

return FishPrawnCrabGameCtrl