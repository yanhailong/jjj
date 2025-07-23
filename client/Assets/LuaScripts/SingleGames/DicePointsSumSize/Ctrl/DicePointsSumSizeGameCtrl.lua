---
---Create by Administrator
---DateTime: 2025-07-22 10:18:39
---
---@class DicePointsSumSizeGameCtrl:BaseCtrl
local DicePointsSumSizeGameCtrl=Class("DicePointsSumSizeGameCtrl",BaseCtrl)

local DicePointsSumSizeConfig = require("SingleGames/DicePointsSumSize/DicePointsSumSizeConfig")
local DicePointsSumSizeChipManager = require("SingleGames/DicePointsSumSize/DicePointsSumSizeChipManager")
local DicePointsSumSizeChipItem = require("SingleGames/DicePointsSumSize/View/Item/DicePointsSumSizeChipItem")
local SimulationServer = require("SingleGames/DicePointsSumSize/DiceSizeSimulationServer")
local Ease = CS.DG.Tweening.Ease

---构造函数
function DicePointsSumSizeGameCtrl:ctor(ctrlName,param)
    self.layer=2;
    self.abName="SingleGames/DicePointsSumSize/prefabs/DicePointsSumSizeGamePanel";
    self.prefabName="DicePointsSumSizeGamePanel"
    self.super.ctor(self,ctrlName,param);
	---@type DicePointsSumSizeGameView
	self.view = self.view
	---@type DicePointsSumSizeGameModel
	self.model = self.model
end

---初始化
function DicePointsSumSizeGameCtrl:CtrlInit(args)
	self.super.CtrlInit(self,args);
	self:InitData()
	self:FirstEntryGame(args)
	self:UpdateChipPageBtns()
end

---初始化数据
function DicePointsSumSizeGameCtrl:InitData()
	---@type ObjectPoolUtil
	self.objPools=ObjectPoolUtil.New()
	---当前选中的底注
	self.betIndex = 1;
	---@type DicePointsSumSizeChipItem
	self.curSelectChip = nil
	self.showChipIndex = 1
	---筹码的集合
	self.chipItems = {};
	---当前是否可以下注
	self.allowBet = false
	---当前总底注
	self.totalBets = {0,0}
	---当前个人底注
	self.selfBets = {0,0}
	self.selfBetInfo = {}
	---玩家真实金币数量
	self.goldRealNum = 1000000000
	self.curStatus = DicePointsSumSizeConfig.GameState.Bet
	---当前状态剩余秒数 13
	self.statusRemainingSeconds = 3

	---复投
	self.lastBetInfo = {}
	---本局是否使用了复投
	self.isRepeatBet = false
	---本局下注数据
	self.allBetData = {{}, {}}
	self.lookOnBetData = {{}, {}}
	self.recordData = {}

	self.view.selfPlayer:UpdatePlayer({ id = DicePointsSumSizeConfig.selfTestPlayerId, coin = self.goldRealNum})
	
	DicePointsSumSizeConfig.InitDiceRecordsPic()
	DicePointsSumSizeConfig.InitDiceResultPic()
	DicePointsSumSizeConfig.InitIconPic()
	DicePointsSumSizeConfig.InitCommonMainPic()
	
	--刷新底注界面
	--self.view:UpdateBetBtnStatus()
	--self.view:ChangeAnte(self.betIndex)
	self.view:UpdateTotalBetAreaInfo(-1)
	self.view:UpdateSelfBetAreaInfo(-1)
end

function DicePointsSumSizeGameCtrl:Close()
    self.super.Close(self);
end

function DicePointsSumSizeGameCtrl:UpdateChipPageBtns()
	self.view.btn_Chipleft.gameObject:SetActive(self.showChipIndex > 1)
	self.view.btn_ChipRight.gameObject:SetActive(self.showChipIndex < table.getCount(self.chipItems) - DicePointsSumSizeConfig.chipItemShowCount + 1)

	local curIndex = 1
	for _, v in pairs(self.chipItems) do
		---@type DicePointsSumSizeChipItem
		local item = v;
		item.gameObject:SetActive(curIndex >= self.showChipIndex)
		
		curIndex = curIndex + 1
	end
end

