---
---Create by Administrator
---DateTime: 2025-06-18 10:32:48
---
---@class USDollarExpressMainCtrl:BaseCtrl
local USDollarExpressMainCtrl=Class("USDollarExpressMainCtrl",BaseCtrl)
---@type USDollarExpressConfig
local config=require"SingleGames/USDollarExpress/USDollarExpressConfig"
---@type USDollarExpressSlotItem
local SlotItem=require"SingleGames/USDollarExpress/Ctrl/USDollarExpressSlotItem"
require("Logic/Common/commonSlots/MVCHead")

---构造函数
function USDollarExpressMainCtrl:ctor(ctrlName,param)
    self.layer=2;
    self.abName="SingleGames/USDollarExpress/prefabs/USDollarExpressMain";
    self.prefabName="USDollarExpressMain"
    self.super.ctor(self,ctrlName,param);
	---@type USDollarExpressMainView
	self.view = self.view
	---@type USDollarExpressMainModel
	self.model = self.model
end

---初始化
function USDollarExpressMainCtrl:CtrlInit(args)
	self.super.CtrlInit(self,args);
	self.model:ReqConfigInfo()
	self:InitData()
	config.InitIconPic()--初始化icon图片
	self:InitFirstSlotPics()
end

function USDollarExpressMainCtrl:ResConfigInfo(betInfos)
	---@type UICommonSlotBtnsCtrl
	self.buttomCtrl= CtrlManager.SingleShow(CtrlNames.UICommonSlotBtns,betInfos)
	---@type UICommonSlotTopCtrl
	self.topCtrl=CtrlManager.SingleShow(CtrlNames.UICommonSlotTop)
	
	self.poolList=betInfos.poolList
	for i = 1, #self.poolList do
		config.jackPotInfos[self.poolList[i].id]=self.poolList[i]
	end

	self.txtJackpots={}
	self.txtJackpots[config.jackpotIds.minori]=self.view.txt_minor
	self.txtJackpots[config.jackpotIds.major]=self.view.txt_mejor
	self.txtJackpots[config.jackpotIds.grand]=self.view.txt_grand
	self.txtJackpots[config.jackpotIds.minni]=self.view.txt_mini
	self:BetInfoChange(betInfos.defaultBet)
	CorManager.StartCor(self, function
	()
		coroutine.wait(1)
		logError("重中之重")
		self:UpDateValue()
	end)
	look("收到的下注配置信息",betInfos)
end


