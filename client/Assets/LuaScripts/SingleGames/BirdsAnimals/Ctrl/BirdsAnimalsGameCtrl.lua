---
---Create by Administrator
---DateTime: 2025-07-02 18:28:37
---
---@class BirdsAnimalsGameCtrl:BaseCtrl
local BirdsAnimalsGameCtrl=Class("BirdsAnimalsGameCtrl",BaseCtrl)
local config =require("SingleGames/BirdsAnimals/BirdsAnimalsConfig")

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
	TimerManager.StartTimer(self,function()    self:EnterRoom(args or 1)  end,1,0)
end

---初始化数据
function BirdsAnimalsGameCtrl:InitData()
	
end

function BirdsAnimalsGameCtrl:Close()
    self.super.Close(self);
end


function BirdsAnimalsGameCtrl:AddUIEvent()
	self:AddFunctionButtons()
	self:AddBetButtons()
	self:AddAreaClickEvents()
end

function BirdsAnimalsGameCtrl:AddFunctionButtons()
	self.uiEventListener:AddClick(self.view.btn_close, function() self:Close() end)
	self.uiEventListener:AddClick(self.view.btn_muen,function() self.view:SettingFade()  end)
	self.uiEventListener:AddClick(self.view.btn_touch,function() self.view:SettingFade()  end)
	self.uiEventListener:AddClick(self.view.btn_help, function() CtrlManager.SingleShow(CtrlNames.BirdsAnimalsRule) end)
	self.uiEventListener:AddClick(self.view.btn_setting, function() look("打开设置界面") end)
	self.uiEventListener:AddClick(self.view.btn_players, function()
		--CtrlManager.SingleShow(CtrlNames.BirdsAnimalsRule)
	end)
	self.uiEventListener:AddClick(self.view.btn_trend,function() CtrlManager.SingleShow(CtrlNames.BirdsAnimalsTrend,self.model.history) end)
	self.uiEventListener:AddClick(self.view.btn_repeat, function() self:RepeatBet() end)
	self.uiEventListener:AddClick(self.view.btn_prev,function()  self.view:DizhuPrev(false) end)
	self.uiEventListener:AddClick(self.view.btn_next,function()  self.view:DizhuPrev(true) end)
end


function BirdsAnimalsGameCtrl:AddBetButtons()
	for i, chipInfo in ipairs(self.view.chipInfos) do
		self.uiEventListener:AddClick(chipInfo.button, function()
			if config.allow then
				self.view:ChangeDiZhu(i)
				look("btn 抵住数值" .. config.dizhuNumArr[config.dizhuIndex])
			end
		end)
	end
end

function BirdsAnimalsGameCtrl:AddAreaClickEvents()
	for i=1,self.view.areasTrs.childCount do
		self.uiEventListener:AddClick(self.view.areasTrs:GetChild(i-1),function(obj)
			self:OnClickCenterYaZhuSide(i)
		end)
	end
end

function BirdsAnimalsGameCtrl:RepeatBet()
	if #config.lastXiaZhuInfo > 0 and not config.isRepeat then
		config.isRepeat = true
		for _, info in ipairs(config.lastXiaZhuInfo) do
			if not config.allow or config.currStatus ~= 1 or config.dizhuNumArr[info.index] > PlayerManager:GetPlayerInfo().goldNum then
				break
			end
			self:Bet(info.side,config.dizhuNumArr[info.index])
		end
		self.view.btn_repeat.interactable = false
	end
end

---中心下注区域
function BirdsAnimalsGameCtrl:OnClickCenterYaZhuSide(area)
	if config.allow == false then
		return
	end
	--local amount = config.dizhuNumArr[config.dizhuIndex]
	self:Bet(area, config.dizhuIndex)
end

-- 进入房间
function BirdsAnimalsGameCtrl:EnterRoom(roomType)
	WebNetworkManager.SendMsg(pb_BirdsAnimals.ReqBirdsAnimalsEnterRoom, {roomType = roomType})
end

-- 押注
function BirdsAnimalsGameCtrl:Bet(side, amount)
	WebNetworkManager.SendMsg(pb_BirdsAnimals.ReqBirdsAnimalsBetting, {side = side, amount = amount})
end

---移除UI事件
function BirdsAnimalsGameCtrl:RemoveEvent()
	self.super.RemoveEvent(self);
end

--endregion


---销毁UI
function BirdsAnimalsGameCtrl:RealCloseDestroy()
	self.super.RealCloseDestroy(self);
end

return BirdsAnimalsGameCtrl