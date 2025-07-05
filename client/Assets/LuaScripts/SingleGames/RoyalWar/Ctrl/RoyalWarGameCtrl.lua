---
---Create by Administrator
---DateTime: 2025-06-30 16:46:28
---
---@class RoyalWarGameCtrl:BaseCtrl
local RoyalWarGameCtrl=Class("RoyalWarGameCtrl",BaseCtrl)
local config = require("SingleGames/RoyalWar/RoyalWarConfig")
---@type RoyalWarZhuPanItem
local RoyalWarZhuPanItem = require"SingleGames/RoyalWar/Ctrl/RoyalWarZhuPanItem"
---@type RoyalWarDaLuItem
local RoyalWarDaLuItem = require"SingleGames/RoyalWar/Ctrl/RoyalWarDaLuItem"
---@type RoyalWarAllChildLuItem
local RoyalWarAllChildLuItem = require"SingleGames/RoyalWar/Ctrl/RoyalWarAllChildLuItem"
---@type RoyalWarCardTypeItem
local RoyalWarCardTypeItem = require("SingleGames/RoyalWar/Ctrl/RoyalWarCardTypeItem")
local CurWhoWin;
local Vector2 = CS.UnityEngine.Vector2
local Vector3 = CS.UnityEngine.Vector3
local Quaternion = CS.UnityEngine.Quaternion
local DOTween = CS.DG.Tweening.DOTween
local Sequence = CS.DG.Tweening.Sequence
local Ease = CS.DG.Tweening.Ease
local RotateMode = CS.DG.Tweening.RotateMode
local Rect = UnityEngine.Rect
local loopType =  CS.DG.Tweening.LoopType;
---当前游戏状态阶段
local curGameStage;
---下注倒计时
local countDownTime;
---当前选中的筹码
local CurSelectChip;
---红方区域总共下注了多少筹码
local BetRedAllNum;
---黑方区域总共下注了多少筹码
local BetBlackAllNum;
---幸运一击区域总共下注了多少筹码
local BetLuckyAllNum;
---筹码下注的集合表
local ChipTable={};
---牌型数据(用来显示在路下面前面7个出过什么牌)
local CardTypeData={};
local CardTypeTable={};
---牌型Obj
local CardTypeObjTable={};
---主盘表
local ZhuPanTable = {};
local ZhuPanObjTable = {};
---主盘数据表(进入游戏向服务器拿到数据后打开界面刷新主盘数据显示)
local ZhuPanDataTable = {};
---大路表
local DaLuTable = {};
local DaLuObjTable = {};
---大路数据表
local DaLuDataTable = {};
---大路大眼路表
local DaYanZaiLuTable ={};
local DaYanZaiLuObjTable ={};
---大路大眼路数据表
local DaYanZaiLuDataTable ={};
---小路表
local xiaoLuTable ={};
local xiaoLuObjTable ={};
---小路数据表
local xiaoLuDataTable ={};
---曱甴路表
local YueYouLuTable = {};
local YueYouLuObjTable = {};
---曱甴路数据表
local YueYouLuDataTable = {};
---构造函数
function RoyalWarGameCtrl:ctor(ctrlName,param)
    self.layer=2;
    self.abName="SingleGames/RoyalWar/prefabs/RoyalWarGamePanel";
    self.prefabName="RoyalWarGamePanel"
    self.super.ctor(self,ctrlName,param);
	---@type RoyalWarGameView
	self.view = self.view
	---@type RoyalWarGameModel
	self.model = self.model
end

---初始化
function RoyalWarGameCtrl:CtrlInit(args)
	self.super.CtrlInit(self,args);
	---@type ObjectPoolUtil
	self.objPools=ObjectPoolUtil.New()
	config.InitIconPic();
	CurSelectChip = 0;
	self:InitZhuPanTable()
	self:InitCardTypeData()
	self:InitDaLuTable()
	self:InitDaLuZiLuTable()
	self:InitXiaoLuTable()
	self:InitYueYouLuTable()
	self:InitData()
end

---初始化数据
function RoyalWarGameCtrl:InitData()
	countDownTime =2;
	curGameStage = config.GameSate.Start;
	BetRedAllNum =0;
	BetBlackAllNum =0;
	BetLuckyAllNum =0;

	self.view.ator_CardRoot:Play("New State")
	self.view.obj_CardBg:SetActive(false);
	self.view.obj_RoadRoot:SetActive(true)
	self.view.obj_WhoWin:SetActive(false);
	self.view.obj_SelfBetBlack:SetActive(false)
	self.view.obj_SelfBetRed:SetActive(false)
	self.view.obj_SelfBetLucky:SetActive(false)
	
	self.view.tmp_RedBetNum.text="0.00"
	self.view.tmp_BlackBetNum.text="0.00"
	self.view.tmp_LuckyBetNum.text="0.00"

	self.view.tmp_SelfBetRedNum.text="0.00"
	self.view.tmp_SelfBetBlackNum.text="0.00"
	self.view.tmp_SelfBetLuckyNum.text="0.00"
	
	self.beginTimer = TimerManager.CreateTimer(self,function()
		self.view.obj_VS:SetActive(false);
		curGameStage =  config.GameSate.Bet;
		self:RefreshGameStage();
	end,1,1,true);

	self.beginTimer2 = TimerManager.CreateTimer(self,function()
		self.view.obj_BeginBet:SetActive(false);
	end,1,1,true);

	self.betCountDownTimer = TimerManager.CreateTimer(self,function()
		countDownTime = countDownTime-1;
		self.view.tmp_Countdown.text = countDownTime;
		if(countDownTime<=0) then
			curGameStage =config.GameSate.Settlement;
			self:RefreshGameStage();
		end
	end,1,countDownTime,true);
	curGameStage = config.GameSate.Start
	self:SetCheckedShow()
	self:RefreshGameStage()
