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
	self.stakeList=args
	self:InitPlayerInfos(self.stakeList)
end

---初始化数据
function UICommonSlotBtnsCtrl:InitData()
	self.betIndex=1--下注索引，默认为1
	self.isLongPress=false
end

function UICommonSlotBtnsCtrl:Close()
    self.super.Close(self);
end

---添加UI事件
function UICommonSlotBtnsCtrl:AddUIEvent()
	self.uiEventListener:AddClick(self.view.btn_start, function()
		if self.isLongPress==true then
			self.isLongPress=false
			return
		end
		self:SetObjFreeShow(false)
		GlobalEvent.Notify(SlotEvent.SlotEventName.StartSpin,self.stakeList[self.betIndex])
	end)
	self.uiEventListener:AddLongPress(self.view.btn_start.gameObject, function()
		self.isLongPress=true
		self:SetObjFreeShow(true)
	end)
	self.uiEventListener:AddClick(self.view.btn_closeFreeMask, function
	()
		self:SetObjFreeShow(false)
	end)
end

function UICommonSlotBtnsCtrl:SetObjFreeShow(bl)
	self.view.btn_closeFreeMask.gameObject:SetActive(bl)
	self.view.obj_free:SetActive(bl)
end


---移除UI事件
function UICommonSlotBtnsCtrl:RemoveEvent()
	self.super.RemoveEvent(self);
end

---设置玩家初始数据
function UICommonSlotBtnsCtrl:InitPlayerInfos(stakeList)
	self:SetChipText(self.stakeList[self.betIndex])--设置默认
	self:InitChipInfoUiEvent()
end

function UICommonSlotBtnsCtrl:SetChipText(value)
	self.view.tmp_chip.text=value
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


---销毁UI
function UICommonSlotBtnsCtrl:RealCloseDestroy()
	self.super.RealCloseDestroy(self);
end

return UICommonSlotBtnsCtrl