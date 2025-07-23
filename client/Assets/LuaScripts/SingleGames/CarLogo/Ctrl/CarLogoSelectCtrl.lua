---
---Create by Administrator
---DateTime: 2025-07-22 17:17:10
---
---@class CarLogoSelectCtrl:BaseCtrl
local CarLogoSelectCtrl=Class("CarLogoSelectCtrl",BaseCtrl)

---构造函数
function CarLogoSelectCtrl:ctor(ctrlName,param)
    self.layer=2;
    self.abName="SingleGames/CarLogo/prefabs/CarLogoSelectPanel";
    self.prefabName="CarLogoSelectPanel"
    self.super.ctor(self,ctrlName,param);
	---@type CarLogoSelectView
	self.view = self.view
	---@type CarLogoSelectModel
	self.model = self.model
end

---初始化
function CarLogoSelectCtrl:CtrlInit(args)
	self.super.CtrlInit(self,args);
	self:InitData()
end

---初始化数据
function CarLogoSelectCtrl:InitData()
	
end

function CarLogoSelectCtrl:Close()
    self.super.Close(self);
end

---添加UI事件
function CarLogoSelectCtrl:AddUIEvent()
	self.uiEventListener:AddClick(self.view.btn_close,function() self:Close()  end)
	self.uiEventListener:AddClick(self.view.btn_car1,function() self:Select(1)  end)
	self.uiEventListener:AddClick(self.view.btn_car2,function() self:Select(2)  end)
	self.uiEventListener:AddClick(self.view.btn_car3,function() self:Select(3)  end)
end

---移除UI事件
function CarLogoSelectCtrl:RemoveEvent()
	self.super.RemoveEvent(self);
end

--region UI事件方法
function CarLogoSelectCtrl:Select(index)
	CtrlManager.SingleShow(CtrlNames.CarLogoGame,index)
end
--endregion


---销毁UI
function CarLogoSelectCtrl:RealCloseDestroy()
	self.super.RealCloseDestroy(self);
end

return CarLogoSelectCtrl