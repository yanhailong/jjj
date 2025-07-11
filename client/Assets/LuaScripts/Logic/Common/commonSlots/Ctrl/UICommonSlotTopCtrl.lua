---
---Create by Administrator
---DateTime: 2025-07-01 16:18:52
---
---@class UICommonSlotTopCtrl:BaseCtrl
local UICommonSlotTopCtrl=Class("UICommonSlotTopCtrl",BaseCtrl)

---构造函数
function UICommonSlotTopCtrl:ctor(ctrlName,param)
    self.layer=2;
    self.abName="Common/UICommon/prefabs/UICommonSlotTop";
    self.prefabName="UICommonSlotTop"
    self.super.ctor(self,ctrlName,param);
	---@type UICommonSlotTopView
	self.view = self.view
	---@type UICommonSlotTopModel
	self.model = self.model
end

---初始化
function UICommonSlotTopCtrl:CtrlInit(args)
	self.super.CtrlInit(self,args);
	self:InitData()
end

---初始化数据
function UICommonSlotTopCtrl:InitData()
	
end

function UICommonSlotTopCtrl:Close()
    self.super.Close(self);
end

---添加UI事件
function UICommonSlotTopCtrl:AddUIEvent()
	self.uiEventListener:AddClick(self.view.btn_home, function
	()
		GlobalEvent.Notify(SlotGlobal.gameEventName.BackHome)
	end)
	self.uiEventListener:AddClick(self.view.btn_set, function()  
		GlobalEvent.Notify(SlotGlobal.gameEventName.OpenHelp)
	end)
end

---移除UI事件
function UICommonSlotTopCtrl:RemoveEvent()
	self.super.RemoveEvent(self);
end

--region UI事件方法

--endregion


---销毁UI
function UICommonSlotTopCtrl:RealCloseDestroy()
	self.super.RealCloseDestroy(self);
end

return UICommonSlotTopCtrl