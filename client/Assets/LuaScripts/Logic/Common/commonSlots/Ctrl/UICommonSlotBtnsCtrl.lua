---
---Create by Administrator
---DateTime: 2025-07-01 13:53:15
---
---@class UICommonSlotBtnsCtrl:BaseCtrl
local UICommonSlotBtnsCtrl=Class("UICommonSlotBtnsCtrl",BaseCtrl)

---构造函数
function UICommonSlotBtnsCtrl:ctor(ctrlName,param)
    self.layer=2;
    self.abName="Common/UICommon/prefabs/UICommonSlotBtns";
    self.prefabName="UICommonSlotBtns"
    self.super.ctor(self,ctrlName,param);
	---@type UICommonSlotBtnsView
	self.view = self.view
	---@type UICommonSlotBtnsModel
	self.model = self.model
end

---初始化
function UICommonSlotBtnsCtrl:CtrlInit(args)
	self.super.CtrlInit(self,args);
	self:InitData()
	self.defaultBet=args.defaultBet
	self.stakeList=args.stakeList
	self:GetChipIndexByValue(self.defaultBet)
	self:InitPlayerInfos(self.stakeList)
end

function UICommonSlotBtnsCtrl:GetChipIndexByValue(value)
	for i = 1, #self.stakeList do
		if value==self.stakeList[i] then
			self.betIndex=i
		end
	end
end

---初始化数据
function UICommonSlotBtnsCtrl:InitData()
	self.betIndex=1--下注索引，默认为1
	self.isLongPress=false
	self.spinArgs={}
end

function UICommonSlotBtnsCtrl:Close()
    self.super.Close(self);
end

---添加UI事件
function UICommonSlotBtnsCtrl:AddUIEvent()
	GlobalEvent.AddListener(SlotGlobal.gameEventName.NoticeAuto, self.NoticeAuto,self)
	GlobalEvent.AddListener(SlotGlobal.gameEventName.NoticeStopAuto, self.NoticeStopAuto,self)
	GlobalEvent.AddListener(SlotGlobal.gameEventName.GameStateChange,self.GameStateChange,self)
	
	self.uiEventListener:AddClick(self.view.btn_start, function()
		if self.isLongPress==true then
			self.isLongPress=false
			return
		end
		self:SetObjFreeShow(false)
		self.spinArgs.betInfo=self.stakeList[self.betIndex]
		self.spinArgs.isAuto=false
		self.spinArgs.autoNum=0
		GlobalEvent.Notify(SlotGlobal.gameEventName.StartSpin,self.spinArgs)
	end)
	self.uiEventListener:AddLongPress(self.view.btn_start.gameObject, function()
		self.isLongPress=true
		self:SetObjFreeShow(true)
	end)
	self.uiEventListener:AddClick(self.view.btn_closeFreeMask, function
	()
		self:SetObjFreeShow(false)
	end)
	self.uiEventListener:AddClick(self.view.btn_25, function
	()
		self:SetObjFreeShow(false)
		self.spinArgs.betInfo=self.stakeList[self.betIndex]
		self.spinArgs.isAuto=true
		self.spinArgs.autoNum=25
		GlobalEvent.Notify(SlotGlobal.gameEventName.StartSpin,self.spinArgs)
	end)
	self.uiEventListener:AddClick(self.view.btn_50, function
	()
		self:SetObjFreeShow(false)
		self.spinArgs.betInfo=self.stakeList[self.betIndex]
		self.spinArgs.isAuto=true
		self.spinArgs.autoNum=25
		GlobalEvent.Notify(SlotGlobal.gameEventName.StartSpin,self.spinArgs)
	end)
	self.uiEventListener:AddClick(self.view.btn_100, function
	()
		self:SetObjFreeShow(false)
		self.spinArgs.betInfo=self.stakeList[self.betIndex]
		self.spinArgs.isAuto=true
		self.spinArgs.autoNum=100
		GlobalEvent.Notify(SlotGlobal.gameEventName.StartSpin,self.spinArgs)
	end)
	self.uiEventListener:AddClick(self.view.btn_200, function
	()
		self:SetObjFreeShow(false)
		self.spinArgs.betInfo=self.stakeList[self.betIndex]
		self.spinArgs.isAuto=true
		self.spinArgs.autoNum=200
		GlobalEvent.Notify(SlotGlobal.gameEventName.StartSpin,self.spinArgs)
	end)
	self.uiEventListener:AddClick(self.view.btn_500, function
	()
		self:SetObjFreeShow(false)
		self.spinArgs.betInfo=self.stakeList[self.betIndex]
		self.spinArgs.isAuto=true
		self.spinArgs.autoNum=500
		GlobalEvent.Notify(SlotGlobal.gameEventName.StartSpin,self.spinArgs)
	end)
	self.uiEventListener:AddClick(self.view.btn_wx, function
	()
		self:SetObjFreeShow(false)
		self.spinArgs.betInfo=self.stakeList[self.betIndex]
		self.spinArgs.isAuto=true
		self.spinArgs.autoNum=99999999
		GlobalEvent.Notify(SlotGlobal.gameEventName.StartSpin,self.spinArgs)
	end)
	
	self.uiEventListener:AddClick(self.view.btn_auto, function
	()
		self.spinArgs={}
		GlobalEvent.Notify(SlotGlobal.gameEventName.NoticeStopAuto)
	end)
	
	self.uiEventListener:AddClick(self.view.btn_stop, function
	()
		GlobalEvent.Notify(SlotGlobal.gameEventName.RollStop)
	end)
	
	
