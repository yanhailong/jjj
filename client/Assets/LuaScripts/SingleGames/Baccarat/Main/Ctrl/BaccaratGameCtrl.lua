---
---Create by Administrator
---DateTime: 2025-06-21 17:21:49
---
---@class BaccaratGameCtrl:BaseCtrl
local BaccaratGameCtrl=Class("BaccaratGameCtrl",BaseCtrl)
---@type BaccaratConfig
local config=require("SingleGames/Baccarat/Main/BaccaratConfig")

---@type BaccaratZhuPanItem
local BaccaratZhuPanItem = require"SingleGames/Baccarat/Main/Ctrl/BaccaratZhuPanItem"
---@type BaccaratDaLuItem
local BaccaratDaLuItem = require"SingleGames/Baccarat/Main/Ctrl/BaccaratDaLuItem"
---@type BaccaratAllChildLuItem
local BaccaratAllChildLuItem = require"SingleGames/Baccarat/Main/Ctrl/BaccaratAllChildLuItem"

---游戏阶段
local  gameStage ={
	Begin = 1,--开始阶段
	Bet =2,--下注阶段
	Settlement =3,--结算阶段
}


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

local curGameStage = gameStage.Begin;

---下注倒计时
local countDownTime;
---闲家是否是对子
local playerIsPairing;
---庄家是否是对子
local BankerIsPairing;
---当前选中的筹码
local CurSelectChip;
---庄家区域总共下注了多少筹码
local BetBankerAllNum;
---闲家区域总共下注了多少筹码
local BetPlayerAllNum;
---和区域总共下注了多少筹码
local BetTieAllNum;
---庄对区域总共下注了多少筹码
local BetPPairAllNum;
---闲对区域总共下注了多少筹码
local BetBPairAllNum;
---筹码下注的集合表
local ChipTable={};

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
---庄家总共赢了多少局
local BankerWinNumber;
---闲家总共赢了多少局
local PlayerWinNumber;
---和总共出了多少局
local TieWinNumber;
---闲对总共出了多少局
local PPairWinNumber;
---庄对总共出了多少局
local BPairWinNumber;
---天王总共出了多少局
local KingNumber;
---当前玩了多少轮数了
local RoundNumber;
---下注记录
local BetRecord={};
---当前下注
local CurBet={};

---构造函数
function BaccaratGameCtrl:ctor(ctrlName,param)
    self.layer=2;
    self.abName="SingleGames/Baccarat/prefabs/BaccaratGamePanel";
    self.prefabName="BaccaratGamePanel"
    self.super.ctor(self,ctrlName,param);
	---@type BaccaratGameView
	self.view = self.view
	---@type BaccaratGameModel
	self.model = self.model
end

---初始化
function BaccaratGameCtrl:CtrlInit(args)
	self.super.CtrlInit(self,args);
	---@type ObjectPoolUtil
	self.objPools=ObjectPoolUtil.New()
	config.InitIconPic();
	config.InitCardPic();
	CurSelectChip = 0;
	self:InitDataShow()
	self:InitZhuPanTable()
	self:InitDaLuTable()
	self:InitDaLuZiLuTable()
	self:InitXiaoLuTable()
	self:InitYueYouLuTable()
	self:InitData()
end
---初始化要显示的数据（接入服务器数据要，要赋值服务器那边的数据显示）
function BaccaratGameCtrl:InitDataShow()
	BankerWinNumber=0;
	PlayerWinNumber=0;
	TieWinNumber=0;
	PPairWinNumber=0;
	BPairWinNumber=0;
	KingNumber=0;
	RoundNumber=1;
	self:RefreshDataShow()
end

