---
---Create by Administrator
---DateTime: 2025-06-21 15:39:44
---
---@class USDollarExpressCarCtrl:BaseCtrl
local USDollarExpressCarCtrl=Class("USDollarExpressCarCtrl",BaseCtrl)

---构造函数
function USDollarExpressCarCtrl:ctor(ctrlName,param)
    self.layer=2;
    self.abName="SingleGames/USDollarExpress/prefabs/USDollarExpressCar";
    self.prefabName="USDollarExpressCar"
    self.super.ctor(self,ctrlName,param);
	---@type USDollarExpressCarView
	self.view = self.view
	---@type USDollarExpressCarModel
	self.model = self.model
end

---初始化
function USDollarExpressCarCtrl:CtrlInit(args)
	self.super.CtrlInit(self,args);
	self:InitData()
	self.trainInfoList=args
	look("拉火车数据",self.trainInfoList)
end

---初始化数据
function USDollarExpressCarCtrl:InitData()
	
end

---初始化火车厢
function USDollarExpressCarCtrl:InitCars()
	
end


function USDollarExpressCarCtrl:Close()
    self.super.Close(self);
end

---添加UI事件
function USDollarExpressCarCtrl:AddUIEvent()
	self.uiEventListener:AddClick(self.view.btn_skip, function
	()
		local ctrl= CtrlManager.GetCtrl(CtrlNames.USDollarExpressMain)
		ctrl:EndSmallGame()
		self:Close()
	end)
end

---移除UI事件
function USDollarExpressCarCtrl:RemoveEvent()
	self.super.RemoveEvent(self);
end

--region UI事件方法

--endregion


---销毁UI
function USDollarExpressCarCtrl:RealCloseDestroy()
	self.super.RealCloseDestroy(self);
end

return USDollarExpressCarCtrl