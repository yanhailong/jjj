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
---自己庄对区域总共下注了多少筹码
local SelfBetBPairAllNum;
---自己闲对区域总共下注了多少筹码
local SelfBetPPairAllNum;
------筹码下注的集合表
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
local RoundNumber=0;
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
---下注的筹码面板集合
local betInfoList={};
---服务器发过来的房间桌面的数据
local BaccaratTableInfo;
---服务器发过来的场上结算信息
local BaccaratSettlementInfo;
---结算时玩家赢的金币值
local PlayerChangedGolds;
---前6名玩家预支体集合
local BestSixPlayerObjs={}
---玩家预支脚本集合
local BaccaratPlayerItems={}
---筹码的集合
local ChipItems = {};
---筹码最大显示数量
local ChipMaxNum = 50;

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
	self.view.obj_Countdown:SetActive(false);
	self:InitUIShow()
	---@type BaccaratPlayerItem
	for i = 1,self.view.obj_PlayerRoot.transform.childCount do
		BestSixPlayerObjs[i] = self.view.obj_PlayerRoot.transform:GetChild(i-1).gameObject;
		BaccaratPlayerItems[i]=BaccaratPlayerItem.New(BestSixPlayerObjs[i],self)
		BestSixPlayerObjs[i]:SetActive(false);
	end
	self.view.tmp_SelfName.text = PlayerManager:GetPlayerInfo().playerName;
	self:RefreshSelfGoldNumShow();
	self.ChipContentRect = ComponentUtilGet.RectTransform(self.view.obj_ChipContent.transform);
	self.ChipContentRect.anchoredPosition.x = 0
	self:RefreshChipLeftRightBtnShow(false)

	vsSpine = ComponentUtilGet.SkeletonGraphic(self.view.obj_VS.transform,"SkeletonGraphic");
	BeginBetSpine = ComponentUtilGet.SkeletonGraphic(self.view.obj_BeginBet.transform,"SkeletonGraphic");
	StopBetSpine = ComponentUtilGet.SkeletonGraphic(self.view.obj_StopBet.transform,"SkeletonGraphic");
	ResultTieSpine = ComponentUtilGet.SkeletonGraphic(self.view.obj_HeWin.transform,"SkeletonGraphic");
	ResultBankerSpine = ComponentUtilGet.SkeletonGraphic(self.view.obj_ZWin.transform,"SkeletonGraphic");
	ResultPlayerSpine = ComponentUtilGet.SkeletonGraphic(self.view.obj_XWin.transform,"SkeletonGraphic");
	PlayerKingSpine = ComponentUtilGet.SkeletonGraphic(self.view.obj_PlayerKing.transform,"SkeletonGraphic");
	BankerKingSpine = ComponentUtilGet.SkeletonGraphic(self.view.obj_BankerKing.transform,"SkeletonGraphic");
	AlarmClockSpine = ComponentUtilGet.SkeletonGraphic(self.view.obj_Countdown.transform);
	---@type BaccaratRoad
	self.BaccaratRoadScripts =BaccaratRoad.New()
	self.BaccaratRoadScripts:Init(self.view.obj_ZhuPanContent,self.view.obj_DaLuContent,
			self.view.obj_DaluZiluContent,self.view.obj_XiaoLuContent,self.view.obj_YueYouLuContent);

	self.betCountDownTimer = TimerManager.CreateTimer(self,function()
		countDownTime = countDownTime-1;
		self.view.txt_Countdown.text = countDownTime;
		if(countDownTime == 3) then
			Tools.PlayerSpineAniByName(AlarmClockSpine,"action",true)
		end
		if(countDownTime<=0) then
			self.betCountDownTimer:Stop()
		end
	end,1,-1,true);
end

