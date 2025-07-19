---
---Create by Administrator
---DateTime: 2025-07-18 17:14:55
---
---@class FishPrawnCrabPlayersCtrl:BaseCtrl
local FishPrawnCrabPlayersCtrl=Class("FishPrawnCrabPlayersCtrl",BaseCtrl)

local FishPrawnCrabConfig = require("SingleGames/FishPrawnCrab/FishPrawnCrabConfig")

---构造函数
function FishPrawnCrabPlayersCtrl:ctor(ctrlName,param)
    self.layer=2;
    self.abName="SingleGames/FishPrawnCrab/prefabs/panel/FishPrawnCrabPlayersPanel";
    self.prefabName="FishPrawnCrabPlayersPanel"
    self.super.ctor(self,ctrlName,param);
	---@type FishPrawnCrabPlayersView
	self.view = self.view
	---@type FishPrawnCrabPlayersModel
	self.model = self.model
end

---初始化
function FishPrawnCrabPlayersCtrl:CtrlInit(args)
	self.super.CtrlInit(self,args);
	self:InitData()
end

---初始化数据
function FishPrawnCrabPlayersCtrl:InitData()
	GlobalEvent.Notify(FishPrawnCrabConfig.GameEventName.REQUEST_RANKLIST)
end

function FishPrawnCrabPlayersCtrl:Close()
    self.super.Close(self);
end

---添加UI事件
function FishPrawnCrabPlayersCtrl:AddUIEvent()
	self.uiEventListener:AddClick(self.view.btn_close,function()
		self:Close()
	end)
end

---移除UI事件
function FishPrawnCrabPlayersCtrl:RemoveEvent()
	self.super.RemoveEvent(self);
end

--region UI事件方法

--endregion


---销毁UI
function FishPrawnCrabPlayersCtrl:RealCloseDestroy()
	self.super.RealCloseDestroy(self);
end

return FishPrawnCrabPlayersCtrl