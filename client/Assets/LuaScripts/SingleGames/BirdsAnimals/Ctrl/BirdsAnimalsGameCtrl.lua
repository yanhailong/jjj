---
---Create by Administrator
---DateTime: 2025-07-02 18:28:37
---
---@class BirdsAnimalsGameCtrl:BaseCtrl
local BirdsAnimalsGameCtrl=Class("BirdsAnimalsGameCtrl",BaseCtrl)
local config =require("SingleGames/BirdsAnimals/BirdsAnimalsConfig")
local BirdsAnimalsSounds = require("SingleGames/BirdsAnimals/BirdsAnimalsSounds")
---构造函数
function BirdsAnimalsGameCtrl:ctor(ctrlName,param)
    self.layer=2;
    self.abName="SingleGames/BirdsAnimals/prefabs/BirdsAnimalsGamePanel";
    self.prefabName="BirdsAnimalsGamePanel"
    self.super.ctor(self,ctrlName,param);
	---@type BirdsAnimalsGameView
	self.view = self.view
	---@type BirdsAnimalsGameModel
	self.model = self.model
end

---初始化
function BirdsAnimalsGameCtrl:CtrlInit(args)
	self.super.CtrlInit(self,args);
	self:InitData()
end

---初始化数据
function BirdsAnimalsGameCtrl:InitData()
	---@type ObjectPoolUtil
	self.objPools=ObjectPoolUtil.New()
	---@type CommFightBtnsCtrl
	self.commCtrl = CtrlManager.SingleShow(CtrlNames.CommFightBtns, self):AddAsyncOpenCallback(function()
		--请求进入房间
		self.model:ReqEnterRoom()
	end)
	self:BindCommFightData()
end


function BirdsAnimalsGameCtrl:BindCommFightData()
	self.commCtrl:BindData(config,false,self.view.xiazhuStarAreas)
	self.commCtrl.OnClickHelp = function()
		CtrlManager.SingleShow(CtrlNames.BirdsAnimalsRule)
	end
	self.commCtrl.OnClickClose = function()
		self:Close()
	end
	self.commCtrl.UpdateXiaZhuLabel = function()
		self.view:UpdateXiaZhuLabel()
	end
	self.commCtrl.PayOtherXiaZhuCoinFlyEnd = function()
		--下注音效
		BirdsAnimalsSounds.PlaySoundEffic(config.AUDIO_KEY.Bet)
	end
	self.commCtrl.PaySelfXiaZhuCoinFlyEnd = function()
		--下注音效
		BirdsAnimalsSounds.PlaySoundEffic(config.AUDIO_KEY.Bet)
	end
	self.commCtrl.PlayCompeleCoinFLyEnd = function()
		--分筹码音效
	end
	self.commCtrl.PlayCompeleCoinFLySelfEnd = function()
		-- 播放得奖音效
		BirdsAnimalsSounds.PlaySoundEffic(config.AUDIO_KEY.WinBet)
	end
end


function BirdsAnimalsGameCtrl:Close()
    self.super.Close(self);
end


function BirdsAnimalsGameCtrl:AddUIEvent()
	self:AddFunctionButtons()
	self:AddAreaClickEvents()
end

function BirdsAnimalsGameCtrl:AddFunctionButtons()
	self.uiEventListener:AddClick(self.view.btn_trend,function() CtrlManager.SingleShow(CtrlNames.BirdsAnimalsTrend,self.model.history) end)
	self.uiEventListener:AddClick(self.view.btn_repeat, function() self:RepeatBet() end)
end

function BirdsAnimalsGameCtrl:AddAreaClickEvents()
	for i=1,self.view.areasTrs.childCount do
		self.uiEventListener:AddClick(self.view.areasTrs:GetChild(i-1),function()
			self:OnClickCenterYaZhuSide(i)
		end)
	end
end

function BirdsAnimalsGameCtrl:RepeatBet()
	if #config.lastXiaZhuInfo > 0 and not config.isRepeat then
		config.isRepeat = true
		local ReqBet = { reqBetBeans = {} }
		for _, info in ipairs(config.lastXiaZhuInfo) do
			if not config.allow or self.model.betPointList[info.index] > PlayerManager:GetPlayerInfo().goldNum then
				goto continue
			end
			table.insert(ReqBet.reqBetBeans, {betValue = self.model.betPointList[info.index],betAreaIdx=config.gameID*100+info.side} )
			::continue::
		end
		self.view.btn_repeat.interactable = false
		self.model:Bet(ReqBet)
	end
end

---中心下注区域
function BirdsAnimalsGameCtrl:OnClickCenterYaZhuSide(area)
	if config.allow == false then
		return
	end
	local ReqBet = {
		reqBetBeans = {
			{betValue = self.model.betPointList[config.dizhuIndex],betAreaIdx=config.gameID*100+area}
		}
	}
	self.model:Bet(ReqBet)
end

---移除UI事件
function BirdsAnimalsGameCtrl:RemoveEvent()
	self.model:ExitRoom()
	self.super.RemoveEvent(self);
end

--endregion


---销毁UI
function BirdsAnimalsGameCtrl:RealCloseDestroy()
	self.super.RealCloseDestroy(self);
	CorManager.StopAll(self)
end

return BirdsAnimalsGameCtrl