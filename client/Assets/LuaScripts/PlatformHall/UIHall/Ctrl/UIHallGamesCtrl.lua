---
---Create by Administrator
---DateTime: 2025-06-26 11:27:13
---
---@class UIHallGamesCtrl:BaseCtrl
local UIHallGamesCtrl=Class("UIHallGamesCtrl",BaseCtrl)
---构造函数
function UIHallGamesCtrl:ctor(ctrlName,param)
    self.layer=2;
    self.abName="PlatformHall/UIHall/Prefabs/UIHallGames";
    self.prefabName="UIHallGames"
    self.super.ctor(self,ctrlName,param);
	---@type UIHallGamesView
	self.view = self.view
	---@type UIHallGamesModel
	self.model = self.model
end

---初始化
function UIHallGamesCtrl:CtrlInit(args)
	self.super.CtrlInit(self,args);
	CtrlManager.SingleShow(CtrlNames.UIHall)
	self:InitData()
end

---初始化数据
function UIHallGamesCtrl:InitData()
	
end

function UIHallGamesCtrl:Close()
    self.super.Close(self);
end

---添加UI事件
function UIHallGamesCtrl:AddUIEvent()
	for i = 1, self.view.gameIconCount do
		self.uiEventListener:AddClick(self.view.itemInfos[i],function ()
			self:OnClickGameItem(i);
		end);
	end
end

---点击游戏按钮
function UIHallGamesCtrl:OnClickGameItem(index)
	logError("点击了Item: "..index)
	if index==1 then
		require("SingleGames/USDollarExpress/MVCHead")
		CtrlManager.SingleShow(CtrlNames.USDollarExpressMain)
	elseif index == 2 then
		require("SingleGames/Baccarat/SelectPanel/MVCHead")
		CtrlManager.SingleShow(CtrlNames.BaccaratMain)
	elseif index == 5 then
		require("SingleGames/RoyalWar/MVCHead")
		CtrlManager.SingleShow(CtrlNames.RoyalWarGame)
	end
end

---移除UI事件
function UIHallGamesCtrl:RemoveEvent()
	self.super.RemoveEvent(self);
end

--region UI事件方法

--endregion


---销毁UI
function UIHallGamesCtrl:RealCloseDestroy()
	self.super.RealCloseDestroy(self);
end

return UIHallGamesCtrl