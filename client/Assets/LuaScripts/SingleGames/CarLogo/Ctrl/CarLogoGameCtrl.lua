---
---Create by Administrator
---DateTime: 2025-06-30 15:05:04
---
---@class CarLogoGameCtrl:BaseCtrl
local CarLogoGameCtrl=Class("CarLogoGameCtrl",BaseCtrl)
local config =require("SingleGames/CarLogo/CarLogoConfig")

---构造函数
function CarLogoGameCtrl:ctor(ctrlName,param)
    self.layer=2;
    self.abName="SingleGames/CarLogo/prefabs/CarLogoGamePanel";
    self.prefabName="CarLogoGamePanel"
    self.super.ctor(self,ctrlName,param);
	---@type CarLogoGameView
	self.view = self.view
	---@type CarLogoGameModel
	self.model = self.model
end

---初始化
function CarLogoGameCtrl:CtrlInit(args)
	self.super.CtrlInit(self,args);
	self:InitData()
	TimerManager.StartTimer(self,function()    self:EnterRoom(args or 1)  end,1,0)
end

---初始化数据
function CarLogoGameCtrl:InitData()
	
end

function CarLogoGameCtrl:Close()
    self.super.Close(self);
end

function CarLogoGameCtrl:AddUIEvent()
	self:AddFunctionButtons()
	self:AddBetButtons()
	self:AddAreaClickEvents()
end

function CarLogoGameCtrl:AddFunctionButtons()
	self.uiEventListener:AddClick(self.view.btn_close, function() self:Close() end)
	self.uiEventListener:AddClick(self.view.btn_muen,function() self.view:SettingFade()  end)
	self.uiEventListener:AddClick(self.view.btn_touch,function() self.view:SettingFade()  end)
	self.uiEventListener:AddClick(self.view.btn_help, function() CtrlManager.SingleShow(CtrlNames.CarLogoRule) end)
	self.uiEventListener:AddClick(self.view.btn_setting, function() look("打开设置界面") end)
	self.uiEventListener:AddClick(self.view.btn_players, function()
		--CtrlManager.SingleShow(CtrlNames.BirdsAnimalsRule)
	end)
	self.uiEventListener:AddClick(self.view.btn_trend,function() CtrlManager.SingleShow(CtrlNames.CarLogoTrend,self.model.history) end)
	self.uiEventListener:AddClick(self.view.btn_repeat, function() self:RepeatBet() end)
	self.uiEventListener:AddClick(self.view.btn_prev,function()  self.view:DizhuPrev(false) end)
	self.uiEventListener:AddClick(self.view.btn_next,function()  self.view:DizhuPrev(true) end)
end


function CarLogoGameCtrl:AddBetButtons()
	for i, chipInfo in ipairs(self.view.chipInfos) do
		self.uiEventListener:AddClick(chipInfo.button, function()
			if config.allow then
				self.view:ChangeDiZhu(i)
				look("btn 抵住数值" .. config.dizhuNumArr[config.dizhuIndex])
			end
		end)
	end
end

function CarLogoGameCtrl:AddAreaClickEvents()
	for i=1,self.view.areasTrs.childCount do
		self.uiEventListener:AddClick(self.view.areasTrs:GetChild(i-1),function(obj)
			self:OnClickCenterYaZhuSide(i)
		end)
	end
end

function CarLogoGameCtrl:RepeatBet()
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
function CarLogoGameCtrl:OnClickCenterYaZhuSide(area)
	if config.allow == false then
		return
	end
	--local amount = config.dizhuNumArr[config.dizhuIndex]
	self:Bet(area, config.dizhuIndex)
end

-- 进入房间
function CarLogoGameCtrl:EnterRoom(roomType)
	WebNetworkManager.SendMsg(pb_CarLogo.ReqCarLogoEnterRoom, {roomType = roomType})
end

-- 押注
function CarLogoGameCtrl:Bet(side, amount)
	WebNetworkManager.SendMsg(pb_CarLogo.ReqCarLogoBetting, {side = side, amount = amount})
end

---移除UI事件
function CarLogoGameCtrl:RemoveEvent()
	self.super.RemoveEvent(self);
end

---模拟测试游戏流程
function CarLogoGameCtrl:Test()
	self.view:InitUI()
	
	CarLogoConfig.allow=true
	CarLogoConfig.currStatus=1
	CarLogoConfig.selfXiaZhuInfo = {}
	--CarLogoConfig.isRepeat = false
	self.view:UpdateDiZhuBtnState()
	self.view:SetRepeatState(CarLogoConfig.isRepeat)
	--复投功能
	self.view.btn_repeat.interactable = #CarLogoConfig.lastXiaZhuInfo>0

	--准备
	self.view:StartEffect(function()

		--下注
		local times= Tools.RandomInt(3,5)
		TimerManager.StartTimer(self, function
		()
			self.view:ChangeDiZhu(Tools.RandomInt(1,5))
			self:OnClickCenterYaZhuSide(Tools.RandomInt(1,8))
		end, 1, 3, true)
		--其他玩家下注消息
		TimerManager.StartTimer(self, function
		()
			GlobalEvent.Notify(CarLogoConfig.EventBinner.XIAZHU,{})
		end, 0.2, times, true)
		--下注结束结算
		TimerManager.StartTimer(self, function
		()
			local logo_id=Tools.RandomInt(1,8)
			local logo_index=CarLogoConfig.LOGO_IDX[logo_id][Tools.RandomInt(1,#CarLogoConfig.LOGO_IDX[logo_id])]
			local result = {win_carlogo={logo_index=logo_index,logo_id=logo_id},last_carlogo={logo_index=4,logo_id=4}}
			self.view:PlayResultAnimation(result)

			TimerManager.StartTimer(self, function
			()
				-- 播放赢的区域闪动
				self.view.areaViews[result.win_carlogo.logo_id]:ShowWinFlashAnim()
				---回收
				GlobalEvent.Notify(CarLogoConfig.EventBinner.XIAZHU_END,{})
			end,7,0,false)

			---复投功能
			if CarLogoConfig.isRepeat then
				CarLogoConfig.lastXiaZhuInfo={}
			else
				CarLogoConfig.lastXiaZhuInfo = CarLogoConfig.selfXiaZhuInfo
			end
			CarLogoConfig.selfXiaZhuInfo = {}
		end, CAR_LOGO_GAME_TIME+0.5, 0, true)

	end)
end
--endregion


---销毁UI
function CarLogoGameCtrl:RealCloseDestroy()
	self.super.RealCloseDestroy(self);
end

return CarLogoGameCtrl