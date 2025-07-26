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
	SoundManager:ChangeBg(config.ABNames.audios.."bgm_train")
	self.enterType=args.enterType
	self.trainInfoList=args.trainInfoList
	--look("拉火车数据",self.trainInfoList)
	self.view.ani:Play("USDollarExpressCar_ruchang")
	self:InitData()
	UpdateManager.AddUpdate(self,self.Update)

end


---初始化数据
function USDollarExpressCarCtrl:InitData()
	self.isFirstEnter=true
	self.isCanUpdate=false
	self.poolList=config.jackPotInfos
	self.numTween={}
	self.txtJackpots={}
	self.txtJackpots[config.jackpotIds.minori]=self.view.txt_minor
	self.txtJackpots[config.jackpotIds.major]=self.view.txt_mejor
	self.txtJackpots[config.jackpotIds.grand]=self.view.txt_grand
	self.txtJackpots[config.jackpotIds.minni]=self.view.txt_mini
	
	self.showStep=0
	
	---@type ObjectPoolUtil
	self.objPools=ObjectPoolUtil.New()
	---@type Queue
	self.CarQueue=Queue.New()
	for i = 1, #self.trainInfoList do
		self.CarQueue:Enqueue(self.trainInfoList[i])
	end
	self:InitCars()
	self.isAllCarArrive=false
	self.allTweens={}
	self.curCarAwardJackPots=false
	self.curCarAwardjackPotValue=0
	self.view.txt_value.text=""
end

---初始化火车厢
function USDollarExpressCarCtrl:InitCars()
	self.isCanUpdate=false
	if self.CarQueue:Count()==0 then
		CorManager.StartCor(self, function
		()
			self.view.ani:Play("USDollarExpressCar_chuchang")
			coroutine.wait(1)
			if self.enterType==102 then
				local ctrl= CtrlManager.GetCtrl(CtrlNames.USDollarExpressMapMain)
				ctrl:allAreaUnLock()
			else
				local ctrl= CtrlManager.GetCtrl(CtrlNames.USDollarExpressMain)
				ctrl:EndSmallGame()
			end
			self:Close()
		end)
	else
		self.isAllCarArrive=false
		self.trainInfo=self.CarQueue:Dequeue()
		self.carType=self.trainInfo.type
		self.goldList=self.trainInfo.goldList
		self.poolId=self.trainInfo.poolId
		self:SetCarTitle(self.carType)
		self:InitTrainComponent(self.goldList,self.carType)
		self.view.txt_trainLeft.text=self.CarQueue:Count()
	end
end

function USDollarExpressCarCtrl:GetJackPotId(poolId)
	for k,v in pairs(config.jackpotIds) do
		if poolId==v then
			return poolId
		end
	end
	return -1
end


function USDollarExpressCarCtrl:SetCarTitle(type)
	if self.isFirstEnter==true then
	else
		self.view.ani:Play("USDollarExpressCar_top")
	end
	self.isFirstEnter=false
	CorManager.StartCor(self, function
	()
		coroutine.wait(0.34)
		self.view.obj_mini.gameObject:SetActive(false)
		self.view.obj_minor.gameObject:SetActive(false)
		self.view.obj_grand.gameObject:SetActive(false)
		self.view.obj_mejor.gameObject:SetActive(false)
		self.view.obj_gold.gameObject:SetActive(false)

		if type==config.TrainColorType.GreenTrain then
			--self.view.tmp_loading.text="绿火车"
			self.view.obj_mini.gameObject:SetActive(true)
			self:UpDateValueByIndex(config.jackpotIds.minni)
		end
		if type==config.TrainColorType.BlueTrain then
			self.view.obj_minor.gameObject:SetActive(true)
			self:UpDateValueByIndex(config.jackpotIds.minori)
		end
		if type==config.TrainColorType.RedTrain then
			self.view.obj_grand.gameObject:SetActive(true)
			self:UpDateValueByIndex(config.jackpotIds.grand)
		end
		if type==config.TrainColorType.VioletTrain then
			self.view.obj_mejor.gameObject:SetActive(true)
			self:UpDateValueByIndex(config.jackpotIds.major)
		end
		if type==config.TrainColorType.GoldTrain then
			--self.view.tmp_loading.text="金火车"
			self.view.obj_gold.gameObject:SetActive(true)
			local ctrl=CtrlManager.GetCtrl(CtrlNames.USDollarExpressMain)
			self.view.txt_gold.text=ctrl.dollarCount
		end
		self.view.ani:Play("USDollarExpressCar_topchu")
	end)

end


function USDollarExpressCarCtrl:UpDateValueByIndex(jackpoyId)
	local jackPool=self.poolList[jackpoyId]
	local form=config.jackpotvalue[jackPool.id]
	local to=math.floor(form*(1+jackPool.updateProp*0.0001))
	local max=math.floor(config.curchipInfo*jackPool.maxTimes)
	if to>=max then
		to=max
	end
	local time=jackPool.perSomeSec
	if self.numTween[jackpoyId] then
		self.numTween[jackpoyId]:Kill()
	end
	self.numTween[jackpoyId]= Tools.NumJump(form,to,time, function
	(v)
		self.txtJackpots[jackPool.id].text=math.floor(v)
	end, function
	()
		if to>=max then
			config.jackpotvalue[jackPool.id]=math.floor(config.curchipInfo*jackPool.initTimes)
			self.txtJackpots[jackPool.id].text=config.jackpotvalue[jackPool.id]
		end
		self:UpDateValueByIndex(jackpoyId)
	end)
