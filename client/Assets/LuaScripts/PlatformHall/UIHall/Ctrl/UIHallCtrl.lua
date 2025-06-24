---
---Create by Administrator
---DateTime: 2025-06-23 17:21:44
---
---@class UIHallCtrl:BaseCtrl
local UIHallCtrl=Class("UIHallCtrl",BaseCtrl)
require("SingleGames/Baccarat/MVCHead")
require("Logic/Config/HallConfig")
require("SingleGames/DragonTigerFight/MVCHead")

---构造函数
function UIHallCtrl:ctor(ctrlName,param)
    self.layer=2;
    self.abName="PlatformHall/UIHall/Prefabs/UIHall";
    self.prefabName="UIHall"
    self.super.ctor(self,ctrlName,param);
	---@type UIHallView
	self.view = self.view
	---@type UIHallModel
	self.model = self.model
end

---初始化
function UIHallCtrl:CtrlInit(args)
	self.super.CtrlInit(self,args);
	self:InitData()
end

---初始化数据
function UIHallCtrl:InitData()
	self.img_buttom_diMoveUpPosY=91
	self.img_buttom_diMoveDownPosy=-178
end

function UIHallCtrl:Close()
    self.super.Close(self);
end

---添加UI事件
function UIHallCtrl:AddUIEvent()
	self.uiEventListener:AddClick(self.view.btn_USDollarExpress, function
	()
		self.model:ReqEnterGame(GameConfig[GameNames.USDollarExpress].gameType)
	end)	
	self.uiEventListener:AddClick(self.view.btn_Baccarat, function
	()
		CtrlManager.SingleShow(CtrlNames.BaccaratGame)
	end)
	self.uiEventListener:AddClick(self.view.btn_LongHuDou, function
	()
		CtrlManager.SingleShow(CtrlNames.DragonTigerFight)
	end)
	local isUp=false
	self.isCanClickBtnArrow=true
	self.uiEventListener:AddClick(self.view.btn_arrow, function
	()
		if not self.isCanClickBtnArrow then
			return
		end
		self.isCanClickBtnArrow=false
		isUp=not isUp
		self:MoveBUttomDi(isUp)
	end)
end

---移除UI事件
function UIHallCtrl:RemoveEvent()
	self.super.RemoveEvent(self);
end

--region UI事件方法
function UIHallCtrl:MoveBUttomDi(isUp)
	---@type DG.Tweening.Tween
	local tw_img_buttom_di= self.view.img_buttom_di.transform:DOLocalMoveY(isUp and self.img_buttom_diMoveUpPosY or self.img_buttom_diMoveDownPosy,0.5)
	tw_img_buttom_di.onComplete=function()
		self.isCanClickBtnArrow=true
		if isUp==true then
			self.view.obj_two:SetActive(true)
		end
	end
	if isUp==false then
		self.view.obj_two:SetActive(false)
	end
	self.view.btn_arrow.transform.localScale =isUp and Vector3.New(1, -1, 1) or Vector3.New(1, 1, 1)
	
end



--endregion


---销毁UI
function UIHallCtrl:RealCloseDestroy()
	self.super.RealCloseDestroy(self);
end

return UIHallCtrl