---
---Create by Administrator
---DateTime: 2025-06-26 11:45:34
---
---@class UIHallCtrl:BaseCtrl
local UIHallCtrl=Class("UIHallCtrl",BaseCtrl)

---构造函数
function UIHallCtrl:ctor(ctrlName,param)
    self.layer=2;
    self.abName="PlatformHall/UIHall/Prefabs/UIHall";
    self.prefabName="UIHall"
    self.super.ctor(self,ctrlName,param);
	---@type UIHallView
	self.view = self.view
	---@type UIHallModel
	self.model = self.model
end

---初始化
function UIHallCtrl:CtrlInit(args)
	self.super.CtrlInit(self,args);
	self:InitData()
end

---初始化数据
function UIHallCtrl:InitData()
	
end

function UIHallCtrl:Close()
    self.super.Close(self);
end

---添加UI事件
function UIHallCtrl:AddUIEvent()
	self.uiEventListener:AddClick(self.view.btn_shop, function
	()
		require("PlatformHall/UITestScroll/MVCHead")
		CtrlManager.SingleShow(CtrlNames.UITestScroll)
	end)
end

---移除UI事件
function UIHallCtrl:RemoveEvent()
	self.super.RemoveEvent(self);
end

--region UI事件方法

--endregion


---销毁UI
function UIHallCtrl:RealCloseDestroy()
	self.super.RealCloseDestroy(self);
end

return UIHallCtrl