---初始化数据
function BaccaratGameCtrl:InitData()
	countDownTime = 13;
	CurBet={};
	BetBankerAllNum = 0;
	BetPlayerAllNum = 0;
	BetTieAllNum = 0;
	BetPPairAllNum = 0;
	BetBPairAllNum = 0;
	
	self.view.obj_HeWin:SetActive(false);
	self.view.obj_ZWin:SetActive(false);
	self.view.obj_XWin:SetActive(false);
	
	self.view.obj_PlayerKing:SetActive(false);
	self.view.obj_PlayerPoints:SetActive(false);
	self.view.obj_BankerKing:SetActive(false);
	self.view.obj_BankerPoints:SetActive(false);
	self.view.obj_DealCardBg:SetActive(false);
	
	self.view.ator_DealCards:Play("New State")
	self.view.ator_BankerCard1:Play("InitAnimator")
	self.view.ator_BankerCard2:Play("InitAnimator")
	--self.view.ator_BankerCard3:Play("New State")
	self.view.ator_PlayerCard1:Play("InitAnimator")
	self.view.ator_PlayerCard2:Play("InitAnimator")
	--self.view.ator_PlayerCard3:Play("New State")
	
	self.view.obj_SelfBetBanker:SetActive(false);
	self.view.obj_SelfBetBPair:SetActive(false);
	self.view.obj_SelfBetPlayer:SetActive(false);
	self.view.obj_SelfBetPPair:SetActive(false);
	self.view.obj_SelfBetTie:SetActive(false);
	
	self.view.tmp_SelfBetBankerNum.text = "0.00";
	self.view.tmp_SelfBetBPairNum.text = "0.00";
	self.view.tmp_SelfBetPlayerNum.text = "0.00";
	self.view.tmp_SelfBetPPairNum.text = "0.00";
	self.view.tmp_SelfBetTieNum.text = "0.00";
	
	self.view.tmp_BankerBetNum.text = "0.00";
	self.view.tmp_PlayerBetNum.text = "0.00";
	self.view.tmp_PPairBetNum.text = "0.00";
	self.view.tmp_TieBetNum.text = "0.00";
	self.view.tmp_BPairBetNum.text = "0.00";

	self.view.btn_Repeat.interactable =#BetRecord>0;
	
	self.beginTimer = TimerManager.CreateTimer(self,function()
		self.view.obj_VS:SetActive(false);
		curGameStage = gameStage.Bet;
		self:RefreshGameStage();
	end,1,1,true);
	
	self.beginTimer2 = TimerManager.CreateTimer(self,function()
		self.view.obj_BeginBet:SetActive(false);
	end,1,1,true);

	self.betCountDownTimer = TimerManager.CreateTimer(self,function()
		countDownTime = countDownTime-1;
		self.view.tmp_Countdown.text = countDownTime;
		if(countDownTime<=0) then
			curGameStage =gameStage.Settlement;
			self:RefreshGameStage();
		end
	end,1,countDownTime,true);
	curGameStage = gameStage.Begin;
	self:SetCheckedShow();
	---从服务器那边拿数据然后看在哪个阶段了，目前写一个假数据每次进来都是第一阶段
	self:RefreshGameStage()
end


---刷新数据显示
function BaccaratGameCtrl:RefreshDataShow()
	self.view.tmp_ZNum.text = BankerWinNumber;
	self.view.tmp_XNum.text = PlayerWinNumber;
	self.view.tmp_HNum.text = TieWinNumber;
	self.view.tmp_ZCoupletNum.text = BPairWinNumber;
	self.view.tmp_XCoupletNum.text = PPairWinNumber;
	self.view.tmp_ScoreNum.text = KingNumber;
	self.view.tmp_RoundsNum.text = RoundNumber;
end
---清空所有路表
function BaccaratGameCtrl:CloseLuTable()
	for _, v in ipairs(ZhuPanObjTable) do
		self.objPools:UnSpawnPrefab(v);
	end
	ZhuPanTable = {}
	ZhuPanDataTable ={}

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
function BaccaratGameCtrl:InitZhuPanTable()
	for _, v in ipairs(ZhuPanDataTable) do
		self:RefreshZhuPanShow(v,false)
	end
end
---初始化大路预制体表
function BaccaratGameCtrl:InitDaLuTable()
	for i = 1, 240 do
		local obj = self.objPools:SpawnPrefab(nil,config.ABNames.prefabsItem,"DaLuItem",self.view.obj_DaLuContent.transform)
		---@type BaccaratDaLuItem
		local item = BaccaratDaLuItem.New(obj,self);
		obj:SetActive(true);
		--obj.transform:SetParent(self.view.obj_DaLuContent.transform);
		obj.transform.localScale = Vector3.one;
		item:InitState();
		item:InitIndex(i);
		table.insert(DaLuObjTable,obj);
		table.insert(DaLuTable,item);
	end
