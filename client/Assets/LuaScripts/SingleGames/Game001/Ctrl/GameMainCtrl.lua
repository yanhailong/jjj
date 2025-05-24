---
---Create by Administrator
---DateTime: 2025-05-23 16:55:00
---
---@class GameMainCtrl:BaseCtrl
local GameMainCtrl=Class("GameMainCtrl",BaseCtrl)

---构造函数
function GameMainCtrl:ctor(ctrlName,param)
    self.layer=2;
    self.abName="SingleGames/Game001/prefabs/GameMain";
    self.prefabName="GameMain"
    self.super.ctor(self,ctrlName,param);
	---@type GameMainView
	self.view = self.view
	---@type GameMainModel
	self.model = self.model
end

---初始化
function GameMainCtrl:CtrlInit(args)
	self.super.CtrlInit(self,args);
end

function GameMainCtrl:Close()
    self.super.Close(self);
end

---添加UI事件
function GameMainCtrl:AddUIEvent()

end

---移除UI事件
function GameMainCtrl:RemoveEvent()
	self.super.RemoveEvent(self);
end

--region UI事件方法

--endregion


---销毁UI
function GameMainCtrl:RealCloseDestroy()
	self.super.RealCloseDestroy(self);
end

return GameMainCtrl