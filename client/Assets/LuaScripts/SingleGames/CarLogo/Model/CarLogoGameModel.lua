---
---Create by Administrator
---DateTime: 2025-06-30 15:05:04
---
---@class CarLogoGameModel:BaseModel
local CarLogoGameModel=Class("CarLogoGameModel",BaseModel)
local config =require("SingleGames/CarLogo/CarLogoConfig")

function CarLogoGameModel:Awake()
	self.super.Awake(self);
	---@type CarLogoGameCtrl
	self.ctrl=self.ctrl

	self.players = {}
	self.sideBetInfos={}
	self.history = {}
	self.Result = {}
	self.AreaChipTotals = {0,0,0,0,0,0,0,0}
end

function CarLogoGameModel:Close()
    self.super.Close(self);
end

function CarLogoGameModel:AddEvent()
	WebNetEvent.AddListener(pb_CarLogo.ResCarLogoEnterRoom, self.OnEnterRoom, self)
	WebNetEvent.AddListener(pb_CarLogo.ResCarLogoBetting, self.OnBetting, self)
	WebNetEvent.AddListener(pb_CarLogo.ResCarLogoGameStatus, self.OnGameStatus, self)
	WebNetEvent.AddListener(pb_CarLogo.ResCarLogoPlayerEnterRoom, self.OnPlayerEnterRoom, self)
	WebNetEvent.AddListener(pb_CarLogo.ResCarLogoPlayerLeaveRoom, self.OnPlayerLeaveRoom, self)
	WebNetEvent.AddListener(pb_CarLogo.ResCarLogoGameResult, self.OnGameResult, self)
end

function CarLogoGameModel:RemoveEvent()
	WebNetEvent.Remove(pb_CarLogo.ResCarLogoEnterRoom, self.OnEnterRoom, self)
	WebNetEvent.Remove(pb_CarLogo.ResCarLogoBetting, self.OnBetting, self)
	WebNetEvent.Remove(pb_CarLogo.ResCarLogoGameStatus, self.OnGameStatus, self)
	WebNetEvent.Remove(pb_CarLogo.ResCarLogoPlayerEnterRoom, self.OnPlayerEnterRoom, self)
	WebNetEvent.Remove(pb_CarLogo.ResCarLogoPlayerLeaveRoom, self.OnPlayerLeaveRoom, self)
	WebNetEvent.Remove(pb_CarLogo.ResCarLogoGameResult, self.OnGameResult, self)
end

--region 事件方法
-- 进入房间返回
function CarLogoGameModel:OnEnterRoom(msg)
	self.roomId = msg.roomId
	self.config = msg.config
	self.sideBetInfos = msg.sideBetInfos
	self.players = msg.players
	self.history = msg.history
	self.status = msg.status
	self.seconds = msg.seconds
	if self.ctrl and self.ctrl.view and self.ctrl.view.UpdateRoomInfo then
		self.ctrl.view:UpdateRoomInfo(self)
	end
end

-- 广播玩家押注信息
function CarLogoGameModel:OnBetting(msg)
	-- msg.betList: {BetInfo}
	if self.ctrl and self.ctrl.view and self.ctrl.view.PayOtherXiaZhuCoinFly then
		for _, bet in ipairs(msg.betList or {}) do
			self.ctrl.view:PayOtherXiaZhuCoinFly(bet)
		end
	end
end

-- 广播切换状态
function CarLogoGameModel:OnGameStatus(msg)
	self.status = msg.status
	self.seconds = msg.seconds
	if self.ctrl and self.ctrl.view and self.ctrl.view.OnGameStatus then
		self.ctrl.view:OnGameStatus(msg.status, msg.seconds)
	end
end

-- 广播玩家进入房间
function CarLogoGameModel:OnPlayerEnterRoom(msg)
	if msg.player then
		for _, p in ipairs(msg.player) do
			table.insert(self.players, p)
		end
		if self.ctrl and self.ctrl.view and self.ctrl.view.UpdatePlayers then
			self.ctrl.view:UpdatePlayerTotal(#self.players)
		end
	end
end

-- 广播玩家离开房间
function CarLogoGameModel:OnPlayerLeaveRoom(msg)
	if msg.userId then
		for i, p in ipairs(self.players) do
			if p.id == msg.userId then
				table.remove(self.players, i)
				break
			end
		end
		if self.ctrl and self.ctrl.view and self.ctrl.view.UpdatePlayers then
			self.ctrl.view:UpdatePlayerTotal(#self.players)
		end
	end
end

-- 广播结算信息
function CarLogoGameModel:OnGameResult(msg)
	self.Result = msg;
	if #self.history>=50 then
		self.history = {}
	end
	table.insert(self.history,msg.winSide)
	if self.ctrl and self.ctrl.view and self.ctrl.view.ResultEffect then
		---显示结果
		self.ctrl.view:ResultEffect(msg)
	end
end

function CarLogoGameModel:ResetConfig()
	for i=1,#config.selfDiZhuNums do
		config.selfDiZhuNums[i]=0
		config.totalDiZhuNums[i]=0
	end
	self.sideBetInfos={}
	self.Result = {}
	self.AreaChipTotals = {0,0,0,0,0,0,0,0}
end

---------------
---收到玩家下注消息
function CarLogoGameModel:PlayerXiaZhu()
	local data  = {id=Tools.RandomInt(1,30),dizhuType=Tools.RandomInt(1,5),areaType=Tools.RandomInt(1,8)}
	CarLogoConfig.allXiaZhuData[#CarLogoConfig.allXiaZhuData+1] = data
	CarLogoConfig.totalDiZhuNums[data.areaType] = CarLogoConfig.totalDiZhuNums[data.areaType]+CarLogoConfig.dizhuNumArr[data.dizhuType]

	self.ctrl.view:PayOtherXiaZhuCoinFly(data)
end

---下注完成结算
function CarLogoGameModel:OnXiaZhuComplete()
	---牌面结果信息
	local cards = {Tools.RandomInt(1,13),Tools.RandomInt(1,13)}
	---显示结果动画
	---回收金币奖励动画
	self.ctrl.view:PlayCompeleCoinFLy(CarLogoConfig.allXiaZhuData,self.players,cards)

	---清理下注数据
	CarLogoConfig.allXiaZhuData = {}
end

--endregion


return CarLogoGameModel