end
---初始化大路大眼路预制体表
function BaccaratGameCtrl:InitDaLuZiLuTable()
	for i = 1, 240 do
		local obj = self.objPools:SpawnPrefab(nil,config.ABNames.prefabsItem,"DaluZiluItem",self.view.obj_DaluZiluContent.transform)
		---@type BaccaratAllChildLuItem
		local item = BaccaratAllChildLuItem.New(obj,self);
		obj:SetActive(true);
		--obj.transform:SetParent(self.view.obj_DaluZiluContent.transform);
		obj.transform.localScale = Vector3.one;
		item:InitState();
		item:InitIndex(i);
		table.insert(DaYanZaiLuObjTable,obj);
		table.insert(DaYanZaiLuTable,item);
	end
	
end
---初始化大路大眼路预制体表
function BaccaratGameCtrl:InitXiaoLuTable()
	for i = 1, 240 do
		local obj = self.objPools:SpawnPrefab(nil,config.ABNames.prefabsItem,"XiaoLuItem",self.view.obj_XiaoLuContent.transform)
		---@type BaccaratAllChildLuItem
		local item = BaccaratAllChildLuItem.New(obj,self);
		obj:SetActive(true);
		--obj.transform:SetParent(self.view.obj_XiaoLuContent.transform);
		obj.transform.localScale = Vector3.one;
		item:InitState();
		item:InitIndex(i);
		table.insert(xiaoLuObjTable,obj);
		table.insert(xiaoLuTable,item);
	end
	
end
---初始化曱甴路预制体表
function BaccaratGameCtrl:InitYueYouLuTable()
	for i = 1, 240 do
		local obj = self.objPools:SpawnPrefab(nil,config.ABNames.prefabsItem,"YueYouLuItem",self.view.obj_YueYouLuContent.transform)
		---@type BaccaratAllChildLuItem
		local item = BaccaratAllChildLuItem.New(obj,self);
		obj:SetActive(true);
		--obj.transform:SetParent(self.view.obj_YueYouLuContent.transform);
		obj.transform.localScale = Vector3.one;
		item:InitState();
		item:InitIndex(i);
		table.insert(YueYouLuObjTable,obj);
		table.insert(YueYouLuTable,item);
	end
	
end

---同步游戏当前在哪个阶段
function BaccaratGameCtrl:RefreshGameStage()
	if curGameStage == gameStage.Begin then
		self:EnterBegin();
	elseif curGameStage == gameStage.Bet then
		self:EnterBetGame();
	elseif curGameStage == gameStage.Settlement then
		self:EnterSettlement();
	end
end

---进入开始阶段(显示VS)
function BaccaratGameCtrl:EnterBegin()
	self.view.obj_Countdown:SetActive(false);
	self.view.obj_VS:SetActive(true);
	self.beginTimer:Start();
end
---进入下注阶段
function BaccaratGameCtrl:EnterBetGame()
	self.view.tmp_Countdown.text = countDownTime;
	self:SetBetButtonInteractable(true);
	self.view.obj_Countdown:SetActive(true);
	self.view.obj_BeginBet:SetActive(true);
	self.beginTimer2:Start();
	self:ShowCountDown();
end
---显示下注倒计时
function BaccaratGameCtrl:ShowCountDown()
	self.betCountDownTimer:Start();
end
---设置按钮的显示状态
function BaccaratGameCtrl:SetBetButtonInteractable(state)
	self.view.btn_One.interactable = state;
	self.view.btn_Ten.interactable = state;
	self.view.btn_Fifty.interactable = state;
	self.view.btn_OneHundred.interactable = state;
	self.view.btn_FiveHundred.interactable = state;
end

function BaccaratGameCtrl:GetCardNum()
	return math.random(1,13);
end

