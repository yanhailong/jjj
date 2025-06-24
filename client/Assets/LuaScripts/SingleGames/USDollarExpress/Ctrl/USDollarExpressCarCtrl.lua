---
---Create by Administrator
---DateTime: 2025-06-21 15:39:44
---
---@class USDollarExpressCarCtrl:BaseCtrl
local USDollarExpressCarCtrl=Class("USDollarExpressCarCtrl",BaseCtrl)
---@type USDollarExpressConfig
local config=require("SingleGames/USDollarExpress/USDollarExpressConfig")

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
	self.trainInfoList=args
	self:InitData()

	
	look("拉火车数据",self.trainInfoList)
end


---初始化数据
function USDollarExpressCarCtrl:InitData()
	---@type ObjectPoolUtil
	self.objPools=ObjectPoolUtil.New()
	---@type Queue
	self.CarQueue=Queue.New()
	for i = 1, #self.trainInfoList do
		self.CarQueue:Enqueue(self.trainInfoList[i])
	end
	self:InitCars()
end

---初始化火车厢
function USDollarExpressCarCtrl:InitCars()
	if self.CarQueue:Count()==0 then
		logError("拉火车模式结束")
		CorManager.StartCor(self, function
		()
			coroutine.wait(2)
			self:Close()
		end)
	else
		local trainInfo=self.CarQueue:Dequeue()
		local carType=trainInfo.type
		local goldList=trainInfo.goldList
		self:SetCarTitle(carType)
		self:InitTrainComponent(goldList,carType)
	end
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
		else
			CorManager.StartCor(self,function
			()
				logError("当前火车移动完毕！！")
				coroutine.wait(2)
				self:InitCars()
			end)
			
		end
	end
end

function USDollarExpressCarCtrl:SetCarTitle(type)
	if type==config.TrainColorType.GreenTrain then
		self.view.tmp_loading.text="绿火车"
	end
	if type==config.TrainColorType.BlueTrain then
		self.view.tmp_loading.text="蓝火车"
	end
	if type==config.TrainColorType.RedTrain then
		self.view.tmp_loading.text="红火车"
	end
	if type==config.TrainColorType.VioletTrain then
		self.view.tmp_loading.text="紫火车"
	end
	if type==config.TrainColorType.GoldTrain then
		self.view.tmp_loading.text="金火车"
	end
end

---初始化火车车厢
function USDollarExpressCarCtrl:InitTrainComponent(goldList,carType)
	self.WidthSpace=1280
	self.allItems={}
	for i = 1, #goldList do
		self.objPools:SpawnPrefab(function
		(card)
			card:SetActive(true)
			card.transform:SetParent(self.view.trans_root)
			card.transform.localPosition = Vector3.New(i* -self.WidthSpace, 0, 0) -- 设置slotItem的位置
			card.transform.localScale = Vector3.one
			ComponentUtilGet.TextMeshProUGUI(card.transform,"tmp_value").text=tostring(goldList[i])
			card.name = tostring(i)
			self.allItems[i]=card
		end, config.ABNames.train, config.GetTrainItemByType(carType), self.view.trans_root)
	end

	self.maxMoveIndex= #goldList
	self.curMoveIndex=1
	self:Move()
	
end


function USDollarExpressCarCtrl:Close()
    self.super.Close(self);
	if self.tweener then
		self.tweener:Kill()
	end
	self.objPools:DestroyAll()
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