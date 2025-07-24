---
---Create by Administrator
---DateTime: 2025-06-26 17:12:30
---
---@class PlayerRankCtrl:BaseCtrl
local PlayerRankCtrl=Class("PlayerRankCtrl",BaseCtrl)

---构造函数
function PlayerRankCtrl:ctor(ctrlName,param)
    self.layer=2;
    self.abName="Common/UICommon/prefabs/PlayerRankPanel";
    self.prefabName="PlayerRankPanel"
    self.super.ctor(self,ctrlName,param);
	---@type PlayerRankView
	self.view = self.view
	---@type PlayerRankModel
	self.model = self.model
end

---初始化
function PlayerRankCtrl:CtrlInit(args)
	self.super.CtrlInit(self,args);
	self:InitData()
	if args then
		self.view:UpdateData(args)
	end
end

---初始化数据
function PlayerRankCtrl:InitData()

end

function PlayerRankCtrl:Close()
    self.super.Close(self);
end

---添加UI事件
function PlayerRankCtrl:AddUIEvent()
	self.uiEventListener:AddClick(self.view.btn_close,function()
		self:Close()
	end)
end

---移除UI事件
function PlayerRankCtrl:RemoveEvent()
	self.super.RemoveEvent(self);
end

--region UI事件方法

--endregion


---销毁UI
function PlayerRankCtrl:RealCloseDestroy()
	self.super.RealCloseDestroy(self);
end

return PlayerRankCtrl