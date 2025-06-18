---
---Create by Administrator
---DateTime: 2025-06-06 17:07:38
---
---@class GameTemp2Ctrl:BaseCtrl
local GameTemp2Ctrl=Class("GameTempCtrl",BaseCtrl)
---@type GameTemp2Config
local config=require"SingleGames/GameTemp2/GameTemp2Config"
local SlotItem=require"SingleGames/GameTemp2/Ctrl/SlotItem2"

---构造函数
function GameTemp2Ctrl:ctor(ctrlName,param)
	self.layer=2;
	self.abName="SingleGames/GameTemp2/prefabs/GameTemp2";
	self.prefabName="GameTemp2"
	self.super.ctor(self,ctrlName,param);
	---@type GameTemp2View
	self.view = self.view
	---@type GameTemp2Model
	self.model = self.model
end

---初始化
function GameTemp2Ctrl:CtrlInit(args)
	self.super.CtrlInit(self,args);
	config.InitIconPic()--初始化icon图片
	self:InitData()
	self:InitFirstSlotPics()
end

---初始化数据
function GameTemp2Ctrl:InitData()
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
function GameTemp2Ctrl:InitFirstSlotPics()
	self.items={}
	for i = 1, config.colNum do
		self.items[i]={}
		local go = GameObject('newobj')
		go.name = tostring(i)
		go.transform:SetParent(self.view.wheelRootList[i].transform) -- 将其设置为某一个滚轮的子物体
		go.transform.localScale = Vector3.one
		go.transform.localPosition = Vector3.New(0,0,0)
		table.insert(self.parentList, go.transform) -- 将创建的newobj插入parentList表中
		for j = 1, config.rowNum do
			---@type UnityEngine.GameObject
			local card = instantiate(self.view.cardPrefab)
			card:SetActive(true)
			card.transform:SetParent(go.transform)
			--card.transform.ac = Vector3.New(0, config.itemStartPosY+(j-2)* config.itemSpace, 0) -- 设置slotItem的位置
			card.transform.localScale = Vector3.one
			card.name = i.."_"..j
			---@type SlotItem2
			local iconItem=SlotItem.New(card,config.rowNum+1-j,i)
			iconItem:InitAnchoredPos(Vector3.New(0, config.itemStartPosY+(j-3)* config.itemSpace, 0))
			local texId = math.random(1,table.getCount(config.iocnPicName))
			iconItem:SetSprite(config.icon_Pics[config.iocnPicName[texId]],texId)--选取固定图片
			self.items[i][config.rowNum+1-j]=iconItem
		end
	end
	look("self.items",self.items)
end



---重置
function GameTemp2Ctrl:Reset()
	for i = 1, config.colNum do
		for j = 1, config.rowNum do
			---@type SlotItem2
			local item=self.items[i][j];
			if i==5 then
				item.needRollCircle=200;
			else
				item.needRollCircle=50+i*10;
			end
			
		end
	end
end

---开始转动
function GameTemp2Ctrl:StartSpin()
	self:Reset()
	if config.startMoveAnimTime>0 then
		CorManager.StartCor(self,function ()
			coroutine.wait(config.startMoveAnimTime);
			for i = 1, config.colNum do
				local delay=config.itemMoveTime*i
				if delay>0 then
					coroutine.wait(delay);
				end
				for j = 1, config.rowNum do
					local item=self.items[i][j];
					self:PlayFastMove(item);
				end
			end
		end);
	else
		for i = 1, config.colNum do
			for j = 1, config.rowNum do
				local item=self.items[i][j];
				self:PlayFastMove(item);
			end
		end
	end
end

---@param item SlotItem2
function GameTemp2Ctrl:PlayFastMove(item)
	local y=item:GetRectTrans().anchoredPosition.y-config.itemSpace;
	local tween=item.rectTrans:DOAnchorPos(Vector2.New(0,y),config.itemMoveTime);
	item.curTween=tween;
	tween:SetEase(DG.Tweening.Ease.Linear);
	tween.onComplete=function()
		--当前在第几行
		item.rowIndex=item.rowIndex+1;
		if item.rowIndex>config.rowNum then
			item.rowIndex=1;
			item.rectTrans.anchoredPosition=self.items[item.colIndex][item.rowIndex]:GetInitAnchorPos()
			local texId = math.random(1,table.getCount(config.iocnPicName))
			item:SetSprite(config.icon_Pics[config.iocnPicName[texId]],texId)--选取固定图片
		end
		item.needRollCircle=item.needRollCircle-1
		if item.needRollCircle==0 then
			logError("转动结束了===！")
		else
			self:PlayFastMove(item);
		end
		
	end
end

---播放停止动画
function GameTemp2Ctrl:PlayStopAnim(stopIndex)
	local item=self.items[stopIndex];
	for y = 1, config.colNum do
		local itemInfo=item[y];
		itemInfo.stopMove=true;
		if itemInfo.curTween then
			itemInfo.curTween:Kill(false);
			itemInfo.curTween=nil;
		end
		if not item.sprArr then
			item.sprArr={};
		end
		if not item.posArr then
			item.posArr={};
		end
		item.sprArr[itemInfo.index]=itemInfo.img.sprite;
		item.posArr[itemInfo.index]=itemInfo.rect.anchoredPosition;
	end

	
	--位置置换
	local index_y=config.colNum;
	for y = 1, config.colNum do
		local itemInfo=item[index_y];
		itemInfo.rect.anchoredPosition=item.posArr[y];
		Tools.SetImageSprite(itemInfo.img,item.sprArr[y]);
		itemInfo.index=y;
		if itemInfo.index>self.config.column then
			itemInfo.index=1;
		end
		index_y=index_y+1;
		if index_y>column then
			index_y=1;
		end
		self:ItemStopMove(itemInfo);
	end

