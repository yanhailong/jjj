---
---Create by Administrator
---DateTime: 2025-06-30 16:46:28
---
---@class RoyalWarGameCtrl:BaseCtrl
local RoyalWarGameCtrl=Class("RoyalWarGameCtrl",BaseCtrl)
local config = require("SingleGames/RoyalWar/RoyalWarConfig")
---@type RoyalWarCardTypeItem
local RoyalWarCardTypeItem = require("SingleGames/RoyalWar/Ctrl/RoyalWarCardTypeItem")
---@type RoyalWarRoad
local RoyalWarRoad = require("SingleGames/RoyalWar/Ctrl/RoyalWarRoad")
---@type RoyalWarPlayerItem
local RoyalWarPlayerItem = require("SingleGames/RoyalWar/Ctrl/RoyalWarPlayerItem")
---@type RoyalWarChipItem
local RoyalWarChipItem = require("SingleGames/RoyalWar/Ctrl/RoyalWarChipItem")
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
local countDownTime=0;
---当前选中的筹码
local CurSelectChip;
---筹码下注的集合表
local ChipTable={};
---牌型数据(用来显示在路下面前面7个出过什么牌)
local CardTypeData={};
local CardTypeTable={};
---牌型Obj
local CardTypeObjTable={};

local SelfBetBlackAllNum
local SelfBetRedAllNum
local SelfBetLuckyAllNum

---前6名玩家预支体集合
local BestSixPlayerObjs={}
---玩家预支脚本集合
local RoyalWarPlayerItems={}
---红方赢了多少局
local RedWinNumber;
---黑方赢了多少局
local BlackWinNumber;
---幸运一击次数
local LuckyWinNumber;
---局数
local RoundNumber;
---下注的筹码面板集合
local betInfoList={};
---筹码的集合
local ChipItems = {};
---筹码最大显示数量
local ChipMaxNum = 50;
---结算信息
local RedBlackWarSettleInfo;
---场上倒计时结束时间戳
local TableCountDownTime;

local vsSpine;
local BeginBetSpine;
local StopBetSpine;
local CountDownSpine;
local AboutEndSpine;
local RedWinSpine;
local BlackSpine;

---下注记录
local BetRecord={};
---当前下注
local CurBet={};

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
	self.model:ReqRoomBaseInfo();
	self:InitData()
end

---第一次进入房间请求房间数据返回
function RoyalWarGameCtrl:NotifyRedBlackWarInfo(data)
	self.GamePhase = data.gamePhase;--游戏阶段信息
	betInfoList = data.betPointList
	RedBlackWarSettleInfo = data.settleInfos
	TableCountDownTime = data.tableCountDownTime
	--初始化筹码
	for i = 1, #betInfoList do
		local item =self.objPools:Spawn(nil,self.view.obj_chipItem,self.view.obj_ChipContent.transform)
		item:SetActive(true);
		---@type RoyalWarChipItem
		local chipItem = RoyalWarChipItem.New(item,self);
		chipItem:InitUIShow(i,betInfoList[i]);
		table.insert(ChipItems,chipItem);
	end
	self.RoyalWarScripts:InitData(data,self.GamePhase.gamePhase == "GAME_ROUND_OVER_SETTLEMENT");
	self:RefreshPlayerInfo(data.playerInfos);
	self:SetBetButtonInteractable(false);
	self:InitDataShow(data.redBlackHistories)
	self:InitTableAreaInfos(data.tableAreaInfos);
	self.view.tmp_AllOtherNumber.text = data.totalPlayerNum
	self:RefreshDataShow(data);
end