---进入结算阶段
function BaccaratGameCtrl:EnterSettlement()
	self.view.obj_StopBet:SetActive(true);
	self:SetBetButtonInteractable(false);
	self.view.btn_Repeat.interactable = false;
	self.view.obj_Countdown:SetActive(false);
	--显示发牌区域
	self.view.obj_DealCardBg:SetActive(true);
	self.view.ator_DealCards:Play("dealAnim")
	if self.SettlementCor then
		coroutine.stop(self.SettlementCor)
		self.SettlementCor=nil
	end
	self.SettlementCor=	CorManager:StartCor(function()--翻牌
		coroutine.wait(0.5)
		self.view.obj_StopBet:SetActive(false);
		coroutine.wait(1)
		local playerCard1 = self:GetCardNum();
		ComponentUtilGet.Image(self.view.ator_PlayerCard1.transform,"CardImage").sprite = config.GetCardPic("pai_"..config.GetPaiXing()..playerCard1);
		self.view.ator_PlayerCard1:Play("FlipCards");
		coroutine.wait(0.5)
		local playerCard2 = self:GetCardNum();
		ComponentUtilGet.Image(self.view.ator_PlayerCard2.transform,"CardImage").sprite = config.GetCardPic("pai_"..config.GetPaiXing()..playerCard2);
		self.view.ator_PlayerCard2:Play("FlipCards");
		playerIsPairing = playerCard1 == playerCard2;
		playerCard1 = self:GetCardPoint(playerCard1);
		playerCard2 = self:GetCardPoint(playerCard2);
		local playerCardNum = self:GetCardEndPoint(playerCard1 + playerCard2);
		local playerIsKing =playerCardNum == 8 or playerCardNum == 9;
		self.view.obj_PlayerKing:SetActive(playerIsKing)
		coroutine.wait(0.75)
		local BankerCard1 =  self:GetCardNum();
		ComponentUtilGet.Image(self.view.ator_BankerCard1.transform,"CardImage").sprite = config.GetCardPic("pai_"..config.GetPaiXing()..BankerCard1);
		self.view.ator_BankerCard1:Play("FlipCards");
		coroutine.wait(0.5)
		local BankerCard2 = self:GetCardNum();
		ComponentUtilGet.Image(self.view.ator_BankerCard2.transform,"CardImage").sprite = config.GetCardPic("pai_"..config.GetPaiXing()..BankerCard2);
		self.view.ator_BankerCard2:Play("FlipCards");
		BankerIsPairing = BankerCard1 ==BankerCard2;
		BankerCard1 = self:GetCardPoint(BankerCard1);
		BankerCard2 = self:GetCardPoint(BankerCard2);
		local BankerCardNum = self:GetCardEndPoint(BankerCard1 + BankerCard2);
		local BankerIsKing = BankerCardNum == 8 or BankerCardNum == 9;
		self.view.obj_BankerKing:SetActive(BankerIsKing)
		if(playerIsKing or BankerIsKing) then
			KingNumber=KingNumber+1;
		end
		self:SettleAccounts(playerCardNum,BankerCardNum);
		
		--if playerIsKing or BankerIsKing  or  playerCardNum == 6  or playerCardNum == 7 or BankerCardNum == 6  or BankerCardNum == 7 then
		--	--不用补牌直接比大小结算
		--	self:SettleAccounts(playerCardNum,BankerCardNum);
		--else
		--	logError("进入补牌")
		--	local playerCard3 = self:GetCardNum();
		--	playerCard3 = self:GetCardPoint(playerCard3);
		--	ComponentUtilGet.Image(self.view.ator_PlayerCard3.transform,"CardImage").sprite = config.GetIconPic("pai"..config.GetPaiXing()..playerCard3);
		--	self.view.ator_PlayerCard3:Play("PlayerOuts");
		--	coroutine.wait(0.5)
		--	if playerCardNum==0 or playerCardNum == 1 or playerCardNum == 2  then--庄家也补牌
		--	
		--		local BankerCard3 = self:GetCardNum();
		--		ComponentUtilGet.Image(self.view.ator_BankerCard3.transform,"CardImage").sprite = config.GetIconPic("pai"..config.GetPaiXing()..BankerCard3);
		--		self.view.ator_BankerCard3:Play("BankerOuts");
		--		BankerCardNum =  self:GetCardEndPoint(BankerCardNum +BankerCard3);
		--		coroutine.wait(0.5)
		--	end
		--	playerCardNum =  self:GetCardEndPoint(playerCardNum + playerCard3);
		--	self:SettleAccounts(playerCardNum,BankerCardNum);
		--end
	end)
