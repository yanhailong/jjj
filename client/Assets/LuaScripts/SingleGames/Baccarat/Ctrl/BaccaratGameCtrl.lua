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
---@type BaccaratAllChildLuItem
local BaccaratAllChildLuItem = require"SingleGames/Baccarat/Ctrl/BaccaratAllChildLuItem"
---@type BaccaratRoad
local BaccaratRoad = require("SingleGames/Baccarat/Ctrl/BaccaratRoad")
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
--endregion
---筹码按钮所有子物体的Image集合
local BottomNoteChildImages={};

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
	config.InitUIImageGray();
	CurSelectChip = 0;
	self:InitDataShow()
	self:InitZhuPanTable()
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
	vsSpine = ComponentUtilGet.SkeletonGraphic(self.view.obj_VS.transform);
	BeginBetSpine = ComponentUtilGet.SkeletonGraphic(self.view.obj_BeginBet.transform);
	StopBetSpine = ComponentUtilGet.SkeletonGraphic(self.view.obj_StopBet.transform);
	ResultTieSpine = ComponentUtilGet.SkeletonGraphic(self.view.obj_HeWin.transform);
	ResultBankerSpine = ComponentUtilGet.SkeletonGraphic(self.view.obj_ZWin.transform);
	ResultPlayerSpine = ComponentUtilGet.SkeletonGraphic(self.view.obj_XWin.transform);
	PlayerKingSpine = ComponentUtilGet.SkeletonGraphic(self.view.obj_PlayerKing.transform);
	BankerKingSpine = ComponentUtilGet.SkeletonGraphic(self.view.obj_BankerKing.transform);
	BottomNoteChildImages = self.view.obj_BottomNote:GetComponentsInChildren(UnityEngine.UI.Image,true)
	
	---@type BaccaratRoad
	self.BaccaratRoadScripts =BaccaratRoad.New()
	self.BaccaratRoadScripts:Init(self.view.obj_ZhuPanContent,self.view.obj_DaLuContent,
			self.view.obj_DaluZiluContent,self.view.obj_XiaoLuContent,self.view.obj_YueYouLuContent);
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
	
	self.VsSpineActionTimer = TimerManager.CreateTimer(self,function()
		Tools.PlayerSpineAniByName(vsSpine,"end",false)
		self.VsSpineEndTimer:Start();
	end,1,1,true);
	
	self.VsSpineEndTimer =  TimerManager.CreateTimer(self,function()
		self.view.obj_VS:SetActive(false);
		curGameStage = gameStage.Bet;
		self:RefreshGameStage();
	end,1,1,true);
	
	self.beginTimer = TimerManager.CreateTimer(self,function()
		self.view.obj_BeginBet:SetActive(false);
		self.view.obj_Countdown:SetActive(true);
		self.betCountDownTimer:Start();
		self:SetBetButtonInteractable(true);
	end,1,1,true);

	self.betCountDownTimer = TimerManager.CreateTimer(self,function()
		countDownTime = countDownTime-1;
		self.view.txt_Countdown.text = countDownTime;
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

---初始化主盘预制体(需要服务器数据)
function BaccaratGameCtrl:InitZhuPanTable(data)
	self.BaccaratRoadScripts:InitData(data);
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

function BaccaratGameCtrl:GetCardNum()
	return math.random(1,52);
end

---进入结算阶段
function BaccaratGameCtrl:EnterSettlement()
	self.view.obj_StopBet:SetActive(true);
	Tools.PlayerSpineAniByName(StopBetSpine,"action",false)
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
		coroutine.wait(1)
		self.view.obj_StopBet:SetActive(false);
		coroutine.wait(1)
		local playerCard1 = self:GetCardNum();
		ComponentUtilGet.Image(self.view.ator_PlayerCard1.transform,"CardImage").sprite = config.GetCardPic("card_"..playerCard1);
		self.view.ator_PlayerCard1:Play("FlipCards");
		coroutine.wait(0.5)
		local playerCard2 = self:GetCardNum();
		ComponentUtilGet.Image(self.view.ator_PlayerCard2.transform,"CardImage").sprite = config.GetCardPic("card_"..playerCard2);
		self.view.ator_PlayerCard2:Play("FlipCards");
		playerIsPairing = playerCard1 == playerCard2;
		playerCard1 = self:GetCardPoint(playerCard1);
		playerCard2 = self:GetCardPoint(playerCard2);
		local playerCardNum = self:GetCardEndPoint(playerCard1 + playerCard2);
		local playerIsKing =playerCardNum == 8 or playerCardNum == 9;
		self.view.obj_PlayerKing:SetActive(playerIsKing)
		if(playerIsKing) then
			tools.PlayerSpineAniByName(PlayerKingSpine,"action",false);
		end
		coroutine.wait(0.75)
		local BankerCard1 =  self:GetCardNum();
		ComponentUtilGet.Image(self.view.ator_BankerCard1.transform,"CardImage").sprite = config.GetCardPic("card_"..BankerCard1);
		self.view.ator_BankerCard1:Play("FlipCards");
		coroutine.wait(0.5)
		local BankerCard2 = self:GetCardNum();
		ComponentUtilGet.Image(self.view.ator_BankerCard2.transform,"CardImage").sprite = config.GetCardPic("card_"..BankerCard2);
		self.view.ator_BankerCard2:Play("FlipCards");
		BankerIsPairing = BankerCard1 ==BankerCard2;
		BankerCard1 = self:GetCardPoint(BankerCard1);
		BankerCard2 = self:GetCardPoint(BankerCard2);
		local BankerCardNum = self:GetCardEndPoint(BankerCard1 + BankerCard2);
		local BankerIsKing = BankerCardNum == 8 or BankerCardNum == 9;
		self.view.obj_BankerKing:SetActive(BankerIsKing)
		if(BankerIsKing) then
			tools.PlayerSpineAniByName(BankerKingSpine,"action",false);
		end
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
	BetRecord=CurBet;
	coroutine.wait(2);
	self:InitData();
	RoundNumber = RoundNumber+1;
	self:RefreshDataShow()
	local data = {};
	data[1] = CurWhoWin
	data[2] = BankerIsPairing
	self.BaccaratRoadScripts:RefreshData(data,true)
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
---获取真正的点数
function BaccaratGameCtrl:GetCardPoint(point)
	local num =  (point - 1) / 13+1;

	if(num >=10) then
		return 0
	else
		return num
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
	chip.transform.localScale =  Vector3.one*0.6
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
	self.objPools:DestroyAll();
	self.BaccaratRoadScripts:Destroy()
end

return BaccaratGameCtrl