---选中哪个筹码
---@param DicePointsSumSizeChipItem
function DicePointsSumSizeGameCtrl:SetCheckedShow(chipItem)
	self.curSelectChip = chipItem;
	for _, v in pairs(self.chipItems) do
		---@type DicePointsSumSizeChipItem
		local item = v;
		item:RefreshChecked(self.curSelectChip.index)
	end
end

---刷新菜单显示隐藏
function DicePointsSumSizeGameCtrl:RefreshMenuShow()
	if self.view.btn_touch.gameObject.activeSelf then
		self.view.trans_menu_panel:DOLocalMoveY(self.view.trans_menu_panel.sizeDelta.y+100,0.5):SetEase(Ease.InBack)
		self.view.btn_touch.gameObject:SetActive(false)
	else
		self.view.trans_menu_panel:DOLocalMoveY(0,0.5):SetEase(Ease.OutBack)
		self.view.btn_touch.gameObject:SetActive(true)
	end

end

---添加UI事件
function DicePointsSumSizeGameCtrl:AddUIEvent()
	self.uiEventListener:AddClick(self.view.btn_muen,function()
		self:RefreshMenuShow()
	end)
	self.uiEventListener:AddClick(self.view.btn_touch,function()
		self:RefreshMenuShow()
	end)
	self.uiEventListener:AddClick(self.view.btn_help,function()
		--CtrlManager.SingleShow(CtrlNames.DicePointsSumSizeHelp)
	end)
	self.uiEventListener:AddClick(self.view.btn_close,function()
		self:Close();
	end)
	self.uiEventListener:AddClick(self.view.btn_setting,function()
		look("打开设置界面")
	end)

	self.uiEventListener:AddClick(self.view.btn_AllOther,function(obj)
		--CtrlManager.SingleShow(CtrlNames.DicePointsSumSizePlayers)
	end)
	self.uiEventListener:AddClick(self.view.btn_1,function(obj)
		SimulationServer:StartServer()
	end)
	self.uiEventListener:AddClick(self.view.btn_Chipleft,function(obj)
		if self.showChipIndex > 1 then
			self.showChipIndex = self.showChipIndex - 1
			self:UpdateChipPageBtns()
		end
	end)
	self.uiEventListener:AddClick(self.view.btn_ChipRight,function(obj)
		if self.showChipIndex < table.getCount(self.chipItems) - DicePointsSumSizeConfig.chipItemShowCount + 1 then
			self.showChipIndex = self.showChipIndex + 1
			self:UpdateChipPageBtns()
		end
	end)

	---压注按钮
	for i=1,#self.view.chipInfos do
		self.uiEventListener:AddClick(self.view.chipInfos[i].obj,function()
			if self.allowBet then
				--self.view:ChangeAnte(i)
				--look("btn 抵住数值"..DicePointsSumSizeGameConfig.dizhuNumArr[DicePointsSumSizeGameConfig.anteIndex])
				---测试数据生成 龙虎和 对应前三个币
				--GlobalEvent.Notify("UPDATE_HIS_ITEMS",i)
			end
		end)
	end
	---下注区域
	for i=1,self.view.clickAreaRoot.childCount do
		self.uiEventListener:AddClick(self.view.clickAreaRoot:GetChild(i-1),function()
			self:OnClickCenterBetArea(i)
		end)
	end
	self.uiEventListener:AddClick(self.view.btn_repeat,function()
		if self:AllowRepeatBet() then
			self.isRepeatBet = true
			for i = 1, #self.lastBetInfo do
				if self.allowBet == false or self.curStatus ~= DicePointsSumSizeConfig.GameState.Bet
						or DicePointsSumSizeConfig.betValuesArr[self.lastBetInfo[i].chip] > self.goldRealNum then
					break
				end

				--发送消息
				local betMsg = { playerid = self.view.selfPlayer.id,
								 area = self.lastBetInfo[i].area,
								 chip = self.lastBetInfo[i].chip }
				GlobalEvent.Notify(DicePointsSumSizeConfig.GameEventName.REQUEST_BET, betMsg)
				--self:OnSelfBet(self.lastBetInfo[i])
				----飞筹码
				--DicePointsSumSizeChipManager:AnimateChip(self.lastBetInfo[i].chip, self.view.selfPlayer.transform.position, self.view.betAreas[self.lastBetInfo[i].area])
			end
			self.view.btn_repeat.interactable = false
		end
	end)
end

---移除UI事件
function DicePointsSumSizeGameCtrl:RemoveEvent()
	self.super.RemoveEvent(self);