end
---同步游戏当前在哪个阶段
function RoyalWarGameCtrl:RefreshGameStage()
	if curGameStage ==  config.GameSate.Start then
		self:EnterBegin();
	elseif curGameStage == config.GameSate.Bet then
		self:EnterBetGame();
	elseif curGameStage == config.GameSate.Settlement then
		self:EnterSettlement();
	end
end

---进入开始阶段(显示VS)
function RoyalWarGameCtrl:EnterBegin()
	self.view.obj_Countdown:SetActive(false);
	self.view.obj_VS:SetActive(true);
	self.beginTimer:Start();
end
---进入下注阶段
function RoyalWarGameCtrl:EnterBetGame()
	self.view.tmp_Countdown.text = countDownTime;
	self:SetBetButtonInteractable(true);
	self.view.obj_Countdown:SetActive(true);
	self.view.obj_BeginBet:SetActive(true);
	self.beginTimer2:Start();
	self.betCountDownTimer:Start();
end

---设置按钮的显示状态
function RoyalWarGameCtrl:SetBetButtonInteractable(state)
	self.view.btn_One:IsInteractable(state);
	self.view.btn_Ten:IsInteractable(state);
	self.view.btn_Fifty:IsInteractable(state);
	self.view.btn_OneHundred:IsInteractable(state);
	self.view.btn_FiveHundred:IsInteractable(state);
end


---进入结算阶段
function RoyalWarGameCtrl:EnterSettlement()
	self.view.obj_StopBet:SetActive(true);
	self:SetBetButtonInteractable(false);
	self.view.obj_Countdown:SetActive(false);
	self.view.obj_CardBg:SetActive(true);
	self.view.obj_RoadRoot:SetActive(false)
	if self.SettlementCor then
		coroutine.stop(self.SettlementCor)
		self.SettlementCor=nil
	end
	self.SettlementCor=	CorManager:StartCor(function()--翻牌
		coroutine.wait(0.5)
		self.view.obj_StopBet:SetActive(false);
		local redCardNumOne = self:GetCardNum();
		local redCardNumTwo = self:GetCardNum();
		local redCardNumThree = self:GetCardNum();
		local redCardColourOne = self:GetRandomColour();
		local redCardColourTwo = self:GetRandomColour();
		local redCardColourThree = self:GetRandomColour();

		local blackCardNumOne = self:GetCardNum();
		local blackCardNumTwo = self:GetCardNum();
		local blackCardNumThree = self:GetCardNum();
		local blackCardColourOne = self:GetRandomColour();
		local blackCardColourTwo = self:GetRandomColour();
		local blackCardColourThree = self:GetRandomColour();
		
		self.view.img_RedCardOne.sprite = config.GetIconPic("card2_"..config.GetColourName(redCardColourOne).."_"..redCardNumOne);
		self.view.img_RedCardTwo.sprite = config.GetIconPic("card2_"..config.GetColourName(redCardColourTwo).."_"..redCardNumTwo);
		self.view.img_RedCardThree.sprite = config.GetIconPic("card2_"..config.GetColourName(redCardColourThree).."_"..redCardNumThree);
		
		self.view.img_BlackCardOne.sprite = config.GetIconPic("card2_"..config.GetColourName(blackCardColourOne).."_"..blackCardNumOne);
		self.view.img_BlackCardTwo.sprite = config.GetIconPic("card2_"..config.GetColourName(blackCardColourTwo).."_"..blackCardNumTwo);
		self.view.img_BlackCardThree.sprite = config.GetIconPic("card2_"..config.GetColourName(blackCardColourThree).."_"..blackCardNumThree);
		
		self.RedCardType = config.GetCardType(redCardNumOne,redCardNumTwo,redCardNumThree,redCardColourOne,redCardColourTwo,redCardColourThree);
		self.BlackCardType = config.GetCardType(blackCardNumOne,blackCardNumTwo,blackCardNumThree,blackCardColourOne,blackCardColourTwo,blackCardColourThree);
		
		self.view.img_RedResultNumber.sprite =  config.GetIconPic(config.GetCardTypeName(self.RedCardType))
		self.view.img_BlackResultNumber.sprite =  config.GetIconPic(config.GetCardTypeName(self.BlackCardType))
		if(self.RedCardType == config.CardType.DanZhang) then
			self.view.img_RedResultBg.sprite = config.GetIconPic("rwn_PBgDaiZi2")
		else
			self.view.img_RedResultBg.sprite = config.GetIconPic("rwn_PBgDaiZi1")
		end

		if(self.BlackCardType == config.CardType.DanZhang) then
			self.view.img_BlackResultBg.sprite = config.GetIconPic("rwn_PBgDaiZi2")
		else
			self.view.img_BlackResultBg.sprite = config.GetIconPic("rwn_PBgDaiZi1")
		end
		coroutine.wait(1)
		self.view.ator_CardRoot:Play("RoyalWarDealCard")
		coroutine.wait(3)
		self.view.obj_WhoWin:SetActive(true)
		self:ShowWin(self.RedCardType > self.BlackCardType)
		self.IsLucky = self.RedCardType~=config.CardType.DanZhang or self.BlackCardType~=config.CardType.DanZhang;
		self:Flicker();
		if(self.RedCardType>self.BlackCardType) then
			self:RefreshCardTypeData(self.RedCardType)
		else
			self:RefreshCardTypeData(self.BlackCardType)
		end
		coroutine.wait(3)
		for _, v in ipairs(ChipTable) do
			self:PlayChipToPlayer(v)
		end
		--if(self.RedCardType == self.BlackCardType) then
		--	if(self.RedCardType == config.CardType.Leopard) then--相同的豹子比牌的大小
		--		if(redCardNumOne==1) then
		--			self:ShowWin(true)
		--		elseif(blackCardNumOne == 1) then
		--			self:ShowWin(false)
		--		else
		--			self:ShowWin(redCardNumOne>blackCardNumOne)
		--		end
		--	elseif(self.RedCardType == config.CardType.ShunJin) then --都是顺金
		--		if()then
		--			
		--		end
		--		
		--	end
		--else
		--	self:ShowWin(self.RedCardType > self.BlackCardType)
		--end
	end)