---第一次进入游戏初始化区域下注信息
function RoyalWarGameCtrl:InitTableAreaInfos(tableAreaInfos)
	local targetRect;
	--下注区域，1: 庄对 2: 和 3: 闲对 4: 闲 5: 庄
	for _, v in ipairs(tableAreaInfos) do
		if(v.betIdx==20010001) then --下注的红方
			targetRect = self.view.rect_RedBetRegion;
			self.view.tmp_RedBetNum.text =  v.betIdxTotal;
			SelfBetRedAllNum =v.playerBetTotal;
		elseif(v.betIdx==config.BetState.Tie) then --下注的黑方
			targetRect = self.view.rect_BlackBetRegion;
			self.view.tmp_BlackBetNum.text = v.betIdxTotal;
			SelfBetBlackAllNum =v.playerBetTotal;
		elseif(v.betIdx==config.BetState.PPair) then --下注的幸运一击
			targetRect = self.view.rect_LuckyBetRegion;
			self.view.tmp_LuckyBetNum.text =  v.betIdxTotal;
			SelfBetLuckyAllNum =v.playerBetTotal;
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
function RoyalWarGameCtrl:DirectGenerationChip(chipIndex,targetRect,betIdxTotal)
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
---刷新自己下注的筹码数量是否显示
function RoyalWarGameCtrl:RefreshSelfBetNumShow()
	self.view.obj_SelfBetBlack:SetActive(SelfBetBlackAllNum~=0);
	self.view.obj_SelfBetRed:SetActive(SelfBetRedAllNum~=0);
	self.view.obj_SelfBetLucky:SetActive(SelfBetLuckyAllNum~=0);
	self.view.tmp_SelfBetBlackNum.text = SelfBetBlackAllNum
	self.view.tmp_SelfBetRedNum.text = SelfBetRedAllNum;
	self.view.tmp_SelfBetLuckyNum.text = SelfBetLuckyAllNum;

end
---服务器推送开始下一局（VS）
function RoyalWarGameCtrl:NotifyRoomReadyWait()
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
	self:InitUIShow()
	self.RoyalWarScripts:RefreshData(RedBlackWarSettleInfo)
	self:RefreshUIDataShow()
	curGameStage =  config.GameSate.Start
	self:RefreshGameStage()
end
---通知开始下注
function RoyalWarGameCtrl:NotifyPhaseChangInfo(msg)
	TableCountDownTime = msg.endTime;
	curGameStage =  config.GameSate.Bet
	self:RefreshGameStage()
end

---通知红黑大战结算
function RoyalWarGameCtrl:NotifyRedBlackWarSettleInfo(msg)
	RedBlackWarSettleInfo = msg
	curGameStage = config.GameSate.Deal
	self:RefreshGameStage()
end

---推送下注
function RoyalWarGameCtrl:PlayerBet(data)
	SoundManager:PlayClip(config.ABNames.audios.."add_chip")
	if(PlayerManager:GetPlayerInfo().playerId == data.playerId) then--自己下注
		self.view.tmp_SelfGoldNumber.text = data.playerCurGold;
	else
		for _, v in pairs(RoyalWarPlayerItems) do
			---@type RoyalWarPlayerItem
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

---服务器数据返回刷新阶段显示
function RoyalWarGameCtrl:RefreshDataShow(data)
	if(self.GamePhase=="START_GAME") then--开始阶段
		curGameStage =  config.GameSate.Start
	elseif(self.GamePhase == "BET") then --下注阶段
		curGameStage =  config.GameSate.Bet;
	elseif(self.GamePhase == "GAME_ROUND_OVER_SETTLEMENT") then --结算阶段
		local ServerTime = ServerTimeSync:GetTimeStamp()
		local endCountDown = (data.tableCountDownTime - ServerTime)/1000;
		if(endCountDown==13) then --需要展示发牌
			curGameStage = config.GameSate.Deal
		elseif(endCountDown <=4) then --显示等待结束
			curGameStage = config.GameSate.None
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
			curGameStage = config.GameSate.Settlement;
		end
	end
	self:RefreshGameStage()
end

