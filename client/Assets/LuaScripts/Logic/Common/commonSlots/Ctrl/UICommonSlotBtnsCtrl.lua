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

function UICommonSlotBtnsCtrl:AddAutoClick()
	self.autoBtns={}
	self.autoNum={25,50,100,200,500,99999999}
	self.autoBtns[1]=self.view.btn_25
	self.autoBtns[2]=self.view.btn_50
	self.autoBtns[3]=self.view.btn_100
	self.autoBtns[4]=self.view.btn_200
	self.autoBtns[5]=self.view.btn_500
	self.autoBtns[6]=self.view.btn_wx
	for i = 1, #self.autoNum do
		self.uiEventListener:AddClick(self.autoBtns[i], function()
			self:SetObjFreeShow(false)
			GlobalEvent.Notify(SlotGlobal.gameEventName.NoticeAutoStart,self.autoNum[i])
		end)
	end
end


---添加UI事件
function UICommonSlotBtnsCtrl:AddUIEvent()
	GlobalEvent.AddListener(SlotGlobal.gameEventName.NoticeAuto, self.NoticeAuto,self)
	GlobalEvent.AddListener(SlotGlobal.gameEventName.NoticeStopAuto, self.NoticeStopAuto,self)
	GlobalEvent.AddListener(SlotGlobal.gameEventName.GameStateChange,self.GameStateChange,self)
	GlobalEvent.AddListener(SlotGlobal.gameEventName.AwardValue,self.SetAwardText,self)
	
	self.uiEventListener:AddClick(self.view.btn_start, function()
		if self.isLongPress==true then
			self.isLongPress=false
			return
		end
		self:SetObjFreeShow(false)
		GlobalEvent.Notify(SlotGlobal.gameEventName.StartSpin)
	end)
	self.uiEventListener:AddLongPress(self.view.btn_start.gameObject, function()
		self.isLongPress=true
		self:SetObjFreeShow(true)
	end)
	self.uiEventListener:AddClick(self.view.btn_closeFreeMask, function
	()
		self:SetObjFreeShow(false)
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

	self:AddAutoClick()
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
	GlobalEvent.Notify(SlotGlobal.gameEventName.ChangeBetInfo,self.stakeList[self.betIndex])
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

function UICommonSlotBtnsCtrl:SetAwardText(value)
	if tostring(value)=="0" then
		value=""
	end
	self.view.txt_win.text=value
end


---销毁UI
function UICommonSlotBtnsCtrl:RealCloseDestroy()
	self.super.RealCloseDestroy(self);
end

return UICommonSlotBtnsCtrl