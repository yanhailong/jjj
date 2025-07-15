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
	local gameName=GameSortID[index];
	if gameName==nil then
		SuspensionTipsUtil.SuspensionTips("游戏未开放!")
	else
		GameCenter.EnterGame(gameName);
	end
	--if index==1 then
	--	--require("SingleGames/TestGame/MVCHead")
	--	require("SingleGames/USDollarExpress/MVCHead")
	--	CtrlManager.SingleShow(CtrlNames.USDollarExpressMain)
	--	
	--elseif index == 2 then
	--	require("SingleGames/Baccarat/MVCHead")
	--	CtrlManager.SingleShow(CtrlNames.BaccaratMain)
	--elseif index == 3 then
	--	require("SingleGames/CarLogo/MVCHead")
	--	CtrlManager.SingleShow(CtrlNames.CarLogoGame)
	--elseif index == 4 then
	--	require("SingleGames/BirdsAnimals/MVCHead")
	--	CtrlManager.SingleShow(CtrlNames.BirdsAnimalsGame)
	--elseif index == 5 then
	--	require("SingleGames/RoyalWar/MVCHead")
	--	CtrlManager.SingleShow(CtrlNames.RoyalWarGame)
	--elseif index == 6 then
	--	require("SingleGames/DragonTigerFight/MVCHead")
	--	CtrlManager.SingleShow(CtrlNames.DragonTigerFight)
	--elseif index == 7 then
	--	require("SingleGames/VietnamChess/MVCHead")
	--	CtrlManager.SingleShow(CtrlNames.VietnamChessGame)
	--elseif index == 8 then
	--	require("SingleGames/FishPrawnCrab/MVCHead")
	--	CtrlManager.SingleShow(CtrlNames.FishPrawnCrabGame)
	--end
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