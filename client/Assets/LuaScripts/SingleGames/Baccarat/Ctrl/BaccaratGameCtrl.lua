---
---Create by Administrator
---DateTime: 2025-06-21 17:21:49
---
---@class BaccaratGameCtrl:BaseCtrl
local BaccaratGameCtrl=Class("BaccaratGameCtrl",BaseCtrl)
---@type BaccaratConfig
local config=require("SingleGames/Baccarat/BaccaratConfig")

---@type BaccaratZhuPanItem
local BaccaratZhuPanItem = require"SingleGames/Baccarat/Ctrl/BaccaratZhuPanItem"
---@type BaccaratDaLuItem
local BaccaratDaLuItem = require"SingleGames/Baccarat/Ctrl/BaccaratDaLuItem"

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
---主盘数据表(进入游戏向服务器拿到数据后打开界面刷新主盘数据显示)
local ZhuPanDataTable = {};
---大路表
local DaLuTable = {};
---大路数据表
local DaLuDataTable = {};

local DaYanZaiLuTable ={};
local xiaoLuTable ={};
local YueYouLuTable = {};
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
	CurSelectChip = 0;
	self:InitZhuPanTable()
	self:InitDaLuTable()
	self:InitData()
end

---初始化数据
function BaccaratGameCtrl:InitData()
	countDownTime = 2;
	
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
	self.view.ator_BankerCard3:Play("New State")
	self.view.ator_PlayerCard1:Play("InitAnimator")
	self.view.ator_PlayerCard2:Play("InitAnimator")
	self.view.ator_PlayerCard3:Play("New State")
	
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
	
	self.beginTimer = TimerManager:CreateTimer(function()
		self.view.obj_VS:SetActive(false);
		curGameStage = gameStage.Bet;
		self:RefreshGameStage();
	end,1,1,true);
	
	self.beginTimer2 = TimerManager:CreateTimer(function()
		self.view.obj_BeginBet:SetActive(false);
	end,1,1,true);

	self.betCountDownTimer = TimerManager:CreateTimer(function()
		countDownTime = countDownTime-1;
		self.view.tmp_Countdown.text = countDownTime;
	end,1,countDownTime,true,function()
		curGameStage =gameStage.Settlement;
		self:RefreshGameStage();
	end);
	
	
	curGameStage = gameStage.Begin;
	
	self:SetCheckedShow();
	---从服务器那边拿数据然后看在哪个阶段了，目前写一个假数据每次进来都是第一阶段
	self:RefreshGameStage()
end
---初始化主盘预制体
function BaccaratGameCtrl:InitZhuPanTable()
	for _, v in ipairs(ZhuPanDataTable) do
		self:RefreshZhuPanShow(v,false)
	end
end
---初始化大路预制体表
function BaccaratGameCtrl:InitDaLuTable()
	for i = 1, 6*24 do
		local obj = self.objPools:SpawnPrefab(nil,config.ABNames.prefabsItem,"DaLuItem")
		---@type BaccaratDaLuItem
		local item = BaccaratDaLuItem.New(obj,self);
		obj:SetActive(true);
		obj.transform:SetParent(self.view.obj_DaLuContent.transform);
		obj.transform.localScale = Vector3.one;
		item:InitState();
		item:InitIndex(i);
		table.insert(DaLuTable,item);
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
	self.view.btn_One:IsInteractable(state);
	self.view.btn_One:IsInteractable(state);
	self.view.btn_Ten:IsInteractable(state);
	self.view.btn_Fifty:IsInteractable(state);
	self.view.btn_OneHundred:IsInteractable(state);
	self.view.btn_FiveHundred:IsInteractable(state);
end

function BaccaratGameCtrl:GetCardNum()
	return math.random(1,13);
end

