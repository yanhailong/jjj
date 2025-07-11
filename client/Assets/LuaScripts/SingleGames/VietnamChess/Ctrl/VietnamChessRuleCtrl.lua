---
---Create by Administrator
---DateTime: 2025-07-10 15:47:34
---
---@class VietnamChessRuleCtrl:BaseCtrl
local VietnamChessRuleCtrl=Class("VietnamChessRuleCtrl",BaseCtrl)

---构造函数
function VietnamChessRuleCtrl:ctor(ctrlName,param)
    self.layer=2;
    self.abName="SingleGames/VietnamChess/prefabs/panel/VietnamChessRulePanel";
    self.prefabName="VietnamChessRulePanel"
    self.super.ctor(self,ctrlName,param);
	---@type VietnamChessRuleView
	self.view = self.view
	---@type VietnamChessRuleModel
	self.model = self.model
end

---初始化
function VietnamChessRuleCtrl:CtrlInit(args)
	self.super.CtrlInit(self,args);
	self:InitData()
end

---初始化数据
function VietnamChessRuleCtrl:InitData()
	
end

function VietnamChessRuleCtrl:Close()
    self.super.Close(self);
end

---添加UI事件
function VietnamChessRuleCtrl:AddUIEvent()
	self.uiEventListener:AddClick(self.view.btn_close,function()
		self:Close()
	end)
end

---移除UI事件
function VietnamChessRuleCtrl:RemoveEvent()
	self.super.RemoveEvent(self);
end

--region UI事件方法

--endregion


---销毁UI
function VietnamChessRuleCtrl:RealCloseDestroy()
	self.super.RealCloseDestroy(self);
end

return VietnamChessRuleCtrl