---初始化数据
function RoyalWarGameCtrl:InitData()
	---@type ObjectPoolUtil
	self.objPools=ObjectPoolUtil.New()
	---@type RoyalWarRoad
	self.RoyalWarScripts =RoyalWarRoad.New()
	self.RoyalWarScripts:Init(self.view.obj_ZhuPanContent,self.view.obj_DaLuContent,
			self.view.obj_DaluZiluContent,self.view.obj_XiaoLuContent,self.view.obj_YueYouLuContent);
	config.InitIconPic();
	config.InitCardTypePic();
	config.InitCardPic();
	config.InitCommonMainPic();
	config.InitUIImageGray();
	self:InitUIShow()
	---@type RoyalWarPlayerItem
	for i = 1,self.view.obj_PlayerRoot.transform.childCount do
		BestSixPlayerObjs[i] = self.view.obj_PlayerRoot.transform:GetChild(i-1).gameObject;
		RoyalWarPlayerItems[i]=RoyalWarPlayerItem.New(BestSixPlayerObjs[i],self)
		BestSixPlayerObjs[i]:SetActive(false);
	end

	vsSpine = ComponentUtilGet.SkeletonGraphic(self.view.obj_VS.transform,"SkeletonGraphic");
	BeginBetSpine = ComponentUtilGet.SkeletonGraphic(self.view.obj_BeginBet.transform,"SkeletonGraphic");
	StopBetSpine = ComponentUtilGet.SkeletonGraphic(self.view.obj_StopBet.transform,"SkeletonGraphic");
	CountDownSpine = ComponentUtilGet.SkeletonGraphic(self.view.obj_Countdown.transform);
	AboutEndSpine = ComponentUtilGet.SkeletonGraphic(self.view.obj_AboutEnd.transform,"SkeletonGraphic");
	RedWinSpine = ComponentUtilGet.SkeletonGraphic(self.view.obj_RedWin.transform,"SkeletonGraphic");
	BlackSpine = ComponentUtilGet.SkeletonGraphic(self.view.obj_BlackWin.transform,"SkeletonGraphic");
	self.betCountDownTimer = TimerManager.CreateTimer(self,function()
		countDownTime = countDownTime-1;
		self.view.txt_Countdown.text = countDownTime;
		if(countDownTime <= 3) then
			SoundManager:PlayClip(config.ABNames.audios.."countdown3")
			if(not self.view.obj_AboutEnd.activeSelf) then
				self.view.obj_Countdown:SetActive(false);
				self.view.obj_AboutEnd:SetActive(true);
				Tools.PlayerSpineAniByName(AboutEndSpine,"action",false);
			end
			--self.view.txt_AboutEnd.text = countDownTime;
		end
		if(countDownTime<=0) then
			SoundManager:PlayClip(config.ABNames.audios.."countdown32")
			self.view.obj_AboutEnd:SetActive(false);
			self.betCountDownTimer:Stop()
		end
	end,1,-1,true);
	CurSelectChip = nil;
	self:RefreshChipLeftRightBtnShow(false)
	self:InitCardTypeData()
end

function RoyalWarGameCtrl:InitUIShow()
	CurBet={};
	SelfBetBlackAllNum = 0;
	SelfBetRedAllNum =0;
	SelfBetLuckyAllNum =0;
	self:RefreshSelfBetNumShow()
	self.view.obj_CardBg:SetActive(false);
	self.view.ator_CardRoot:Play("New State")
	self.view.obj_RoadRoot:SetActive(true)
	self.view.obj_SelfBetBlack:SetActive(false)
	self.view.obj_SelfBetRed:SetActive(false)
	self.view.obj_SelfBetLucky:SetActive(false)
	self.view.obj_Settlement:SetActive(false);
	self.view.obj_RedWin:SetActive(false)
	self.view.obj_BlackWin:SetActive(false)

	self.view.tmp_RedBetNum.text="0.00"
	self.view.tmp_BlackBetNum.text="0.00"
	self.view.tmp_LuckyBetNum.text="0.00"

	self.view.tmp_SelfBetRedNum.text="0.00"
	self.view.tmp_SelfBetBlackNum.text="0.00"
	self.view.tmp_SelfBetLuckyNum.text="0.00"

	
