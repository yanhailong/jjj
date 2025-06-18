---
---Create by Administrator
---DateTime: 2025-06-18 10:32:48
---
---@class USDollarExpressMainCtrl:BaseCtrl
local USDollarExpressMainCtrl=Class("USDollarExpressMainCtrl",BaseCtrl)
---@type GameTemp1Config
local config=require"SingleGames/USDollarExpress/USDollarExpressConfig"
---@type USDollarExpressSlotItem
local SlotItem=require"SingleGames/USDollarExpress/Ctrl/USDollarExpressSlotItem"



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
	self:InitData()
	config.InitIconPic()--初始化icon图片
	self:InitFirstSlotPics()
end

---初始化数据
function USDollarExpressMainCtrl:InitData()
	self.parentList={}
	self.childsList = {}
	self.showChildsList = {}

	self.isOnclickStart=false
	self.realCard={}
	self.tweener={}
	self.tweener1={}
	self.freeState=false;
	self.isAllRoate=false
	self.isAward=0---是否中奖（0,1,2）--未中奖，小奖，大奖
end
-- 初始化第一批展示用的SlotPics
function USDollarExpressMainCtrl:InitFirstSlotPics()
	local dis = config.itemSpace
	for i = 1, config.lieNum do
		local go = GameObject('newobj')
		go.transform:SetParent(self.view.wheelRootList[i].transform) -- 将其设置为某一个滚轮的子物体
		go.transform.localScale = Vector3.one
		go.transform.localPosition = Vector3.New(0,0,0)
		table.insert(self.parentList, go.transform) -- 将创建的newobj插入parentList表中
		self.childsList[i] = {}
		self.showChildsList[i] = {}
		local nCircels = config.rollItemNum
		for j = 1, nCircels do
			local card = instantiate(self.view.cardPrefab)
			card:SetActive(true)
			card.transform:SetParent(go.transform)
			card.transform.localPosition = Vector3.New(0, config.itemStartPosY+(j-2)* dis, 0) -- 设置slotItem的位置
			card.transform.localScale = Vector3.one
			card.name = tostring(j)
			local iconItem=SlotItem.New(card)
			local texId = math.random(1,table.getCount(config.iocnPicName))
			iconItem:SetSprite(config.icon_Pics[config.iocnPicName[texId]],texId)--选取固定图片       
			table.insert(self.childsList[i], iconItem)
			local m_index=6
			if j>1 and j<5 then
				self.showChildsList[i][m_index-j] = iconItem
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
	self:ReSetData()
	self.realCard=self.model.CardPos
	CorManager.StartCor(self,function()
		for i = 1,5 do
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
	for i = 1,5 do

		if i==5 then
			self.rollCircles[i] = 15
		else
			self.rollCircles[i] = 3+i
		end
	end
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
		if self.rollCircles[wheelId]==0 then
			self.tweener1[wheelId]=parent_newObj.transform:DOLocalMove(endpos, config.rollTime.rebackTime[wheelId])
			self.tweener1[wheelId]:SetEase(DG.Tweening.Ease.OutQuart);
			self.tweener1[wheelId].onComplete=function()
				self:RestWheelPos(wheelId,true)
				parent_newObj.transform.localPosition =Vector3.New(
						parent_newObj.transform.localPosition.x, 0, parent_newObj.transform.localPosition.z)
				if (wheelId == 5) then
					self:ShowResoult()-- 旋转结束处理服务器数据表现
				end
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
-- 重置滚动轴的位置
function USDollarExpressMainCtrl:RestWheelPos(wheelid,isEnd)
	local nCircels = #self.childsList[wheelid]
	for j = 1,nCircels do
		local index = math.random(1,#config.iocnPicName)
		if(j > 1 and j <= 5) then
			local num=6
			num=num-j
			---@type SlotItem1
			local item=self.childsList[wheelid][config.rollItemNum-num]
			self.childsList[wheelid][j]:SetSprite(item:GetCurSprite(),item:GetIconIndex())
		else
			if not isEnd then
				self.childsList[wheelid][j]:SetSprite(config.icon_Pics[config.iocnPicName[index]],index)
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
	logError("展示中奖效果")
	config.showStep=config.showStep+1
end

function USDollarExpressMainCtrl:EnterSmallGame()
	logError("进入小游戏")
	config.showStep=config.showStep+1
end

function USDollarExpressMainCtrl:EnterFreeGame()
	logError("进入免费模式")
	config.showStep=config.showStep+1
end

function USDollarExpressMainCtrl:SetStateLast()
	logError("结束=====》")
	self.isOnclickStart=false
end


function USDollarExpressMainCtrl:Close()
    self.super.Close(self);
end

---添加UI事件
function USDollarExpressMainCtrl:AddUIEvent()
	self.uiEventListener:AddClick(self.view.btn_close,function()
		self:Close()
	end )
	
	self.uiEventListener:AddClick(self.view.btn_start,function()
		self:OnStartDoSpin()
	end )
end

---移除UI事件
function USDollarExpressMainCtrl:RemoveEvent()
	self.super.RemoveEvent(self);
end

--region UI事件方法

--endregion


---销毁UI
function USDollarExpressMainCtrl:RealCloseDestroy()
	self.super.RealCloseDestroy(self);
end

return USDollarExpressMainCtrl