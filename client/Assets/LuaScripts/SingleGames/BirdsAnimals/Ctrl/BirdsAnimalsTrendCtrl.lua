---
---Create by Administrator
---DateTime: 2025-07-03 13:19:02
---
---@class BirdsAnimalsTrendCtrl:BaseCtrl
local BirdsAnimalsTrendCtrl=Class("BirdsAnimalsTrendCtrl",BaseCtrl)

---构造函数
function BirdsAnimalsTrendCtrl:ctor(ctrlName,param)
    self.layer=2;
    self.abName="SingleGames/BirdsAnimals/prefabs/BirdsAnimalsTrendPanel";
    self.prefabName="BirdsAnimalsTrendPanel"
    self.super.ctor(self,ctrlName,param);
	---@type BirdsAnimalsTrendView
	self.view = self.view
	---@type BirdsAnimalsTrendModel
	self.model = self.model
end

---初始化
function BirdsAnimalsTrendCtrl:CtrlInit(args)
	self.super.CtrlInit(self,args);
	self:InitData()
end

---初始化数据
function BirdsAnimalsTrendCtrl:InitData()
	
end

function BirdsAnimalsTrendCtrl:Close()
    self.super.Close(self);
end

---添加UI事件
function BirdsAnimalsTrendCtrl:AddUIEvent()
	self.uiEventListener:AddClick(self.view.btn_close,function()
		self:Close()
	end)
end

---移除UI事件
function BirdsAnimalsTrendCtrl:RemoveEvent()
	self.super.RemoveEvent(self);
end

--region UI事件方法

--endregion


---销毁UI
function BirdsAnimalsTrendCtrl:RealCloseDestroy()
	self.super.RealCloseDestroy(self);
end

return BirdsAnimalsTrendCtrl