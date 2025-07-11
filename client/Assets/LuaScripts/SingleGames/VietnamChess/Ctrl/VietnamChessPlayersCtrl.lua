---
---Create by Administrator
---DateTime: 2025-07-10 15:47:41
---
---@class VietnamChessPlayersCtrl:BaseCtrl
local VietnamChessPlayersCtrl=Class("VietnamChessPlayersCtrl",BaseCtrl)

---构造函数
function VietnamChessPlayersCtrl:ctor(ctrlName,param)
    self.layer=2;
    self.abName="SingleGames/VietnamChess/prefabs/panel/VietnamChessPlayersPanel";
    self.prefabName="VietnamChessPlayersPanel"
    self.super.ctor(self,ctrlName,param);
	---@type VietnamChessPlayersView
	self.view = self.view
	---@type VietnamChessPlayersModel
	self.model = self.model
end

---初始化
function VietnamChessPlayersCtrl:CtrlInit(args)
	self.super.CtrlInit(self,args);
	self:InitData()
end

---初始化数据
function VietnamChessPlayersCtrl:InitData()
	
end

function VietnamChessPlayersCtrl:Close()
    self.super.Close(self);
end

---添加UI事件
function VietnamChessPlayersCtrl:AddUIEvent()
	self.uiEventListener:AddClick(self.view.btn_close,function()
		self:Close()
	end)
end

---移除UI事件
function VietnamChessPlayersCtrl:RemoveEvent()
	self.super.RemoveEvent(self);
end

--region UI事件方法

--endregion


---销毁UI
function VietnamChessPlayersCtrl:RealCloseDestroy()
	self.super.RealCloseDestroy(self);
end

return VietnamChessPlayersCtrl