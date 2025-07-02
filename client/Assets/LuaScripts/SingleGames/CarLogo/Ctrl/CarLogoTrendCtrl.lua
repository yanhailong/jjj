---
---Create by Administrator
---DateTime: 2025-06-30 15:05:35
---
---@class CarLogoTrendCtrl:BaseCtrl
local CarLogoTrendCtrl=Class("CarLogoTrendCtrl",BaseCtrl)

---构造函数
function CarLogoTrendCtrl:ctor(ctrlName,param)
    self.layer=2;
    self.abName="SingleGames/CarLogo/prefabs/CarLogoTrendPanel";
    self.prefabName="CarLogoTrendPanel"
    self.super.ctor(self,ctrlName,param);
	---@type CarLogoTrendView
	self.view = self.view
	---@type CarLogoTrendModel
	self.model = self.model
end

---初始化
function CarLogoTrendCtrl:CtrlInit(args)
	self.super.CtrlInit(self,args);
	self:InitData()
end

---初始化数据
function CarLogoTrendCtrl:InitData()
	
end

function CarLogoTrendCtrl:Close()
    self.super.Close(self);
end

---添加UI事件
function CarLogoTrendCtrl:AddUIEvent()
	self.uiEventListener:AddClick(self.view.btn_close,function()
		self:Close()
	end)
end

---移除UI事件
function CarLogoTrendCtrl:RemoveEvent()
	self.super.RemoveEvent(self);
end

--region UI事件方法

--endregion


---销毁UI
function CarLogoTrendCtrl:RealCloseDestroy()
	self.super.RealCloseDestroy(self);
end

return CarLogoTrendCtrl