---进入结算阶段
function BaccaratGameCtrl:EnterSettlement()
	self.view.obj_StopBet:SetActive(true);
	self:SetBetButtonInteractable(false);
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
		ComponentUtilGet.Image(self.view.ator_PlayerCard1.transform,"CardImage").sprite = config.GetIconPic("card2_club_"..playerCard1);
		self.view.ator_PlayerCard1:Play("FlipCards");
		coroutine.wait(0.5)
		local playerCard2 = self:GetCardNum();
		ComponentUtilGet.Image(self.view.ator_PlayerCard2.transform,"CardImage").sprite = config.GetIconPic("card2_club_"..playerCard2);
		self.view.ator_PlayerCard2:Play("FlipCards");
		playerIsPairing = playerCard1 == playerCard2;
		playerCard1 = self:GetCardPoint(playerCard1);
		playerCard2 = self:GetCardPoint(playerCard2);
		local playerCardNum = self:GetCardEndPoint(playerCard1 + playerCard2);
		local playerIsKing =playerCardNum == 8 or playerCardNum == 9;
		self.view.obj_PlayerKing:SetActive(playerIsKing)
		coroutine.wait(0.75)
		local BankerCard1 =  self:GetCardNum();
		ComponentUtilGet.Image(self.view.ator_BankerCard1.transform,"CardImage").sprite = config.GetIconPic("card2_club_"..BankerCard1);
		self.view.ator_BankerCard1:Play("FlipCards");
		coroutine.wait(0.5)
		local BankerCard2 = self:GetCardNum();
		ComponentUtilGet.Image(self.view.ator_BankerCard2.transform,"CardImage").sprite = config.GetIconPic("card2_club_"..BankerCard2);
		self.view.ator_BankerCard2:Play("FlipCards");
		BankerIsPairing = BankerCard1 ==BankerCard2;
		BankerCard1 = self:GetCardPoint(BankerCard1);
		BankerCard2 = self:GetCardPoint(BankerCard2);
		local BankerCardNum = self:GetCardEndPoint(BankerCard1 + BankerCard2);
		local BankerIsKing = BankerCardNum == 8 or BankerCardNum == 9;
		self.view.obj_BankerKing:SetActive(BankerIsKing)
		self:SettleAccounts(playerCardNum,BankerCardNum);
		--if playerIsKing or BankerIsKing  or  playerCardNum == 6  or playerCardNum == 7 or BankerCardNum == 6  or BankerCardNum == 7 then
		--	--不用补牌直接比大小结算
		--	self:SettleAccounts(playerCardNum,BankerCardNum);
		--else
		--	logError("进入补牌")
		--	local playerCard3 = self:GetCardNum();
		--	playerCard3 = self:GetCardPoint(playerCard3);
		--	ComponentUtilGet.Image(self.view.ator_PlayerCard3.transform,"CardImage").sprite = config.GetIconPic("card2_club_"..playerCard3);
		--	self.view.ator_PlayerCard3:Play("PlayerOuts");
		--	coroutine.wait(0.5)
		--	if playerCardNum==0 or playerCardNum == 1 or playerCardNum == 2  then--庄家也补牌
		--	
		--		local BankerCard3 = self:GetCardNum();
		--		ComponentUtilGet.Image(self.view.ator_BankerCard3.transform,"CardImage").sprite = config.GetIconPic("card2_club_"..BankerCard3);
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
	self.view.tmp_PlayerPoint.text = playerCardNum;
	self.view.obj_PlayerPoints:SetActive(true);
	coroutine.wait(0.5)
	self.view.tmp_BankerPoint.text = BankerCardNum;
	self.view.obj_BankerPoints:SetActive(true);
	coroutine.wait(0.5)
	self.view.obj_HeWin:SetActive(playerCardNum == BankerCardNum);
	self.view.obj_ZWin:SetActive(BankerCardNum>playerCardNum);
	self.view.obj_XWin:SetActive(playerCardNum>BankerCardNum);
	self:Flicker(playerCardNum,BankerCardNum);
	coroutine.wait(3);
	for _, v in ipairs(ChipTable) do
		self:PlayChipToPlayer(v)
	end
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
		self:PlayFlicker(ComponentUtilGet.Image(self.view.obj_TieWin.transform),true)
	elseif BankerCardNum > playerCardNum then--庄赢
		CurWhoWin = config.WhoWin.BankerWin
		self:PlayFlicker(ComponentUtilGet.Image(self.view.obj_BankerWin.transform),true)
	elseif playerCardNum>BankerCardNum then--闲赢
		CurWhoWin = config.WhoWin.PlayerWin
		self:PlayFlicker(ComponentUtilGet.Image(self.view.obj_PlayerWin.transform),true)
	end
	if BankerIsPairing then--庄家对子
		self:PlayFlicker(ComponentUtilGet.Image(self.view.obj_PPairWin.transform),false)
	end
	if playerIsPairing then--闲对子
		self:PlayFlicker(ComponentUtilGet.Image(self.view.obj_BPairWin.transform),false)
	end