end

--region UI事件方法
---首次进入游戏刷新显示
function DicePointsSumSizeGameCtrl:FirstEntryGame(data)
	----初始化筹码
	--for i = 1, #data.betInfoList do
	for i = 1, #DicePointsSumSizeConfig.betValuesArr do
		local item = self.objPools:Spawn(nil, self.view.obj_chipItem, self.view.obj_ChipContent.transform)
		item:SetActive(true);
		---@type DicePointsSumSizeChipItem
		local chipItem = DicePointsSumSizeChipItem.New(item, self);
		look("FirstEntryGame:" .. i .. "betAmount:" .. DicePointsSumSizeConfig.betValuesArr[i])
		chipItem:InitUIShow(i, DicePointsSumSizeConfig.betValuesArr[i]);
		table.insert(self.chipItems, chipItem);
		--默认选中第一个
		if i == 1 then
			self.curSelectChip = chipItem
		end
	end
	
	self:SetCheckedShow(self.curSelectChip)
	--self:RefreshDataShow(data);
end

---进入到准备阶段
function DicePointsSumSizeGameCtrl:SwitchToPrepareState(message)
	---当前总底注
	self.totalBets = {0,0}
	---当前个人底注
	self.selfBets = {0,0}
	self.selfBetInfo = {}
	self.allowBet = false
	self.allBetData = {{}, {}}
	self.lookOnBetData = {{}, {}}
	self.curStatus = DicePointsSumSizeConfig.GameState.Prepare
	--重置筹码数据
	self.view.selfPlayer:ResetBetData()
	for i = 1, #self.view.AllOtherPlayerHeads do
		self.view.AllOtherPlayerHeads[i]:ResetBetData()
	end
	--筹码是否回收完
	local chipsArr = DicePointsSumSizeChipManager:GetChipArr()
	if #chipsArr > 0 then
		logError("筹码未回收完")
		DicePointsSumSizeChipManager:CleanAllChipAnim()
		DicePointsSumSizeChipManager:CleanChip()
	end

	self.view:UpdateTotalBetAreaInfo(-1)
	self.view:UpdateSelfBetAreaInfo(-1)
	self.view.btn_repeat.interactable = false
	self.view:UpdateBetBtnStatus()

	--tip
	self.view.tipsStartToBet:SetActive(false)
	self.view.tipsStopBetting:SetActive(false)

	--骰子
	self.view.bigDiceLid:SetActive(true)
	self.view.smallDiceLid:SetActive(true)

	--倒计时
	self.view.colockStateTimePrepare:SetActive(true)
	self.view.colockStateTimeBet:SetActive(false)
	self.view.colockStateTimeSettlement:SetActive(false)
	self.view.colockStateTimeTrs.gameObject:SetActive(true)
	self.statusRemainingSeconds = message.remaining_time
	local timeInterval = 0.5
	self.view.colockStateTimeNumPrepare.text = tostring(math.max(0, math.floor(self.statusRemainingSeconds + 0.1))) .. "s"
	TimerManager.StartTimer(self,function()
		self.statusRemainingSeconds = self.statusRemainingSeconds - timeInterval
		self.view.colockStateTimeNumPrepare.text = tostring(math.max(0, math.floor(self.statusRemainingSeconds + 0.1))) .. "s"
	end, timeInterval, math.floor(self.statusRemainingSeconds / timeInterval),false)
end

function DicePointsSumSizeGameCtrl:AllowRepeatBet()
	local allReBet = false
	if self.allowBet and #self.lastBetInfo > 0 then
		-- 判断钱是否足够
		local lastBetAmount = 0
		for i = 1, #self.lastBetInfo do
			lastBetAmount = lastBetAmount + DicePointsSumSizeConfig.betValuesArr[self.lastBetInfo[i].chip]
		end
		if lastBetAmount <= self.goldRealNum then
			allReBet = true
		end
	end

	return allReBet
end