function USDollarExpressMainCtrl:InitRollData()
	self.rollData={}
	self.initAllGrid={}
	for i = 1, 5 do
		self.rollData[i]={}
		self.initAllGrid[i]={}
		local data=ConfigManager.CfgC_Roller[GameConfig[GameNames.USDollarExpress].gameType.."_"..i]
		self.rollData[i]=jsonDecode(data.elements)
		self.initAllGrid[i]=jsonDecode(data.initGrid)
	end
	self.curIndex=Tools.RandomInt(1,#self.initAllGrid[1])
	look("self.initAllGrid",self.initAllGrid)
end


---初始化数据
function USDollarExpressMainCtrl:InitData()
	---@type ObjectPoolUtil
	self.objPools=ObjectPoolUtil.New()
	
	self:InitRollData()
	self.parentList={}
	self.childsList = {}
	self.showChildsList = {}---显示的card1-20
	self.numTween={}
	self.isOnclickStart=false
	self.realCard={}
	self.tweener={}
	self.tweener1={}
	self.tweener2={}
	self.tweener3={}
	self.fastStop={}
	self.allendPos={}
	self.isArrpos=true
	
	self.freeState=false;
	self.isAllRoate=false
	self.isAward=0---是否中奖（0,1,2）--未中奖，小奖，大奖
	---
	---旋转的数据替换索引
	self.curRollData={}
	for i = 1, 5 do
		self.curRollData[i]=0	
	end
	
	
end
-- 初始化第一批展示用的SlotPics
function USDollarExpressMainCtrl:InitFirstSlotPics()
	local dis = config.itemSpace
	for i = 1, config.lieNum do
		--local go = GameObject('newobj')
		--go.transform:SetParent(self.view.wheelRootList[i].transform) -- 将其设置为某一个滚轮的子物体
		local go=ComponentUtilGet.GameObject(self.view.wheelRootList[i],"newobj")
		--go.transform.localScale = Vector3.one
		--go.transform.localPosition = Vector3.New(0,0,0)
		table.insert(self.parentList, go.transform) -- 将创建的newobj插入parentList表中
		self.childsList[i] = {}
		local nCircels = config.rollItemNum
		local curInitGrid=self.initAllGrid[i]
		look("curInitGrid",curInitGrid)
		
		for j = 1, nCircels do
			---@type UnityEngine.GameObject
			local card = instantiate(self.view.cardPrefab)
			card:SetActive(true)
			card.transform:SetParent(go.transform)
			card.transform.localPosition = Vector3.New(0, config.itemStartPosY+(j-2)* dis, 0) -- 设置slotItem的位置
			card.transform.localScale = Vector3.one
			card.name = tostring(j)
			card.transform:SetAsFirstSibling()
			---@type USDollarExpressSlotItem
			local iconItem=SlotItem.New(card,self)
			iconItem:InitIndex(j-1)
			local texId = math.random(1,table.getCount(config.iocnPicName))
			local numFF=6;
			if(j<=5 and j>1) then
				numFF=numFF-j
				local index = (i-1)*4+numFF  -- 计算原始索引
				self.showChildsList[index] = iconItem
				texId=curInitGrid[self.curIndex][numFF]
			end
			if j>5 then
				self.curRollData[i]=j-6
				local rollIndex=#self.rollData[i]-self.curRollData[i]
				texId=self.rollData[i][rollIndex]
			end
			
			iconItem:SetSprite(config.icon_Pics[config.iocnPicName[texId]],texId)--选取固定图片       
			table.insert(self.childsList[i], iconItem)
			
		end
	end
	look("self.showChildsList",#self.showChildsList)
	CorManager.StartCor(self, function
	()
		coroutine.wait(0.1)
		self:InitSmallKuang()
		self:InitBigKuang()
	end)
end

function USDollarExpressMainCtrl:InitSmallKuang()
	self.awardSmallKuangEffects={}
	for i = 1, #self.showChildsList do
		local iconEffect= self.objPools:SpawnPrefab(nil, config.ABNames.smallKuang,"effect_biankuang_small_liuguang", self.view.rootEffects)
		iconEffect.transform.position=self.showChildsList[i]:GetPosition()
		self.awardSmallKuangEffects[i]=iconEffect
		Tools.SetActive(self.awardSmallKuangEffects[i],false)
	end
end

function USDollarExpressMainCtrl:InitBigKuang()
	self.bigKuangEffects={}
	for i = 1, 5 do
		self.bigKuangEffects[i]=ComponentUtilGet.GameObject(self.view.transform,"content/effects/effect_biankuang_su_liuguang"..i)
	end
	self.eff_choose_a_freature_bd=ComponentUtilGet.GameObject(self.view.transform,"content/effects/eff_choose_a_freature_bd")
	self.eff_choose_a_freature_bd:SetActive(false)
end
---特殊模式展示大框
function USDollarExpressMainCtrl:ShowBigKuang(wheelId)
	if config.gameTypeState==1 then
		for i = 1, 5 do
			if wheelId==i then
				Tools.SetActive(self.bigKuangEffects[i],true)
			else
				Tools.SetActive(self.bigKuangEffects[i],false)
			end

		end
	end
end

--开始抽奖旋转
function USDollarExpressMainCtrl:OnStartDoSpin()
	if  self.isOnclickStart then
		return
	end
	self.isOnclickStart = true
	GlobalEvent.Notify(SlotGlobal.gameEventName.GameStateChange, SlotGlobal.gameState.RollState)
	self:ReSetData()
	self.realCard=self.model.CardPos
	CorManager.StartCor(self,function()
		for i = 1,5 do
			if config.gameTypeState==1 then
				self:ShowBigKuang(1)
			end
			self:StartCirle(i)
		end
	end)
end

function USDollarExpressMainCtrl:SetRealIndex(wheelId)
	for j = 1,4 do
		local num=5
		num=num-j
		---@type SlotItem1
		local item=self.childsList[wheelId][config.rollItemNum-num]
		item:SetSprite(config.icon_Pics[config.iocnPicName[self.realCard[wheelId][num]]],self.realCard[wheelId][num])
	end
end

---重置数据
function USDollarExpressMainCtrl:ReSetData()
	self.isAllRoate=false
	if self.cor001~=nil then
		CorManager.StopCor(self,self.cor001)
		self.cor001=nil
	end

	---默认都转3圈结束转动
	self.rollCircles={}
	if config.gameTypeState==1 then
		self:SetAllChildItemMask(true)
		--二选1模式
		for i = 1,5 do
			self.rollCircles[i] = config.rollCircles1[i]
		end
	else
		self:SetAllChildItemMask(false)
		for i = 1,5 do
			self.rollCircles[i] = config.rollCircles[i]
		end
	end


	if self.lineShowCor~=nil then
		coroutine.stop(self.lineShowCor)
	end
	for i = 1, 20 do
		self.showChildsList[i]:SetIsAward(false)
	end
	self:HideAllAwardSmallKuangEffects()

	self.curRollData={}
	for i = 1, 5 do
		self.curRollData[i]=0
		self.fastStop[i]=false
		self.allendPos[i]=false
	end
	self.isArrpos=true
	GlobalEvent.Notify(SlotGlobal.gameEventName.AwardValue,"")
end

--旋转
function USDollarExpressMainCtrl:StartCirle(wheelId)
	local parent_newObj = self.parentList[wheelId]-- parentList 就是newobj列表
	-- self.childsList就是icon图标列表
	local dis = #self.childsList[wheelId]-6
	local to = -dis * (config.itemSpace)--最终位置
	local endpos = Vector3.New(parent_newObj.transform.localPosition.x, to, parent_newObj.transform.localPosition.z)
	--停止时候超出为止
	local to1 = to - config.itemSpace * 0.5--超出位置   
	local endpos1 = Vector3.New(parent_newObj.transform.localPosition.x, to1 ,parent_newObj.transform.localPosition.z)

	local stopPos=endpos
	if self.rollCircles[wheelId]==0 then
		stopPos=endpos1
		self:SetRealIndex(wheelId)
	end
	self.tweener[wheelId]=parent_newObj.transform:DOLocalMove(stopPos, config.rollItemNumTime)
	self.tweener[wheelId]:SetEase(DG.Tweening.Ease.Linear);
	self.tweener[wheelId].onComplete=function()
		if self.fastStop[wheelId]==true then
			return
		end
		if self.rollCircles[wheelId]==0 then
			self.tweener1[wheelId]=parent_newObj.transform:DOLocalMove(endpos, config.rollTime.rebackTime[wheelId])
			self.tweener1[wheelId]:SetEase(DG.Tweening.Ease.OutQuart);
			self.tweener1[wheelId].onComplete=function()
				self.allendPos[wheelId]=true
				self:RestWheelPos(wheelId,true)
				parent_newObj.transform.localPosition =Vector3.New(
						parent_newObj.transform.localPosition.x, 0, parent_newObj.transform.localPosition.z)
				if (wheelId == 5) then
					self:ShowBigKuang(0)
					self:ShowResoult()-- 旋转结束处理服务器数据表现

				else
					self:ShowBigKuang(wheelId+1)
				end
				self:CheckWheelIdAndPlayAni(wheelId)
			end
		else
			self.rollCircles[wheelId]=self.rollCircles[wheelId]-1
			self:RestWheelPos(wheelId)
			parent_newObj.transform.localPosition =Vector3.New(
					parent_newObj.transform.localPosition.x, 0, parent_newObj.transform.localPosition.z)
			self:StartCirle(wheelId)
		end
	end
	if wheelId==5 and not self.isAllRoate then
		self.isAllRoate=true
	end
end

---快速停止
function USDollarExpressMainCtrl:StopRollState()
	for i = 1, 5 do
		if self.rollCircles[i]>=1 then
			self.fastStop[i]=true
		end
		---@type DG.Tweening.Tween
		local tw=self.tweener[i]
		--look("self.rollCircles[i]",i,self.rollCircles[i])
		if self.rollCircles[i]>=1 then
			self:SetRealIndex(i)
			self.rollCircles[i]=0
			--tw:Goto(config.rollItemNumTime, false)
			tw:Kill()
			self:FastStopCirle(i,false)
		end

	end
end

function USDollarExpressMainCtrl:FastStopCirle(wheelId,blgoEnd)
	local parent_newObj = self.parentList[wheelId]-- parentList 就是newobj列表
	-- self.childsList就是icon图标列表
	local dis = #self.childsList[wheelId]-6
	local to = -dis * (config.itemSpace)--最终位置
	local endpos = Vector3.New(parent_newObj.transform.localPosition.x, to, parent_newObj.transform.localPosition.z)

	--停止时候超出为止
	local to1 = to - config.itemSpace * 0.5--超出位置   
	local endpos1 = Vector3.New(parent_newObj.transform.localPosition.x, to1 ,parent_newObj.transform.localPosition.z)
	if blgoEnd==true then
		self:StartCirleStop2(parent_newObj,wheelId,endpos)
	else
		self:StartCirleStop1(parent_newObj,wheelId,endpos,endpos1)
	end

	
end

function USDollarExpressMainCtrl:StartCirleStop1(parent_newObj,wheelId,endpos,endpos1)
	
	if self.rollCircles[wheelId]==0 then
		self.tweener2[wheelId]=parent_newObj.transform:DOLocalMove(endpos1, config.rollTime.rebackTime[wheelId])
		self.tweener2[wheelId]:SetEase(DG.Tweening.Ease.OutQuart);
		self.tweener2[wheelId].onComplete=function()
			self:StartCirleStop2(parent_newObj,wheelId,endpos)
		end
	end
end

function USDollarExpressMainCtrl:StartCirleStop2(parent_newObj,wheelId,endpos)
	self.tweener3[wheelId]=parent_newObj.transform:DOLocalMove(endpos, config.rollTime.rebackTime[wheelId])
	self.tweener3[wheelId]:SetEase(DG.Tweening.Ease.OutQuart);
	self.tweener3[wheelId].onComplete=function()
		self:RestWheelPos(wheelId,true)
		parent_newObj.transform.localPosition =Vector3.New(
				parent_newObj.transform.localPosition.x, 0, parent_newObj.transform.localPosition.z)
		self.allendPos[wheelId]=true
		if (wheelId == 5) then
			
			CorManager.StartCor(self, function
			()
				while self:IsAllArrivePos()==false do
					coroutine.yield(1)
				end
				self:ShowBigKuang(0)
				self:ShowResoult()-- 旋转结束处理服务器数据表现

			end)
		end
		self:CheckWheelIdAndPlayAni(wheelId)
	end
end

function USDollarExpressMainCtrl:IsAllArrivePos()
	self.isArrpos=true
	for i = 1, 5 do
		if self.allendPos[i]==false then
			self.isArrpos=false
		end
	end
	return self.isArrpos
end


---@param wheelId number 轴数
---@param curCirle number 当前圈数
function USDollarExpressMainCtrl:RestWheelPos(wheelid,isEnd)

	local nCircels = #self.childsList[wheelid]
	for j = 1,nCircels do
		if(j >= 1 and j <= 6) then
			local num=6
			num=num-j

			---@type SlotItem1
			local item=self.childsList[wheelid][config.rollItemNum-num]
			self.childsList[wheelid][j]:SetSprite(item:GetCurSprite(),item:GetIconIndex())
		else
			self.curRollData[wheelid]=self.curRollData[wheelid]+(j-6)
			local rollIndex=#self.rollData[wheelid]-self.curRollData[wheelid]
			local texId=self.rollData[wheelid][rollIndex]
			self.childsList[wheelid][j]:SetSprite(config.icon_Pics[config.iocnPicName[texId]],texId)
		end

	end
end

function USDollarExpressMainCtrl:SetAllChildItemMask(isSetMask)
	if isSetMask==true then
		self.view:IsShowBl(true)
		for i = 1, config.lieNum do
			for j = 1, config.rollItemNum do
				self.childsList[i][j]:SetItemMask(true)
			end
		end
	else
		self.view:IsShowBl(false)
		for i = 1, config.lieNum do
			for j = 1, config.rollItemNum do
				self.childsList[i][j]:SetItemMask(false)
			end
		end
	end
end

---item.iconIndex>=15 and item.iconIndex<=22出现则要播放动画
function USDollarExpressMainCtrl:CheckWheelIdAndPlayAni(wheelId)
	if wheelId==1 then
		for i = 1, 4 do
			local item=self.showChildsList[i]
			if item.iconIndex>=15 and item.iconIndex<=22 then
				item:SetIsAward(true)
			end

		end
	end
	if wheelId==2 then
		for i = 5, 8 do
			local item=self.showChildsList[i]
			if item.iconIndex>=15 and item.iconIndex<=22 then
				item:SetIsAward(true)
			end

		end
	end
	if wheelId==3 then
		for i = 9, 12 do
			local item=self.showChildsList[i]
			if item.iconIndex>=15 and item.iconIndex<=22 then
				item:SetIsAward(true)
			end

		end
	end
	if wheelId==4 then
		for i = 13, 16 do
			local item=self.showChildsList[i]
			if item.iconIndex>=15 and item.iconIndex<=22 then
				item:SetIsAward(true)
			end

		end
	end
	if wheelId==5 then
		for i = 17, 20 do
			local item=self.showChildsList[i]
			if item.iconIndex>=15 and item.iconIndex<=22 then
				item:SetIsAward(true)
			end

		end
	end
end



--展示结果
function USDollarExpressMainCtrl:ShowResoult()
	if self.resoultCor then
		coroutine.stop(self.resoultCor)
		self.resoultCor=nil
	end
	config.showStep=0
	self.resoultCor=CorManager.StartCor(self,function()
		self:ShowAwardEffect()
		while config.showStep < 1 do
			coroutine.yield(1)
		end
		self:EnterSmallGame()
		while config.showStep < 2 do
			coroutine.yield(1)
		end
		self:EnterFreeGame()
		while config.showStep < 3 do
			coroutine.yield(1)
		end
		self:SetStateLast()
	end)
end

function USDollarExpressMainCtrl:ShowAwardEffect()
	local allWinGold=self.model.allWinGold
	local resultLineInfoList=self.model.resultLineInfoList
	local specialType=self.model.specialType
	local totalAwardLineCount=#resultLineInfoList --中奖总线
	if totalAwardLineCount>=0 then
		self:ShowCirculationLinesAnim()
		config.showStep=config.showStep+1
	else
		log("未中奖")
		config.showStep=config.showStep+1
	end
end

---单线循环展示
function USDollarExpressMainCtrl:ShowCirculationLinesAnim()
	self.isShowXianbl=true
	local showXianindex=0
	if self.lineShowCor~=nil then
		CorManager.StopCor(self,self.lineShowCor)
	end
	self.lineShowCor=nil
	local lineList=self.model.resultLineInfoList
	local lineCount=#lineList+1--所有中奖线个数
	self.lineShowCor = CorManager.StartCor(self,function()
		while self.isActive and self.isShowXianbl do
			showXianindex=showXianindex%lineCount
			if showXianindex == 0 then
				for i=1,lineCount-1 do
					local lineInfo=lineList[i]
					self:SetIconEffect(lineInfo)
				end
			else
				self:HideAllAwardSmallKuangEffects()
				local lineInfo=lineList[showXianindex]
				self:SetIconEffect(lineInfo)
			end
			coroutine.wait(1) 
			showXianindex=showXianindex+1
		end
	end)
end


function USDollarExpressMainCtrl:SetIconEffect(lineInfo)
	local awardPos=lineInfo.iconIndexs
	for i=1,#awardPos do
		---@type USDollarExpressSlotItem
		local item=self.showChildsList[awardPos[i]]
		if item then
			item:SetIsAward(true)
			Tools.SetActive(self.awardSmallKuangEffects[awardPos[i]],true)
		else
			logError("icon not has!"..awardPos[i])
		end
	end
end

function USDollarExpressMainCtrl:HideAllAwardSmallKuangEffects()
	local nums=#self.awardSmallKuangEffects
	for i = 1, nums do
		Tools.SetActive(self.awardSmallKuangEffects[i],false)
	end
end

function USDollarExpressMainCtrl:SetAwardKuang()
	
end

function USDollarExpressMainCtrl:EnterSmallGame()
	if self.model.status==1 then
		logError("进入二选1模式")
		config.gameTypeState=1
		CorManager.StartCor(self, function
		()
			coroutine.wait(1)
			CtrlManager.SingleShow(CtrlNames.USDollarExpressGameSelect)
		end)

	elseif self.model.status==3 then
		config.gameTypeState=3
		CorManager.StartCor(self, function
		()
			coroutine.wait(1)
			CtrlManager.SingleShow(CtrlNames.USDollarExpressCar,self.model.trainInfoList)
		end)

	else
		self:AddShowStep()
	end
end

---各种模式小游戏完成后返回
function USDollarExpressMainCtrl:EndSmallGame()
	self:AddShowStep()
	if self.model.status==1 then
		CorManager.StartCor(self, function
		()
			config.gameTypeState=1
			self.eff_choose_a_freature_bd:SetActive(true)
			coroutine.wait(1)
			self.eff_choose_a_freature_bd:SetActive(false)
			self.model:ReqStartGame()---请求旋转一次
		end)
	elseif self.model.status==3 then
		logError("开火车模式完成！")
	end
end

function USDollarExpressMainCtrl:AddShowStep()
	config.showStep=config.showStep+1
end


function USDollarExpressMainCtrl:EnterFreeGame()
	if self.model.remainFreeCount>0 then
		logError("进入免费模式")
		config.gameTypeState=5
		GlobalEvent.Notify(SlotGlobal.gameEventName.GameStateChange,SlotGlobal.gameState.FreeState)
		CorManager.StartCor(self,function()
			coroutine.wait(1)
			self.model:ReqStartGame()
		end)
	end
	config.showStep=config.showStep+1
end

function USDollarExpressMainCtrl:SetStateLast()
	logError("结束=====》")
	GlobalEvent.Notify(SlotGlobal.gameEventName.AwardValue,self.model.allWinGold)
	self.isOnclickStart=false
	local freeCount=self.model.remainFreeCount
	if freeCount>0 then
		GlobalEvent.Notify(SlotGlobal.gameEventName.GameStateChange,SlotGlobal.gameState.FreeState)
	elseif config.selfMotionNum>0 then
		logError("自动旋转模式")
		config.selfMotionNum=config.selfMotionNum-1
		GlobalEvent.Notify(SlotGlobal.gameEventName.NoticeAuto,config.selfMotionNum)
		if config.selfMotionNum==0 then
			logError("自动旋转停止")
			GlobalEvent.Notify(SlotGlobal.gameEventName.NoticeStopAuto)
		end
		self.model:ReqStartGame()
		GlobalEvent.Notify(SlotGlobal.gameEventName.GameStateChange,SlotGlobal.gameState.AutoState)
	elseif config.gameTypeState==1 then
		logError("其他模式---》")
 	else
		---正常模式
		GlobalEvent.Notify(SlotGlobal.gameEventName.GameStateChange,SlotGlobal.gameState.Normal)
	end
	
	--CorManager.StartCor(self,function()
	--	if config.curGameState==SlotGlobal.gameState.AutoState and config.selfMotionNum>0 then
	--		config.selfMotionNum=config.selfMotionNum-1
	--		GlobalEvent.Notify(SlotGlobal.gameEventName.NoticeAuto,config.selfMotionNum)
	--		if config.selfMotionNum==0 then
	--			logError("自动旋转停止")
	--			GlobalEvent.Notify(SlotGlobal.gameEventName.NoticeStopAuto)
	--		end
	--		self.model:ReqStartGame()
	--	end
	--end)

	
end


function USDollarExpressMainCtrl:Close()
    self.super.Close(self);
end

---添加UI事件
function USDollarExpressMainCtrl:AddUIEvent()
	GlobalEvent.AddListener(SlotGlobal.gameEventName.ChangeBetInfo, self.BetInfoChange,self)
end

---下注信息改变修改奖池显示
function USDollarExpressMainCtrl:BetInfoChange(betInfo)
	self:RestJackPots(betInfo)
end

function USDollarExpressMainCtrl:RestJackPots(_betInfo)
	config.curchipInfo=_betInfo
	local betInfo=_betInfo
	for i = 1, #self.poolList do
		local jackPool=self.poolList[i]
		local baseShow=math.floor(betInfo*jackPool.initTimes)
		config.jackpotvalue[jackPool.id]=baseShow
		self.txtJackpots[jackPool.id].text=config.jackpotvalue[jackPool.id]
	end
	self:UpDateValue()
end

function USDollarExpressMainCtrl:UpDateValue()
	for i = 1, #self.poolList do
		self:UpDateValueByIndex(i)
	end
end

function USDollarExpressMainCtrl:UpDateValueByIndex(index)
	local jackPool=self.poolList[index]
	local form=config.jackpotvalue[jackPool.id]
	local to=math.floor(form*(1+jackPool.updateProp*0.0001))
	local max=math.floor(config.curchipInfo*jackPool.maxTimes)
	if to>=max then
		to=max
	end
	local time=jackPool.perSomeSec
	if self.numTween[index] then
		self.numTween[index]:Kill()
	end
	self.numTween[index]= Tools.NumJump(form,to,time, function
	(v)
		self.txtJackpots[jackPool.id].text=math.floor(v)
	end, function
	()
		if to>=max then
			config.jackpotvalue[jackPool.id]=math.floor(config.curchipInfo*jackPool.initTimes)
			self.txtJackpots[jackPool.id].text=config.jackpotvalue[jackPool.id]
		end
		self:UpDateValueByIndex(index)
	end)
end


function USDollarExpressMainCtrl:BackHome()
	GameCenter.LeaveGame();

end

---移除UI事件
function USDollarExpressMainCtrl:RemoveEvent()
	self.super.RemoveEvent(self);
end


---销毁UI
function USDollarExpressMainCtrl:RealCloseDestroy()
	self.super.RealCloseDestroy(self);
	self.buttomCtrl:Close()
	self.topCtrl:Close()
	for k,v in pairs(self.numTween) do
		if v then
			v:Kill()
		end
	end
end

return USDollarExpressMainCtrl