end
---播放赢的区域闪烁(播放完开始下一局)
function BaccaratGameCtrl:PlayFlicker(image,isInitData)
	self.flickerSequence = DOTween.Sequence()
	self.flickerSequence:Append(image:DOFade(1,0.5))
	self.flickerSequence:SetLoops(8,loopType.Yoyo)
	self.flickerSequence:OnComplete(function()
		if(isInitData) then
			self:InitData();
			local data = {};
			data[1] = CurWhoWin
			data[2] = BankerIsPairing
			data[3] = playerIsPairing;
			self:RefreshZhuPanShow(data,true)
			table.insert(ZhuPanDataTable,data);
		end
	end)

	self.flickerSequence:Play();
end

---刷新主盘显示
function BaccaratGameCtrl:RefreshZhuPanShow(data,isFlicker)
	local obj = self.objPools:SpawnPrefab(nil,config.ABNames.prefabsItem,"BaccaratZhuPanItem")
	---@type BaccaratZhuPanItem
	local item = BaccaratZhuPanItem.New(obj,self);
	obj:SetActive(true);
	obj.transform:SetParent(self.view.obj_ZhuPanContent.transform);
	obj.transform.localScale = Vector3.one;
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
		tieNum = lastPiece[#lastPiece][2];

		if data[1] == config.WhoWin.TieWin then --如果是和就不往下面加，而是显示数字
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
		elseif(lastPiece[#lastPiece][1] ~= data[1]) then --如果和上一次的不一样就往另外开一列
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
	    end
	end
end

function BaccaratGameCtrl:GetNeedShowDaLuItem()
	local index = 1;
	for i, v in ipairs(DaLuTable) do
		if v:IsActive() then
			if(i>index) then
				index = i;
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
		targetRect = self.view.btn_BetBanker.transform:GetComponent("RectTransform");
		BetBankerAllNum = BetBankerAllNum+config.GetChipMoneyNum(selectChip);
		self.view.tmp_BankerBetNum.text = BetBankerAllNum;
	elseif 	selectBet == config.BetState.Player then -- 下注的闲家
        targetRect = self.view.btn_BetPlayer.transform:GetComponent("RectTransform")
		BetPlayerAllNum = BetPlayerAllNum+config.GetChipMoneyNum(selectChip);
		self.view.tmp_PlayerBetNum.text = BetPlayerAllNum;
	elseif 	selectBet == config.BetState.Tie then -- 下注的和
		targetRect = self.view.btn_BetTie.transform:GetComponent("RectTransform")
		BetTieAllNum = BetTieAllNum+config.GetChipMoneyNum(selectChip);
		self.view.tmp_TieBetNum.text = BetTieAllNum;
	elseif 	selectBet == config.BetState.PPair then -- 下注的庄对
		targetRect = self.view.btn_BetPPair.transform:GetComponent("RectTransform")
		BetPPairAllNum = BetPPairAllNum+config.GetChipMoneyNum(selectChip);
		self.view.tmp_PPairBetNum.text = BetPPairAllNum;
	elseif 	selectBet == config.BetState.BPair then -- 下注的闲对
		targetRect = self.view.btn_BetBPair.transform:GetComponent("RectTransform")
		BetBPairAllNum = BetBPairAllNum+config.GetChipMoneyNum(selectChip);
		self.view.tmp_BPairBetNum.text = BetBPairAllNum;
	end
	
	local chip = self.objPools:SpawnPrefab(nil,config.ABNames.chipPool,config.GetChipPoolName(selectChip))
	chip:SetActive(true)
	chip.transform:SetParent(targetRect.transform,false)
	chip.transform.localScale =  Vector3.one
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
	self.PlayChipSequence:Append(chip.transform:DOScale(1.2, 0.3):SetEase(Ease.Linear))
	self.PlayChipSequence:Append(chip.transform:DOScale(1, 0.4):SetEase(Ease.Linear))
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

	if self.beginTimer.running then
		self.beginTimer:Stop();
	end
	if self.betCountDownTimer.running then
		self.betCountDownTimer:Stop();
	end
	if self.beginTimer2.running then
		self.beginTimer2:Stop();
	end
	TimerManager.StopAllTimer(self)
	
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
	ZhuPanTable = {};
end

return BaccaratGameCtrl