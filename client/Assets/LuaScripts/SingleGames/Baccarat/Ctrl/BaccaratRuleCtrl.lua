---
---Create by Administrator
---DateTime: 2025-07-09 15:01:09
---
---@class BaccaratRuleCtrl:BaseCtrl
local BaccaratRuleCtrl=Class("BaccaratRuleCtrl",BaseCtrl)

---构造函数
function BaccaratRuleCtrl:ctor(ctrlName,param)
    self.layer=2;
    self.abName="SingleGames/Baccarat/prefabs/BaccaratRulePanel";
    self.prefabName="BaccaratRulePanel"
    self.super.ctor(self,ctrlName,param);
	---@type BaccaratRuleView
	self.view = self.view
	---@type BaccaratRuleModel
	self.model = self.model
end

---初始化
function BaccaratRuleCtrl:CtrlInit(args)
	self.super.CtrlInit(self,args);
	self:InitData()
end

---初始化数据
function BaccaratRuleCtrl:InitData()
	
end

function BaccaratRuleCtrl:Close()
    self.super.Close(self);
end

---添加UI事件
function BaccaratRuleCtrl:AddUIEvent()
	self.uiEventListener:AddClick(self.view.btn_close,function()
		self:Close()
	end)
end

---移除UI事件
function BaccaratRuleCtrl:RemoveEvent()
	self.super.RemoveEvent(self);
end

--region UI事件方法

--endregion


---销毁UI
function BaccaratRuleCtrl:RealCloseDestroy()
	self.super.RealCloseDestroy(self);
end

return BaccaratRuleCtrl