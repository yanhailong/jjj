---
---Create by Administrator
---DateTime: 2025-06-21 15:39:44
---
---@class USDollarExpressCarCtrl:BaseCtrl
local USDollarExpressCarCtrl=Class("USDollarExpressCarCtrl",BaseCtrl)
---@type USDollarExpressConfig
local config=require("SingleGames/USDollarExpress/USDollarExpressConfig")
---@type USDollarExpressTrainItem
local USDollarExpressTrainItem=require("SingleGames/USDollarExpress/Ctrl/USDollarExpressTrainItem")

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
	self.isAllCarArrive=false
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

--function USDollarExpressCarCtrl:Move()
--	self.WidthSpace=CS.UnityEngine.Screen.width/2
--	logError("移动的间距："..self.WidthSpace)
--	local posx=self.WidthSpace*self.curMoveIndex
--	local endPos=Vector3.New(posx,0,0)
--	self.tweener=self.view.trans_root:DOAnchorPos(endPos, 2)
--	self.tweener:SetEase(DG.Tweening.Ease.Linear);
--	self.tweener.onComplete=function()
--		logError("移动完毕")
--		CorManager.StartCor(self, function
--		()
--			---@type USDollarExpressTrainItem
--			local item= self.allItems[self.curMoveIndex]
--			item:DOPlayerAni()
--			coroutine.wait(0.5)
--			self.curMoveIndex=self.curMoveIndex+1
--			if self.curMoveIndex<=self.maxMoveIndex then
--				self:Move()
--			else
--				logError("当前火车移动完毕！！")
--				coroutine.wait(2)
--				self:InitCars()
--
--			end
--		end)
--		
--
--	end
--	
--end

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
	self.allItems={}
	for i = 1, #goldList+1 do
		local abName=""
		local index= Tools.RandomInt(1,3)
		if i==1 then
			abName="chetou_group_chetou"--火车头
		else
			abName=config.trainAssetName[index]
		end
		local card= self.objPools:SpawnPrefab(nil, config.ABNames.train[carType],abName, self.view.trans_root)
		---@type USDollarExpressTrainItem
		local item=USDollarExpressTrainItem.New(card,self)
		local rectTrans=ComponentUtilGet.RectTransform(item.transform)
		local lastPosx=0
		if i==1 then
			lastPosx=0
		end
		if i==2 then
			lastPosx=-1890
		end
		if i>2 then
			local lastItem=self.allItems[i-1]
			local lastItemRect=ComponentUtilGet.RectTransform(lastItem.transform)
			lastPosx=lastItemRect.anchoredPosition.x-rectTrans.rect.width
		end
		
		rectTrans.transform.rotation=Quaternion.Euler(0,180,0)
		card:SetActive(true)
		card.transform:SetParent(self.view.trans_root)
		card.transform.localPosition = Vector3.New(lastPosx, 0, 0) -- 设置slotItem的位置
		card.transform.localScale = Vector3.one
		card.name = tostring(i)
		item:SetText(goldList[i])
		self.allItems[i]=item
	end

	self.maxMoveIndex= #goldList
	self.curMoveIndex=1
	
	self.centerPos=self.view.trans_centerPos.position
	self.endPos= self.view.trans_endPos.position
	self.isCanMove=false
	UpdateManager.AddUpdate(self,self.Update)
end

function USDollarExpressCarCtrl:Update()
	if self.isAllCarArrive==true then
		return
	end
	for i = 1, #self.allItems do
		---@type USDollarExpressTrainItem
		local item = self.allItems[i]
		item.transform:Translate(Vector3.New(-1,0,0)*Time.deltaTime*5)
		--look("item.transform.position",item.transform.position)
		if item.isArriveCenterPos==false then
			if item.transform.position.x>=self.centerPos.x then
				look("到达中心点了",item.gameObject.name)
				item.isArriveCenterPos=true
				item:DOPlayerAni()
			end
		end
		if item.isArriveEndPos==false then
			if item.transform.position.x>=self.endPos.x then
				item.isArriveEndPos=true
			end

		end
		if i==#self.allItems and item.isArriveEndPos==true then
			logError("所有元素都已经到达终点了")
			self.isAllCarArrive=true
			CorManager.StartCor(self, function
			()
				coroutine.wait(5)
				self:Close()
			end)
		end

	end
end


function USDollarExpressCarCtrl:Settmp_value(num)
	local curNum=tonumber(self.view.tmp_value.text)
	local nextNum=curNum+num
	self.view.tmp_value.text=tostring(nextNum)
end

function USDollarExpressCarCtrl:Close()
    self.super.Close(self);
	if self.tweener then
		self.tweener:Kill()
	end
	self.objPools:DestroyAll()
	UpdateManager.ReMoveAllUpdate(self)
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