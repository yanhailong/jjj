---
---Create by Administrator
---DateTime: 2025-07-04 13:37:43
---
---@class USDollarExpressGameSelectCtrl:BaseCtrl
local USDollarExpressGameSelectCtrl=Class("USDollarExpressGameSelectCtrl",BaseCtrl)

---构造函数
function USDollarExpressGameSelectCtrl:ctor(ctrlName,param)
    self.layer=2;
    self.abName="SingleGames/USDollarExpress/prefabs/USDollarExpressGameSelect";
    self.prefabName="USDollarExpressGameSelect"
    self.super.ctor(self,ctrlName,param);
	---@type USDollarExpressGameSelectView
	self.view = self.view
	---@type USDollarExpressGameSelectModel
	self.model = self.model
end

---初始化
function USDollarExpressGameSelectCtrl:CtrlInit(args)
	self.super.CtrlInit(self,args);
	self:InitData()
end

---初始化数据
function USDollarExpressGameSelectCtrl:InitData()
	
end

function USDollarExpressGameSelectCtrl:Close()
    self.super.Close(self);
end

---添加UI事件
function USDollarExpressGameSelectCtrl:AddUIEvent()

end

---移除UI事件
function USDollarExpressGameSelectCtrl:RemoveEvent()
	self.super.RemoveEvent(self);
end

--region UI事件方法

--endregion


---销毁UI
function USDollarExpressGameSelectCtrl:RealCloseDestroy()
	self.super.RealCloseDestroy(self);
end

return USDollarExpressGameSelectCtrl