---
---Create by Administrator
---DateTime: 2025-06-21 17:21:49
---
---@class BaccaratGameCtrl:BaseCtrl
local BaccaratGameCtrl=Class("BaccaratGameCtrl",BaseCtrl)
---@type BaccaratConfig
local config=require("SingleGames/Baccarat/BaccaratConfig")
---@type BaccaratRoad
local BaccaratRoad = require("SingleGames/Baccarat/Ctrl/BaccaratRoad")
---@type BaccaratPlayerItem
local BaccaratPlayerItem = require("SingleGames/Baccarat/Ctrl/BaccaratPlayerItem")
---@type BaccaratChipItems
local BaccaratChipItems = require("SingleGames/Baccarat/Ctrl/BaccaratChipItems")
---游戏阶段
local  gameStage ={
	Begin = 1,--开始阶段
	Bet =2,--下注阶段
	Deal =3,--发牌后开始结算
	Settlement =4,--直接展示牌面后结算
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
---当前游戏状态
local curGameStage = gameStage.Begin;

---下注倒计时
local countDownTime;
---闲家是否是对子
local playerIsPairing;
---庄家是否是对子
local BankerIsPairing;
---当前选中的筹码
local CurSelectChip;
---自己庄家区域总共下注了多少筹码
local SelfBetBankerAllNum;
---自己闲家区域总共下注了多少筹码
local SelfBetPlayerAllNum;
---自己和区域总共下注了多少筹码
local SelfBetTieAllNum;
---自己闲对区域总共下注了多少筹码
local SelfBetBPairAllNum;
---筹码下注的集合表
local SelfBetPPairAllNum;
---自己庄对区域总共下注了多少筹码
local ChipTable={};
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
--region spine动画
local vsSpine;
local BeginBetSpine;
local StopBetSpine;
local ResultTieSpine;
local ResultBankerSpine;
local ResultPlayerSpine;
local PlayerKingSpine;
local BankerKingSpine;
local AlarmClockSpine;--闹钟动画
--endregion
---筹码按钮所有子物体的Image集合
local BottomNoteChildImages={};
---服务器发过来的房间数据
local BaccaratTableInfo;
---前6名玩家预支体集合
local BestSixPlayerObjs={}
---玩家预支脚本集合
local BaccaratPlayerItems={}
---筹码的集合
local ChipItems = {};

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
	self:InitData()
	self:FirstEntryGame(args)
end

---初始化数据
function BaccaratGameCtrl:InitData()
	---@type ObjectPoolUtil
	self.objPools=ObjectPoolUtil.New()
	config.InitIconPic();
	config.InitCardPic();
	config.InitUIImageGray();
	config.InitCommonMainPic();
	CurSelectChip = nil;
	self:InitUIShow()
	---@type BaccaratPlayerItem
	for i = 1,self.view.obj_PlayerRoot.transform.childCount do
		BestSixPlayerObjs[i] = self.view.obj_PlayerRoot.transform:GetChild(i-1).gameObject;
		BaccaratPlayerItems[i]=BaccaratPlayerItem.New(BestSixPlayerObjs[i],self)
		BestSixPlayerObjs[i]:SetActive(false);
	end
	
	

	vsSpine = ComponentUtilGet.SkeletonGraphic(self.view.obj_VS.transform);
	BeginBetSpine = ComponentUtilGet.SkeletonGraphic(self.view.obj_BeginBet.transform);
	StopBetSpine = ComponentUtilGet.SkeletonGraphic(self.view.obj_StopBet.transform);
	ResultTieSpine = ComponentUtilGet.SkeletonGraphic(self.view.obj_HeWin.transform);
	ResultBankerSpine = ComponentUtilGet.SkeletonGraphic(self.view.obj_ZWin.transform);
	ResultPlayerSpine = ComponentUtilGet.SkeletonGraphic(self.view.obj_XWin.transform);
	PlayerKingSpine = ComponentUtilGet.SkeletonGraphic(self.view.obj_PlayerKing.transform);
	BankerKingSpine = ComponentUtilGet.SkeletonGraphic(self.view.obj_BankerKing.transform);
	AlarmClockSpine = ComponentUtilGet.SkeletonGraphic(self.view.obj_Countdown.transform);
	BottomNoteChildImages = self.view.obj_BottomNote:GetComponentsInChildren(UnityEngine.UI.Image,true)

	---@type BaccaratRoad
	self.BaccaratRoadScripts =BaccaratRoad.New()
	self.BaccaratRoadScripts:Init(self.view.obj_ZhuPanContent,self.view.obj_DaLuContent,
			self.view.obj_DaluZiluContent,self.view.obj_XiaoLuContent,self.view.obj_YueYouLuContent);
	
	self.VsSpineActionTimer = TimerManager.CreateTimer(self,function()
		Tools.PlayerSpineAniByName(vsSpine,"end",false)
		self.VsSpineEndTimer:Start();
	end,1,1,true);

	self.VsSpineEndTimer =  TimerManager.CreateTimer(self,function()
		self.view.obj_VS:SetActive(false);
		curGameStage = gameStage.Bet;
		self:RefreshGameStage();
	end,0.5,1,true);

	self.beginTimer = TimerManager.CreateTimer(self,function()
		self.view.obj_BeginBet:SetActive(false);
		self.view.obj_Countdown:SetActive(true);
		Tools.PlayerSpineAniByName(AlarmClockSpine,"idle",true)
		self.betCountDownTimer:Start();
		self:SetBetButtonInteractable(true);
	end,1,1,true);

	self.betCountDownTimer = TimerManager.CreateTimer(self,function()
		countDownTime = countDownTime-1;
		self.view.txt_Countdown.text = countDownTime;
		if(countDownTime == 3) then
			Tools.PlayerSpineAniByName(AlarmClockSpine,"action",true)
		end
		if(countDownTime<=0) then
			curGameStage =gameStage.Deal;
			self:RefreshGameStage();
		end
	end,1,countDownTime,true);
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
	self:RefreshUIDataShow()
end
---刷新UI数据显示
function BaccaratGameCtrl:RefreshUIDataShow()
	self.view.tmp_ZNum.text = BankerWinNumber;
	self.view.tmp_XNum.text = PlayerWinNumber;
	self.view.tmp_HNum.text = TieWinNumber;
	self.view.tmp_ZCoupletNum.text = BPairWinNumber;
	self.view.tmp_XCoupletNum.text = PPairWinNumber;
	self.view.tmp_ScoreNum.text = KingNumber;
	self.view.tmp_RoundsNum.text = RoundNumber;
end

function BaccaratGameCtrl:InitUIShow()
	if self.SettlementCor then
		coroutine.stop(self.SettlementCor)
		self.SettlementCor=nil
	end
	CurBet={};
	SelfBetBankerAllNum = 0;
	SelfBetPlayerAllNum = 0;
	SelfBetTieAllNum = 0;
	SelfBetPPairAllNum = 0;
	SelfBetBPairAllNum = 0;
	self:RefreshSelfBetNumShow()
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
end

---刷新自己下注的筹码数量是否显示
function BaccaratGameCtrl:RefreshSelfBetNumShow()
	self.view.obj_SelfBetBanker:SetActive(SelfBetBankerAllNum~=0);
	self.view.obj_SelfBetPlayer:SetActive(SelfBetPlayerAllNum~=0);
	self.view.obj_SelfBetTie:SetActive(SelfBetTieAllNum~=0);
	self.view.obj_SelfBetBPair:SetActive(SelfBetBPairAllNum~=0);
	self.view.obj_SelfBetPPair:SetActive(SelfBetPPairAllNum~=0);
	
end
---首次进入游戏刷新显示
function BaccaratGameCtrl:FirstEntryGame(data)
	self.BaccaratRoadScripts:InitData(data,self.GamePhase.gamePhase == 5);
	--初始化筹码
	for i = 1, #data.betInfoList do
		local item =self.objPools:Spawn(nil,self.view.obj_chipItem,self.view.obj_ChipContent.transform)
		item:SetActive(true);
		---@type BaccaratChipItems
		local chipItem = BaccaratChipItems.New(item,self);
		chipItem:InitUIShow(i,data.betInfoList[i]);
		table.insert(ChipItems,chipItem);
	end
	self:RefreshDataShow(data);
end

---服务器数据返回刷新阶段显示
function BaccaratGameCtrl:RefreshDataShow(data)
	BaccaratTableInfo = data;
	self.GamePhase = data.gamePhase;--游戏阶段信息
	local ServerTime = ServerTimeSync:GetTimeStamp()
	if(self.GamePhase==0) then--开始阶段
		curGameStage = gameStage.Begin;
	elseif(self.GamePhase == 1) then --下注阶段
		countDownTime =BaccaratTableInfo.baccaratTableInfo.tableCountDownTime - ServerTime;
		curGameStage = gameStage.Bet;
	elseif(self.GamePhase == 5) then --结算阶段
		local endCountDown = BaccaratTableInfo.baccaratTableInfo.tableCountDownTime - ServerTime;
		if(BaccaratTableInfo.baccaratTableInfo.totalTime == endCountDown) then --需要展示发牌
			curGameStage = gameStage.Deal
		else -- 直接显示牌面后开始结算
			curGameStage = gameStage.Settlement;
		end
	end
	self:RefreshGameStage()
	self:RefreshPlayerInfo(data.baccaratTableInfo.tablePlayerInfoList);
end

---第一次进入游戏初始化区域下注信息
function BaccaratGameCtrl:InitTableAreaInfos(tableAreaInfos)
	for i, v in ipairs(tableAreaInfos) do
		
	end
end

---刷新前6的玩家显示
---@param playerInfoList 前6的玩家列表信息
function BaccaratGameCtrl:RefreshPlayerInfo(playerInfoList)
	for i, v in ipairs(BestSixPlayerObjs) do
		v:SetActive(#playerInfoList>=i);
	end
	
	for i, v in ipairs(playerInfoList) do
		---@type BaccaratPlayerItem
		local item = BaccaratPlayerItems[i];
		item:RefreshPlayerInfoShow(v);
	end
	
end

---同步游戏当前在哪个阶段
function BaccaratGameCtrl:RefreshGameStage()
	if curGameStage == gameStage.Begin then
		self:EnterBegin();
	elseif curGameStage == gameStage.Bet then
		self:EnterBetGame();
	elseif curGameStage == gameStage.Deal then
		self:EnterDeal();
	elseif curGameStage == gameStage.Settlement then
		self:EnterSettlement();
	end
end

---进入开始阶段(显示VS)
function BaccaratGameCtrl:EnterBegin()
	self.view.obj_Countdown:SetActive(false);
	self.view.obj_VS:SetActive(true);
	Tools.PlayerSpineAniByName(vsSpine,"action",false)
	self.VsSpineActionTimer:Start()
	
	
end
---进入下注阶段
function BaccaratGameCtrl:EnterBetGame()
	self.view.txt_Countdown.text = countDownTime;
	self.view.obj_BeginBet:SetActive(true);
	Tools.PlayerSpineAniByName(BeginBetSpine,"action",false)
	self.beginTimer:Start();

end

---设置按钮的显示状态
function BaccaratGameCtrl:SetBetButtonInteractable(state)
	self.view.btn_One.enabled = state;
	self.view.btn_Ten.enabled = state;
	self.view.btn_Fifty.enabled = state;
	self.view.btn_OneHundred.enabled = state;
	self.view.btn_FiveHundred.enabled = state;
	for _, v in pairs(BottomNoteChildImages) do
		if state then
			v.material = nil;
		else
			v.material = config.GetUIImageGray();
		end
	end
	--if state then
	--	self.view.btn_One.image.material = nil;
	--	self.view.btn_Ten.image.material = nil;
	--	self.view.btn_Fifty.image.material = nil;
	--	self.view.btn_OneHundred.image.material = nil;
	--	self.view.btn_FiveHundred.image.material = nil;
	--else
	--	self.view.btn_One.image.material = config.GetUIImageGray();
	--	self.view.btn_Ten.image.material = config.GetUIImageGray();
	--	self.view.btn_Fifty.image.material = config.GetUIImageGray();
	--	self.view.btn_OneHundred.image.material = config.GetUIImageGray();
	--	self.view.btn_FiveHundred.image.material = config.GetUIImageGray();
	--end
end

---进入发牌阶段
function BaccaratGameCtrl:EnterDeal()
	self.view.obj_StopBet:SetActive(true);
	Tools.PlayerSpineAniByName(StopBetSpine,"action",false)
	self:SetBetButtonInteractable(false);
	self.view.btn_Repeat.interactable = false;
	self.view.obj_Countdown:SetActive(false);
	if self.SettlementCor then
		coroutine.stop(self.SettlementCor)
		self.SettlementCor=nil
	end
	self.SettlementCor=	CorManager:StartCor(function()--翻牌
		--显示发牌区域
		self.view.obj_DealCardBg:SetActive(true);
		self.view.ator_DealCards:Play("dealAnim")
		coroutine.wait(1)
		self.view.obj_StopBet:SetActive(false);
		coroutine.wait(1)
		local playerCard1 = BaccaratTableInfo.baccaratSettlementInfo.playerCardIds[1];
		ComponentUtilGet.Image(self.view.ator_PlayerCard1.transform,"CardImage").sprite = config.GetCardPic("card_"..playerCard1);
		self.view.ator_PlayerCard1:Play("FlipCards");
		coroutine.wait(0.5)
		local playerCard2 = BaccaratTableInfo.baccaratSettlementInfo.playerCardIds[2];
		ComponentUtilGet.Image(self.view.ator_PlayerCard2.transform,"CardImage").sprite = config.GetCardPic("card_"..playerCard2);
		self.view.ator_PlayerCard2:Play("FlipCards");
		playerIsPairing =BaccaratTableInfo.baccaratSettlementInfo.cardState.cardTypeWinState == 2 or BaccaratTableInfo.baccaratSettlementInfo.cardState.cardTypeWinState == 3;
		local playerCardNum =BaccaratTableInfo.baccaratSettlementInfo.playerPointId;
		local playerIsKing =BaccaratTableInfo.baccaratSettlementInfo.extraPlayerCardId ==0 and (playerCardNum == 8 or playerCardNum == 9);
		self.view.obj_PlayerKing:SetActive(playerIsKing)
		if(playerIsKing) then
			tools.PlayerSpineAniByName(PlayerKingSpine,"action",false);
		end
		coroutine.wait(0.5)
		local BankerCard1 =  BaccaratTableInfo.baccaratSettlementInfo.bankerCardIds[1];
		ComponentUtilGet.Image(self.view.ator_BankerCard1.transform,"CardImage").sprite = config.GetCardPic("card_"..BankerCard1);
		self.view.ator_BankerCard1:Play("FlipCards");
		coroutine.wait(0.5)
		local BankerCard2 = BaccaratTableInfo.baccaratSettlementInfo.bankerCardIds[2];
		ComponentUtilGet.Image(self.view.ator_BankerCard2.transform,"CardImage").sprite = config.GetCardPic("card_"..BankerCard2);
		self.view.ator_BankerCard2:Play("FlipCards");
		BankerIsPairing =BaccaratTableInfo.baccaratSettlementInfo.cardState.cardTypeWinState == 1 or BaccaratTableInfo.baccaratSettlementInfo.cardState.cardTypeWinState == 3;
		BankerCard1 = self:GetCardPoint(BankerCard1);
		BankerCard2 = self:GetCardPoint(BankerCard2);
		local BankerCardNum = BaccaratTableInfo.baccaratSettlementInfo.bankerPointId;
		local BankerIsKing =BaccaratTableInfo.baccaratSettlementInfo.extraBankerCardId ==0 and (BankerCardNum == 8 or BankerCardNum == 9);
		self.view.obj_BankerKing:SetActive(BankerIsKing)
		if(BankerIsKing) then
			tools.PlayerSpineAniByName(BankerKingSpine,"action",false);
		end
		if(playerIsKing or BankerIsKing) then
			KingNumber=KingNumber+1;
		end
		
		if BaccaratTableInfo.baccaratSettlementInfo.extraBankerCardId ==0 and BaccaratTableInfo.baccaratSettlementInfo.extraPlayerCardId ==0 then
			--不用补牌直接比大小结算
			self:SettleAccounts(playerCardNum,BankerCardNum);
		else
			if(BaccaratTableInfo.baccaratSettlementInfo.extraPlayerCardId ~=0 ) then
				local playerCard3 = BaccaratTableInfo.baccaratSettlementInfo.extraPlayerCardId
				ComponentUtilGet.Image(self.view.ator_PlayerCard3.transform,"CardImage").sprite = config.GetCardPic("card_"..playerCard3);
				self.view.ator_DealCards:Play("Bufaxian");
				coroutine.wait(0.5)
				self.view.ator_PlayerCard3:Play("FlipCards")
			end
		  
			if BaccaratTableInfo.baccaratSettlementInfo.extraBankerCardId ~=0   then--庄家也补牌
				local BankerCard3 =  BaccaratTableInfo.baccaratSettlementInfo.extraBankerCardId
				ComponentUtilGet.Image(self.view.ator_BankerCard3.transform,"CardImage").sprite = config.GetCardPic("card_"..BankerCard3);
				self.view.ator_DealCards:Play("Bufazhuang");
				coroutine.wait(0.5)
				self.view.ator_BankerCard3:Play("FlipCards")
			end
			self:SettleAccounts(playerCardNum,BankerCardNum);
		end
	end)
end

---直接展示牌面后结算
function BaccaratGameCtrl:EnterSettlement()
	if self.SettlementCor then
		coroutine.stop(self.SettlementCor)
		self.SettlementCor=nil
	end
	self.SettlementCor=	CorManager:StartCor(function()
		local playerCard1 = BaccaratTableInfo.baccaratSettlementInfo.playerCardIds[1];
		ComponentUtilGet.Image(self.view.ator_PlayerCard1.transform,"CardImage").sprite = config.GetCardPic("card_"..playerCard1);
		local playerCard2 = BaccaratTableInfo.baccaratSettlementInfo.playerCardIds[2];
		ComponentUtilGet.Image(self.view.ator_PlayerCard2.transform,"CardImage").sprite = config.GetCardPic("card_"..playerCard2);
		local BankerCard1 =  BaccaratTableInfo.baccaratSettlementInfo.bankerCardIds[1];
		ComponentUtilGet.Image(self.view.ator_BankerCard1.transform,"CardImage").sprite = config.GetCardPic("card_"..BankerCard1);
		local BankerCard2 = BaccaratTableInfo.baccaratSettlementInfo.bankerCardIds[2];
		ComponentUtilGet.Image(self.view.ator_BankerCard2.transform,"CardImage").sprite = config.GetCardPic("card_"..BankerCard2);
	
		if BaccaratTableInfo.baccaratSettlementInfo.extraBankerCardId ==0 and BaccaratTableInfo.baccaratSettlementInfo.extraPlayerCardId ==0 then--不用补牌
			self.view.ator_DealCards:Play("dealAnim_idle");
		else
			if(BaccaratTableInfo.baccaratSettlementInfo.extraPlayerCardId ~=0 ) then
				local playerCard3 = BaccaratTableInfo.baccaratSettlementInfo.extraPlayerCardId
				ComponentUtilGet.Image(self.view.ator_PlayerCard3.transform,"CardImage").sprite = config.GetCardPic("card_"..playerCard3);
			end

			if BaccaratTableInfo.baccaratSettlementInfo.extraBankerCardId ~=0   then--庄家也补牌
				local BankerCard3 =  BaccaratTableInfo.baccaratSettlementInfo.extraBankerCardId
				ComponentUtilGet.Image(self.view.ator_BankerCard3.transform,"CardImage").sprite = config.GetCardPic("card_"..BankerCard3);
			end

			if(BaccaratTableInfo.baccaratSettlementInfo.extraBankerCardId ~=0 and BaccaratTableInfo.baccaratSettlementInfo.extraPlayerCardId ~=0) then
				self.view.ator_DealCards:Play("Bufaliangzhang_idle");
			elseif(BaccaratTableInfo.baccaratSettlementInfo.extraPlayerCardId ~=0 ) then
				self.view.ator_DealCards:Play("Bufaxian_idle");
			elseif(BaccaratTableInfo.baccaratSettlementInfo.extraBankerCardId ~=0 ) then
				self.view.ator_DealCards:Play("Bufazhuang_idle");
			end
		end
		
		local playerCardNum =  BaccaratTableInfo.baccaratSettlementInfo.playerPointId;
		local BankerCardNum =  BaccaratTableInfo.baccaratSettlementInfo.bankerPointId;
		self:PlayResult(playerCardNum,BankerCardNum)
	end)
end
---结算
function BaccaratGameCtrl:SettleAccounts(playerCardNum,BankerCardNum)
	coroutine.wait(0.5)
	self.view.txt_PlayerPoint.text = playerCardNum;
	self.view.obj_PlayerPoints:SetActive(true);
	coroutine.wait(0.5)
	self.view.txt_BankerPoint.text = BankerCardNum;
	self.view.obj_BankerPoints:SetActive(true);
	coroutine.wait(0.5)
	self:PlayResult(playerCardNum,BankerCardNum)
end

function BaccaratGameCtrl:PlayResult(playerCardNum,BankerCardNum)
	self.view.obj_HeWin:SetActive(playerCardNum == BankerCardNum);
	self.view.obj_ZWin:SetActive(BankerCardNum>playerCardNum);
	self.view.obj_XWin:SetActive(playerCardNum>BankerCardNum);
	if(playerCardNum == BankerCardNum) then
		Tools.PlayerSpineAniByName(ResultTieSpine,"action",false)
	elseif(BankerCardNum>playerCardNum) then
		Tools.PlayerSpineAniByName(ResultBankerSpine,"action",false)
	elseif(playerCardNum>BankerCardNum) then
		Tools.PlayerSpineAniByName(ResultPlayerSpine,"action",false)
	end
	self:Flicker(playerCardNum,BankerCardNum);
	coroutine.wait(3);
	for _, v in ipairs(ChipTable)  do
		self:PlayChipToPlayer(v)
	end
	BetRecord = CurBet;
	coroutine.wait(2);
	self:InitUIShow()
	RoundNumber = RoundNumber+1;
	self:RefreshUIDataShow()
	self.BaccaratRoadScripts:RefreshData(BaccaratTableInfo.baccaratSettlementInfo.cardState,true)
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

---刷新菜单显示隐藏
function BaccaratGameCtrl:RefreshMenuShow()
	if self.view.btn_touch.gameObject.activeSelf then
		self.view.obj_Menu.transform:DOLocalMoveY(483,0.5):SetEase(Ease.InBack)
		self.view.btn_touch.gameObject:SetActive(false)
	else
		self.view.obj_Menu.transform:DOLocalMoveY(0,0.5):SetEase(Ease.OutBack)
		self.view.btn_touch.gameObject:SetActive(true)
	end

end

function BaccaratGameCtrl:Close()
    self.super.Close(self);
end

---添加UI事件
function BaccaratGameCtrl:AddUIEvent()
	self.uiEventListener:AddClick(self.view.btn_Menu,function()
		self:RefreshMenuShow()
	end)
	
	self.uiEventListener:AddClick(self.view.btn_touch,function()
		self:RefreshMenuShow()
	end)
	self.uiEventListener:AddClick(self.view.btn_help,function()
		CtrlManager.SingleShow(CtrlNames.BaccaratRule)
	end)
    self.uiEventListener:AddClick(self.view.btn_close,function()
		self:Close();
	end)

	for i = 1, self.view.trans_BetBtns.childCount do
		local btn = ComponentUtilGet.Button(self.view.trans_BetBtns:GetChild(i))
		self.uiEventListener:AddClick(btn,function()
			if CurSelectChip == nil  or curGameStage~=gameStage.Bet then
				return;
			end
			--请求下注
			local bet = {}
			bet.betValue = CurSelectChip.num;
			bet.betAreaIdx = i;
			self.model:ReqBet(bet);
		end)
	end
	
	self.uiEventListener:AddClick(self.view.btn_Repeat,function()
		--点击续押
		self.view.btn_Repeat.interactable = false;
		self.model:ReqBet(BetRecord);
	end)
end
---选中哪个筹码
function BaccaratGameCtrl:SetCheckedShow(BaccaratChipItem)
	CurSelectChip = BaccaratChipItem;
	for _, v in pairs(ChipItems) do
		---@type BaccaratChipItems
		local item = v;
		item:RefreshChecked(CurSelectChip.index)
	end
end

function BaccaratGameCtrl:PlayerBet(data)
	if(PlayerInfo.GetPlayerId() == data.playerId) then--自己下注
		self.view.tmp_SelfGoldNumber.text = data.playerCurGold;
	else
		for _, v in pairs(BaccaratPlayerItems) do
			---@type BaccaratPlayerItem
            local item = v;
			if(item:GetPlayerId() == data.playerId) then
				item:ChangeGoldNum(data.playerCurGold)
			end
		end
	end

	for _, v in pairs(data.betTableInfoList) do
		if(PlayerInfo.GetPlayerId() == data.playerId) then--自己下注
			local bet = {}
			bet.betValue = v.betValue;
			bet.betAreaIdx = v.betIdx;
			table.insert(CurBet,bet);
		end
		self:PlayChip(data,data.playerId);
	end
end

---筹码飞行到指定区域
---@param data 服务器发过来的数据结构
function BaccaratGameCtrl:PlayChip(data,playerId)
	local isSelf = playerId ==PlayerInfo.GetPlayerId();
    local targetRect;
	if(data.betIdx == config.BetState.Banker) then -- 下注的庄家
		targetRect = self.view.obj_BetBankerRegion.transform:GetComponent("RectTransform");
		self.view.tmp_BankerBetNum.text = data.betIdxTotal;
		if(isSelf) then
			SelfBetBankerAllNum = SelfBetBankerAllNum+data.betValue;
		end
		
	elseif data.betIdx  == config.BetState.Player then -- 下注的闲家
        targetRect = self.view.obj_BetPlayerRegion.transform:GetComponent("RectTransform")
		self.view.tmp_PlayerBetNum.text = data.betIdxTotal;
		if(isSelf) then
			SelfBetPlayerAllNum = SelfBetPlayerAllNum+data.betValue;
		end
	elseif data.betIdx  == config.BetState.Tie then -- 下注的和
		targetRect = self.view.obj_BetTieRegion.transform:GetComponent("RectTransform")
		self.view.tmp_TieBetNum.text = data.betIdxTotal;
		if(isSelf) then
			SelfBetTieAllNum = SelfBetTieAllNum+data.betValue;
		end
	elseif data.betIdx  == config.BetState.BPair then -- 下注的庄对
		targetRect = self.view.obj_BetBPairRegion.transform:GetComponent("RectTransform")
		self.view.tmp_BPairBetNum.text =  data.betIdxTotal;
		if(isSelf) then
			SelfBetBPairAllNum = SelfBetBPairAllNum+data.betValue;
		end
	elseif 	data.betIdx  == config.BetState.PPair then -- 下注的闲对
		targetRect = self.view.obj_BetPPairRegion.transform:GetComponent("RectTransform")
		self.view.tmp_PPairBetNum.text =  data.betIdxTotal;
		if(isSelf) then
			SelfBetPPairAllNum = SelfBetPPairAllNum+data.betValue;
		end
	end
	self:RefreshSelfBetNumShow();
	local chipIndex = 0;
	for _, v in pairs(ChipItems) do
		---@type BaccaratChipItems
		local item = v;
		if(item:IsSelf(data.betIdxTotal)) then
			chipIndex = item.index;
		end
	end
	
	local chip = self.objPools:SpawnPrefab(nil,config.ABNames.chipPool,"BaccaratChip_"..chipIndex)
	chip:SetActive(true)
	ComponentUtilGet.Text(chip.transform,"Icon/Number").text = data.betIdxTotal;
	chip.transform:SetParent(targetRect.transform,false)
	chip.transform.localScale =  Vector3.one*0.6
	if(isSelf) then
		chip.transform.position = self.view.obj_Player.transform.position;
	else
		local player;
		for _, v in pairs(BaccaratPlayerItems) do
			---@type BaccaratPlayerItem
			local item = v;
			if(item:GetPlayerId() == playerId) then
				player = item.gameObject;
			end
		end
		chip.transform.position = player.transform.position;
	end
	
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
	self.objPools:DestroyAll();
	self.BaccaratRoadScripts:Destroy()
	BestSixPlayerObjs = {}
	BaccaratPlayerItems = {}
	ChipItems = {}
end

return BaccaratGameCtrl