end

function GameTemp2Ctrl:ItemStopMove(itemInfo)
	local t=itemInfo.rect;
	local y=itemInfo.index*self.config.itemHeightCell;
	local dt=itemInfo.rect.anchoredPosition.y+y;

	local delayTime=self:CalcStopMoveTweenTime(dt);

	local tween=t:DOAnchorPos(Vector2.New(0,-y),delayTime);--self.config.moveCellTime
	tween:SetEase(DG.Tweening.Ease.Linear);
	tween.onComplete=function()
		--当前在第几行
		itemInfo.index=itemInfo.index+1;
		if itemInfo.index>self.config.column then
			itemInfo.index=1;
			t.anchoredPosition=Vector2.New(0,0);
		end

		if itemInfo.index==1 then
			self:SetItemResultInfo(itemInfo);
		end

		if itemInfo.index==itemInfo.rawIndex then
			if itemInfo.rawIndex==self.config.column then
				self:PlayFastMoveFinished(itemInfo.cellIndex);
			end
			return;
		end
		self:ItemStopMove(itemInfo);
	end
end











--开始抽奖旋转
function GameTemp2Ctrl:OnStartDoSpin()
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

function GameTemp2Ctrl:SetRealIndex(wheelId)
	for j = 1,4 do
		local num=5
		num=num-j
		---@type SlotItem1
		local item=self.childsList[wheelId][config.rollItemNum-num]
		item:SetSprite(config.icon_Pics[config.iocnPicName[self.realCard[wheelId][num]]],self.realCard[wheelId][num])
	end
end

---重置数据
function GameTemp2Ctrl:ReSetData()
	self.isAllRoate=false
	if self.cor001~=nil then
		CorManager.StopCor(self,self.cor001)
		self.cor001=nil
	end
	
	---转动多少圈结束转动
	self.rollCircles={}
	for i = 1,5 do

		if i==5 then
			self.rollCircles[i] = 15
		else
			self.rollCircles[i] = 2+i
		end
	end
end

--旋转
function GameTemp2Ctrl:StartCirle(wheelId)
	local parent_newObj = self.parentList[wheelId]-- parentList 就是newobj列表
	-- self.childsList就是icon图标列表
	local dis = #self.childsList[wheelId]-6
	local to = -dis * (config.itemSpace)--最终位置
	local endpos = Vector3.New(parent_newObj.transform.localPosition.x, to, parent_newObj.transform.localPosition.z)
	--停止时候超出为止
	local to1 = to - config.itemSpace * 0.5--超出位置   
	local endpos1 = Vector3.New(parent_newObj.transform.localPosition.x, to1 ,parent_newObj.transform.localPosition.z)
	
	local stopPos=endpos
	if self.rollCircles[wheelId]==0 then--最后一圈的时候设置数据
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
end
-- 重置滚动轴的位置
function GameTemp2Ctrl:RestWheelPos(wheelid,isEnd)
	local nCircels = #self.childsList[wheelid]
	for j = 1,nCircels do
		local index = math.random(1,#config.iocnPicName)
		if(j > 0 and j <= 5) then
			local num=6
			num=num-j
			---@type SlotItem1
			local item=self.childsList[wheelid][config.rollItemNum-num]
			self.childsList[wheelid][j]:SetSprite(item:GetCurSprite(),item:GetIconIndex())
		else
			self.childsList[wheelid][j]:SetSprite(config.icon_Pics[config.iocnPicName[index]],index)
		end
	end
end






--展示结果
function GameTemp2Ctrl:ShowResoult()
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

function GameTemp2Ctrl:ShowAwardEffect()
	logError("展示中奖效果")
	config.showStep=config.showStep+1
end

function GameTemp2Ctrl:EnterSmallGame()
	logError("进入小游戏")
	config.showStep=config.showStep+1
end

function GameTemp2Ctrl:EnterFreeGame()
	logError("进入免费模式")
	config.showStep=config.showStep+1
end

function GameTemp2Ctrl:SetStateLast()
	logError("结束=====》")
	self.isOnclickStart=false
end

function GameTemp2Ctrl:Close()
	self.super.Close(self);
end

---添加UI事件
function GameTemp2Ctrl:AddUIEvent()
	self.uiEventListener:AddClick(self.view.btn_start, function
	()
		--self:OnStartDoSpin()
		self:StartSpin()
	end)

	self.uiEventListener:AddClick(self.view.btn_close, function
	()
		self:Close()
	end)
end

---移除UI事件
function GameTemp2Ctrl:RemoveEvent()
	self.super.RemoveEvent(self);
end

--region UI事件方法

--endregion


---销毁UI
function GameTemp2Ctrl:RealCloseDestroy()
	self.super.RealCloseDestroy(self);
	for k,v in pairs(self.tweener) do
		if v then
			v:Kill()
		end
	end
	for k,v in pairs(self.tweener1) do
		if v then
			v:Kill()
		end
	end
	self.tweener={}
	self.tweener1={}
end


---new-------------------------------------------------------------------------

---初始化Item
function GameTemp2Ctrl:InitItem()
	self.items={};
	for i = 1, config.rowNum do
		local item={};
		local t=TransFindChild(self.transform,self.config.componentPath.gameItem..i);
		for j = 1, self.config.column do
			local info={};
			local rect=TransChildGetComponent(t,tostring(j),"RectTransform");
			info.gameObject=rect.gameObject;
			info.img=TransGetComponent(rect,"Image");
			--info.anim=TransGetComponent(rect,"Animator");
			info.rect=rect;
			info.rawIndex=j;
			info.index=j;
			info.cellIndex=i;
			item[j]=info;
		end
		self.items[i]=item;
	end
end


---new-------------------------------------------------------------------------



return GameTemp2Ctrl