---进入到下注阶段
function DicePointsSumSizeGameCtrl:SwitchToBetState(message)
	self.curStatus = DicePointsSumSizeConfig.GameState.Bet
	self.allowBet = true
	self.isRepeatBet = false

	self.view.btn_repeat.interactable = self:AllowRepeatBet()
	self.view:UpdateBetBtnStatus()

	--tip
	self.view.tipsStartToBet:SetActive(true)
	self.view.tipsStopBetting:SetActive(false)
	TimerManager.StartTimer(self,function()
		self.view.tipsStartToBet:SetActive(false)
	end,1.5,1,false)

	--倒计时
	self.view.colockStateTimePrepare:SetActive(false)
	self.view.colockStateTimeBet:SetActive(true)
	self.view.colockStateTimeSettlement:SetActive(false)
	self.view.colockStateTimeTrs.gameObject:SetActive(true)
	self.statusRemainingSeconds = message.remaining_time
	local timeInterval = 0.5
	self.view.colockStateTimeNumBet.text = tostring(math.max(0, math.floor(self.statusRemainingSeconds + 0.1))) .. "s"
	TimerManager.StartTimer(self,function()
		self.statusRemainingSeconds = self.statusRemainingSeconds - timeInterval
		self.view.colockStateTimeNumBet.text = tostring(math.max(0, math.floor(self.statusRemainingSeconds + 0.1))) .. "s"
		----倒计时3s
		--if math.abs(self.statusRemainingSeconds - 3) <= 0.1 then
		--	self.view.colockStateTimeTrs.gameObject:SetActive(false)
		--	self.view:PlayDaoJiShiEffect()
		--end
	end, timeInterval, math.floor(self.statusRemainingSeconds / timeInterval),false)
end

---进入到结算阶段
function DicePointsSumSizeGameCtrl:SwitchToSettlementState(message)
	self.curStatus = DicePointsSumSizeConfig.GameState.Settlement
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
	end,1.5,1,false)

	--倒计时
	self.view.colockStateTimeTrs.gameObject:SetActive(true)
	self.view.colockStateTimePrepare:SetActive(false)
	self.view.colockStateTimeBet:SetActive(false)
	self.view.colockStateTimeSettlement:SetActive(true)
	self.statusRemainingSeconds = message.remaining_time
	local timeInterval = 0.5
	self.view.colockStateTimeNumSettlement.text = tostring(math.max(0, math.floor(self.statusRemainingSeconds + 0.1))) .. "s"
	TimerManager.StartTimer(self,function()
		self.statusRemainingSeconds = self.statusRemainingSeconds - timeInterval
		self.view.colockStateTimeNumSettlement.text = tostring(math.max(0, math.floor(self.statusRemainingSeconds + 0.1))) .. "s"
	end, timeInterval, math.floor(self.statusRemainingSeconds / timeInterval),false)
end

