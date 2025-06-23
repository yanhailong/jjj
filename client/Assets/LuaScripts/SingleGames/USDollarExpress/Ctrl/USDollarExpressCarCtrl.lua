---
---Create by Administrator
---DateTime: 2025-06-21 15:39:44
---
---@class USDollarExpressCarCtrl:BaseCtrl
local USDollarExpressCarCtrl=Class("USDollarExpressCarCtrl",BaseCtrl)

---构造函数
function USDollarExpressCarCtrl:ctor(ctrlName,param)
    self.layer=2;
    self.abName="SingleGames/USDollarExpress/prefabs/USDollarExpressCar";
    self.prefabName="USDollarExpressCar"
    self.super.ctor(self,ctrlName,param);
	---@type USDollarExpressCarView
	self.view = self.view
	---@type USDollarExpressCarModel
	self.model = self.model
end

---初始化
function USDollarExpressCarCtrl:CtrlInit(args)
	self.super.CtrlInit(self,args);
	self:InitData()
	self.trainInfoList=args
	
	
	look("拉火车数据",self.trainInfoList)
end

---初始化数据
function USDollarExpressCarCtrl:InitData()
	---@type Queue
	self.CarQueue=Queue.New()
	self:InitCars()
end

---初始化火车厢
function USDollarExpressCarCtrl:InitCars()
	self.WidthSpace=1280
	self.allItems={}
	for i = 1, 10 do
		local card = instantiate(self.view.objCar)
		card:SetActive(true)
		card.transform:SetParent(self.view.trans_root)
		card.transform.localPosition = Vector3.New(i* -self.WidthSpace, 0, 0) -- 设置slotItem的位置
		card.transform.localScale = Vector3.one
		card.name = tostring(i)
		self.allItems[i]=card
	end
	
	self.maxMoveIndex=10
	self.curMoveIndex=1
	self:Move()
	 
end

function USDollarExpressCarCtrl:Move()
	self.tweener=self.view.trans_root:DOLocalMoveX(self.WidthSpace*self.curMoveIndex, 2)
	self.tweener:SetEase(DG.Tweening.Ease.Linear);
	self.tweener.onComplete=function()
		logError("移动完毕")
		---@type UnityEngine.GameObject
		local obj= self.allItems[self.curMoveIndex]
		obj.transform:DOScale(1.1, 0.2)
		self.curMoveIndex=self.curMoveIndex+1
		if self.curMoveIndex<=self.maxMoveIndex then
			self:Move()
		end
	end
end


function USDollarExpressCarCtrl:Close()
    self.super.Close(self);
end

---添加UI事件
function USDollarExpressCarCtrl:AddUIEvent()
	self.uiEventListener:AddClick(self.view.btn_skip, function
	()
		local ctrl= CtrlManager.GetCtrl(CtrlNames.USDollarExpressMain)
		ctrl:EndSmallGame()
		self:Close()
	end)
end

---移除UI事件
function USDollarExpressCarCtrl:RemoveEvent()
	self.super.RemoveEvent(self);
end

--region UI事件方法

--endregion


---销毁UI
function USDollarExpressCarCtrl:RealCloseDestroy()
	self.super.RealCloseDestroy(self);
end

return USDollarExpressCarCtrl