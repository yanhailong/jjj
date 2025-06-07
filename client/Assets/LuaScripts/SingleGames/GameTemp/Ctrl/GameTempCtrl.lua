---
---Create by Administrator
---DateTime: 2025-06-06 17:07:38
---
---@class GameTempCtrl:BaseCtrl
local GameTempCtrl=Class("GameTempCtrl",BaseCtrl)
---@type GameSlotConfig
local config=require"SingleGames/GameTemp/GameSlotConfig"
local SlotItem=require"SingleGames/GameTemp/Ctrl/SlotItem"

---构造函数
function GameTempCtrl:ctor(ctrlName,param)
    self.layer=2;
    self.abName="SingleGames/GameTemp/prefabs/GameTemp";
    self.prefabName="GameTemp"
    self.super.ctor(self,ctrlName,param);
	---@type GameTempView
	self.view = self.view
	---@type GameTempModel
	self.model = self.model
end

---初始化
function GameTempCtrl:CtrlInit(args)
	self.super.CtrlInit(self,args);
	config.InitIconPic()--初始化icon图片
	self:InitData()
	self:InitFirstSlotPics()
end

---初始化数据
function GameTempCtrl:InitData()
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
function GameTempCtrl:InitFirstSlotPics()
	local dis = config.itemSpace
	for i = 1, config.lieNum do
		local go = GameObject('newobj')
		go.transform:SetParent(self.view.wheelRootList[i].transform) -- 将其设置为某一个滚轮的子物体
		go.transform.localScale = Vector3.one
		go.transform.localPosition = Vector3.New(0,0,0)
		table.insert(self.parentList, go.transform) -- 将创建的newobj插入parentList表中
		self.childsList[i] = {}
		self.showChildsList[i] = {}
		local nCircels = config.itemNum + (i-1) * config.lieNum --圈数
		for j = 1, nCircels do
			local card = instantiate(self.view.cardPrefab)
			card:SetActive(true)
			card.transform:SetParent(go.transform)
			card.transform.localPosition = Vector3.New(0, -(j-3) * dis, 0) -- 设置slotItem的位置
			card.transform.localScale = Vector3.one
			card.name = tostring(j)
			local iconItem=SlotItem.New(card)
			local texId = math.random(1,10)
			iconItem:SetSprite(config.icon_Pics[config.iocnPicName[texId]],texId)--选取固定图片       
			table.insert(self.childsList[i], iconItem)
			local m_index=5
			if j>1 and j<5 then
				self.showChildsList[i][m_index-j] = iconItem
			end
		end
	end
end


--开始抽奖旋转
function GameTempCtrl:OnStartDoSpin()
	if  self.isOnclickStart then
		return
	end
	self.isOnclickStart = true
	self:ReSetData()
	self.realCard=self.model.CardPos
	look("self.realCard ",self.realCard)
	-- 预设置中奖的图片组
	for i = 1,5 do
		for j = 1,3 do
			local num=4
			num=num-j
			self.childsList[i][(config.itemNum-7)+(i-1)*5+j]:SetSprite(config.icon_Pics[config.iocnPicName[self.realCard[i][num]]],self.realCard[i][num])
		end
	end
	
	CorManager.StartCor(self,function()
		for i = 1,5 do
			self:StartCirle(i)
		end
	end)

end

---重置数据
function GameTempCtrl:ReSetData()
	self.isAllRoate=false

	if self.cor001~=nil then
		CorManager.StopCor(self,self.cor001)
		self.cor001=nil
	end
	
end

--旋转
function GameTempCtrl:StartCirle(wheelId)
	local parent_newObj = self.parentList[wheelId]-- parentList 就是newobj列表
	-- self.childsList就是icon图标列表
	local dis = #self.childsList[wheelId] - 8
	local to = dis * (config.itemSpace)--最终位置
	local to1 = to + config.itemSpace * 0.3--超出位置   
	local endpos = Vector3.New(parent_newObj.transform.localPosition.x, to, parent_newObj.transform.localPosition.z)
	local endpos1 = Vector3.New(parent_newObj.transform.localPosition.x, to1 ,parent_newObj.transform.localPosition.z)

	self.tweener[wheelId]=parent_newObj.transform:DOLocalMove(endpos1, config.rollTime.dropTime[wheelId])
	self.tweener[wheelId]:SetEase(DG.Tweening.Ease.Linear);
	self.tweener[wheelId].onComplete=function()
		self.tweener1[wheelId]=parent_newObj.transform:DOLocalMove(endpos, config.rollTime.rebackTime[wheelId])
		self.tweener1[wheelId]:SetEase(DG.Tweening.Ease.Linear);
		self.tweener1[wheelId].onComplete=function()
			self:RestWheelPos(wheelId)
			parent_newObj.transform.localPosition =Vector3.New(
					parent_newObj.transform.localPosition.x, 0, parent_newObj.transform.localPosition.z)
			if (wheelId == 5) then
				self:ShowResoult()-- 旋转结束处理服务器数据表现
			end
		end
	end

	-- 如果转到第5个转动轴，并且动画有效--都转起来了
	if(wheelId == 5) then
		self.isAllRoate = true
	end
end
-- 重置滚动轴的位置
function GameTempCtrl:RestWheelPos(wheelid)
	local nCircels = #self.childsList[wheelid]
	for j = 1,nCircels do
		local index = math.random(1,10)
		if(j > 1 and j <= 4) then
			local num=5
			num=num-j
			self.childsList[wheelid][j]:SetSprite(config.icon_Pics[config.iocnPicName[self.realCard[wheelid][num]]],self.realCard[wheelid][num])
		else
			self.childsList[wheelid][j]:SetSprite(config.icon_Pics[config.iocnPicName[index]],index)
		end
	end
end
--展示结果
function GameTempCtrl:ShowResoult()
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

function GameTempCtrl:ShowAwardEffect()
	logError("展示中奖效果")
	config.showStep=config.showStep+1
end

function GameTempCtrl:EnterSmallGame()
	logError("进入小游戏")
	config.showStep=config.showStep+1
end

function GameTempCtrl:EnterFreeGame()
	logError("进入免费模式")
	config.showStep=config.showStep+1
end

function GameTempCtrl:SetStateLast()
	logError("结束=====》")
	self.isOnclickStart=false
end

function GameTempCtrl:Close()
    self.super.Close(self);
end

---添加UI事件
function GameTempCtrl:AddUIEvent()
	self.uiEventListener:AddClick(self.view.btn_start, function
	()
		self:OnStartDoSpin()
	end)

	self.uiEventListener:AddClick(self.view.btn_close, function
	()
		self:Close()
	end)
end

---移除UI事件
function GameTempCtrl:RemoveEvent()
	self.super.RemoveEvent(self);
end

--region UI事件方法

--endregion


---销毁UI
function GameTempCtrl:RealCloseDestroy()
	self.super.RealCloseDestroy(self);
end

return GameTempCtrl