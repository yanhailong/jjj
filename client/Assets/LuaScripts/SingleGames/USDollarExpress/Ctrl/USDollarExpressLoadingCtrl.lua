---
---Create by Administrator
---DateTime: 2025-06-18 13:55:05
---
---@class USDollarExpressLoadingCtrl:BaseCtrl
local USDollarExpressLoadingCtrl=Class("USDollarExpressLoadingCtrl",BaseCtrl)

---构造函数
function USDollarExpressLoadingCtrl:ctor(ctrlName,param)
    self.layer=2;
    self.abName="SingleGames/USDollarExpress/prefabs/USDollarExpressLoading";
    self.prefabName="USDollarExpressLoading"
    self.super.ctor(self,ctrlName,param);
	---@type USDollarExpressLoadingView
	self.view = self.view
	---@type USDollarExpressLoadingModel
	self.model = self.model
end

---初始化
function USDollarExpressLoadingCtrl:CtrlInit(args)
	self.super.CtrlInit(self,args);
	self:InitData()
end

---初始化数据
function USDollarExpressLoadingCtrl:InitData()
	
end

function USDollarExpressLoadingCtrl:Close()
    self.super.Close(self);
end

---添加UI事件
function USDollarExpressLoadingCtrl:AddUIEvent()

end

---移除UI事件
function USDollarExpressLoadingCtrl:RemoveEvent()
	self.super.RemoveEvent(self);
end

--region UI事件方法

--endregion


---销毁UI
function USDollarExpressLoadingCtrl:RealCloseDestroy()
	self.super.RealCloseDestroy(self);
end

return USDollarExpressLoadingCtrl