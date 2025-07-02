---
---Create by Administrator
---DateTime: 2025-07-02 08:53:42
---
---@class CarLogoPlayersCtrl:BaseCtrl
local CarLogoPlayersCtrl=Class("CarLogoPlayersCtrl",BaseCtrl)

---构造函数
function CarLogoPlayersCtrl:ctor(ctrlName,param)
    self.layer=2;
    self.abName="SingleGames/CarLogo/prefabs/CarLogoPlayersPanel";
    self.prefabName="CarLogoPlayersPanel"
    self.super.ctor(self,ctrlName,param);
	---@type CarLogoPlayersView
	self.view = self.view
	---@type CarLogoPlayersModel
	self.model = self.model
end

---初始化
function CarLogoPlayersCtrl:CtrlInit(args)
	self.super.CtrlInit(self,args);
	self:InitData()
end

---初始化数据
function CarLogoPlayersCtrl:InitData()
	GlobalEvent.Notify("RECT_CARLOGO_PLAYER",{}) --测试
end

function CarLogoPlayersCtrl:Close()
    self.super.Close(self);
end

---添加UI事件
function CarLogoPlayersCtrl:AddUIEvent()
	self.uiEventListener:AddClick(self.view.btn_close,function()
		self:Close()
	end)
end

---移除UI事件
function CarLogoPlayersCtrl:RemoveEvent()
	self.super.RemoveEvent(self);
end

--region UI事件方法

--endregion


---销毁UI
function CarLogoPlayersCtrl:RealCloseDestroy()
	self.super.RealCloseDestroy(self);
end

return CarLogoPlayersCtrl