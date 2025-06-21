---
---Create by Administrator
---DateTime: 2025-06-21 17:21:49
---
---@class BaccaratGameCtrl:BaseCtrl
local BaccaratGameCtrl=Class("BaccaratGameCtrl",BaseCtrl)

---构造函数
function BaccaratGameCtrl:ctor(ctrlName,param)
    self.layer=2;
    self.abName="SingleGames/Baccarat/prefabs/BaccaratGamePanel";
    self.prefabName="BaccaratGamePanel"
    self.super.ctor(self,ctrlName,param);
	---@type BaccaratGameView
	self.view = self.view
	---@type BaccaratGameModel
	self.model = self.model
end

---初始化
function BaccaratGameCtrl:CtrlInit(args)
	self.super.CtrlInit(self,args);
	self:InitData()
end

---初始化数据
function BaccaratGameCtrl:InitData()
	
end

function BaccaratGameCtrl:Close()
    self.super.Close(self);
end

---添加UI事件
function BaccaratGameCtrl:AddUIEvent()
    self.uiEventListener:AddClick(self.view.btn_close,function()
		self:Close();
	end)
end

---移除UI事件
function BaccaratGameCtrl:RemoveEvent()
	self.super.RemoveEvent(self);
end

--region UI事件方法

--endregion


---销毁UI
function BaccaratGameCtrl:RealCloseDestroy()
	self.super.RealCloseDestroy(self);
end

return BaccaratGameCtrl