---游戏结算数据
function DicePointsSumSizeGameCtrl:OnGameSettlementMsg(message)
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
		self.view.bigDiceResultObj:SetActive(true)
		self.view.smallDiceResultObj:SetActive(true)
		self.view.bigDiceLid:SetActive(true)
		self.view.smallDiceLid:SetActive(true)
		coroutine.wait(1.5)
		--设置结果
		for i = 1, DicePointsSumSizeConfig.diceCount do
			local diceSideIndex = message.dices[i]
			local curResultIcon = DicePointsSumSizeConfig.diceResult_Pics["tb_tz_" .. diceSideIndex]
			self.view.bigDiceImages[i].sprite = curResultIcon
			self.view.bigDiceImages[i]:SetNativeSize()

			self.view.smallDiceImages[i].sprite = curResultIcon
			self.view.smallDiceImages[i]:SetNativeSize()
		end
		self.view.smallDiceLid:SetActive(false)
		self.view.bigDiceLid:SetActive(false)
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
		--for areaIndex = 1, DicePointsSumSizeConfig.diceSideCount do
		--	if not isAreaWin(areaIndex) then
		--		local chipsArr = self.allBetData[areaIndex]
		--		for chipIndex = 1, #chipsArr do
		--			DicePointsSumSizeChipManager:DestroyChipFly(chipsArr[chipIndex], self.view.btn_dealer.transform.position)
		--		end
		--		chipsArr = {}
		--	end
		--end

		--coroutine.wait(2)
		--荷官赔下中的筹码到桌面上
		--for playerIndex = 1, #message.win_info do
		--	local playerWinInfo = message.win_info[playerIndex]
		--	local targetChipArr = nil
		--	local targetPlayer = self.view:FindPlayer(playerWinInfo.playerid)
		--	if targetPlayer ~= nil then
		--		targetChipArr = targetPlayer.chipInfo
		--	else
		--		targetChipArr = self.lookOnBetData
		--	end
		--
		--	for winIndex = 1, #playerWinInfo.win_info do
		--		local oddAmount = playerWinInfo.win_info[winIndex].oddAmount
		--		local winAreaIndex = playerWinInfo.win_info[winIndex].anim_index
		--		local chipList = self:GetChilIndexArrByAmount(oddAmount)
		--		for chipIndex = 1, #chipList do
		--			--飞筹码
		--			local newChipObj = DicePointsSumSizeChipManager:AnimateChip(chipList[chipIndex], self.view.btn_dealer.transform.position, self.view.betAreas[winAreaIndex])
		--			table.insert(targetChipArr[winAreaIndex], newChipObj)
		--		end
		--	end
		--end

		coroutine.wait(2)
		--把桌面上的筹码分到对应的人身上
		for areaIndex = 1, #message.dice_result do
			--自己
			local chipsArr = self.view.selfPlayer.chipInfo[message.dice_result[areaIndex].anim_index]
			--for chipIndex = 1, #chipsArr do
			--	DicePointsSumSizeChipManager:DestroyChipFly(chipsArr[chipIndex], self.view.selfPlayer.transform.position)
			--end
			--chipsArr = {}
			CorManager.StartCor(self, function()
				for chipIndex = 1, #chipsArr do
					DicePointsSumSizeChipManager:DestroyChipFly(chipsArr[chipIndex], self.view.selfPlayer.transform.position)
					if #chipsArr - chipIndex < 3 then
						coroutine.wait(0.2)
					end
				end
				chipsArr = {}
			end)
			--旁观的人
			local lookOnChipsArr = self.lookOnBetData[message.dice_result[areaIndex].anim_index]
			--for chipIndex = 1, #lookOnChipsArr do
			--	DicePointsSumSizeChipManager:DestroyChipFly(lookOnChipsArr[chipIndex], self.view.btn_AllOther.transform.position)
			--end
			--lookOnChipsArr = {}
			CorManager.StartCor(self, function()
				for chipIndex = 1, #lookOnChipsArr do
					DicePointsSumSizeChipManager:DestroyChipFly(lookOnChipsArr[chipIndex], self.view.btn_AllOther.transform.position)
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
				--	DicePointsSumSizeChipManager:DestroyChipFly(chipsArr[chipIndex], otherPlayer.transform.position)
				--end
				--chipsArr = {}
				CorManager.StartCor(self, function()
					for chipIndex = 1, #chipsArr do
						DicePointsSumSizeChipManager:DestroyChipFly(chipsArr[chipIndex], otherPlayer.transform.position)
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

function DicePointsSumSizeGameCtrl:AddNewRecord(dices)
	if dices ~= nil and #dices == DicePointsSumSizeConfig.diceCount then
		--删除多余的记录
		while #self.recordData >= DicePointsSumSizeConfig.showRecordCount do
			table.remove(self.recordData, 1)
		end

		--添加新的记录
		table.insert(self.recordData, dices)
	end
end

function DicePointsSumSizeGameCtrl:UpdateRecordUI()
	local recordCount = #self.recordData
	self.view.recordsRootObj:SetActive(recordCount > 0)
	for i = 1, DicePointsSumSizeConfig.showRecordCount do
		--有数据就显示
		if i <= recordCount then
			self.view.recordUIDatas[i].rootObj:SetActive(true)
			local showDicesData = self.recordData[recordCount - i + 1]
			local pointSum = 0
			for diceIndex = 1, DicePointsSumSizeConfig.diceCount do
				pointSum = pointSum + showDicesData[diceIndex]
				local diceSideIndex = showDicesData[diceIndex]
				local curResultIcon = DicePointsSumSizeConfig.diceRecords_Pics["tb_tz_" .. showDicesData[diceIndex]]
				self.view.recordUIDatas[i].diceImages[diceIndex].sprite = curResultIcon
				self.view.recordUIDatas[i].diceImages[diceIndex]:SetNativeSize()
			end
			local diceSizeType = DicePointsSumSizeConfig.DiceSumType.Small
			local diceTypeSprite = nil
			if pointSum >= 11 and pointSum <= 18 then
				diceSizeType = DicePointsSumSizeConfig.DiceSumType.Big
				diceTypeSprite = DicePointsSumSizeConfig.icon_Pics["dxtz_da"]
			else
				diceTypeSprite = DicePointsSumSizeConfig.icon_Pics["dxtz_xiao"]
			end
			local diceColor = DicePointsSumSizeConfig.diceSumShowData[diceSizeType]
			self.view.recordUIDatas[i].dicePointSumText.text = tostring(pointSum)
			self.view.recordUIDatas[i].dicePointSumText.color = Color.New(diceColor.r, diceColor.g, diceColor.b, diceColor.a)
			self.view.recordUIDatas[i].resultTypeImage.sprite = diceTypeSprite
			self.view.recordUIDatas[i].resultTypeImage:SetNativeSize()
		else
			--无数据就隐藏
			self.view.recordUIDatas[i].rootObj:SetActive(false)
		end
	end
end

function DicePointsSumSizeGameCtrl:GetChilIndexArrByAmount(goldAmount)
	local chipList = {}
	local tmpGold = goldAmount
	for i = 1, #DicePointsSumSizeConfig.betValuesArr do
		local index = #DicePointsSumSizeConfig.betValuesArr - i + 1
		local curChipValue = DicePointsSumSizeConfig.betValuesArr[index]
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
function DicePointsSumSizeGameCtrl:OnClickCenterBetArea(areaIndex)
	--look("点击了下注区域：" .. areaIndex)
	if self.allowBet == false or self.curStatus ~= DicePointsSumSizeConfig.GameState.Bet
			or self.curSelectChip == nil or DicePointsSumSizeConfig.betValuesArr[self.curSelectChip.index] > self.goldRealNum then
		return
	end

	--高亮点击的区域
	local targetAreaHighLight = self.view.winHighLights[areaIndex]
	targetAreaHighLight.gameObject:SetActive(true)
	Tools.DoColor_Alpha(targetAreaHighLight,1,0,0.1)

	--发送消息
	local betMsg = { playerid = self.view.selfPlayer.id,
					 area = areaIndex,
					 chip = self.curSelectChip.index }
	GlobalEvent.Notify(DicePointsSumSizeConfig.GameEventName.REQUEST_BET, betMsg)
end

function DicePointsSumSizeGameCtrl:OnPlayerBetMsg(message)
	local targetPlayer = self.view:FindPlayer(message.playerid)
	--飞筹码
	if targetPlayer ~= nil then
		local newChipObj = DicePointsSumSizeChipManager:AnimateChip(message.chip, targetPlayer.transform.position, self.view.betAreas[message.area])
		table.insert(self.allBetData[message.area], newChipObj)
		targetPlayer:AddChip(message.area, newChipObj)
	else
		local newChipObj = DicePointsSumSizeChipManager:AnimateChip(message.chip, self.view.btn_AllOther.transform.position, self.view.betAreas[message.area])
		table.insert(self.allBetData[message.area], newChipObj)
		table.insert(self.lookOnBetData[message.area], newChipObj)
	end
end

function DicePointsSumSizeGameCtrl:OnBetRusultMsg(message)
	--local message = {area = areaIndex,
	--			  chip = self.betIndex,
	--              remaining_coin = 0,
	--				result = 0}
	if message ~= nil and message.result == 0 then
		self:OnSelfBet(message)
		--飞筹码
		local newChipObj = DicePointsSumSizeChipManager:AnimateChip(message.chip, self.view.selfPlayer.transform.position, self.view.betAreas[message.area])
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

function DicePointsSumSizeGameCtrl:OnSelfBet(data)
	local areaIndex = data.area
	local betMoney = DicePointsSumSizeConfig.betValuesArr[data.chip]
	self.selfBets[areaIndex] = self.selfBets[areaIndex] + betMoney
	--self.totalBets[areaIndex] = self.totalBets[areaIndex] + betMoney
	self.goldRealNum = self.goldRealNum - betMoney
	table.insert(self.selfBetInfo, data)

	self.view:UpdateSelfBetAreaInfo(data.area)
end

--endregion


---销毁UI
function DicePointsSumSizeGameCtrl:RealCloseDestroy()
	self.super.RealCloseDestroy(self);
	DicePointsSumSizeChipManager:Destroy()
	TimerManager.StopAllTimer(self)
	CorManager.StopAll(self)
	GlobalEvent.Notify(DicePointsSumSizeConfig.GameEventName.STOP_SIMULATION_SERVER)
end

return DicePointsSumSizeGameCtrl