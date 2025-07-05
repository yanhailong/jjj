---
---Create by Administrator
---DateTime: 2025-07-02 15:39:02
---
---@class USDollarExpressMapSelectCtrl:BaseCtrl
local USDollarExpressMapSelectCtrl=Class("USDollarExpressMapSelectCtrl",BaseCtrl)

---构造函数
function USDollarExpressMapSelectCtrl:ctor(ctrlName,param)
    self.layer=2;
    self.abName="SingleGames/USDollarExpress/prefabs/USDollarExpressMapSelect";
    self.prefabName="USDollarExpressMapSelect"
    self.super.ctor(self,ctrlName,param);
	---@type USDollarExpressMapSelectView
	self.view = self.view
	---@type USDollarExpressMapSelectModel
	self.model = self.model
end

---初始化
function USDollarExpressMapSelectCtrl:CtrlInit(args)
	self.super.CtrlInit(self,args);
	self:InitData()
end

---初始化数据
function USDollarExpressMapSelectCtrl:InitData()
	
end

function USDollarExpressMapSelectCtrl:Close()
    self.super.Close(self);
end

---添加UI事件
function USDollarExpressMapSelectCtrl:AddUIEvent()
	--self.view.img_1.alphaHitTestMinimumThreshold=0.1
	--self.view.img_2.alphaHitTestMinimumThreshold=0.1
	--self.view.img_3.alphaHitTestMinimumThreshold=0.1
	--self.view.img_4.alphaHitTestMinimumThreshold=0.1
	--self.view.img_5.alphaHitTestMinimumThreshold=0.1
	--self.view.img_6.alphaHitTestMinimumThreshold=0.1
	--
	--
	--self.uiEventListener:AddClick(self.view.img_1, function
	--()
	--	logError("img_1")
	--end)
	--self.uiEventListener:AddClick(self.view.img_2, function
	--()
	--	logError("img_2")
	--end)
	--self.uiEventListener:AddClick(self.view.img_3, function
	--()
	--	logError("img_3")
	--end)
	--self.uiEventListener:AddClick(self.view.img_4, function
	--()
	--	logError("img_4")
	--end)
	--self.uiEventListener:AddClick(self.view.img_5, function
	--()
	--	logError("img_5")
	--end)
	--self.uiEventListener:AddClick(self.view.img_6, function
	--()
	--	logError("img_6")
	--end)
end

---移除UI事件
function USDollarExpressMapSelectCtrl:RemoveEvent()
	self.super.RemoveEvent(self);
end

--region UI事件方法

--endregion


---销毁UI
function USDollarExpressMapSelectCtrl:RealCloseDestroy()
	self.super.RealCloseDestroy(self);
end

return USDollarExpressMapSelectCtrl