end

function USDollarExpressCarCtrl:StopTweenbyJackPotId(jackpoyId)
	if self.numTween[jackpoyId] then
		self.numTween[jackpoyId]:Kill()
	end
end

---初始化火车车厢
function USDollarExpressCarCtrl:InitTrainComponent(goldList,carType)
	config.iscarhasjackpot=false
	self.allItems={}
	for i = 1, #goldList+1 do
		local abName=""
		local index= Tools.RandomInt(1,3)
		if i==1 then
			abName="chetou_group_chetou"--火车头
		else
			abName=config.trainAssetName[index]
		end
		local card= resMgr:CreateGameObject(config.ABNames.train[carType],abName,self.view.trans_root)--self.objPools:SpawnPrefab(nil, config.ABNames.train[carType],abName, self.view.trans_root)
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
		--item:SetText(goldList[i])
		self.allItems[i]=item
	end

	local gNums=#goldList+1
	for i = 1, gNums do
		if i>1 then
			if self:GetJackPotId(self.poolId)>0 and i==gNums then
				self.allItems[i]:SetText(self.poolId,goldList[i-1])
				self.curCarAwardJackPots=true
				config.iscarhasjackpot=true
				self.curCarAwardjackPotValue=goldList[i-1]
				config.iscarjackpotvalue=goldList[i-1]
			else
				self.allItems[i]:SetText(goldList[i-1])
			end
		end
	end
	
	self.maxMoveIndex= #goldList
	self.curMoveIndex=1
	
	self.centerPos=self.view.trans_centerPos.position
	self.endPos= self.view.trans_endPos.position
	self.isCanMove=false

	if self:GetJackPotId(self.poolId)>0 then
		self.curCarAwardJackPots=true
		config.iscarhasjackpot=true
	end


	self.isCanUpdate=true
	SoundManager:PlayClip(config.ABNames.audios.."reel_notify2")
	SoundManager:ChangeBg(config.ABNames.audios.."train_move")
end

function USDollarExpressCarCtrl:Update()
	if self.isCanUpdate==false then
		return
	end
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
				item.isArriveCenterPos=true
				if i>1 then
					item:DOPlayerAni()
				end
			end
		end
		if item.isArriveEndPos==false then
			if item.transform.position.x>=self.endPos.x then
				item.isArriveEndPos=true
			end

		end
		if i==#self.allItems and item.isArriveEndPos==true then
			self.isAllCarArrive=true
			self:ShowNextStep()
		end

	end
end

function USDollarExpressCarCtrl:ShowNextStep()
	if self.resoultCor then
		coroutine.stop(self.resoultCor)
		self.resoultCor=nil
	end
	self.showStep=0
	self.resoultCor=CorManager.StartCor(self,function()
		self:CkeckISAwardJackPot()
		while self.showStep < 1 do
			coroutine.yield(1)
		end
		self:CheckNext()
	end)
end
---检测是否中奖池
function USDollarExpressCarCtrl:CkeckISAwardJackPot()
	if config.iscarhasjackpot==true then
	else
		self.showStep=self.showStep+1
	end
end

function USDollarExpressCarCtrl:NextStep()
	CorManager.StartCor(self, function
	()
		if config.iscarhasjackpot==true then
			self:Settmp_value(config.iscarjackpotvalue)
			coroutine.wait(1)
			self.view.txt_value.text=""
			self.showStep=self.showStep+1
		end
	end)

end


function USDollarExpressCarCtrl:CheckNext()
	self:InitCars()
end

function USDollarExpressCarCtrl:Settmp_value(num)
	local str=self.view.txt_value.text
	if str=="" then
		str=0
	end
	local curNum=tonumber(str)
	local nextNum=curNum+num
	self.view.txt_value.text=tostring(nextNum)
end

function USDollarExpressCarCtrl:Close()
    self.super.Close(self);
	for k,v in pairs(self.allTweens) do
		if v then
			v:Kill()
		end
	end
	for k,v in pairs(self.numTween) do
		if v then
			v:Kill()
		end
	end
	
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
		if self.enterType==102 then
			local ctrl= CtrlManager.GetCtrl(CtrlNames.USDollarExpressMapMain)
			if ctrl then
				ctrl:allAreaUnLock()
			end
		else
			local ctrl= CtrlManager.GetCtrl(CtrlNames.USDollarExpressMain)
			ctrl:EndSmallGame()
		end
		self:Close()
	end)
end

---移除UI事件
function USDollarExpressCarCtrl:RemoveEvent()
	self.super.RemoveEvent(self);
	CorManager.StopAll(self)
end

--region UI事件方法

--endregion


---销毁UI
function USDollarExpressCarCtrl:RealCloseDestroy()
	self.super.RealCloseDestroy(self);
end

return USDollarExpressCarCtrl