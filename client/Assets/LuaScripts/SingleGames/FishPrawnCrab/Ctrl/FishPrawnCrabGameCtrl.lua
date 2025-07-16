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
	---本局结果
	self.side = 0
	self.isouNum = true
	self.betAreas = {}
	---本局骰子结果
	self.resultDices = {0,0,0}
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
	---房间总人数
	self.totalPlayerNum = 66

	---复投
	self.lastBetInfo = {}
	---本局是否使用了复投
	self.isRepeatBet = false
	---本局下注数据
	self.allBetData = {}
	
	self.view.selfPlayer:UpdatePlayer({ id = 1314, coin = self.goldRealNum})
	
	--刷新底注界面
	self.view:UpdateBetBtnStatus()
	self.view:ChangeAnte(self.betIndex)
	self.view:UpdateBetAreaInfo(-1)
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
		--CtrlManager.SingleShow(CtrlNames)
	end)
	self.uiEventListener:AddClick(self.view.btn_close,function()
		self:Close();
	end)
	self.uiEventListener:AddClick(self.view.btn_setting,function()
		look("打开设置界面")
	end)

	self.uiEventListener:AddClick(self.view.btn_players,function(obj)
		--CtrlManager.SingleShow(CtrlNames)
	end)
	self.uiEventListener:AddClick(self.view.btn_1,function(obj)
		SimulationServer.StartServer()
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
		if #self.lastBetInfo > 0 and self.isRepeatBet == false then
			self.isRepeatBet = true
			for i = 1, #self.lastBetInfo do
				if self.allowBet == false or self.curStatus ~= FishPrawnCrabConfig.GameState.Bet 
						or FishPrawnCrabConfig.betValuesArr[self.lastBetInfo[i].chip] > self.goldRealNum then
					break
				end
				self:OnSelfBet(self.lastBetInfo[i])
				--self.view:PayXiaZhuCoinFly(VietnamChessConfig.lastXiaZhuInfo[i].side)
				--飞筹码
				FishPrawnCrabChipManager:AnimateChip(self.lastBetInfo[i].chip, self.view.selfPlayer.transform.position, self.view.betAreas[self.lastBetInfo[i].area])
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
end

---进入到准备阶段
function FishPrawnCrabGameCtrl:SwitchToPrepareState(message)
	---当前总底注
	self.totalBets = {0,0,0,0,0,0}
	---当前个人底注
	self.selfBets = {0,0,0,0,0,0}
	self.selfBetInfo = {}
	self.allowBet = false
	self.curStatus = FishPrawnCrabConfig.GameState.Prepare
	
	self.view:UpdateBetAreaInfo()
	self.view.btn_repeat.interactable = self.allowBet
	self.view:UpdateBetBtnStatus()

	--tip
	self.view.tipsStartToBet:SetActive(false)
	self.view.tipsStopBetting:SetActive(false)
	
	--倒计时
	self.view.colockStateTimePrepare:SetActive(true)
	self.view.colockStateTimeBet:SetActive(false)
	self.view.colockStateTimeSettlement:SetActive(false)
	self.view.colockStateTimeTrs.gameObject:SetActive(true)
	self.statusRemainingSeconds = FishPrawnCrabConfig.prepareStateDuration
	local timeInterval = 0.5
	TimerManager.StartTimer(self,function()
		self.statusRemainingSeconds = self.statusRemainingSeconds - timeInterval
		self.view.colockStateTimeNum.text = math.floor(self.statusRemainingSeconds + 0.1)
	end, timeInterval, math.floor(self.statusRemainingSeconds / timeInterval),false)
end

---进入到下注阶段
function FishPrawnCrabGameCtrl:SwitchToBetState(message)
	self.curStatus = FishPrawnCrabConfig.GameState.Bet
	self.allowBet = true
	self.isRepeatBet = false

	self.view.btn_repeat.interactable = self.allowBet and #self.lastBetInfo > 0
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
	self.statusRemainingSeconds = FishPrawnCrabConfig.betStateDuration
	local timeInterval = 0.5
	TimerManager.StartTimer(self,function()
		self.statusRemainingSeconds = self.statusRemainingSeconds - timeInterval
		self.view.colockStateTimeNum.text = math.floor(self.statusRemainingSeconds + 0.1)
		--倒计时3s
		if math.abs(self.statusRemainingSeconds - 3) <= 0.1 then
			self.view.colockStateTimeTrs.gameObject:SetActive(false)
			--self:PlayDaoJiShiEffect()
		end
	end, timeInterval, math.floor(self.statusRemainingSeconds / timeInterval),false)
end

---进入到结算阶段
function FishPrawnCrabGameCtrl:SwitchToSettlementState(message)
	self.curStatus = FishPrawnCrabConfig.GameState.Settlement
	self.allowBet = false
	self.lastBetInfo = self.selfBetInfo

	self.view.btn_repeat.interactable = self.allowBet
	self.view:UpdateBetBtnStatus()

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
	self.statusRemainingSeconds = FishPrawnCrabConfig.settlementStateDuration
	local timeInterval = 0.5
	TimerManager.StartTimer(self,function()
		self.statusRemainingSeconds = self.statusRemainingSeconds - timeInterval
		self.view.colockStateTimeNum.text = math.floor(self.statusRemainingSeconds + 0.1)
	end, timeInterval, math.floor(self.statusRemainingSeconds / timeInterval),false)
	
	--回收筹码到荷官处
	local chipsArr = FishPrawnCrabChipManager:GetChipArr()
	while #chipsArr > 0 do
		FishPrawnCrabChipManager:DestroyChipFly(chipsArr[#chipsArr], self.view.btn_dealer.transform.position)
	end
end

---中心下注区域
function FishPrawnCrabGameCtrl:OnClickCenterBetArea(areaIndex)
	--look("点击了下注区域：" .. areaIndex)
	if self.allowBet == false or self.curStatus ~= FishPrawnCrabConfig.GameState.Bet 
			or FishPrawnCrabConfig.betValuesArr[self.betIndex] > self.goldRealNum then
		return
	end
	
	local betMsg = { playerid = self.view.selfPlayer.id,
					 area = areaIndex,
					 chip = self.betIndex }
	GlobalEvent.Notify(FishPrawnCrabConfig.GameEventName.REQUEST_BET, betMsg)

	local data = {area = areaIndex, 
				  chip = self.betIndex}
	self:OnSelfBet(data)
	--飞筹码
	FishPrawnCrabChipManager:AnimateChip(self.betIndex, self.view.selfPlayer.transform.position, self.view.betAreas[areaIndex])

	self.view:UpdateBetBtnStatus()
	self.view:UpdateSelfGoldCount()
	--高亮点击的区域
	local targetAreaHighLight = self.view.winHighLights[areaIndex]
	targetAreaHighLight.gameObject:SetActive(true)
	Tools.DoColor_Alpha(targetAreaHighLight,1,0,0.1)
end

function FishPrawnCrabGameCtrl:OnSelfBet(data)
	local areaIndex = data.area
	local betMoney = FishPrawnCrabConfig.betValuesArr[data.chip]
	self.selfBets[areaIndex] = self.selfBets[areaIndex] + betMoney
	self.totalBets[areaIndex] = self.totalBets[areaIndex] + betMoney
	self.goldRealNum = self.goldRealNum - betMoney
	table.insert(self.selfBetInfo, data)
	
	self.view:UpdateBetAreaInfo(data.area)
end

return FishPrawnCrabGameCtrl