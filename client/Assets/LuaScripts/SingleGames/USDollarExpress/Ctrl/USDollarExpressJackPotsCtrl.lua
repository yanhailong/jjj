---
---Create by Administrator
---DateTime: 2025-07-19 11:25:15
---
---@class USDollarExpressJackPotsCtrl:BaseCtrl
local USDollarExpressJackPotsCtrl=Class("USDollarExpressJackPotsCtrl",BaseCtrl)

---构造函数
function USDollarExpressJackPotsCtrl:ctor(ctrlName,param)
    self.layer=2;
    self.abName="SingleGames/USDollarExpress/prefabs/USDollarExpressJackPots";
    self.prefabName="USDollarExpressJackPots"
    self.super.ctor(self,ctrlName,param);
	---@type USDollarExpressJackPotsView
	self.view = self.view
	---@type USDollarExpressJackPotsModel
	self.model = self.model
end

---初始化
function USDollarExpressJackPotsCtrl:CtrlInit(args)
	self.super.CtrlInit(self,args);
	self:InitData()
	local data=args
	self.poolId=data.poolId
	self.jackpotvalue=data.jackpotvalue
	look("奖池，",data)
end

---初始化数据
function USDollarExpressJackPotsCtrl:InitData()
	
end

function USDollarExpressJackPotsCtrl:Close()
    self.super.Close(self);
end

---添加UI事件
function USDollarExpressJackPotsCtrl:AddUIEvent()

end

---移除UI事件
function USDollarExpressJackPotsCtrl:RemoveEvent()
	self.super.RemoveEvent(self);
end

--region UI事件方法

--endregion


---销毁UI
function USDollarExpressJackPotsCtrl:RealCloseDestroy()
	self.super.RealCloseDestroy(self);
end

return USDollarExpressJackPotsCtrl