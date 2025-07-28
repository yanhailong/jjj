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

	self.initState = false
	self.status = 1
	self.endTime = 0
	self.betPointList = {}
	self.sideBetInfos={}
	self.history = {}
	self.Result = {}
	self.bettingDataMap = {}
	self.AreaChipTotals = {0,0,0,0,0,0,0,0}
	self.playersNum=0
	self.lastIndex = 1
	--请求进入房间
	self:ReqEnterRoom()
end

function CarLogoGameModel:Close()
    self.super.Close(self);
end

function CarLogoGameModel:AddEvent()
	WebNetEvent.AddListener(pb_CarLogo.NotifyLuxuryCarClubTableInfo, self.OnEnterRoom, self)
	WebNetEvent.AddListener(pb_CarLogo.NotifyRoomReadyWait, self.OnGameStatus, self)
	WebNetEvent.AddListener(pb_CarLogo.NotifyLuxuryCarClubSettlement, self.OnGameResult, self)
	WebNetEvent.AddListener(pb_CarLogo.NotifyPlayerBet, self.OnBetting, self)
	WebNetEvent.AddListener(pb_CarLogo.NotifyTableRoomPlayerInfoChange, self.UpdatePlayerInfo, self)
	WebNetEvent.AddListener(pb_CarLogo.RespTablePlayerInfo,self.UpdateAllPlayers,self)
	WebNetEvent.AddListener(pb_CarLogo.NotifyPhaseChangInfo,self.OnStartXiaZhu,self)
end

function CarLogoGameModel:RemoveEvent()
	WebNetEvent.RemoveAllTo(self)
end

--region 事件方法
-- 进入房间请求
function CarLogoGameModel:ReqEnterRoom()
	WebNetworkManager.SendMsg(pb_CarLogo.ReqRoomBaseInfo)
end
-- 押注
function CarLogoGameModel:Bet(data)
	WebNetworkManager.SendMsg(pb_CarLogo.ReqBet, data)
end
--退出房间
function CarLogoGameModel:ExitRoom()
	WebNetworkManager.SendMsg(pb_PlatformHall.ReqExitGame)
end
--获取房间玩家信息
function CarLogoGameModel:ReqRoomPlayers()
	WebNetworkManager.SendMsg(pb_CarLogo.ReqTablePlayerInfo)
end
-- 进入房间返回 NotifyLoongTigerWarInfo
function CarLogoGameModel:OnEnterRoom(msg)
	self.betPointList = msg.betPointList
	self.sideBetInfos = msg.tableAreaInfos
	self.history = msg.settlementHistory or {}
	self.status = self:TransEGamePhase(msg.gamePhase)
	self.endTime = msg.tableCountDownTime
	self.playersNum = msg.totalPlayerNum
	self.Result = msg.settlementInfo

	self.view:UpdateRoomInfo(self)
	self.initState = true
	--如果有结果直接显示
	if self.Result then
		self:ShowResult()
	end
end

-- 广播玩家押注信息 NotifyPlayerBet 
function CarLogoGameModel:OnBetting(msg)
	if msg and msg.code == 200 and self.initState then
		--自己的直接显示
		if msg.playerId == PlayerManager:GetPlayerInfo().playerId then
			for _, value in ipairs(msg.betTableInfoList or {}) do
				local bet = {
					side = value.betIdx<config.gameID and value.betIdx or value.betIdx-config.gameID*100,
					index = self:FindBetIndex(value.betValue),
					currency = msg.playerCurGold,
					playerId = msg.playerId,
					betValue = value.betValue,
					betIdxTotal = value.betIdxTotal,--区域下标的总的押注数量
				}
				self.view:PayOtherXiaZhuCoinFly(bet)
			end
			return
		end
		--其他玩家批量更新
		msg.handled = false
		if self.bettingDataMap[msg.playerId] and not self.bettingDataMap[msg.playerId].handled then
			for i = 1, #msg.betTableInfoList do
				table.insert(self.bettingDataMap[msg.playerId].betTableInfoList, msg.betTableInfoList[i])
			end
			msg.betTableInfoList = self.bettingDataMap[msg.playerId].betTableInfoList
			self.bettingDataMap[msg.playerId] = msg
		else
			self.bettingDataMap[msg.playerId] = msg
		end
	end
end

-- 重新开始游戏的消息 NotifyRoomReadyWait
function CarLogoGameModel:OnGameStatus(msg)
	if  not self.initState then return end
	self.view:OnGameStatus(4)
	self.status = 1
	self.endTime = msg.waitEndTime
	logError("OnGameStatus:"..os.date("%H:%M:%S", math.modf(self.endTime/1000)))
	self.view:OnGameStatus(self.status)
	self.bettingDataMap = {}
	self:OnStartXiaZhu(msg)
end
--收到开始下注消息
function CarLogoGameModel:OnStartXiaZhu(msg)
	if not self.initState then return end
	self.status = 2
	self.endTime = msg.waitEndTime
	self.view:OnGameStatus(self.status)
end

-- 房间玩家信息更新
function CarLogoGameModel:UpdatePlayerInfo(msg)
	if self.initState and msg.tableChangedPlayerInfos then
		self.playersNum = msg.totalPlayerNum
		self.view:UpdatePlayerTotal()
	end
end

-- 广播结算信息 NotifyLoongTigerWarSettleInfo
function CarLogoGameModel:OnGameResult(msg)
	if not self.initState and msg.code ~=200 then return end
	self.Result = msg.settlementInfo;
	self.endTime = msg.settlementInfo.tableCountDownTime;
	table.insert(self.history,self.Result.rewardAreaIdx)
	logError("OnGameResult:"..os.date("%H:%M:%S", math.modf(self.Result.tableCountDownTime/1000)))
	--切换状态
	self.status = 3
	self.view:OnGameStatus(self.status)

	self:ShowResult()
end

function CarLogoGameModel:ShowResult()
	if not self.initState then return end
	---显示牌面结果
	self.view:ResultEffect(self.Result)
end
--玩家列表信息返回 
function CarLogoGameModel:UpdateAllPlayers(msg)
	if msg.code == 200 and msg.tablePlayerInfo then
		require("Logic/Common/PlayerRankPanel/MVCHead")
		CtrlManager.SingleShow(CtrlNames.PlayerRankPanel,msg.tablePlayerInfo)
	end
end

function CarLogoGameModel:ResetConfig()
	for i=1,#config.selfDiZhuNums do
		config.selfDiZhuNums[i]=0
		config.totalDiZhuNums[i]=0
	end
	self.sideBetInfos={}
	self.Result = {}
	self.bettingDataMap = {}
	self.AreaChipTotals = {0,0,0,0,0,0,0,0}
end

--endregion
function CarLogoGameModel:FindBetIndex(value)
	for i=1,#self.betPointList do
		if self.betPointList[i]==value then
			return i
		end
	end
	return nil
end

function CarLogoGameModel:TransEGamePhase(value)
	--[准备阶段时间-毫秒，押分阶段时间-毫秒，亮牌阶段时间-毫秒，结算阶段-毫秒]
	if value == "WAIT_READY" or "START_GAME" == 0  then return 1 end
	if value == "BET" then return 2 end
	if value == "PLAY_CART" or "GAME_ROUND_OVER_SETTLEMENT" then return 3 end
	--if value == "GAME_ROUND_OVER_SETTLEMENT" then return 4 end
	return 5
end

return CarLogoGameModel