end
---自动次数显示刷新
function UICommonSlotBtnsCtrl:NoticeAuto(autoNum)
	self.view.txt_StopNum.text=autoNum
end

function UICommonSlotBtnsCtrl:SetObjFreeShow(bl)
	self.view.btn_closeFreeMask.gameObject:SetActive(bl)
	self.view.obj_auto:SetActive(bl)
end

---被通知停止自动
function UICommonSlotBtnsCtrl:NoticeStopAuto()
	self.spinArgs={}
end


---移除UI事件
function UICommonSlotBtnsCtrl:RemoveEvent()
	self.super.RemoveEvent(self);
	GlobalEvent.RemoveAllTo(self)
end

---设置玩家初始数据
function UICommonSlotBtnsCtrl:InitPlayerInfos(stakeList)
	self:SetChipText(self.stakeList[self.betIndex])--设置默认
	self:InitChipInfoUiEvent()
end

function UICommonSlotBtnsCtrl:SetChipText(value)
	self.view.tmp_chip.text=value
end

---游戏状态改变
function UICommonSlotBtnsCtrl:GameStateChange(gameState)
	self:SetGameState(gameState)
end


--region UI事件方法
--下注相关--------------------
function UICommonSlotBtnsCtrl:InitChipInfoUiEvent()
	self.uiEventListener:AddClick(self.view.btn_add, function()
		self:SetChipInfo("add")
	end)
	self.uiEventListener:AddClick(self.view.btn_reduce, function()
		self:SetChipInfo("reduce")
	end)
	self.uiEventListener:AddClick(self.view.btn_max, function()
		self:SetChipInfo("max")
	end)
end
function UICommonSlotBtnsCtrl:SetChipInfo(str)
	local chipMoney = self.stakeList[self.betIndex]
	local playerMoney=1000000000000
	if str == "max" then
		if tonumber(chipMoney)> tonumber(playerMoney)   then
			SuspensionTipsUtil.SuspensionTips("金币不足");
			return
		end
		self.betIndex = #self.stakeList
	elseif str == "add" then
		if tonumber(chipMoney)> tonumber(playerMoney)  then
			SuspensionTipsUtil.SuspensionTips("金币不足");
			return
		end
		self.betIndex = self.betIndex%(#self.stakeList) + 1
	elseif str == "reduce" then
		if tonumber(chipMoney)> tonumber(playerMoney)   then
			SuspensionTipsUtil.SuspensionTips("金币不足");
			return
		end
		self.betIndex=self.betIndex-1;
		if  self.betIndex<=0  then
			self.betIndex=#self.stakeList
		end
	end
	self:SetChipText(self.stakeList[self.betIndex])
end
--下注相关--------------------
--endregion


---设置游戏状态
function UICommonSlotBtnsCtrl:SetGameState(gameState)
	self.view.btn_start.gameObject:SetActive(gameState==SlotGlobal.gameState.Normal)
	self.view.btn_stop.gameObject:SetActive(gameState==SlotGlobal.gameState.RollState)
	self.view.btn_auto.gameObject:SetActive(gameState==SlotGlobal.gameState.AutoState)
	self.view.btn_free.gameObject:SetActive(gameState==SlotGlobal.gameState.FreeState)
	if gameState==SlotGlobal.gameState.Normal then
		self:SetChipState(true)
	else
		self:SetChipState(false)
	end
end

function UICommonSlotBtnsCtrl:SetChipState(bl)
	self.view.btn_add.interactable=bl
	self.view.btn_reduce.interactable=bl
	self.view.btn_max.interactable=bl
end


---销毁UI
function UICommonSlotBtnsCtrl:RealCloseDestroy()
	self.super.RealCloseDestroy(self);
end

return UICommonSlotBtnsCtrl