end

---闪烁对应区域
function RoyalWarGameCtrl:Flicker()
	if(self.isRedWin) then
		self:PlayFlicker(ComponentUtilGet.Image(self.view.obj_RedWinIcon.transform),true)
	else
		self:PlayFlicker(ComponentUtilGet.Image(self.view.obj_BlackWinIcon.transform),true)
	end
	if self.IsLucky then--闲对子
		self:PlayFlicker(ComponentUtilGet.Image(self.view.obj_LuckyWinIcon.transform),false)
	end
end
---播放赢的区域闪烁(播放完开始下一局)
function RoyalWarGameCtrl:PlayFlicker(image,isInitData)
	self.flickerSequence = DOTween.Sequence()
	self.flickerSequence:Append(image:DOFade(1,0.5))
	self.flickerSequence:SetLoops(8,loopType.Yoyo)
	self.flickerSequence:OnComplete(function()
		if(isInitData) then
			self:InitData();
			if(#ZhuPanDataTable>=50) then
				self:CloseLuTable()
			end
			local data = {};
			data[1] = self.isRedWin
			self:RefreshZhuPanShow(data,true)
			table.insert(ZhuPanDataTable,data);
		end
	end)

	self.flickerSequence:Play();
end

---飞筹码到对应玩家头像上
function RoyalWarGameCtrl:PlayChipToPlayer(chip)
	self.PlayChipToPlayerSequence = chip.transform:DOMove(self.view.obj_Player.transform.position, 0.5);
	self.PlayChipToPlayerSequence:SetEase(Ease.Linear)
	-- 动画完成后回收筹码
	self.PlayChipToPlayerSequence:OnComplete(function()
		--回收筹码
		self.objPools:UnSpawnPrefab(chip)
		chip = nil;
	end)
end

function RoyalWarGameCtrl:ShowWin(redWin)
	self.isRedWin = redWin;
	self.view.obj_RedWin:SetActive(redWin)
	self.view.obj_BlackWin:SetActive(not redWin);
end

---随机牌
function RoyalWarGameCtrl:GetCardNum()
	return math.random(1,13);
end
---随机花色
function RoyalWarGameCtrl:GetRandomColour()
	return math.random(1,4)
end
---选中哪个筹码
function RoyalWarGameCtrl:SetCheckedShow()
	self.view.obj_checkedOne:SetActive(CurSelectChip == config.ChipState.One);
	self.view.obj_checkedTen:SetActive(CurSelectChip == config.ChipState.Ten);
	self.view.obj_checkedFifty:SetActive(CurSelectChip == config.ChipState.Fifty);
	self.view.obj_checkedOneHundred:SetActive(CurSelectChip == config.ChipState.OneHundred);
	self.view.obj_checkedFiveHundred:SetActive(CurSelectChip == config.ChipState.FiveHundred);
end
---清空所有路表
function RoyalWarGameCtrl:CloseLuTable()
	for _, v in ipairs(ZhuPanObjTable) do
		self.objPools:UnSpawnPrefab(v);
	end
	ZhuPanTable = {}
	ZhuPanDataTable ={}

	for _, v in ipairs(CardTypeObjTable) do
		self.objPools:UnSpawnPrefab(v);
	end
	CardTypeTable = {}
	CardTypeData = {}
	
	for _, v in ipairs(DaLuTable) do
		v:InitState()
	end
	for _, v in ipairs(DaLuObjTable) do
		v:SetActive(true)
	end
	DaLuDataTable = {}

	for _, v in ipairs(DaYanZaiLuTable) do
		v:InitState()
	end
	for _, v in ipairs(DaYanZaiLuObjTable) do
		v:SetActive(true)
	end
	DaYanZaiLuDataTable = {}

	for _, v in ipairs(xiaoLuTable) do
		v:InitState()
	end
	for _, v in ipairs(xiaoLuObjTable) do
		v:SetActive(true)
	end
	xiaoLuDataTable = {}

	for _, v in ipairs(YueYouLuTable) do
		v:InitState()
	end
	for _, v in ipairs(YueYouLuObjTable) do
		v:SetActive(true)
	end
	YueYouLuDataTable = {}
end
---初始化主盘预制体
function RoyalWarGameCtrl:InitZhuPanTable()
	for _, v in ipairs(ZhuPanDataTable) do
		self:RefreshZhuPanShow(v,false)
	end
end
---初始化牌型数据显示
function RoyalWarGameCtrl:InitCardTypeData()
	for _, v in ipairs(CardTypeData) do
		self:RefreshCardTypeData(v);
	end
end

function RoyalWarGameCtrl:RefreshCardTypeData(type)
	if(#CardTypeTable>=7)then
		table.remove(CardTypeTable,1)
		self.objPools:UnSpawnPrefabByPoolName("CardTypeItem",CardTypeObjTable[1]);
		table.remove(CardTypeObjTable,1)
	end
	local obj = self.objPools:SpawnPrefab(nil,config.ABNames.prefabsItem,"CardTypeItem")
	---@type RoyalWarCardTypeItem
	local item = RoyalWarCardTypeItem.New(obj,self);
	obj:SetActive(true);
	obj.transform:SetParent(self.view.obj_CardTypeContent.transform);
	obj.transform.localScale = Vector3.one;
	item:RefreshShow(type);
	table.insert(CardTypeObjTable,#CardTypeObjTable+1,obj);
	table.insert(CardTypeTable,item);
end

---初始化大路预制体表
function RoyalWarGameCtrl:InitDaLuTable()
	for i = 1, 240 do
		local obj = self.objPools:SpawnPrefab(nil,config.ABNames.prefabsItem,"DaLuItem",self.view.obj_DaLuContent.transform)
		---@type RoyalWarDaLuItem
		local item = RoyalWarDaLuItem.New(obj,self);
		obj:SetActive(true);
		obj.transform.localScale = Vector3.one;
		item:InitState();
		item:InitIndex(i);
		table.insert(DaLuObjTable,obj);
		table.insert(DaLuTable,item);
	end
end
---初始化大路大眼路预制体表
function RoyalWarGameCtrl:InitDaLuZiLuTable()
	for i = 1, 240 do
		local obj = self.objPools:SpawnPrefab(nil,config.ABNames.prefabsItem,"DaluZiluItem",self.view.obj_DaluZiluContent.transform)
		---@type RoyalWarAllChildLuItem
		local item = RoyalWarAllChildLuItem.New(obj,self);
		obj:SetActive(true);
		obj.transform.localScale = Vector3.one;
		item:InitState();
		item:InitIndex(i);
		table.insert(DaYanZaiLuObjTable,obj);
		table.insert(DaYanZaiLuTable,item);
	end

end
---初始化大路大眼路预制体表
function RoyalWarGameCtrl:InitXiaoLuTable()
	for i = 1, 240 do
		local obj = self.objPools:SpawnPrefab(nil,config.ABNames.prefabsItem,"XiaoLuItem",self.view.obj_XiaoLuContent.transform)
		---@type RoyalWarAllChildLuItem
		local item = RoyalWarAllChildLuItem.New(obj,self);
		obj:SetActive(true);
		obj.transform.localScale = Vector3.one;
		item:InitState();
		item:InitIndex(i);
		table.insert(xiaoLuObjTable,obj);
		table.insert(xiaoLuTable,item);
	end
end


---初始化曱甴路预制体表
function RoyalWarGameCtrl:InitYueYouLuTable()
	for i = 1, 240 do
		local obj = self.objPools:SpawnPrefab(nil,config.ABNames.prefabsItem,"YueYouLuItem",self.view.obj_YueYouLuContent.transform)
		---@type RoyalWarAllChildLuItem
		local item = RoyalWarAllChildLuItem.New(obj,self);
		obj:SetActive(true);
		obj.transform.localScale = Vector3.one;
		item:InitState();
		item:InitIndex(i);
		table.insert(YueYouLuObjTable,obj);
		table.insert(YueYouLuTable,item);
	end
end

---刷新主盘显示
function RoyalWarGameCtrl:RefreshZhuPanShow(data,isFlicker)
	if(#ZhuPanTable==48) then
		for i = 1, 6 do
			ZhuPanObjTable[i]:SetActive(false);
		end
	end
	local obj = self.objPools:SpawnPrefab(nil,config.ABNames.prefabsItem,"ZhuPanItem",self.view.obj_ZhuPanContent.transform)
	---@type RoyalWarZhuPanItem
	local item = RoyalWarZhuPanItem.New(obj,self);
	obj:SetActive(true);
	--obj.transform:SetParent(self.view.obj_ZhuPanContent.transform);
	obj.transform.localScale = Vector3.one;
	table.insert(ZhuPanObjTable,obj);
	item:RefreshShow(data,isFlicker)
	table.insert(ZhuPanTable,item);
	self:AddDaLuTableShow(data);
end
---大路新增显示
function RoyalWarGameCtrl:AddDaLuTableShow(data)
	local curIndex = 0; --当前的索引
	local curList = 0;--当前是第几列
	local dataTable = {};--缓存的需要加入到数据结构里面的表
	local IsGoL; --是否走了L型了
	if(#DaLuDataTable==0) then--刚开始
		local item = DaLuTable[1];
		item:RefreshShow(data[1]);
		curList = 1;
		DaLuDataTable[curList] ={};
		dataTable[1] = data[1];
		dataTable[2] = item;
		dataTable[3] = false;
		table.insert(DaLuDataTable[curList],dataTable)
	else
		curList = #DaLuDataTable;
		local lastPiece= DaLuDataTable[curList]
		if(lastPiece[#lastPiece][1] == data[1]) then --如果和上一次的一样就往后面加
			IsGoL = lastPiece[#lastPiece][3];
			local lastItem = lastPiece[#lastPiece][2];
			if(IsGoL) then -- 已经开始走L型了
				curIndex = lastItem:GetIndex()+6;
			else
				curIndex = lastItem:GetIndex()+1;
				---@type RoyalWarDaLuItem
				local item = DaLuTable[curIndex];
				if(item:IsActive()or (curIndex-1)%6==0) then --如果下一个索引的物体已经被激活了就走L型
					curIndex = lastItem:GetIndex()+6;
					IsGoL = true;
				end
			end
			---@type RoyalWarDaLuItem
			local item = DaLuTable[curIndex];
			dataTable[1] = data[1];
			dataTable[2] = item;
			dataTable[3] = IsGoL;
			item:RefreshShow(data[1])
			table.insert(DaLuDataTable[curList],dataTable)
			self:AddDaYanZiLuTableShow();
			self:AddXiaoLuTableShow();
			self:AddYueYouLuTableShow();
		elseif(lastPiece[#lastPiece][1] ~= data[1]) then --如果和上一次的不一样就往另外开一列
			if(#DaLuDataTable>=24) then--超出列表了，需要隐藏前面
				for i = 1, (#DaLuDataTable-23)*6 do
					DaLuObjTable[i]:SetActive(false);
				end
			end
			curList = #DaLuDataTable+1;
			curIndex = #DaLuDataTable*6+1;
			---@type RoyalWarDaLuItem
			local item = DaLuTable[curIndex];
			dataTable[1] =  data[1];
			dataTable[2] = item;
			dataTable[3] = IsGoL;
			item:RefreshShow(data[1])
			DaLuDataTable[curList] ={};
			table.insert(DaLuDataTable[curList],dataTable)
			self:AddDaYanZiLuTableShow();
			self:AddXiaoLuTableShow();
			self:AddYueYouLuTableShow();
		end
	end

end

---大眼路刷新显示
function RoyalWarGameCtrl:AddDaYanZiLuTableShow()
	local curList = #DaLuDataTable;
	local lastPiece= DaLuDataTable[curList]
	---@type RoyalWarDaLuItem
	local lastItem = lastPiece[#lastPiece][2];
	local index = lastItem:GetIndex();
	if(index>=8) then--开始演化大眼路的走向
		local isEqual;
		if((index-1)%6==0)then--在第一行对比前面2列的数量是否相等
			local list1 = curList-1;
			local list2 = curList-2;
			local lastItems1 = DaLuDataTable[list1]
			local lastItems2 = DaLuDataTable[list2]
			isEqual = #lastItems1==#lastItems2;
		else --不在第一行
			local index1 = index-6;
			local index2 = index-7;
			---@type RoyalWarDaLuItem
			local item1 =  DaLuTable[index1];
			local item2 =  DaLuTable[index2];
			isEqual = item1:IsActive()==item2:IsActive();
		end

		local dataTable = {};--缓存的需要加入到数据结构里面的表
		local IsGoL; --是否走了L型了
		local CurIndex;
		if(#DaYanZaiLuDataTable==0) then--刚开始走
			---@type RoyalWarAllChildLuItem
			local item = DaYanZaiLuTable[1];
			item:RefreshShow(isEqual);
			IsGoL = false;
			dataTable[1] = isEqual;
			dataTable[2] = IsGoL;
			dataTable[3] = item;
			DaYanZaiLuDataTable[1] = {}
			table.insert(DaYanZaiLuDataTable[1],dataTable);
		else
			local ListCur = #DaYanZaiLuDataTable;
			local childList = DaYanZaiLuDataTable[ListCur];
			local child = childList[#childList];
			---@type RoyalWarAllChildLuItem
			local listItem2 = child[3];
			if(isEqual == child[1])then -- 如果相等就往后面加
				IsGoL = child[2];
				if(IsGoL) then -- 已经开始走L型了
					CurIndex = listItem2:GetIndex()+6;
				else
					CurIndex =  listItem2:GetIndex()+1;
					---@type RoyalWarAllChildLuItem
					local item = DaYanZaiLuTable[CurIndex];
					if(item:IsActive()or (CurIndex-1)%6==0) then --如果下一个索引的物体已经被激活了就走L型
						CurIndex = listItem2:GetIndex()+6;
						IsGoL = true;
					end
				end
				---@type RoyalWarAllChildLuItem
				local item = DaYanZaiLuTable[CurIndex];
				item:RefreshShow(isEqual);
				dataTable[1] = isEqual;
				dataTable[2] = IsGoL;
				dataTable[3] = item;
				table.insert(DaYanZaiLuDataTable[ListCur],dataTable);
			else -- 不等就另外开一列
				if(#DaYanZaiLuDataTable>=24) then--超出列表了，需要隐藏前面
					for i = 1, (#DaYanZaiLuDataTable-23)*6 do
						DaYanZaiLuObjTable[i]:SetActive(false);
					end
				end
				ListCur = #DaYanZaiLuDataTable+1
				CurIndex = #DaYanZaiLuDataTable*6+1;
				---@type RoyalWarAllChildLuItem
				local item = DaYanZaiLuTable[CurIndex];
				item:RefreshShow(isEqual)
				dataTable[1] = isEqual;
				dataTable[2] = IsGoL;
				dataTable[3] = item;
				DaYanZaiLuDataTable[ListCur] ={};
				table.insert(DaYanZaiLuDataTable[ListCur],dataTable)
			end
		end
	end
end

---小路刷新显示
function RoyalWarGameCtrl:AddXiaoLuTableShow()
	local curList = #DaLuDataTable;
	local lastPiece= DaLuDataTable[curList]
	---@type RoyalWarDaLuItem
	local lastItem = lastPiece[#lastPiece][2];
	local index = lastItem:GetIndex();
	if(index>=14) then--开始演化小路的走向
		local isEqual;
		if((index-1)%6==0)then--在第一行对比前面2列的数量是否相等
			local list1 = curList-1;
			local list2 = curList-3;
			local lastItems1 = DaLuDataTable[list1]
			local lastItems2 = DaLuDataTable[list2]
			isEqual = #lastItems1==#lastItems2;
		else --不在第一行
			local index1 = index-12;
			local index2 = index-13;
			---@type RoyalWarDaLuItem
			local item1 =  DaLuTable[index1];
			local item2 =  DaLuTable[index2];
			isEqual = item1:IsActive()==item2:IsActive();
		end

		local dataTable = {};--缓存的需要加入到数据结构里面的表
		local IsGoL; --是否走了L型了
		local CurIndex;
		if(#xiaoLuDataTable==0) then--刚开始走iao
			---@type RoyalWarAllChildLuItem
			local item = xiaoLuTable[1];
			item:RefreshShow(isEqual);
			IsGoL = false;
			dataTable[1] = isEqual;
			dataTable[2] = IsGoL;
			dataTable[3] = item;
			xiaoLuDataTable[1] = {}
			table.insert(xiaoLuDataTable[1],dataTable);
		else
			local ListCur = #xiaoLuDataTable;
			local childList = xiaoLuDataTable[ListCur];
			local child = childList[#childList];
			---@type RoyalWarAllChildLuItem
			local listItem2 = child[3];
			if(isEqual == child[1])then -- 如果相等就往后面加
				IsGoL = child[2];
				if(IsGoL) then -- 已经开始走L型了
					CurIndex = listItem2:GetIndex()+6;
				else
					CurIndex =  listItem2:GetIndex()+1;
					---@type RoyalWarAllChildLuItem
					local item = xiaoLuTable[CurIndex];
					if(item:IsActive()or (CurIndex-1)%6==0) then --如果下一个索引的物体已经被激活了就走L型
						CurIndex = listItem2:GetIndex()+6;
						IsGoL = true;
					end
				end
				---@type RoyalWarAllChildLuItem
				local item = xiaoLuTable[CurIndex];
				item:RefreshShow(isEqual);
				dataTable[1] = isEqual;
				dataTable[2] = IsGoL;
				dataTable[3] = item;
				table.insert(xiaoLuDataTable[ListCur],dataTable);
			else -- 不等就另外开一列
				if(#xiaoLuDataTable>=24) then--超出列表了，需要隐藏前面
					for i = 1, (#xiaoLuDataTable-23)*6 do
						xiaoLuObjTable[i]:SetActive(false);
					end
				end
				ListCur = #xiaoLuDataTable+1
				CurIndex = #xiaoLuDataTable*6+1;
				---@type RoyalWarAllChildLuItem
				local item = xiaoLuTable[CurIndex];
				item:RefreshShow(isEqual)
				dataTable[1] = isEqual;
				dataTable[2] = IsGoL;
				dataTable[3] = item;
				xiaoLuDataTable[ListCur] ={};
				table.insert(xiaoLuDataTable[ListCur],dataTable)
			end
		end

	end
end
---曱甴刷新显示
function RoyalWarGameCtrl:AddYueYouLuTableShow()
	local curList = #DaLuDataTable;
	local lastPiece= DaLuDataTable[curList]
	---@type RoyalWarDaLuItem
	local lastItem = lastPiece[#lastPiece][2];
	local index = lastItem:GetIndex();
	if(index>=20) then--开始演化小路的走向
		local isEqual;
		if((index-1)%6==0)then--在第一行对比前面2列的数量是否相等
			local list1 = curList-1;
			local list2 = curList-4;
			local lastItems1 = DaLuDataTable[list1]
			local lastItems2 = DaLuDataTable[list2]
			isEqual = #lastItems1==#lastItems2;
		else --不在第一行
			local index1 = index-18;
			local index2 = index-19;
			---@type RoyalWarDaLuItem
			local item1 =  DaLuTable[index1];
			local item2 =  DaLuTable[index2];
			isEqual = item1:IsActive()==item2:IsActive();
		end

		local dataTable = {};--缓存的需要加入到数据结构里面的表
		local IsGoL; --是否走了L型了
		local CurIndex;
		if(#YueYouLuDataTable==0) then--刚开始走iao
			---@type RoyalWarAllChildLuItem
			local item = YueYouLuTable[1];
			item:RefreshShow(isEqual);
			IsGoL = false;
			dataTable[1] = isEqual;
			dataTable[2] = IsGoL;
			dataTable[3] = item;
			YueYouLuDataTable[1] = {}
			table.insert(YueYouLuDataTable[1],dataTable);
		else
			local ListCur = #YueYouLuDataTable;
			local childList = YueYouLuDataTable[ListCur];
			local child = childList[#childList];
			---@type RoyalWarAllChildLuItem
			local listItem2 = child[3];
			if(isEqual == child[1])then -- 如果相等就往后面加
				IsGoL = child[2];
				if(IsGoL) then -- 已经开始走L型了
					CurIndex = listItem2:GetIndex()+6;
				else
					CurIndex =  listItem2:GetIndex()+1;
					---@type RoyalWarAllChildLuItem
					local item = YueYouLuTable[CurIndex];
					if(item:IsActive()or (CurIndex-1)%6==0) then --如果下一个索引的物体已经被激活了就走L型
						CurIndex = listItem2:GetIndex()+6;
						IsGoL = true;
					end
				end
				---@type RoyalWarAllChildLuItem
				local item = YueYouLuTable[CurIndex];
				item:RefreshShow(isEqual);
				dataTable[1] = isEqual;
				dataTable[2] = IsGoL;
				dataTable[3] = item;
				table.insert(YueYouLuDataTable[ListCur],dataTable);
			else -- 不等就另外开一列
				if(#YueYouLuDataTable>=24) then--超出列表了，需要隐藏前面
					for i = 1, (#YueYouLuDataTable-23)*6 do
						YueYouLuObjTable[i]:SetActive(false);
					end
				end
				ListCur = #YueYouLuDataTable+1
				CurIndex = #YueYouLuDataTable*6+1;
				---@type RoyalWarAllChildLuItem
				local item = YueYouLuTable[CurIndex];
				item:RefreshShow(isEqual)
				dataTable[1] = isEqual;
				dataTable[2] = IsGoL;
				dataTable[3] = item;
				YueYouLuDataTable[ListCur] ={};
				table.insert(YueYouLuDataTable[ListCur],dataTable)
			end
		end

	end
end



function RoyalWarGameCtrl:Close()
    self.super.Close(self);
end

---添加UI事件
function RoyalWarGameCtrl:AddUIEvent()
	self.uiEventListener:AddClick(self.view.btn_close,function()
		self:Close();
	end)

	self.uiEventListener:AddClick(self.view.btn_One,function()
		CurSelectChip = config.ChipState.One;
		self:SetCheckedShow();
	end)
	self.uiEventListener:AddClick(self.view.btn_Ten,function()
		CurSelectChip = config.ChipState.Ten;
		self:SetCheckedShow();
	end)
	self.uiEventListener:AddClick(self.view.btn_Fifty,function()
		CurSelectChip = config.ChipState.Fifty;
		self:SetCheckedShow();
	end)
	self.uiEventListener:AddClick(self.view.btn_OneHundred,function()
		CurSelectChip = config.ChipState.OneHundred;
		self:SetCheckedShow();
	end)
	self.uiEventListener:AddClick(self.view.btn_FiveHundred,function()
		CurSelectChip = config.ChipState.FiveHundred;
		self:SetCheckedShow();
	end)
	

	self.uiEventListener:AddClick(self.view.btn_BetBlackOne,function()
		--下注庄家区域
		self:PlayChip(config.BetState.Black,CurSelectChip)
	end)

	self.uiEventListener:AddClick(self.view.btn_BetBlackTwo,function()
		--下注闲家区域
		self:PlayChip(config.BetState.Black,CurSelectChip)
	end)

	self.uiEventListener:AddClick(self.view.btn_BetRedOne,function()
		--下注和区域
		self:PlayChip(config.BetState.Red,CurSelectChip)
	end)

	self.uiEventListener:AddClick(self.view.btn_BetRedTwo,function()
		--下注庄对区域
		self:PlayChip(config.BetState.Red,CurSelectChip)
	end)

	self.uiEventListener:AddClick(self.view.btn_BetLucky,function()
		--下注闲对区域
		self:PlayChip(config.BetState.Lucky,CurSelectChip)
	end)

end

---筹码飞行到指定区域
---@param selectBet 选中的下注区域
---@param selectChip 下注的多少
function RoyalWarGameCtrl:PlayChip(selectBet,selectChip)
	if CurSelectChip == 0  or curGameStage~=config.GameSate.Bet then
		return;
	end
	local targetRect;
	if(selectBet == config.BetState.Black) then -- 下注的黑方
		targetRect = self.view.btn_BetBlackTwo.transform:GetComponent("RectTransform");
		BetBlackAllNum = BetBlackAllNum+config.GetChipMoneyNum(selectChip);
		self.view.tmp_BlackBetNum.text = BetBlackAllNum;
	elseif 	selectBet == config.BetState.Red then -- 下注的红方
		targetRect = self.view.btn_BetRedOne.transform:GetComponent("RectTransform")
		BetRedAllNum = BetRedAllNum + config.GetChipMoneyNum(selectChip);
		self.view.tmp_RedBetNum.text = BetRedAllNum;
	elseif 	selectBet == config.BetState.Lucky then -- 下注的幸运一击
		targetRect = self.view.btn_BetLucky.transform:GetComponent("RectTransform")
		BetLuckyAllNum = BetLuckyAllNum+config.GetChipMoneyNum(selectChip);
		self.view.tmp_LuckyBetNum.text = BetLuckyAllNum;
	end

	local chip = self.objPools:SpawnPrefab(nil,config.ABNames.chipPool,config.GetChipPoolName(selectChip),targetRect.transform)
	chip:SetActive(true)
	--chip.transform:SetParent(targetRect.transform,false)
	chip.transform.localScale =  Vector3.one*1.3
	chip.transform.position = self.view.obj_Player.transform.position;
	table.insert(ChipTable,chip);
	-- 获取目标区域的矩形顶点
	local corners = CS.System.Array.CreateInstance(typeof(CS.UnityEngine.Vector3),4)
	targetRect:GetWorldCorners(corners)
	--目标位置
	local endPos= Vector3(UnityEngine.Random.Range(corners[0].x,corners[2].x), UnityEngine.Random.Range(corners[0].y,corners[2].y), 0)
	self.PlayChipSequence = DOTween.Sequence()
	-- 设置金币动画效果
	self.PlayChipSequence:Append(chip.transform:DOMove(endPos, 0.5):SetEase(Ease.Linear))
	self.PlayChipSequence:Append(chip.transform:DOScale(1, 0.3):SetEase(Ease.Linear))
	--self.PlayChipSequence:Append(chip.transform:DOScale(1, 0.4):SetEase(Ease.Linear))
	-- 动画完成后保持金币在桌面上
	self.PlayChipSequence:OnComplete(function()
		--self.PlayChipSequence:Kill();
	end)

	self.PlayChipSequence:Play()

end
---移除UI事件
function RoyalWarGameCtrl:RemoveEvent()
	self.super.RemoveEvent(self);
end

--region UI事件方法

--endregion


---销毁UI
function RoyalWarGameCtrl:RealCloseDestroy()
	self.super.RealCloseDestroy(self);
	TimerManager.StopAllTimer(self)
	if self.SettlementCor then
		coroutine.stop(self.SettlementCor)
		self.SettlementCor=nil
	end
	if self.flickerSequence~=nil then
		self.flickerSequence:Kill();
	end
	if self.PlayChipSequence~=nil then
		self.PlayChipSequence:Kill();
	end
	if self.PlayChipToPlayerSequence~=nil then
		self.PlayChipToPlayerSequence:Kill();
	end
	for _, v in ipairs(ZhuPanTable) do
		---@type RoyalWarZhuPanItem
		local item =v;
		item:Destroy();
	end
	self.objPools:DestroyAll();
	ZhuPanObjTable = {}
	ZhuPanTable ={}
	ZhuPanDataTable ={}

	for _, v in ipairs(DaLuTable) do
		---@type RoyalWarDaLuItem
		local item =v;
		item:Destroy();
	end
	DaLuObjTable ={};
	DaLuTable ={}
	DaLuDataTable ={}

	for _, v in ipairs(CardTypeTable) do
		---@type RoyalWarCardTypeItem
		local item =v;
		item:Destroy();
	end
	CardTypeObjTable ={};
	CardTypeData ={}
	CardTypeTable ={}


	for _, v in ipairs(DaYanZaiLuTable) do
		---@type RoyalWarAllChildLuItem
		local item =v;
		item:Destroy();
	end
	DaYanZaiLuObjTable = {}
	DaYanZaiLuTable = {}
	DaYanZaiLuDataTable = {}

	for _, v in ipairs(xiaoLuTable) do
		---@type RoyalWarAllChildLuItem
		local item =v;
		item:Destroy();
	end

	xiaoLuObjTable ={}
	xiaoLuTable = {}
	xiaoLuDataTable ={}

	for _, v in ipairs(YueYouLuTable) do
		---@type RoyalWarAllChildLuItem
		local item =v;
		item:Destroy();
	end

	YueYouLuObjTable = {}
	YueYouLuTable ={}
	YueYouLuDataTable ={}
end


--function RoyalWarGameCtrl:

return RoyalWarGameCtrl