end
---结算
function BaccaratGameCtrl:SettleAccounts(playerCardNum,BankerCardNum)
	self.view.txt_PlayerPoint.text = playerCardNum;
	self.view.obj_PlayerPoints:SetActive(true);
	coroutine.wait(0.5)
	self.view.txt_BankerPoint.text = BankerCardNum;
	self.view.obj_BankerPoints:SetActive(true);
	coroutine.wait(0.5)
	self.view.obj_HeWin:SetActive(playerCardNum == BankerCardNum);
	self.view.obj_ZWin:SetActive(BankerCardNum>playerCardNum);
	self.view.obj_XWin:SetActive(playerCardNum>BankerCardNum);
	self:Flicker(playerCardNum,BankerCardNum);
	coroutine.wait(3);
	for _, v in ipairs(ChipTable)  do
		self:PlayChipToPlayer(v)
	end
	BetRecord=CurBet;
	coroutine.wait(2);
	self:InitData();
	RoundNumber = RoundNumber+1;
	self:RefreshDataShow()
	if(#ZhuPanDataTable>=50) then
		self:CloseLuTable()
	end
	local data = {};
	data[1] = CurWhoWin
	data[2] = BankerIsPairing
	data[3] = playerIsPairing;
	self:RefreshZhuPanShow(data,true)
	table.insert(ZhuPanDataTable,data);
end
---飞筹码到对应玩家头像上
function BaccaratGameCtrl:PlayChipToPlayer(chip)
	self.PlayChipToPlayerSequence = chip.transform:DOMove(self.view.obj_Player.transform.position, 0.5);
	self.PlayChipToPlayerSequence:SetEase(Ease.Linear)
	-- 动画完成后回收筹码
	self.PlayChipToPlayerSequence:OnComplete(function()
	    --回收筹码
		self.objPools:UnSpawnPrefab(chip)
		chip = nil;
	end)
end

---闪烁对应区域
function BaccaratGameCtrl:Flicker(playerCardNum,BankerCardNum)
	if playerCardNum == BankerCardNum then--和
		CurWhoWin =config.WhoWin.TieWin;
		TieWinNumber = TieWinNumber+1
		self:PlayFlicker(ComponentUtilGet.Image(self.view.obj_TieWin.transform))
	elseif BankerCardNum > playerCardNum then--庄赢
		BankerWinNumber = BankerWinNumber+1;
		CurWhoWin = config.WhoWin.BankerWin
		self:PlayFlicker(ComponentUtilGet.Image(self.view.obj_BankerWin.transform))
	elseif playerCardNum>BankerCardNum then--闲赢
		PlayerWinNumber = PlayerWinNumber+1;
		CurWhoWin = config.WhoWin.PlayerWin
		self:PlayFlicker(ComponentUtilGet.Image(self.view.obj_PlayerWin.transform))
	end
	if BankerIsPairing then--庄家对子
		BPairWinNumber = BPairWinNumber+1;
		self:PlayFlicker(ComponentUtilGet.Image(self.view.obj_BPairWin.transform))
	end
	if playerIsPairing then--闲对子
		PPairWinNumber = PPairWinNumber+1;
		self:PlayFlicker(ComponentUtilGet.Image(self.view.obj_PPairWin.transform))
	end
end
---播放赢的区域闪烁
function BaccaratGameCtrl:PlayFlicker(image)
	self.flickerSequence = DOTween.Sequence()
	self.flickerSequence:Append(image:DOFade(1,0.5))
	self.flickerSequence:SetLoops(8,loopType.Yoyo)
	self.flickerSequence:Play();
end

---刷新主盘显示
function BaccaratGameCtrl:RefreshZhuPanShow(data,isFlicker)
	if(#ZhuPanTable==48) then
		for i = 1, 6 do
			ZhuPanObjTable[i]:SetActive(false);
		end
	end
	local obj = self.objPools:SpawnPrefab(nil,config.ABNames.prefabsItem,"ZhuPanItem",self.view.obj_ZhuPanContent.transform)
	---@type BaccaratZhuPanItem
	local item = BaccaratZhuPanItem.New(obj,self);
	obj:SetActive(true);
	--obj.transform:SetParent(self.view.obj_ZhuPanContent.transform);
	obj.transform.localScale = Vector3.one;
	table.insert(ZhuPanObjTable,obj);
	item:RefreshShow(data,isFlicker)
	table.insert(ZhuPanTable,item);
	self:AddDaLuTableShow(data);
end

---大路新增显示
function BaccaratGameCtrl:AddDaLuTableShow(data)
	local curIndex = 0; --当前的索引
	local curList = 0;--当前是第几列
	local tieNum = 0;--和的数字
	local whoWin;--谁赢
	local dataTable = {};--缓存的需要加入到数据结构里面的表
	local IsGoL; --是否走了L型了
	if(#DaLuDataTable==0) then--刚开始
		---@type BaccaratDaLuItem
		local item = DaLuTable[1];
		if(data[1] == config.WhoWin.TieWin) then
			tieNum=tieNum+1;
			item:RefreshTieNumShow(tieNum);
		else
			whoWin = data[1];
			item:RefreshShow(whoWin);
		end
		curList = 1;
		DaLuDataTable[curList] ={};
		dataTable[1] = whoWin;
		dataTable[2] = tieNum;
		dataTable[3] = item;
		dataTable[4] = false;
		table.insert(DaLuDataTable[curList],dataTable)
	else
		curList = #DaLuDataTable;
		local lastPiece= DaLuDataTable[curList]
		if data[1] == config.WhoWin.TieWin then --如果是和就不往下面加，而是显示数字
			tieNum = lastPiece[#lastPiece][2];
			tieNum = tieNum+1;
			lastPiece[#lastPiece][2] = tieNum;
			---@type BaccaratDaLuItem
			local lastItem = lastPiece[#lastPiece][3];
			lastItem:RefreshTieNumShow(tieNum);
		elseif(lastPiece[#lastPiece][1] == data[1]) then --如果和上一次的一样就往后面加
			IsGoL = lastPiece[#lastPiece][4];
			local lastItem = lastPiece[#lastPiece][3];
			if(IsGoL) then -- 已经开始走L型了
				curIndex = lastItem:GetIndex()+6;
			else
				curIndex = lastItem:GetIndex()+1;
				---@type BaccaratDaLuItem
				local item = DaLuTable[curIndex];
				if(item:IsActive()or (curIndex-1)%6==0) then --如果下一个索引的物体已经被激活了就走L型
					curIndex = lastItem:GetIndex()+6;
					IsGoL = true;
				end
			end
			---@type BaccaratDaLuItem
			local item = DaLuTable[curIndex];
			dataTable[1] = data[1];
			dataTable[2] = tieNum;
			dataTable[3] = item;
			dataTable[4] = IsGoL;
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
			---@type BaccaratDaLuItem
			local item = DaLuTable[curIndex];
			dataTable[1] =  data[1];
			dataTable[2] = tieNum;
			dataTable[3] = item;
			dataTable[4] = IsGoL;
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
function BaccaratGameCtrl:AddDaYanZiLuTableShow()
	local curList = #DaLuDataTable;
	local lastPiece= DaLuDataTable[curList]
	---@type BaccaratDaLuItem
	local lastItem = lastPiece[#lastPiece][3];
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
			---@type BaccaratDaLuItem
			local item1 =  DaLuTable[index1];
			local item2 =  DaLuTable[index2];
			isEqual = item1:IsActive()==item2:IsActive();
		end
		
		local dataTable = {};--缓存的需要加入到数据结构里面的表
		local IsGoL; --是否走了L型了
		local CurIndex;
		if(#DaYanZaiLuDataTable==0) then--刚开始走
			---@type BaccaratAllChildLuItem
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
			---@type BaccaratAllChildLuItem
			local listItem2 = child[3];
			if(isEqual == child[1])then -- 如果相等就往后面加
				IsGoL = child[2];
				if(IsGoL) then -- 已经开始走L型了
					CurIndex = listItem2:GetIndex()+6;
				else
					CurIndex =  listItem2:GetIndex()+1;
					---@type BaccaratAllChildLuItem
					local item = DaYanZaiLuTable[CurIndex];
					if(item:IsActive()or (CurIndex-1)%6==0) then --如果下一个索引的物体已经被激活了就走L型
						CurIndex = listItem2:GetIndex()+6;
						IsGoL = true;
					end
				end
				---@type BaccaratAllChildLuItem
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
				---@type BaccaratAllChildLuItem
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
function BaccaratGameCtrl:AddXiaoLuTableShow()
	local curList = #DaLuDataTable;
	local lastPiece= DaLuDataTable[curList]
	---@type BaccaratDaLuItem
	local lastItem = lastPiece[#lastPiece][3];
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
			---@type BaccaratDaLuItem
			local item1 =  DaLuTable[index1];
			local item2 =  DaLuTable[index2];
			isEqual = item1:IsActive()==item2:IsActive();
		end
		
		local dataTable = {};--缓存的需要加入到数据结构里面的表
		local IsGoL; --是否走了L型了
		local CurIndex;
		if(#xiaoLuDataTable==0) then--刚开始走iao
			---@type BaccaratAllChildLuItem
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
			---@type BaccaratAllChildLuItem
			local listItem2 = child[3];
			if(isEqual == child[1])then -- 如果相等就往后面加
				IsGoL = child[2];
				if(IsGoL) then -- 已经开始走L型了
					CurIndex = listItem2:GetIndex()+6;
				else
					CurIndex =  listItem2:GetIndex()+1;
					---@type BaccaratAllChildLuItem
					local item = xiaoLuTable[CurIndex];
					if(item:IsActive()or (CurIndex-1)%6==0) then --如果下一个索引的物体已经被激活了就走L型
						CurIndex = listItem2:GetIndex()+6;
						IsGoL = true;
					end
				end
				---@type BaccaratAllChildLuItem
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
				---@type BaccaratAllChildLuItem
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
function BaccaratGameCtrl:AddYueYouLuTableShow()
	local curList = #DaLuDataTable;
	local lastPiece= DaLuDataTable[curList]
	---@type BaccaratDaLuItem
	local lastItem = lastPiece[#lastPiece][3];
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
			---@type BaccaratDaLuItem
			local item1 =  DaLuTable[index1];
			local item2 =  DaLuTable[index2];
			isEqual = item1:IsActive()==item2:IsActive();
		end
		
		local dataTable = {};--缓存的需要加入到数据结构里面的表
		local IsGoL; --是否走了L型了
		local CurIndex;
		if(#YueYouLuDataTable==0) then--刚开始走iao
			---@type BaccaratAllChildLuItem
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
			---@type BaccaratAllChildLuItem
			local listItem2 = child[3];
			if(isEqual == child[1])then -- 如果相等就往后面加
				IsGoL = child[2];
				if(IsGoL) then -- 已经开始走L型了
					CurIndex = listItem2:GetIndex()+6;
				else
					CurIndex =  listItem2:GetIndex()+1;
					---@type BaccaratAllChildLuItem
					local item = YueYouLuTable[CurIndex];
					if(item:IsActive()or (CurIndex-1)%6==0) then --如果下一个索引的物体已经被激活了就走L型
						CurIndex = listItem2:GetIndex()+6;
						IsGoL = true;
					end
				end
				---@type BaccaratAllChildLuItem
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
				---@type BaccaratAllChildLuItem
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

---获取真正的点数
function BaccaratGameCtrl:GetCardPoint(point)
	if(point >=10) then
		return 0
	else
		return point 
	end
end

---获取相加后显示的点数
function BaccaratGameCtrl:GetCardEndPoint(point)
	if(point >=10) then
		point = point-10;
		return point 
	else
		return point
	end
end


function BaccaratGameCtrl:Close()
    self.super.Close(self);
end

---添加UI事件
function BaccaratGameCtrl:AddUIEvent()
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
	
	self.uiEventListener:AddClick(self.view.btn_BetBanker,function()
		--下注庄家区域
		self:PlayChip(config.BetState.Banker,CurSelectChip)
	end)

	self.uiEventListener:AddClick(self.view.btn_BetPlayer,function()
		--下注闲家区域
		self:PlayChip(config.BetState.Player,CurSelectChip)
	end)

	self.uiEventListener:AddClick(self.view.btn_BetTie,function()
		--下注和区域
		self:PlayChip(config.BetState.Tie,CurSelectChip)
	end)

	self.uiEventListener:AddClick(self.view.btn_BetPPair,function()
		--下注庄对区域
		self:PlayChip(config.BetState.PPair,CurSelectChip)
	end)

	self.uiEventListener:AddClick(self.view.btn_BetBPair,function()
		--下注闲对区域
		self:PlayChip(config.BetState.BPair,CurSelectChip)
	end)
	
	self.uiEventListener:AddClick(self.view.btn_Repeat,function()
		--点击续押
		self.view.btn_Repeat.interactable = false;
		for _, v in pairs(BetRecord) do
			self:PlayChip(v[1],v[2]);
		end
	end)
end
---选中哪个筹码
function BaccaratGameCtrl:SetCheckedShow()
	self.view.obj_checkedOne:SetActive(CurSelectChip == config.ChipState.One);
	self.view.obj_checkedTen:SetActive(CurSelectChip == config.ChipState.Ten);
	self.view.obj_checkedFifty:SetActive(CurSelectChip == config.ChipState.Fifty);
	self.view.obj_checkedOneHundred:SetActive(CurSelectChip == config.ChipState.OneHundred);
	self.view.obj_checkedFiveHundred:SetActive(CurSelectChip == config.ChipState.FiveHundred);
end
---筹码飞行到指定区域
---@param selectBet 选中的下注区域
---@param selectChip 下注的多少
function BaccaratGameCtrl:PlayChip(selectBet,selectChip)
	if CurSelectChip == 0  or curGameStage~=gameStage.Bet then
		return;
	end
    local targetRect;
	if(selectBet == config.BetState.Banker) then -- 下注的庄家
		targetRect = self.view.obj_BetBankerRegion.transform:GetComponent("RectTransform");
		BetBankerAllNum = BetBankerAllNum+config.GetChipMoneyNum(selectChip);
		self.view.tmp_BankerBetNum.text = BetBankerAllNum;
	elseif 	selectBet == config.BetState.Player then -- 下注的闲家
        targetRect = self.view.obj_BetPlayerRegion.transform:GetComponent("RectTransform")
		BetPlayerAllNum = BetPlayerAllNum+config.GetChipMoneyNum(selectChip);
		self.view.tmp_PlayerBetNum.text = BetPlayerAllNum;
	elseif 	selectBet == config.BetState.Tie then -- 下注的和
		targetRect = self.view.obj_BetTieRegion.transform:GetComponent("RectTransform")
		BetTieAllNum = BetTieAllNum+config.GetChipMoneyNum(selectChip);
		self.view.tmp_TieBetNum.text = BetTieAllNum;
	elseif 	selectBet == config.BetState.BPair then -- 下注的庄对
		targetRect = self.view.obj_BetBPairRegion.transform:GetComponent("RectTransform")
		BetBPairAllNum = BetBPairAllNum+config.GetChipMoneyNum(selectChip);
		self.view.tmp_BPairBetNum.text = BetBPairAllNum;
	elseif 	selectBet == config.BetState.PPair then -- 下注的闲对
		targetRect = self.view.obj_BetPPairRegion.transform:GetComponent("RectTransform")
		BetPPairAllNum = BetPPairAllNum+config.GetChipMoneyNum(selectChip);
		self.view.tmp_PPairBetNum.text = BetPPairAllNum;
	end
	
	local betType={};
	betType[1] = selectBet
	betType[2] = selectChip
	table.insert(CurBet,betType);
	
	local chip = self.objPools:SpawnPrefab(nil,config.ABNames.chipPool,config.GetChipPoolName(selectChip))
	chip:SetActive(true)
	chip.transform:SetParent(targetRect.transform,false)
	chip.transform.localScale =  Vector3.one*0.8
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
	self.PlayChipSequence:Append(chip.transform:DOScale(0.5, 0.3):SetEase(Ease.Linear))
	--self.PlayChipSequence:Append(chip.transform:DOScale(1, 0.4):SetEase(Ease.Linear))
	-- 动画完成后保持金币在桌面上
	self.PlayChipSequence:OnComplete(function()
		--self.PlayChipSequence:Kill();
	end)

	self.PlayChipSequence:Play()
	
end


---移除UI事件
function BaccaratGameCtrl:RemoveEvent()
	self.super.RemoveEvent(self);
end

--region UI事件方法

--endregion


---销毁UI
function BaccaratGameCtrl:RealCloseDestroy()
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
		---@type BaccaratZhuPanItem
		local item =v;
		item:Destroy();
	end
	self.objPools:DestroyAll();
	ZhuPanObjTable = {}
	ZhuPanTable ={}
	ZhuPanDataTable ={}
    
	for _, v in ipairs(DaLuTable) do
		---@type BaccaratDaLuItem
		local item =v;
		item:Destroy();
	end
	DaLuObjTable ={};
	DaLuTable ={}
	DaLuDataTable ={}


	for _, v in ipairs(DaYanZaiLuTable) do
		---@type BaccaratAllChildLuItem
		local item =v;
		item:Destroy();
	end
	DaYanZaiLuObjTable = {}
	DaYanZaiLuTable = {}
	DaYanZaiLuDataTable = {}
	
	for _, v in ipairs(xiaoLuTable) do
		---@type BaccaratAllChildLuItem
		local item =v;
		item:Destroy();
	end

	xiaoLuObjTable ={}
	xiaoLuTable = {}
	xiaoLuDataTable ={}
	
	for _, v in ipairs(YueYouLuTable) do
		---@type BaccaratAllChildLuItem
		local item =v;
		item:Destroy();
	end
	
	YueYouLuObjTable = {}
	YueYouLuTable ={}
	YueYouLuDataTable ={}
end

return BaccaratGameCtrl