---初始化要显示的数据（接入服务器数据要，要赋值服务器那边的数据显示）
function BaccaratGameCtrl:InitDataShow(data)
	BankerWinNumber=0;
	PlayerWinNumber=0;
	TieWinNumber=0;
	PPairWinNumber=0;
	BPairWinNumber=0;
	KingNumber=0;
	RoundNumber=#data;
	for _, v in ipairs(data) do
		if(v.winState==  config.WhoWin.BankerWin) then
			BankerWinNumber = BankerWinNumber+1
		elseif(v.winState==config.WhoWin.PlayerWin) then
			PlayerWinNumber = PlayerWinNumber+1
		elseif(v.winState==config.WhoWin.TieWin) then
			TieWinNumber = TieWinNumber+1
		end

		if(v.cardTypeWinState == 1) then--庄对
			BPairWinNumber = BPairWinNumber+1
		elseif(v.cardTypeWinState == 2) then -- 闲对
			PPairWinNumber = PPairWinNumber+1;
		elseif (v.cardTypeWinState == 3) then
			BPairWinNumber = BPairWinNumber+1
			PPairWinNumber = PPairWinNumber+1;
		end

		if(v.hasKingCard) then
			KingNumber = KingNumber + 1;
		end
	end


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

	self.view.obj_WaitEndGame:SetActive(false);
	
	self.view.obj_PlayerKing:SetActive(false);
	self.view.obj_PlayerPoints:SetActive(false);
	self.view.obj_BankerKing:SetActive(false);
	self.view.obj_BankerPoints:SetActive(false);
	self.view.obj_DealCardBg:SetActive(false);
	
	self.view.ator_DealCards:Play("New State")
	self.view.ator_BankerCard1:Play("InitAnimator")
	self.view.ator_BankerCard2:Play("InitAnimator")
	self.view.ator_BankerCard3:Play("InitAnimator")
	self.view.ator_PlayerCard1:Play("InitAnimator")
	self.view.ator_PlayerCard2:Play("InitAnimator")
	self.view.ator_PlayerCard3:Play("InitAnimator")

	self.view.tmp_BankerBetNum.text = "0.00";
	self.view.tmp_PlayerBetNum.text = "0.00";
	self.view.tmp_PPairBetNum.text = "0.00";
	self.view.tmp_TieBetNum.text = "0.00";
	self.view.tmp_BPairBetNum.text = "0.00";
	self.view.btn_Repeat.enabled = #BetRecord>0;
	if(#BetRecord>0) then
		self.view.btn_Repeat.image.material = nil;
	else
		self.view.btn_Repeat.image.material = config.GetUIImageGray();
	end
end

---刷新自己下注的筹码数量是否显示
function BaccaratGameCtrl:RefreshSelfBetNumShow()
	self.view.obj_SelfBetBanker:SetActive(SelfBetBankerAllNum~=0);
	self.view.obj_SelfBetPlayer:SetActive(SelfBetPlayerAllNum~=0);
	self.view.obj_SelfBetTie:SetActive(SelfBetTieAllNum~=0);
	self.view.obj_SelfBetBPair:SetActive(SelfBetBPairAllNum~=0);
	self.view.obj_SelfBetPPair:SetActive(SelfBetPPairAllNum~=0);
	self.view.tmp_SelfBetBankerNum.text = SelfBetBankerAllNum
	self.view.tmp_SelfBetBPairNum.text = SelfBetBPairAllNum;
	self.view.tmp_SelfBetPlayerNum.text = SelfBetPlayerAllNum;
	self.view.tmp_SelfBetPPairNum.text = SelfBetPPairAllNum;
	self.view.tmp_SelfBetTieNum.text = SelfBetTieAllNum;
	
end
---刷新自己的金币数量显示
function BaccaratGameCtrl:RefreshSelfGoldNumShow()
	self.view.tmp_SelfGoldNumber.text = PlayerManager:GetPlayerInfo().goldNum
end

---首次进入游戏刷新显示
function BaccaratGameCtrl:FirstEntryGame(data)
	self.GamePhase = data.gamePhase;--游戏阶段信息
	self.BaccaratRoadScripts:InitData(data,self.GamePhase.gamePhase == "GAME_ROUND_OVER_SETTLEMENT");
	self:InitDataShow(data.cardStateList)
	betInfoList = data.betInfoList;
	BaccaratTableInfo = data.baccaratTableInfo;
	BaccaratSettlementInfo	 = data.baccaratSettlementInfo;
	PlayerChangedGolds = data.playerChangedGolds;
	--初始化筹码
	for i = 1, #betInfoList do
		local item =self.objPools:Spawn(nil,self.view.obj_chipItem,self.view.obj_ChipContent.transform)
		item:SetActive(true);
		---@type BaccaratChipItems
		local chipItem = BaccaratChipItems.New(item,self);
		chipItem:InitUIShow(i,betInfoList[i]);
		table.insert(ChipItems,chipItem);
	end
	--BottomNoteChildImages = self.view.obj_ChipContent.transform:GetComponentsInChildren(UnityEngine.UI.Image,true)
	self:SetBetButtonInteractable(false);
	self:RefreshDataShow();
	self:InitTableAreaInfos();
	self.view.tmp_AllOtherNumber.text = data.playerTotalNum
end
---推送百家乐通知新的一局开始
function BaccaratGameCtrl:NotifyBaccaratRoundStart(data)
	if self.SettlementCor then
		coroutine.stop(self.SettlementCor)
		self.SettlementCor=nil
	end
	
	if(#ChipTable>0)then
		for _, value in pairs(ChipTable) do
			self.objPools:UnSpawnPrefab(value.chip)
		end
		ChipTable = {}
	end
	
	BetRecord = CurBet;
	RoundNumber = RoundNumber+1;
	self:RefreshUIDataShow()
	self.BaccaratRoadScripts:RefreshData(BaccaratSettlementInfo.cardState,true,false)
	self:InitUIShow()
	
	BaccaratTableInfo = data.baccaratTableInfo
	self.GamePhase="START_GAME";
	curGameStage = gameStage.Begin;
	self:RefreshGameStage()
	self:RefreshPlayerInfo(BaccaratTableInfo.tablePlayerInfoList);
end
---推送百家乐结算信息
function BaccaratGameCtrl:NotifyBaccaratSettlementInfo(data)
	BaccaratSettlementInfo = data.baccaratSettlementInfo
	BaccaratTableInfo = data.baccaratTableInfo
	PlayerChangedGolds = data.playerChangedGolds;
	curGameStage =gameStage.Deal;
	self:RefreshGameStage();
end
---通知押注类房间玩家信息变化
function BaccaratGameCtrl:NotifyTableRoomPlayerInfoChange(data)
	BaccaratTableInfo = data.tableChangedPlayerInfos;
	self:RefreshPlayerInfo(BaccaratTableInfo.tablePlayerInfoList);
	self.view.tmp_AllOtherNumber.text = data.totalPlayerNum
end

---服务器数据返回刷新阶段显示
function BaccaratGameCtrl:RefreshDataShow()
	if(self.GamePhase=="START_GAME") then--开始阶段
		curGameStage = gameStage.Begin;
	elseif(self.GamePhase == "BET") then --下注阶段
		curGameStage = gameStage.Bet;
	elseif(self.GamePhase == "GAME_ROUND_OVER_SETTLEMENT") then --结算阶段
		local ServerTime = ServerTimeSync:GetTimeStamp()
		local endCountDown = (BaccaratTableInfo.tableCountDownTime - ServerTime)/1000;
		if(BaccaratTableInfo.totalTime == endCountDown) then --需要展示发牌
			curGameStage = gameStage.Deal
		elseif(endCountDown <=4) then --显示等待结束
			self.view.obj_WaitEndGame:SetActive(true);
			local downTime = math.floor(endCountDown);
			self.view.txt_WaitCountDown.text =downTime;
			self.WaitCountDownTimer = TimerManager.StartTimer(self,function()
				downTime = downTime-1;
				self.view.txt_WaitCountDown.text =downTime;
				if(downTime<=0) then
					self.view.obj_WaitEndGame:SetActive(false);
					self.WaitCountDownTimer:Stop()
				end
			end,1,-1,true);
		else -- 直接显示牌面后开始结算
			curGameStage = gameStage.Settlement;
		end
	end
	self:RefreshGameStage()
	self:RefreshPlayerInfo(BaccaratTableInfo.tablePlayerInfoList);
	
end

---第一次进入游戏初始化区域下注信息
function BaccaratGameCtrl:InitTableAreaInfos()
	local targetRect;
	--下注区域，1: 庄对 2: 和 3: 闲对 4: 闲 5: 庄
	for _, v in ipairs(BaccaratTableInfo.tableAreaInfos) do
		if(v.betIdx==config.BetState.BPair) then --庄对
			targetRect = self.view.obj_BetBPairRegion.transform:GetComponent("RectTransform")
			self.view.tmp_BPairBetNum.text =  v.betIdxTotal;
			SelfBetBPairAllNum =v.playerBetTotal;
		elseif(v.betIdx==config.BetState.Tie) then --和
			targetRect = self.view.obj_BetTieRegion.transform:GetComponent("RectTransform")
			self.view.tmp_TieBetNum.text = v.betIdxTotal;
			SelfBetTieAllNum =v.playerBetTotal;
		elseif(v.betIdx==config.BetState.PPair) then --闲对
			targetRect = self.view.obj_BetPPairRegion.transform:GetComponent("RectTransform")
			self.view.tmp_PPairBetNum.text =  v.betIdxTotal;
			SelfBetPPairAllNum =v.playerBetTotal;
		elseif(v.betIdx==config.BetState.Player) then --闲
			targetRect = self.view.obj_BetPlayerRegion.transform:GetComponent("RectTransform")
			self.view.tmp_PlayerBetNum.text = v.betIdxTotal;
			SelfBetPlayerAllNum =v.playerBetTotal;
		elseif(v.betIdx==config.BetState.Banker) then --庄
			targetRect = self.view.obj_BetBankerRegion.transform:GetComponent("RectTransform");
			self.view.tmp_BankerBetNum.text = v.betIdxTotal;
			SelfBetBankerAllNum =v.playerBetTotal;
		end
		for _, k in ipairs(v.betGoldList) do
			local chipIndex = 0;
			for _, j in pairs(ChipItems) do
				---@type BaccaratChipItems
				local item = j;
				if(item:IsSelf(k)) then
					chipIndex = item.index;
					break
				end
			end
			self:DirectGenerationChip(chipIndex,targetRect,k)
		end
	end
	self:RefreshSelfBetNumShow();
end
---直接生成筹码到对应区域
function BaccaratGameCtrl:DirectGenerationChip(chipIndex,targetRect,betIdxTotal)
	if(#ChipTable>=ChipMaxNum) then -- 超过配置显示的数量后就不显示了
		return
	end
	local chip = self.objPools:SpawnPrefab(nil,config.ABNames.chipPool,"BaccaratChip_"..chipIndex,targetRect.transform)
	chip:SetActive(true)
	ComponentUtilGet.Text(chip.transform,"Icon/Number").text = betIdxTotal;
	chip.transform.localScale =  Vector3.one*0.5
	local corners = CS.System.Array.CreateInstance(typeof(Vector3),4)
	targetRect:GetWorldCorners(corners)
	--目标位置
	local endPos= Vector3(UnityEngine.Random.Range(corners[0].x,corners[2].x), UnityEngine.Random.Range(corners[0].y,corners[2].y), 0)
	chip.transform.position = endPos;
	local chipNumTable = {}
	chipNumTable.betIdxTotal = betIdxTotal;
	chipNumTable.chip = chip;
	table.insert(ChipTable,chipNumTable);
end

---刷新前6的玩家显示
---@param playerInfoList 前6的玩家列表信息
function BaccaratGameCtrl:RefreshPlayerInfo(playerInfoList)
	local keysToRemove=0;
	for i, v in ipairs(playerInfoList) do
		if(v.playerId == PlayerManager:GetPlayerInfo().playerId) then--删除自己
			keysToRemove = i;
		end
	end
	
	if(keysToRemove~=0) then
		table.remove(playerInfoList,keysToRemove);
	end
	
	for i, v in ipairs(BestSixPlayerObjs) do
		v:SetActive(#playerInfoList>=i);
	end
	for i, v in ipairs(playerInfoList) do
		if(i>=7) then
			break;
		end
		---@type BaccaratPlayerItem
		local item = BaccaratPlayerItems[i];
		item:RefreshPlayerInfoShow(v);
	end
end

---同步游戏当前在哪个阶段
function BaccaratGameCtrl:RefreshGameStage()
	if self.GameStageCor then
		coroutine.stop(self.GameStageCor)
		self.GameStageCor=nil
	end
	self.GameStageCor=	CorManager:StartCor(function()
		if curGameStage == gameStage.Begin then
			self:EnterBegin();
		elseif curGameStage == gameStage.Bet then
			self:EnterBetGame();
		elseif curGameStage == gameStage.Deal then
			self:EnterDeal();
		elseif curGameStage == gameStage.Settlement then
			self:EnterSettlement();
		end
	end)
end

---进入开始阶段(显示VS)
function BaccaratGameCtrl:EnterBegin()
	self.view.obj_Countdown:SetActive(false);
	self.view.obj_VS:SetActive(true);
	Tools.PlayerSpineAniByName(vsSpine,"action",false)
	SoundManager:PlayClip(config.ABNames.audios.."bet_ready")
	coroutine.wait(1)
	Tools.PlayerSpineAniByName(vsSpine,"end",false)
	coroutine.wait(0.5)
	self.view.obj_VS:SetActive(false);
	curGameStage = gameStage.Bet;
	self:RefreshGameStage();
end
---进入下注阶段
function BaccaratGameCtrl:EnterBetGame()
	self.view.obj_BeginBet:SetActive(true);
	Tools.PlayerSpineAniByName(BeginBetSpine,"action",false)
	SoundManager:PlayClip(config.ABNames.audios.."startXiaZhu")
	coroutine.wait(1)
	local ServerTime = ServerTimeSync:GetTimeStamp()
	countDownTime =math.floor((BaccaratTableInfo.tableCountDownTime - ServerTime)/1000);
	self.view.txt_Countdown.text = countDownTime;
	self.view.obj_Countdown:SetActive(true);
	self.view.obj_BeginBet:SetActive(false);
	Tools.PlayerSpineAniByName(AlarmClockSpine,"idle",true)
	self:SetBetButtonInteractable(true);
	self.betCountDownTimer:Start();
end

---设置按钮的显示状态
function BaccaratGameCtrl:SetBetButtonInteractable(state)
	for _, v in pairs(ChipItems) do
		---@type BaccaratChipItems
		local item = v;
		item.btn.enabled = state;
		if state then
			item.icon.material = nil;
		else
			item.icon.material = config.GetUIImageGray();
		end
	end
end

---进入发牌阶段
function BaccaratGameCtrl:EnterDeal()
	self.view.obj_StopBet:SetActive(true);
	SoundManager:PlayClip(config.ABNames.audios.."endXiaZhu")
	Tools.PlayerSpineAniByName(StopBetSpine,"action",false)
	self:SetBetButtonInteractable(false);
	self.view.btn_Repeat.enabled =false;
	self.view.btn_Repeat.image.material = config.GetUIImageGray();
	self.betCountDownTimer:Stop();
	self.view.obj_Countdown:SetActive(false);
	if self.SettlementCor then
		coroutine.stop(self.SettlementCor)
		self.SettlementCor=nil
	end
	self.SettlementCor=	CorManager:StartCor(function()--翻牌
		--显示发牌区域
		self.view.obj_DealCardBg:SetActive(true);
		self.view.ator_DealCards:Play("dealAnim")
		local playerCardNum =BaccaratSettlementInfo.playerPointId;
		local BankerCardNum = BaccaratSettlementInfo.bankerPointId;
		coroutine.wait(0.75)
		self.view.obj_StopBet:SetActive(false);
		local playerCard1 = BaccaratSettlementInfo.playerCardIds[1];
		local playerIsKing =BaccaratSettlementInfo.extraPlayerCardId ==0 and (playerCardNum == 8 or playerCardNum == 9);
		local BankerIsKing =BaccaratSettlementInfo.extraBankerCardId ==0 and (BankerCardNum == 8 or BankerCardNum == 9);
		ComponentUtilGet.Image(self.view.ator_PlayerCard1.transform,"CardImage").sprite = config.GetCardPic("card_"..playerCard1);
		self.view.ator_PlayerCard1:Play("FlipCards");
		SoundManager:PlayClip(config.ABNames.audios.."faPai")
		self.view.obj_PlayerKing:SetActive(playerIsKing)
		if(playerIsKing) then
			Tools.PlayerSpineAniByName(PlayerKingSpine,"action",false);
			if(playerCardNum == 8) then
				SoundManager:PlayClip(config.ABNames.audios.."player_8")
			elseif(playerCardNum == 9) then
				SoundManager:PlayClip(config.ABNames.audios.."player_9")
			end
			coroutine.wait(0.5)
		end
		coroutine.wait(0.5)
		local playerCard2 = BaccaratSettlementInfo.playerCardIds[2];
		ComponentUtilGet.Image(self.view.ator_PlayerCard2.transform,"CardImage").sprite = config.GetCardPic("card_"..playerCard2);
		self.view.ator_PlayerCard2:Play("FlipCards");
		SoundManager:PlayClip(config.ABNames.audios.."faPai")
		playerIsPairing =BaccaratSettlementInfo.cardState.cardTypeWinState == 2 or BaccaratSettlementInfo.cardState.cardTypeWinState == 3;
		if(playerIsKing) then
			self.view.txt_PlayerPoint.text = playerCardNum;
			self.view.obj_PlayerPoints:SetActive(true);
		end
		coroutine.wait(0.5)
		local BankerCard1 =  BaccaratSettlementInfo.bankerCardIds[1];
		ComponentUtilGet.Image(self.view.ator_BankerCard1.transform,"CardImage").sprite = config.GetCardPic("card_"..BankerCard1);
		self.view.ator_BankerCard1:Play("FlipCards");
		SoundManager:PlayClip(config.ABNames.audios.."faPai")
		if(BankerIsKing) then
			self.view.obj_BankerKing:SetActive(BankerIsKing)
			Tools.PlayerSpineAniByName(BankerKingSpine,"action",false);
			if(BankerCardNum == 8) then
				SoundManager:PlayClip(config.ABNames.audios.."banker_8")
			elseif(BankerCardNum == 9) then
				SoundManager:PlayClip(config.ABNames.audios.."banker_9")
			end
			coroutine.wait(0.5)
		end
		coroutine.wait(0.5)
		local BankerCard2 = BaccaratSettlementInfo.bankerCardIds[2];
		ComponentUtilGet.Image(self.view.ator_BankerCard2.transform,"CardImage").sprite = config.GetCardPic("card_"..BankerCard2);
		self.view.ator_BankerCard2:Play("FlipCards");
		SoundManager:PlayClip(config.ABNames.audios.."faPai")
		BankerIsPairing =BaccaratSettlementInfo.cardState.cardTypeWinState == 1 or BaccaratSettlementInfo.cardState.cardTypeWinState == 3;
		if(BankerIsKing) then
			self.view.txt_BankerPoint.text = BankerCardNum;
			self.view.obj_BankerPoints:SetActive(true);
		end
		if(BankerIsKing and not playerIsKing) then
			coroutine.wait(0.5)
			self.view.txt_PlayerPoint.text = playerCardNum;
			self.view.obj_PlayerPoints:SetActive(true);
			SoundManager:PlayClip(config.ABNames.audios.."player")
			coroutine.wait(0.5)
			SoundManager:PlayClip(config.ABNames.audios.."point_"..playerCardNum)
		end
		if(playerIsKing) then
			coroutine.wait(0.5)
			self.view.txt_BankerPoint.text = BankerCardNum;
			self.view.obj_BankerPoints:SetActive(true);
			SoundManager:PlayClip(config.ABNames.audios.."banker")
			coroutine.wait(0.5)
			SoundManager:PlayClip(config.ABNames.audios.."point_"..BankerCardNum)
		end
		if(playerIsKing or BankerIsKing) then
			KingNumber=KingNumber+1;
		end
		coroutine.wait(0.5)
		if BaccaratSettlementInfo.extraBankerCardId ==0 and BaccaratSettlementInfo.extraPlayerCardId ==0 then
			--不用补牌直接比大小结算
			self:PlayResult(playerCardNum,BankerCardNum)
		else

			if(BaccaratSettlementInfo.extraPlayerCardId ~=0  and BaccaratSettlementInfo.extraBankerCardId ~=0 ) then
				local playerCard3 = BaccaratSettlementInfo.extraPlayerCardId
				ComponentUtilGet.Image(self.view.ator_PlayerCard3.transform,"CardImage").sprite = config.GetCardPic("card_"..playerCard3);
				local BankerCard3 =  BaccaratSettlementInfo.extraBankerCardId
				ComponentUtilGet.Image(self.view.ator_BankerCard3.transform,"CardImage").sprite = config.GetCardPic("card_"..BankerCard3);
				self.view.ator_DealCards:Play("BufaZhuangxian");
				SoundManager:PlayClip(config.ABNames.audios.."player_add")
				coroutine.wait(1)
				SoundManager:PlayClip(config.ABNames.audios.."banker_add")
				SoundManager:PlayClip(config.ABNames.audios.."faPai")
				self.view.ator_PlayerCard3:Play("FlipCards")
				coroutine.wait(1)
				SoundManager:PlayClip(config.ABNames.audios.."faPai")
				self.view.ator_BankerCard3:Play("FlipCards")
			else
				if(BaccaratSettlementInfo.extraPlayerCardId ~=0 ) then
					local playerCard3 = BaccaratSettlementInfo.extraPlayerCardId
					ComponentUtilGet.Image(self.view.ator_PlayerCard3.transform,"CardImage").sprite = config.GetCardPic("card_"..playerCard3);
					self.view.ator_DealCards:Play("Bufaxian");
					SoundManager:PlayClip(config.ABNames.audios.."player_add")
					coroutine.wait(1)
					SoundManager:PlayClip(config.ABNames.audios.."faPai")
					self.view.ator_PlayerCard3:Play("FlipCards")
					coroutine.wait(0.5)
				end
				if BaccaratSettlementInfo.extraBankerCardId ~=0   then--庄家也补牌
					local BankerCard3 =  BaccaratSettlementInfo.extraBankerCardId
					ComponentUtilGet.Image(self.view.ator_BankerCard3.transform,"CardImage").sprite = config.GetCardPic("card_"..BankerCard3);
					self.view.ator_DealCards:Play("Bufazhuang");
					SoundManager:PlayClip(config.ABNames.audios.."banker_add")
					coroutine.wait(1)
					SoundManager:PlayClip(config.ABNames.audios.."faPai")
					self.view.ator_BankerCard3:Play("FlipCards")
					coroutine.wait(0.5)
				end
			end
			self:PlayResult(playerCardNum,BankerCardNum)
		end
	end)
end

---直接展示牌面后结算
function BaccaratGameCtrl:EnterSettlement()
	logError("直接展示牌面后结算");
	if self.SettlementCor then
		coroutine.stop(self.SettlementCor)
		self.SettlementCor=nil
	end
	self.SettlementCor=CorManager:StartCor(function()
		self.view.obj_DealCardBg:SetActive(true);
		--self.view.ator_DealCards:Play("dealAnim")
		local playerCard1 = BaccaratSettlementInfo.playerCardIds[1];
		ComponentUtilGet.Image(self.view.ator_PlayerCard1.transform,"CardImage").sprite = config.GetCardPic("card_"..playerCard1);
		local playerCard2 = BaccaratSettlementInfo.playerCardIds[2];
		ComponentUtilGet.Image(self.view.ator_PlayerCard2.transform,"CardImage").sprite = config.GetCardPic("card_"..playerCard2);
		local BankerCard1 =  BaccaratSettlementInfo.bankerCardIds[1];
		ComponentUtilGet.Image(self.view.ator_BankerCard1.transform,"CardImage").sprite = config.GetCardPic("card_"..BankerCard1);
		local BankerCard2 = BaccaratSettlementInfo.bankerCardIds[2];
		ComponentUtilGet.Image(self.view.ator_BankerCard2.transform,"CardImage").sprite = config.GetCardPic("card_"..BankerCard2);
		self.view.ator_PlayerCard1:Play("FlipCards",0,1)
		self.view.ator_BankerCard1:Play("FlipCards",0,1)
		self.view.ator_PlayerCard2:Play("FlipCards",0,1)
		self.view.ator_BankerCard2:Play("FlipCards",0,1)
		if BaccaratSettlementInfo.extraBankerCardId ==0 and BaccaratSettlementInfo.extraPlayerCardId ==0 then--不用补牌
			self.view.ator_DealCards:Play("dealAnim_idle",0,1);
		else
			if(BaccaratSettlementInfo.extraPlayerCardId ~=0 ) then
				local playerCard3 = BaccaratSettlementInfo.extraPlayerCardId
				ComponentUtilGet.Image(self.view.ator_PlayerCard3.transform,"CardImage").sprite = config.GetCardPic("card_"..playerCard3);
			end

			if BaccaratSettlementInfo.extraBankerCardId ~=0   then--庄家也补牌
				local BankerCard3 =  BaccaratSettlementInfo.extraBankerCardId
				ComponentUtilGet.Image(self.view.ator_BankerCard3.transform,"CardImage").sprite = config.GetCardPic("card_"..BankerCard3);
			end

			if(BaccaratSettlementInfo.extraBankerCardId ~=0 and BaccaratSettlementInfo.extraPlayerCardId ~=0) then
				self.view.ator_PlayerCard3:Play("FlipCards",0,1)
				self.view.ator_BankerCard3:Play("FlipCards",0,1)
				self.view.ator_DealCards:Play("BufaZhuangxian",0,1);
			elseif(BaccaratSettlementInfo.extraPlayerCardId ~=0 ) then
				self.view.ator_PlayerCard3:Play("FlipCards",0,1)
				self.view.ator_DealCards:Play("Bufaxian",0,1);
			elseif(BaccaratSettlementInfo.extraBankerCardId ~=0 ) then
				self.view.ator_BankerCard3:Play("FlipCards",0,1)
				self.view.ator_DealCards:Play("Bufazhuang",0,1);
			end
		end
		
		local playerCardNum =  BaccaratSettlementInfo.playerPointId;
		local BankerCardNum =  BaccaratSettlementInfo.bankerPointId;
		self:PlayResult(playerCardNum,BankerCardNum)
	end)
end

function BaccaratGameCtrl:PlayResult(playerCardNum,BankerCardNum)

	if(self.view.obj_PlayerPoints.activeSelf == false) then
		self.view.txt_PlayerPoint.text = playerCardNum;
		self.view.obj_PlayerPoints:SetActive(true);
		SoundManager:PlayClip(config.ABNames.audios.."player")
		coroutine.wait(0.5)
		SoundManager:PlayClip(config.ABNames.audios.."point_"..playerCardNum)
	end
	coroutine.wait(0.5)
	if(self.view.obj_BankerPoints.activeSelf==false) then
		self.view.txt_BankerPoint.text = BankerCardNum;
		self.view.obj_BankerPoints:SetActive(true);
		SoundManager:PlayClip(config.ABNames.audios.."banker")
		coroutine.wait(0.5)
		SoundManager:PlayClip(config.ABNames.audios.."point_"..BankerCardNum)
	end
	coroutine.wait(0.5)
	self.view.obj_HeWin:SetActive(playerCardNum == BankerCardNum);
	self.view.obj_ZWin:SetActive(BankerCardNum>playerCardNum);
	self.view.obj_XWin:SetActive(playerCardNum>BankerCardNum);
	if(playerCardNum == BankerCardNum) then
		SoundManager:PlayClip(config.ABNames.audios.."tie")
		Tools.PlayerSpineAniByName(ResultTieSpine,"action",false)
	elseif(BankerCardNum>playerCardNum) then
		SoundManager:PlayClip(config.ABNames.audios.."banker_win")
		Tools.PlayerSpineAniByName(ResultBankerSpine,"action",false)
	elseif(playerCardNum>BankerCardNum) then
		SoundManager:PlayClip(config.ABNames.audios.."player_win")
		Tools.PlayerSpineAniByName(ResultPlayerSpine,"action",false)
	end
	if playerIsPairing then--闲对子
		coroutine.wait(0.5)
		SoundManager:PlayClip(config.ABNames.audios.."player_pair")
	end
	if BankerIsPairing then--庄家对子
		coroutine.wait(0.5)
		SoundManager:PlayClip(config.ABNames.audios.."banker_pair")
	end
	self:Flicker(playerCardNum,BankerCardNum);
	coroutine.wait(2);
	self:PlayChipToPlayer()
end

---飞筹码到对应玩家头像上
function BaccaratGameCtrl:PlayChipToPlayer()
	SoundManager:PlayClip(config.ABNames.audios.."ding")
	local betInfoDescendingList =betInfoList;
	table.sort(betInfoDescendingList, function(a, b) return a > b end);
	
	for _, v in ipairs(PlayerChangedGolds) do
		if(v.playerId == PlayerManager:GetPlayerInfo().playerId) then--自己赢钱了
			local selfWinGold = v.playerWinGold+v.playerBetGold
			self:ScreeningChip(betInfoDescendingList,selfWinGold,self.view.obj_Player.transform)
		elseif(self:IsInScene(v.playerId)) then --前6名的玩家赢钱了
			for _, k in pairs(BaccaratPlayerItems) do
				---@type BaccaratPlayerItem
				local item = k;
				if(item:GetPlayerId() == v.playerId) then
					local winGold = v.playerWinGold+v.playerBetGold
					self:ScreeningChip(betInfoDescendingList,winGold,item.transform)
				end
			end
		else
			for _, value in pairs(ChipTable) do
				self:PlayChipToPlayerTwo(value.chip,self.view.btn_AllOther.transform)
			end
		end
	end
	
	for _, value in pairs(ChipTable) do
		self.objPools:UnSpawnPrefab(value.chip)
	end
	ChipTable = {}

end
---筛选筹码r
function BaccaratGameCtrl:ScreeningChip(list,winGold,target)
	local result = self:GetChipAndNum(list,winGold);
	local selfChip={}
	for value, count in pairs(result) do
		if(count>0) then
			for j = 1, count do
				local chip =self:FindChipNumObj(value)
				table.insert(selfChip,chip);
			end
		end
	end
	for _, chipObj in pairs(selfChip) do
		self:PlayChipToPlayerTwo(chipObj,target)
	end
	local obj =self.objPools:Spawn(nil,self.view.obj_UpWin,target)
	obj:SetActive(true);
	local txtNum = ComponentUtilGet.Text(obj.transform,"Num");
	txtNum.text =string.format("+"..winGold) ;
	obj.transform:DOLocalMoveY(50,1):OnComplete(function()
		self.objPools:UnSpawnPrefab(obj)
	end);
	
end

---获取某个玩家需要回收多少筹码和数量
function BaccaratGameCtrl:GetChipAndNum(betList,winGold)
	local Result = {}
	for _, value in ipairs(betList) do
		Result[value] = math.floor(winGold / value)
		winGold = winGold % value
	end
	return Result;
end
---飞筹码到对应玩家身上
function BaccaratGameCtrl:PlayChipToPlayerTwo(chip,target)
	if(chip==nil) then
		return;
	end
	self.PlayChipToPlayerSequence = chip.transform:DOMove(target.position, 0.5);
	self.PlayChipToPlayerSequence:SetEase(Ease.Linear)
	-- 动画完成后回收筹码
	self.PlayChipToPlayerSequence:OnComplete(function()
	    --回收筹码
		self.objPools:UnSpawnPrefab(chip)
	end)
end
---通过筹码数量找到场上下注的筹码预支体返回去
function BaccaratGameCtrl:FindChipNumObj(num)
	for i, v in ipairs(ChipTable) do
		if(v.betIdxTotal == num) then
			local chip =  v.chip;
			table.remove(ChipTable,i);
			return chip
		end
	end
	return nil;
end

---判断玩家是不是在场上（前6名）
function BaccaratGameCtrl:IsInScene(playerId)
	for _, v in pairs(BaccaratPlayerItems) do
		---@type BaccaratPlayerItem
		local item = v;
		if(item:GetPlayerId() == playerId) then
			return true
		end
	end
	return false
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
---刷新筹码左右选择按钮的显示
function BaccaratGameCtrl:RefreshChipLeftRightBtnShow(state)
	self.view.btn_Chipleft.gameObject:SetActive(state)
	self.view.btn_ChipRight.gameObject:SetActive(not  state)
end
	

---添加UI事件
function BaccaratGameCtrl:AddUIEvent()
	self.uiEventListener:AddClick(self.view.btn_Chipleft,function()
		self.view.obj_ChipContent.transform:DOLocalMoveX(0,0.5):OnComplete(function()
			self:RefreshChipLeftRightBtnShow(false);
		end)
		
	end)

	self.uiEventListener:AddClick(self.view.btn_ChipRight,function()
		self.view.obj_ChipContent.transform:DOLocalMoveX(-410,0.5):OnComplete(function()
			self:RefreshChipLeftRightBtnShow(true);
		end)
	end)
	
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
		self.model:ReqExitRoomInGame();
	end)

	for i = 1, self.view.trans_BetBtns.childCount do
		local btn = ComponentUtilGet.Button(self.view.trans_BetBtns:GetChild(i-1))
		self.uiEventListener:AddClick(btn,function()
			if CurSelectChip == nil  or curGameStage~=gameStage.Bet then
				return;
			end
			--请求下注
			local bet = {}
			bet.betValue = CurSelectChip.num;
			bet.betAreaIdx = i;
			local betData = {}
			table.insert(betData,bet)
			self.model:ReqBet(betData);
		end)
	end
	
	self.uiEventListener:AddClick(self.view.btn_Repeat,function()
		--点击续押
		self.view.btn_Repeat.image.material = config.GetUIImageGray();
		self.view.btn_Repeat.enabled =false;
		self.model:ReqBet(BetRecord);
	end)
	
	self.uiEventListener:AddClick(self.view.btn_AllOther,function()
		self.model:ReqTablePlayerInfo()--请求百家乐房间的玩家列表信息
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
	SoundManager:PlayClip(config.ABNames.audios.."add_chip")
	if(PlayerManager:GetPlayerInfo().playerId == data.playerId) then--自己下注
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
		if(PlayerManager:GetPlayerInfo().playerId == data.playerId) then--自己下注
			local bet = {}
			bet.betValue = v.betValue;
			bet.betAreaIdx = v.betIdx;
			table.insert(CurBet,bet);
		end
		self:PlayChip(v,data.playerId);
	end
end

---筹码飞行到指定区域
---@param data 服务器发过来的数据结构
function BaccaratGameCtrl:PlayChip(data,playerId)
	local isSelf = playerId ==PlayerManager:GetPlayerInfo().playerId;
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
		if(item:IsSelf(data.betValue)) then
			chipIndex = item.index;
		end
	end
	
	local chip = self.objPools:SpawnPrefab(nil,config.ABNames.chipPool,"BaccaratChip_"..chipIndex,targetRect.transform)
	chip:SetActive(true)
	ComponentUtilGet.Text(chip.transform,"Icon/Number").text = data.betValue;
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
	local chipNumTable = {}
	chipNumTable.betIdxTotal = data.betIdxTotal;
	chipNumTable.chip = chip;
	table.insert(ChipTable,chipNumTable);
	-- 获取目标区域的矩形顶点
	local corners = CS.System.Array.CreateInstance(typeof(CS.UnityEngine.Vector3),4)
	targetRect:GetWorldCorners(corners)
	--目标位置
	local endPos= Vector3(UnityEngine.Random.Range(corners[0].x,corners[2].x), UnityEngine.Random.Range(corners[0].y,corners[2].y), 0)
	self.PlayChipSequence = DOTween.Sequence()
	-- 设置金币动画效果
	self.PlayChipSequence:Append(chip.transform:DOMove(endPos, 0.3):SetEase(Ease.Linear))
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

	if self.GameStageCor then
		coroutine.stop(self.GameStageCor)
		self.GameStageCor=nil
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