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
---@type RoyalWarRoad
local RoyalWarRoad = require("SingleGames/RoyalWar/Ctrl/RoyalWarRoad")
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
	---@type BaccaratRoad
	self.RoyalWarScripts =RoyalWarRoad.New()
	self.RoyalWarScripts:Init(self.view.obj_ZhuPanContent,self.view.obj_DaLuContent,
			self.view.obj_DaluZiluContent,self.view.obj_XiaoLuContent,self.view.obj_YueYouLuContent);
	config.InitIconPic();
	config.InitCardTypePic();
	config.InitCardPic();
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
	countDownTime =13;
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
	self.view.obj_Settlement:SetActive(false);
	
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
		self.view.txt_Countdown.text = countDownTime;
		if(countDownTime <= 3) then
			self.view.obj_Countdown:SetActive(false);
			self.view.obj_AboutEnd:SetActive(true);
			self.view.txt_AboutEnd.text = countDownTime;
		end
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
	if self.GameStageCor then
		coroutine.stop(self.GameStageCor)
		self.GameStageCor=nil
	end
	self.GameStageCor=	CorManager:StartCor(function()
		if curGameStage ==  config.GameSate.Start then
			self:EnterBegin();
		elseif curGameStage == config.GameSate.Bet then
			self:EnterBetGame();
		elseif curGameStage == config.GameSate.Settlement then
			self:EnterSettlement();
		end
	end)


	
end

---进入开始阶段(显示VS)
function RoyalWarGameCtrl:EnterBegin()
	self.view.obj_Countdown:SetActive(false);
	self.view.obj_VS:SetActive(true);
	self.beginTimer:Start();
end
---进入下注阶段
function RoyalWarGameCtrl:EnterBetGame()
	self.view.txt_Countdown.text = countDownTime;
	self:SetBetButtonInteractable(true);
	self.view.obj_Countdown:SetActive(true);
	self.view.obj_BeginBet:SetActive(true);
	self.beginTimer2:Start();
	self.betCountDownTimer:Start();
end

---设置按钮的显示状态
function RoyalWarGameCtrl:SetBetButtonInteractable(state)
	self.view.btn_One.interactable = state;
	self.view.btn_Ten.interactable = state;
	self.view.btn_Fifty.interactable = state;
	self.view.btn_OneHundred.interactable = state;
	self.view.btn_FiveHundred.interactable = state;
end


---进入结算阶段
function RoyalWarGameCtrl:EnterSettlement()
	self.view.obj_StopBet:SetActive(true);
	self:SetBetButtonInteractable(false);
	
	self.view.obj_AboutEnd:SetActive(false);
	self.view.obj_CardBg:SetActive(true);
	self.view.obj_RoadRoot:SetActive(false)
	if self.SettlementCor then
		coroutine.stop(self.SettlementCor)
		self.SettlementCor=nil
	end
	self.SettlementCor=	CorManager:StartCor(function()--翻牌
		coroutine.wait(0.5)
		self.view.obj_StopBet:SetActive(false);
		self.view.obj_Settlement:SetActive(true);
		local redCardNumOne = self:GetCardNum();
		local redCardNumTwo = self:GetCardNum();
		local redCardNumThree = self:GetCardNum();
		
		local redCardColourOne =  (redCardNumOne - 1) / 13+1;
		local redCardColourTwo =  (redCardNumTwo - 1) / 13+1;
		local redCardColourThree =  (redCardNumThree - 1) / 13+1;

		local blackCardNumOne = self:GetCardNum();
		local blackCardNumTwo = self:GetCardNum();
		local blackCardNumThree = self:GetCardNum();
		
		local blackCardColourOne = (blackCardNumOne - 1) / 13+1;
		local blackCardColourTwo = (blackCardNumTwo - 1) / 13+1;
		local blackCardColourThree =  (blackCardNumThree - 1) / 13+1;
		
		self.view.img_RedCardOne.sprite = config.GetCardPic("card_"..redCardNumOne);
		self.view.img_RedCardTwo.sprite = config.GetCardPic("card_"..redCardNumTwo);
		self.view.img_RedCardThree.sprite = config.GetCardPic("card_"..redCardNumThree);
		
		self.view.img_BlackCardOne.sprite = config.GetCardPic("card_"..blackCardNumOne);
		self.view.img_BlackCardTwo.sprite = config.GetCardPic("card_"..blackCardNumTwo);
		self.view.img_BlackCardThree.sprite = config.GetCardPic("card_"..blackCardNumThree);
		
		self.RedCardType = config.GetCardType(redCardNumOne,redCardNumTwo,redCardNumThree,redCardColourOne,redCardColourTwo,redCardColourThree);
		self.BlackCardType = config.GetCardType(blackCardNumOne,blackCardNumTwo,blackCardNumThree,blackCardColourOne,blackCardColourTwo,blackCardColourThree);
		
		self.view.img_RedResultNumber.sprite =  config.GetIconCardTypePic(config.GetRedCardTypeName(self.RedCardType))
		self.view.img_BlackResultNumber.sprite =  config.GetIconCardTypePic(config.GetBlackCardTypeName(self.BlackCardType))
		if(self.RedCardType == config.CardType.DanZhang) then
			self.view.img_RedResultBg.sprite = config.GetIconPic("hhdz_dk_7")
		else
			self.view.img_RedResultBg.sprite = config.GetIconPic("hhdz_dk_8")
		end

		if(self.BlackCardType == config.CardType.DanZhang) then
			self.view.img_BlackResultBg.sprite = config.GetIconPic("hhdz_dk_7")
		else
			self.view.img_BlackResultBg.sprite = config.GetIconPic("hhdz_dk_8")
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
	return math.random(1,52);
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

---添加UI事件
function RoyalWarGameCtrl:AddUIEvent()
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
	

	self.uiEventListener:AddClick(self.view.btn_BetBlack,function()
		--下注庄家区域
		self:PlayChip(config.BetState.Black,CurSelectChip)
	end)

	self.uiEventListener:AddClick(self.view.btn_BetRed,function()
		--下注和区域
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
		targetRect = self.view.rect_BlackBetRegion;
		BetBlackAllNum = BetBlackAllNum+config.GetChipMoneyNum(selectChip);
		self.view.tmp_BlackBetNum.text = BetBlackAllNum;
	elseif 	selectBet == config.BetState.Red then -- 下注的红方
		targetRect = self.view.rect_RedBetRegion
		BetRedAllNum = BetRedAllNum + config.GetChipMoneyNum(selectChip);
		self.view.tmp_RedBetNum.text = BetRedAllNum;
	elseif 	selectBet == config.BetState.Lucky then -- 下注的幸运一击
		targetRect = self.view.rect_LuckyBetRegion
		BetLuckyAllNum = BetLuckyAllNum+config.GetChipMoneyNum(selectChip);
		self.view.tmp_LuckyBetNum.text = BetLuckyAllNum;
	end

	local chip = self.objPools:SpawnPrefab(nil,config.ABNames.chipPool,config.GetChipPoolName(selectChip),targetRect.transform)
	chip:SetActive(true)
	--chip.transform:SetParent(targetRect.transform,false)
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

	for _, v in ipairs(CardTypeTable) do
		---@type RoyalWarCardTypeItem
		local item =v;
		item:Destroy();
	end
	CardTypeObjTable ={};
	CardTypeData ={}
	CardTypeTable ={}
	self.RoyalWarScripts:Destroy()
end

return RoyalWarGameCtrl