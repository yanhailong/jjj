---
---Create by Administrator
---DateTime: 2025-06-21 17:21:49
---
---@class BaccaratGameCtrl:BaseCtrl
local BaccaratGameCtrl=Class("BaccaratGameCtrl",BaseCtrl)
---@type BaccaratConfig
local config=require"SingleGames/Baccarat/BaccaratConfig"
---游戏阶段
local  gameStage ={
	Begin = 1,--开始阶段
	Bet =2,--下注阶段
	Settlement =3,--结算阶段
}

local curGameStage = gameStage.Begin;
---下注倒计时
local countDownTime = 12;
---闲家是否是对子
local playerIsPairing;
---庄家是否是对子
local BankerIsPairing;
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

	self.beginTimer = TimerManager:CreateTimer(function()
		self.view.obj_VS:SetActive(false);
		curGameStage = gameStage.Bet;
		self:RefreshGameStage();
	end,1,1,true);
	
	self.betCountDownTimer = TimerManager:CreateTimer(function()
		countDownTime = countDownTime-1;
		self.view.tmp_Countdown.text = countDownTime;
		if countDownTime<=0 then
			curGameStage =gameStage.Settlement;
			self:RefreshGameStage();
		end
	end,1,12,true);
end

---初始化
function BaccaratGameCtrl:CtrlInit(args)
	self.super.CtrlInit(self,args);
	config.InitIconPic();
	self:InitData()
end

---初始化数据
function BaccaratGameCtrl:InitData()
	curGameStage = gameStage.Begin;
	---从服务器那边拿数据然后看在哪个阶段了，目前写一个假数据每次进来都是第一阶段
	self:RefreshGameStage()
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
	self:SetBetButtonInteractable(true);
	self.view.obj_Countdown:SetActive(true);
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
---进入结算阶段
function BaccaratGameCtrl:EnterSettlement()
	self:SetBetButtonInteractable(false);
	self.view.obj_Countdown:SetActive(false);
	--显示发牌区域
	self.view.obj_DealCards:SetActive(true);
	if self.SettlementCor then
		coroutine.stop(self.SettlementCor)
		self.SettlementCor=nil
	end
	self.SettlementCor=	CorManager:StartCor(function()
		coroutine.wait(1)
		local playerCard1 = self.model:GetCardNum();
		ComponentUtilGet.Image(self.view.ator_PlayerCard1.transform,"CardImage").sprite = config.GetIconPic("card2_club_"..playerCard1);
		self.view.ator_PlayerCard1:Play("FlipCards");
		coroutine.wait(0.5)
		local playerCard2 = self.model:GetCardNum();
		ComponentUtilGet.Image(self.view.ator_PlayerCard2.transform,"CardImage").sprite = config.GetIconPic("card2_club_"..playerCard2);
		self.view.ator_PlayerCard2:Play("FlipCards");
		playerIsPairing = playerCard1 == playerCard2;
		playerCard1 = self:GetCardPoint(playerCard1);
		playerCard2 = self:GetCardPoint(playerCard2);
		local playerCardNum = playerCard1 + playerCard2;
		local playerIsKing = playerCardNum == 8 or playerCardNum == 9;
		self.view.obj_PlayerKing:SetActive(playerIsKing)
		coroutine.wait(0.75)
		local BankerCard1 =  self.model:GetCardNum();
		ComponentUtilGet.Image(self.view.ator_BankerCard1.transform,"CardImage").sprite = config.GetIconPic("card2_club_"..playerCard1);
		self.view.ator_BankerCard1:Play("FlipCards");
		coroutine.wait(0.5)
		local BankerCard2 = self.model:GetCardNum();
		ComponentUtilGet.Image(self.view.ator_BankerCard2.transform,"CardImage").sprite = config.GetIconPic("card2_club_"..playerCard2);
		self.view.ator_BankerCard2:Play("FlipCards");
		BankerIsPairing = BankerCard1 ==BankerCard2;
		BankerCard1 = self:GetCardPoint(BankerCard1);
		BankerCard2 = self:GetCardPoint(BankerCard2);
		local BankerCardNum = BankerCard1 + BankerCard2;
		local BankerIsKing = BankerCardNum == 8 or BankerCardNum == 9;
		self.view.obj_PlayerKing:SetActive(BankerIsKing)
		if playerIsKing or BankerIsKing then
			--不用补牌直接比大小结算
			self.view.tmp_PlayerPoint.text = playerCardNum;
			self.view.obj_PlayerPoints:SetActive(true);
			coroutine.wait(0.5)
			self.view.tmp_BankerPoint.text = BankerCardNum;
			self.view.obj_BankerPoints:SetActive(true);
			coroutine.wait(0.5)
			self.view.obj_HeWin:SetActive(playerCardNum == BankerCardNum);
			self.view.obj_ZWin:SetActive(BankerCardNum>playerCardNum);
			self.view.obj_XWin:SetActive(playerCardNum>BankerCardNum);
			if playerCardNum == BankerCardNum then--和
				---@type DG.Tweening.Tween
				self.TieWinImageDoFade =  ComponentUtilGet.Image(self.view.obj_TieWin.transform):DOFade(1,0.5)
				self.TieWinImageDoFade:SetLoops(3, DG.Tweening.LoopType.Yoyo);
				self.TieWinImageDoFade:SetEase(DG.Tweening.Ease.Linear);
				self.TieWinImageDoFade.onComplete=function()
					--飞筹码到对应的玩家身上
					self.TieWinImageDoFade:Kill();
				end
			elseif BankerCardNum>playerCardNum then--庄赢
				---@type DG.Tweening.Tween
				self.BankerWinImageDoFade =  ComponentUtilGet.Image(self.view.obj_BankerWin.transform):DOFade(1,0.5)
				self.BankerWinImageDoFade:SetLoops(3, DG.Tweening.LoopType.Yoyo);
				self.BankerWinImageDoFade:SetEase(DG.Tweening.Ease.Linear);
				self.BankerWinImageDoFade.onComplete=function()
					--飞筹码到对应的玩家身上
					self.BankerWinImageDoFade:Kill();
				end
				
			elseif playerCardNum>BankerCardNum then--闲赢
				---@type DG.Tweening.Tween
				self.PlayerWinImageDoFade =  ComponentUtilGet.Image(self.view.obj_PlayerWin.transform):DOFade(1,0.5)
				self.PlayerWinImageDoFade:SetLoops(3, DG.Tweening.LoopType.Yoyo);
				self.PlayerWinImageDoFade:SetEase(DG.Tweening.Ease.Linear);
				self.PlayerWinImageDoFade.onComplete=function()
					--飞筹码到对应的玩家身上
					self.PlayerWinImageDoFade:Kill();
				end
			end

			if BankerIsPairing then--庄家对子
				---@type DG.Tweening.Tween
				self.PPairWinImageDoFade =  ComponentUtilGet.Image(self.view.obj_PPairWin.transform):DOFade(1,0.5)
				self.PPairWinImageDoFade:SetLoops(3, DG.Tweening.LoopType.Yoyo);
				self.PPairWinImageDoFade:SetEase(DG.Tweening.Ease.Linear);
				self.PPairWinImageDoFade.onComplete=function()
					self.PPairWinImageDoFade:Kill();
				end
			end

			if playerIsPairing then--闲对子
				---@type DG.Tweening.Tween
				self.BPairWinImageDoFade =  ComponentUtilGet.Image(self.view.obj_BPairWin.transform):DOFade(1,0.5)
				self.BPairWinImageDoFade:SetLoops(3, DG.Tweening.LoopType.Yoyo);
				self.BPairWinImageDoFade:SetEase(DG.Tweening.Ease.Linear);
				self.BPairWinImageDoFade.onComplete=function()
					self.BPairWinImageDoFade:Kill();
				end
			end
			
		else
			
		end
		
	end)
	--开始发牌（发完牌后看下要不要补牌）
	--比牌
