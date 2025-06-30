---
---Create by Administrator
---DateTime: 2025-06-30 16:37:31
---
---@class UICommonSelectionCtrl:BaseCtrl
local UICommonSelectionCtrl=Class("UICommonSelectionCtrl",BaseCtrl)

---构造函数
function UICommonSelectionCtrl:ctor(ctrlName,param)
    self.layer=2;
    self.abName="PlatformHall/UICommonSelection/UICommonSelection";
    self.prefabName="UICommonSelection"
    self.super.ctor(self,ctrlName,param);
	---@type UICommonSelectionView
	self.view = self.view
	---@type UICommonSelectionModel
	self.model = self.model
end

---初始化
function UICommonSelectionCtrl:CtrlInit(args)
	self.super.CtrlInit(self,args);
	self:InitData()
end

---初始化数据
function UICommonSelectionCtrl:InitData()
	
end

function UICommonSelectionCtrl:Close()
    self.super.Close(self);
end

---添加UI事件
function UICommonSelectionCtrl:AddUIEvent()

end

---移除UI事件
function UICommonSelectionCtrl:RemoveEvent()
	self.super.RemoveEvent(self);
end

--region UI事件方法

--endregion


---销毁UI
function UICommonSelectionCtrl:RealCloseDestroy()
	self.super.RealCloseDestroy(self);
end

return UICommonSelectionCtrl