end
---设置按钮的显示状态
function RoyalWarGameCtrl:SetBetButtonInteractable(state)
	self.view.btn_Repeat.enabled = #BetRecord>0;
	if(#BetRecord>0) then
		self.view.btn_Repeat.image.material = nil;
	else
		self.view.btn_Repeat.image.material = config.GetUIImageGray();
	end
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
---同步游戏当前在哪个阶段
function RoyalWarGameCtrl:RefreshGameStage()
	if self.GameStageCor then
		coroutine.stop(self.GameStageCor)
		self.GameStageCor=nil
	end
	self.GameStageCor=	CorManager:StartCor(function()
		if curGameStage ==  config.GameSate.Start then
			self:EnterBegin();
		elseif curGameStage == config.GameSate.Bet then
			self:EnterBetGame();
		elseif curGameStage == config.GameSate.Deal then
			self:EnterDeal();
		elseif curGameStage == config.GameSate.Settlement then
			self:EnterSettlement();
		end
	end)
	
end

---进入开始阶段(显示VS)
function RoyalWarGameCtrl:EnterBegin()
	self.view.obj_Countdown:SetActive(false);
	self.view.obj_VS:SetActive(true);
	Tools.PlayerSpineAniByName(vsSpine,"action",false)
	SoundManager:PlayClip(config.ABNames.audios.."hh_vs")
	coroutine.wait(1)
	self.view.obj_VS:SetActive(false);
end
---进入下注阶段
function RoyalWarGameCtrl:EnterBetGame()
	countDownTime = 
	self.view.obj_BeginBet:SetActive(true);
	Tools.PlayerSpineAniByName(BeginBetSpine,"kaishixiazhu",false)
	SoundManager:PlayClip(config.ABNames.audios.."startXiaZhu")
	coroutine.wait(1);
	local ServerTime = ServerTimeSync:GetTimeStamp()
	countDownTime =math.floor((TableCountDownTime - ServerTime)/1000);
	self.view.txt_Countdown.text = countDownTime;
	self.view.obj_Countdown:SetActive(true);
	self.view.obj_BeginBet:SetActive(false);
	self:SetBetButtonInteractable(true);
	self.betCountDownTimer:Start();
end

---通知押注类房间玩家信息变化
function RoyalWarGameCtrl:NotifyTableRoomPlayerInfoChange(data)
	self:RefreshPlayerInfo(data.tablePlayerInfoList);
	self.view.tmp_AllOtherNumber.text = data.totalPlayerNum
end

---初始化要显示的数据（接入服务器数据要，要赋值服务器那边的数据显示）
function RoyalWarGameCtrl:InitDataShow(data)
	RedWinNumber=0;
	BlackWinNumber=0;
	LuckyWinNumber=0;
	RoundNumber=#data;
	for _, v in ipairs(data) do
		if(v.winner ==  1) then
			RedWinNumber = RedWinNumber+1
		elseif(v.winState==2) then
			BlackWinNumber = BlackWinNumber+1
		end

		if(v.cardType>1)then
			LuckyWinNumber = LuckyWinNumber+1
		end
	end
	self:RefreshUIDataShow()
end

function RoyalWarGameCtrl:RefreshUIDataShow()
	self.view.tmp_RedNum.text = RedWinNumber
	self.view.tmp_BlackNum.text = BlackWinNumber
	self.view.tmp_LuckyNum.text = LuckyWinNumber
	self.view.tmp_RoundsNum.text = RoundNumber
end

---刷新前6的玩家显示
---@param playerInfoList 前6的玩家列表信息
function RoyalWarGameCtrl:RefreshPlayerInfo(playerInfoList)
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
		---@type RoyalWarPlayerItem
		local item = RoyalWarPlayerItems[i];
		item:RefreshPlayerInfoShow(v);
	end
end
---直接展示结果
function RoyalWarGameCtrl:EnterSettlement()
	self.view.obj_CardBg:SetActive(true);
	self.view.obj_RoadRoot:SetActive(false)
	if self.SettlementCor then
		coroutine.stop(self.SettlementCor)
		self.SettlementCor=nil
	end
	self.SettlementCor=	CorManager:StartCor(function()--翻牌
		local redCardNumOne = RedBlackWarSettleInfo.redCards[1];
		local redCardNumTwo = RedBlackWarSettleInfo.redCards[2];
		local redCardNumThree = RedBlackWarSettleInfo.redCards[3];

		local blackCardNumOne = RedBlackWarSettleInfo.blackCards[1];
		local blackCardNumTwo =  RedBlackWarSettleInfo.blackCards[2];
		local blackCardNumThree =  RedBlackWarSettleInfo.blackCards[3];

		self.view.img_RedCardOne.sprite = config.GetCardPic("card_"..redCardNumOne);
		self.view.img_RedCardTwo.sprite = config.GetCardPic("card_"..redCardNumTwo);
		self.view.img_RedCardThree.sprite = config.GetCardPic("card_"..redCardNumThree);

		self.view.img_BlackCardOne.sprite = config.GetCardPic("card_"..blackCardNumOne);
		self.view.img_BlackCardTwo.sprite = config.GetCardPic("card_"..blackCardNumTwo);
		self.view.img_BlackCardThree.sprite = config.GetCardPic("card_"..blackCardNumThree);

		self.view.img_RedResultNumber.sprite =  config.GetIconCardTypePic(config.GetRedCardTypeName(RedBlackWarSettleInfo.redCardType))
		self.view.img_RedResultNumber:SetNativeSize();
		self.view.img_BlackResultNumber.sprite =  config.GetIconCardTypePic(config.GetBlackCardTypeName(RedBlackWarSettleInfo.blackCardType))
		self.view.img_BlackResultNumber:SetNativeSize();

		if(RedBlackWarSettleInfo.redCardType == config.CardType.DanZhang) then
			self.view.img_RedResultBg.sprite = config.GetIconPic("hhdz_dk_7")
		else
			self.view.img_RedResultBg.sprite = config.GetIconPic("hhdz_dk_8")
		end

		if(RedBlackWarSettleInfo.blackCardType== config.CardType.DanZhang) then
			self.view.img_BlackResultBg.sprite = config.GetIconPic("hhdz_dk_7")
		else
			self.view.img_BlackResultBg.sprite = config.GetIconPic("hhdz_dk_8")
		end
		self.view.ator_CardRoot:Play("RoyalWarDealCard",0,1)
		self.isRedWin = RedBlackWarSettleInfo.winState==1;
		self.view.obj_RedWin:SetActive(self.isRedWin)
		self.view.obj_BlackWin:SetActive(not self.isRedWin);
		if(RedBlackWarSettleInfo.winState == 1) then
			SoundManager:PlayClip(config.ABNames.audios.."redWin")
			Tools.PlayerSpineAniByName(RedWinSpine,"action",false)
		else
			SoundManager:PlayClip(config.ABNames.audios.."blackWin")
			Tools.PlayerSpineAniByName(BlackSpine,"action",false)
		end
		self.IsLucky = RedBlackWarSettleInfo.redCardType~=config.CardType.DanZhang or RedBlackWarSettleInfo.blackCardType~=config.CardType.DanZhang;
		self:Flicker();
		if(RedBlackWarSettleInfo.redCardType>RedBlackWarSettleInfo.blackCardType) then
			self:RefreshCardTypeData(RedBlackWarSettleInfo.redCardType)
		else
			self:RefreshCardTypeData(RedBlackWarSettleInfo.blackCardType)
		end
		coroutine.wait(3)
		self:PlayChipToPlayer()
	end)
end
---进入结算阶段(从翻牌开始)
function RoyalWarGameCtrl:EnterDeal()
	self.view.obj_StopBet:SetActive(true);
	self.view.obj_AboutEnd:SetActive(false);
	self.view.obj_CardBg:SetActive(true);
	self.view.obj_RoadRoot:SetActive(false)
	self:SetBetButtonInteractable(false);
	Tools.PlayerSpineAniByName(StopBetSpine,"jieshuxiazhu",false)
	SoundManager:PlayClip(config.ABNames.audios.."endXiaZhu")
	if self.SettlementCor then
		coroutine.stop(self.SettlementCor)
		self.SettlementCor=nil
	end
	self.SettlementCor=	CorManager:StartCor(function()--翻牌
		coroutine.wait(1)
		self.view.obj_StopBet:SetActive(false);
		self.view.obj_Settlement:SetActive(true);
		local redCardNumOne = RedBlackWarSettleInfo.redCards[1];
		local redCardNumTwo = RedBlackWarSettleInfo.redCards[2];
		local redCardNumThree = RedBlackWarSettleInfo.redCards[3];
	

		local blackCardNumOne = RedBlackWarSettleInfo.blackCards[1];
		local blackCardNumTwo =  RedBlackWarSettleInfo.blackCards[2];
		local blackCardNumThree =  RedBlackWarSettleInfo.blackCards[3];
		
	
		
		self.view.img_RedCardOne.sprite = config.GetCardPic("card_"..redCardNumOne);
		self.view.img_RedCardTwo.sprite = config.GetCardPic("card_"..redCardNumTwo);
		self.view.img_RedCardThree.sprite = config.GetCardPic("card_"..redCardNumThree);
		
		self.view.img_BlackCardOne.sprite = config.GetCardPic("card_"..blackCardNumOne);
		self.view.img_BlackCardTwo.sprite = config.GetCardPic("card_"..blackCardNumTwo);
		self.view.img_BlackCardThree.sprite = config.GetCardPic("card_"..blackCardNumThree);
		
	
		
		self.view.img_RedResultNumber.sprite =  config.GetIconCardTypePic(config.GetRedCardTypeName(RedBlackWarSettleInfo.redCardType))
		self.view.img_RedResultNumber:SetNativeSize();
		self.view.img_BlackResultNumber.sprite =  config.GetIconCardTypePic(config.GetBlackCardTypeName(RedBlackWarSettleInfo.blackCardType))
		self.view.img_BlackResultNumber:SetNativeSize();
		
		if(RedBlackWarSettleInfo.redCardType == config.CardType.DanZhang) then
			self.view.img_RedResultBg.sprite = config.GetIconPic("hhdz_dk_7")
		else
			self.view.img_RedResultBg.sprite = config.GetIconPic("hhdz_dk_8")
		end

		if(RedBlackWarSettleInfo.blackCardType== config.CardType.DanZhang) then
			self.view.img_BlackResultBg.sprite = config.GetIconPic("hhdz_dk_7")
		else
			self.view.img_BlackResultBg.sprite = config.GetIconPic("hhdz_dk_8")
		end
		coroutine.wait(1)
		self.view.ator_CardRoot:Play("RoyalWarDealCard")
		SoundManager:PlayClip(config.ABNames.audios.."fan_LastPai")
		coroutine.wait(0.5)
		SoundManager:PlayClip(config.ABNames.audios.."fan_LastPai")
		coroutine.wait(0.5)
		SoundManager:PlayClip(config.ABNames.audios.."faPai")
		coroutine.wait(0.5)
		SoundManager:PlayClip(config.ABNames.audios..config.GetRedCardAudioName(RedBlackWarSettleInfo.redCardType))
		SoundManager:PlayClip(config.ABNames.audios.."faPai")
		coroutine.wait(1)
		SoundManager:PlayClip(config.ABNames.audios..config.GetRedCardAudioName(RedBlackWarSettleInfo.blackCardType))
		coroutine.wait(0.5)

		self.isRedWin = RedBlackWarSettleInfo.winState==1;
		self.view.obj_RedWin:SetActive(self.isRedWin)
		self.view.obj_BlackWin:SetActive(not self.isRedWin);
		if(RedBlackWarSettleInfo.winState == 1) then
			SoundManager:PlayClip(config.ABNames.audios.."redWin")
			Tools.PlayerSpineAniByName(RedWinSpine,"action",false)
		else
			SoundManager:PlayClip(config.ABNames.audios.."blackWin")
			Tools.PlayerSpineAniByName(BlackSpine,"action",false)
		end
		self.IsLucky = RedBlackWarSettleInfo.redCardType~=config.CardType.DanZhang or RedBlackWarSettleInfo.blackCardType~=config.CardType.DanZhang;
		self:Flicker();
		if(RedBlackWarSettleInfo.redCardType>RedBlackWarSettleInfo.blackCardType) then
			self:RefreshCardTypeData(RedBlackWarSettleInfo.redCardType)
		else
			self:RefreshCardTypeData(RedBlackWarSettleInfo.blackCardType)
		end
		coroutine.wait(3)
		self:PlayChipToPlayer()
		
	end)
end

---闪烁对应区域
function RoyalWarGameCtrl:Flicker()
	if(self.isRedWin) then
		self:PlayFlicker(ComponentUtilGet.Image(self.view.obj_RedWinIcon.transform),true)
		RedWinNumber=RedWinNumber+1
	else
		self:PlayFlicker(ComponentUtilGet.Image(self.view.obj_BlackWinIcon.transform),true)
		BlackWinNumber=BlackWinNumber+1
	end
	if self.IsLucky then
		self:PlayFlicker(ComponentUtilGet.Image(self.view.obj_LuckyWinIcon.transform),false)
		LuckyWinNumber=LuckyWinNumber+1
	end
end
---播放赢的区域闪烁(播放完开始下一局)
function RoyalWarGameCtrl:PlayFlicker(image,isInitData)
	self.flickerSequence = DOTween.Sequence()
	self.flickerSequence:Append(image:DOFade(1,0.5))
	self.flickerSequence:SetLoops(8,loopType.Yoyo)
	self.flickerSequence:Play();
end

---飞筹码到对应玩家头像上
function RoyalWarGameCtrl:PlayChipToPlayer()
	if(#RedBlackWarSettleInfo.playerSettleInfos>0) then
		SoundManager:PlayClip(config.ABNames.audios.."ding")
	end
	local betInfoDescendingList =betInfoList;
	table.sort(betInfoDescendingList, function(a, b) return a > b end);

	for _, v in ipairs(RedBlackWarSettleInfo.playerSettleInfos) do
		if(v.playerId == PlayerManager:GetPlayerInfo().playerId) then--自己赢钱了
			local selfWinGold = v.playerWinGold+v.playerBetGold
			self:ScreeningChip(betInfoDescendingList,v.playerWinGold,self.view.obj_Player.transform)
			self:UpWinGoldNum(v.playerWinGold,self.view.obj_Player.transform)
		elseif(self:IsInScene(v.playerId)) then --前6名的玩家赢钱了
			for _, k in pairs(RoyalWarPlayerItems) do
				---@type RoyalWarPlayerItem
				local item = k;
				if(item:GetPlayerId() == v.playerId) then
					local winGold = v.playerWinGold+v.playerBetGold
					self:ScreeningChip(betInfoDescendingList,v.playerWinGold,item.transform)
					self:UpWinGoldNum(v.playerWinGold,item.transform)
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

---展示赢了多少金币
function RoyalWarGameCtrl:UpWinGoldNum(winGold,target)
	local obj =self.objPools:Spawn(nil,self.view.obj_UpWin,target)
	obj:SetActive(true);
	local txtNum = ComponentUtilGet.Text(obj.transform,"Num");
	txtNum.text =string.format("+"..winGold) ;
	obj.transform:DOLocalMoveY(50,1):OnComplete(function()
		self.objPools:UnSpawnPrefab(obj)
	end);
end
---筛选筹码r
function RoyalWarGameCtrl:ScreeningChip(list,winGold,target)
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


end

---获取某个玩家需要回收多少筹码和数量
function RoyalWarGameCtrl:GetChipAndNum(betList,winGold)
	local Result = {}
	for _, value in ipairs(betList) do
		Result[value] = math.floor(winGold / value)
		winGold = winGold % value
	end
	return Result;
end
---飞筹码到对应玩家身上
function RoyalWarGameCtrl:PlayChipToPlayerTwo(chip,target)
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
function RoyalWarGameCtrl:FindChipNumObj(num)
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
function RoyalWarGameCtrl:IsInScene(playerId)
	for _, v in pairs(RoyalWarPlayerItems) do
		---@type RoyalWarPlayerItem
		local item = v;
		if(item:GetPlayerId() == playerId) then
			return true
		end
	end
	return false
end

---随机牌
function RoyalWarGameCtrl:GetCardNum()
	return math.random(1,52);
end
---随机花色
function RoyalWarGameCtrl:GetRandomColour()
	return math.random(1,4)
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



---刷新菜单显示隐藏
function RoyalWarGameCtrl:RefreshMenuShow()
	if self.view.btn_touch.gameObject.activeSelf then
		self.view.obj_Menu.transform:DOLocalMoveY(483,0.5):SetEase(Ease.InBack)
		self.view.btn_touch.gameObject:SetActive(false)
	else
		self.view.obj_Menu.transform:DOLocalMoveY(0,0.5):SetEase(Ease.OutBack)
		self.view.btn_touch.gameObject:SetActive(true)
	end

end

function RoyalWarGameCtrl:Close()
    self.super.Close(self);
end
---刷新筹码左右选择按钮的显示
function RoyalWarGameCtrl:RefreshChipLeftRightBtnShow(state)
	self.view.btn_Chipleft.gameObject:SetActive(state)
	self.view.btn_ChipRight.gameObject:SetActive(not  state)
end
---添加UI事件
function RoyalWarGameCtrl:AddUIEvent()
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
		--CtrlManager.SingleShow(CtrlNames.BaccaratRule)--还没加这个帮助面板
	end)
	self.uiEventListener:AddClick(self.view.btn_close,function()
		GameCenter.LeaveGame()
		self:Close();
	end)

	self.uiEventListener:AddClick(self.view.btn_BetBlack,function()
		--下注黑方区域
		--请求下注
		self:ReqBet(20010002);
	end)

	self.uiEventListener:AddClick(self.view.btn_BetRed,function()
		--下注红方区域
		--请求下注
		self:ReqBet(20010001);
	end)

	self.uiEventListener:AddClick(self.view.btn_BetLucky,function()
		--下注幸运一击区域
		--请求下注
		self:ReqBet(20010003);
	end)
	self.uiEventListener:AddClick(self.view.btn_Repeat,function()
		--点击续押
		self.view.btn_Repeat.image.material = config.GetUIImageGray();
		self.view.btn_Repeat.enabled =false;
		self.model:ReqBet(BetRecord);
		SoundManager:PlayClip(config.ABNames.audios.."xiazhu4")
	end)
	self.uiEventListener:AddClick(self.view.btn_AllOther,function()
		self.model:ReqTablePlayerInfo()--请求百家乐房间的玩家列表信息
	end)
end

function RoyalWarGameCtrl:ReqBet(betAreaIdx)
	if CurSelectChip == nil  or curGameStage ~=  config.GameSate.Bet then
		return;
	end
	local bet = {}
	bet.betValue = CurSelectChip.num;
	bet.betAreaIdx =betAreaIdx;
	local betData = {}
	table.insert(betData,bet)
	self.model:ReqBet(betData);
	self:CloseBetRecord();
	SoundManager:PlayClip(config.ABNames.audios.."add_chip")
	
end

function RoyalWarGameCtrl:CloseBetRecord()
	if(#BetRecord>0) then
		BetRecord = {};
		self.view.btn_Repeat.image.material = config.GetUIImageGray();
		self.view.btn_Repeat.enabled =false;
	end
end

---筹码飞行到指定区域
---@param selectBet 选中的下注区域
---@param selectChip 下注的多少
function RoyalWarGameCtrl:PlayChip(data,playerId)
	local isSelf = playerId ==PlayerManager:GetPlayerInfo().playerId;
	local targetRect;
	if(data.betIdx == 20010001) then -- 下注的红方
		targetRect = self.view.rect_RedBetRegion
		self.view.tmp_RedBetNum.text = data.betIdxTotal;
		if(isSelf) then
			SelfBetRedAllNum = SelfBetRedAllNum+data.betValue;
		end
	elseif data.betIdx == 20010002 then -- 下注的黑方
		targetRect = self.view.rect_BlackBetRegion;
		self.view.tmp_BlackBetNum.text =  data.betIdxTotal;
		if(isSelf) then
			SelfBetBlackAllNum = SelfBetBlackAllNum+data.betValue;
		end
	elseif 	data.betIdx == 20010003 then -- 下注的幸运一击
		targetRect = self.view.rect_LuckyBetRegion
		self.view.tmp_LuckyBetNum.text =  data.betIdxTotal;
		if(isSelf) then
			SelfBetLuckyAllNum = SelfBetLuckyAllNum+data.betValue;
		end
	end
	
	self:RefreshSelfBetNumShow();
	local chipIndex = 0;
	for _, v in pairs(ChipItems) do
		---@type RoyalWarChipItem
		local item = v;
		if(item:IsSelf(data.betValue)) then
			chipIndex = item.index;
		end
	end
	local chip = self.objPools:SpawnPrefab(nil,config.ABNames.chipPool,"RoyalWarChip_"..chipIndex,targetRect.transform)
	chip:SetActive(true)
	ComponentUtilGet.Text(chip.transform,"Icon/Number").text =StringUtil.FormatNumber(data.betValue);
	chip.transform.localScale =  Vector3.one*0.6
	if(isSelf) then
		chip.transform.position = self.view.obj_Player.transform.position;
	else
		local player;
		for _, v in pairs(RoyalWarPlayerItems) do
			---@type RoyalWarPlayerItem
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
function RoyalWarGameCtrl:RemoveEvent()
	self.super.RemoveEvent(self);
end
---选中哪个筹码
function RoyalWarGameCtrl:SetCheckedShow(ChipItem)
	CurSelectChip = ChipItem;
	for _, v in pairs(ChipItems) do
		---@type BaccaratChipItems
		local item = v;
		item:RefreshChecked(CurSelectChip.index)
	end
end
--region UI事件方法

--endregion


---销毁UI
function RoyalWarGameCtrl:RealCloseDestroy()
	self.super.RealCloseDestroy(self);
	TimerManager.StopAllTimer(self)
	self.objPools:DestroyAll();
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

	for _, v in ipairs(CardTypeTable) do
		---@type RoyalWarCardTypeItem
		local item =v;
		item:Destroy();
	end
	CardTypeObjTable ={};
	CardTypeData ={}
	CardTypeTable ={}
	
	BestSixPlayerObjs={}
	RoyalWarPlayerItems={}
	self.RoyalWarScripts:Destroy()
	ChipItems = {};
end

return RoyalWarGameCtrl