end

---获取真正的点数
function BaccaratGameCtrl:GetCardPoint(point)
	if(point >=10) then
		return 0
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
		--选中1块的筹码
		self:SetCheckedShow(1);
	end)
	self.uiEventListener:AddClick(self.view.btn_Ten,function()
		--选中1块的筹码
		self:SetCheckedShow(10);
	end)
	self.uiEventListener:AddClick(self.view.btn_Fifty,function()
		self:SetCheckedShow(50);
	end)
	self.uiEventListener:AddClick(self.view.btn_OneHundred,function()
		self:SetCheckedShow(100);
	end)
	self.uiEventListener:AddClick(self.view.btn_FiveHundred,function()
		self:SetCheckedShow(500);
	end)
end
---选中哪个筹码
function BaccaratGameCtrl:SetCheckedShow(state)
	self.view.obj_checkedOne:SetActive(state ==1);
	self.view.obj_checkedTen:SetActive(state ==10);
	self.view.obj_checkedFifty:SetActive(state ==50);
	self.view.obj_checkedOneHundred:SetActive(state ==100);
	self.view.obj_checkedFiveHundred:SetActive(state ==500);
end

---移除UI事件
function BaccaratGameCtrl:RemoveEvent()
	self.super.RemoveEvent(self);
	TimerManager.StopAllTimer(self)
end

--region UI事件方法

--endregion


---销毁UI
function BaccaratGameCtrl:RealCloseDestroy()
	self.super.RealCloseDestroy(self);
end

return BaccaratGameCtrl