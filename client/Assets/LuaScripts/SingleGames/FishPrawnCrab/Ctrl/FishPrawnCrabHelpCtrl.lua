---
---Create by Administrator
---DateTime: 2025-07-18 15:45:49
---
---@class FishPrawnCrabHelpCtrl:BaseCtrl
local FishPrawnCrabHelpCtrl=Class("FishPrawnCrabHelpCtrl",BaseCtrl)

---构造函数
function FishPrawnCrabHelpCtrl:ctor(ctrlName,param)
    self.layer=2;
    self.abName="SingleGames/FishPrawnCrab/prefabs/panel/FishPrawnCrabHelp";
    self.prefabName="FishPrawnCrabHelp"
    self.super.ctor(self,ctrlName,param);
	---@type FishPrawnCrabHelpView
	self.view = self.view
	---@type FishPrawnCrabHelpModel
	self.model = self.model
end

---初始化
function FishPrawnCrabHelpCtrl:CtrlInit(args)
	self.super.CtrlInit(self,args);
	self:InitData()
end

---初始化数据
function FishPrawnCrabHelpCtrl:InitData()
	
end

function FishPrawnCrabHelpCtrl:Close()
    self.super.Close(self);
end

---添加UI事件
function FishPrawnCrabHelpCtrl:AddUIEvent()
	self.uiEventListener:AddClick(self.view.btn_close,function()
		self:Close()
	end)
end

---移除UI事件
function FishPrawnCrabHelpCtrl:RemoveEvent()
	self.super.RemoveEvent(self);
end

--region UI事件方法

--endregion


---销毁UI
function FishPrawnCrabHelpCtrl:RealCloseDestroy()
	self.super.RealCloseDestroy(self);
end

return FishPrawnCrabHelpCtrl