---
---Create by Administrator
---DateTime: 2025-05-23 14:52:23
---
---@class UILoginCtrl:BaseCtrl
local UILoginCtrl=Class("UILoginCtrl",BaseCtrl)
require("PlatformHall/UIHall/MVCHead")
---构造函数
function UILoginCtrl:ctor(ctrlName,param)
    self.layer=2;
    self.abName="PlatformHall/prefabs/UILogin";
    self.prefabName="UILogin"
    self.super.ctor(self,ctrlName,param);
	---@type UILoginView
	self.view = self.view
	---@type UILoginModel
	self.model = self.model
end

---初始化
function UILoginCtrl:CtrlInit(args)
	self.super.CtrlInit(self,args);
end

function UILoginCtrl:Close()
    self.super.Close(self);
end

---添加UI事件
function UILoginCtrl:AddUIEvent()
	self.uiEventListener:AddClick(self.view.btn_login.gameObject, function
	()
		CtrlManager.SingleShow(CtrlNames.UIHall)
	end)
end

---移除UI事件
function UILoginCtrl:RemoveEvent()
	self.super.RemoveEvent(self);
end

--region UI事件方法

--endregion


---销毁UI
function UILoginCtrl:RealCloseDestroy()
	self.super.RealCloseDestroy(self);
end

return UILoginCtrl