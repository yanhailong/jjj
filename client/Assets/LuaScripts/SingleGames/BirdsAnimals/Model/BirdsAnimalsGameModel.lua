---
---Create by Administrator
---DateTime: 2025-07-02 18:28:37
---
---@class BirdsAnimalsGameModel:BaseModel
local BirdsAnimalsGameModel=Class("BirdsAnimalsGameModel",BaseModel)
local config =require("SingleGames/BirdsAnimals/BirdsAnimalsConfig")

function BirdsAnimalsGameModel:Awake()
	self.super.Awake(self);
	---@type BirdsAnimalsGameCtrl
	self.ctrl=self.ctrl

	self.initState = false
	self.status = 1
	self.endTime = 0
	self.betPointList = {}
	self.sideBetInfos={}
	self.history = {}
	self.Result = {}
	self.playersNum=0
	self.lastIndex = 1
	config.AreaChipTotals = {0,0,0,0,0,0,0,0,0,0,0,0,0,0}
	config.bettingDataMap = {}
end

function BirdsAnimalsGameModel:Close()
    self.super.Close(self);
end

function BirdsAnimalsGameModel:AddEvent()
	WebNetEvent.AddListener(pb_comonFight.NotifyAnimalsTableInfo, self.OnEnterRoom, self)
	WebNetEvent.AddListener(pb_comonFight.NotifyRoomReadyWait, self.OnGameStatus, self)
	WebNetEvent.AddListener(pb_comonFight.NotifyAnimalsSettlement, self.OnGameResult, self)
	WebNetEvent.AddListener(pb_comonFight.NotifyPlayerBet, self.OnBetting, self)
	WebNetEvent.AddListener(pb_comonFight.NotifyTableRoomPlayerInfoChange, self.UpdatePlayerInfo, self)
	WebNetEvent.AddListener(pb_comonFight.RespTablePlayerInfo,self.UpdateAllPlayers,self)
	WebNetEvent.AddListener(pb_comonFight.NotifyPhaseChangInfo,self.OnStartXiaZhu,self)
end

function BirdsAnimalsGameModel:RemoveEvent()
	WebNetEvent.RemoveAllTo(self)
end

--region 事件方法
-- 进入房间请求
function BirdsAnimalsGameModel:ReqEnterRoom()
	WebNetworkManager.SendMsg(pb_comonFight.ReqRoomBaseInfo)
end
-- 押注
function BirdsAnimalsGameModel:Bet(data)
	WebNetworkManager.SendMsg(pb_comonFight.ReqBet, data)
end
--退出房间
function BirdsAnimalsGameModel:ExitRoom()
	WebNetworkManager.SendMsg(pb_PlatformHall.ReqExitGame)
end
--获取房间玩家信息
function BirdsAnimalsGameModel:ReqRoomPlayers()
	WebNetworkManager.SendMsg(pb_comonFight.ReqTablePlayerInfo)
end
-- 进入房间返回 NotifyLoongTigerWarInfo
function BirdsAnimalsGameModel:OnEnterRoom(msg)
	self.betPointList = msg.betPointList
	self.sideBetInfos = msg.tableAreaInfos
	self.history = self:SetHistory(msg.settlementHistory)
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
function BirdsAnimalsGameModel:OnBetting(msg)
	if msg and msg.code == 200 and self.initState and self.ctrl.commCtrl then
		--自己的直接显示
		if msg.playerId == PlayerManager:GetPlayerInfo().playerId then
			for _, value in ipairs(msg.betTableInfoList or {}) do
				local bet = {
					side = value.betIdx<config.gameID and value.betIdx or value.betIdx-config.gameID*100,
					index = self.ctrl.commCtrl:FindBetIndex(value.betValue),
					currency = msg.playerCurGold,
					playerId = msg.playerId,
					betValue = value.betValue,
					betIdxTotal = value.betIdxTotal,--区域下标的总的押注数量
				}
				self.ctrl.commCtrl:PayOtherXiaZhuCoinFly(bet)
			end
			return
		end
		--其他玩家批量更新
		msg.handled = false
		if config.bettingDataMap[msg.playerId] and not config.bettingDataMap[msg.playerId].handled then
			for i = 1, #msg.betTableInfoList do
				table.insert(config.bettingDataMap[msg.playerId].betTableInfoList, msg.betTableInfoList[i])
			end
			msg.betTableInfoList = config.bettingDataMap[msg.playerId].betTableInfoList
			config.bettingDataMap[msg.playerId] = msg
		else
			config.bettingDataMap[msg.playerId] = msg
		end
	end
end

-- 重新开始游戏的消息 NotifyRoomReadyWait
function BirdsAnimalsGameModel:OnGameStatus(msg)
	if  not self.initState then return end
	self.view:OnGameStatus(4)
	self.status = 1
	self.endTime = msg.waitEndTime
	logError("OnGameStatus:"..os.date("%H:%M:%S", math.modf(self.endTime/1000)))
	self.view:OnGameStatus(self.status)
	config.bettingDataMap = {}
	self:OnStartXiaZhu(msg)
end
--收到开始下注消息
function BirdsAnimalsGameModel:OnStartXiaZhu(msg)
	if not self.initState then return end
	self.status = 2
	self.endTime = msg.waitEndTime
	self.view:OnGameStatus(self.status)
end

-- 房间玩家信息更新
function BirdsAnimalsGameModel:UpdatePlayerInfo(msg)
	if self.initState and msg.tableChangedPlayerInfos then
		self.playersNum = msg.totalPlayerNum
		self.view:UpdatePlayerTotal()
	end
end

-- 广播结算信息 NotifyLoongTigerWarSettleInfo
function BirdsAnimalsGameModel:OnGameResult(msg)
	if not self.initState and msg.code ~=200 then return end
	self.Result = msg.settlementInfo;
	self.endTime = self.Result.tableCountDownTime;
	table.insert(self.history,self.Result.rewardAreaIdx)
	logError("OnGameResult:"..os.date("%H:%M:%S", math.modf(self.Result.tableCountDownTime/1000)))
	--切换状态
	self.status = 3
	self.view:OnGameStatus(self.status)

	self:ShowResult()
end

function BirdsAnimalsGameModel:ShowResult()
	if not self.initState then return end
	---显示牌面结果
	self.view:ResultEffect(self.Result)
end
--玩家列表信息返回 
function BirdsAnimalsGameModel:UpdateAllPlayers(msg)
	if msg.code == 200 and msg.tablePlayerInfo then
		CtrlManager.SingleShow(CtrlNames.PlayerRankPanel,msg.tablePlayerInfo)
	end
end

function BirdsAnimalsGameModel:ResetConfig()
	self.sideBetInfos={}
	self.Result = {}
	for i=1,#config.selfDiZhuNums do
		config.selfDiZhuNums[i]=0
		config.totalDiZhuNums[i]=0
	end
	config.AreaChipTotals = {0,0,0,0,0,0,0,0,0,0,0,0,0,0}
	config.bettingDataMap = {}
end

--endregion

function BirdsAnimalsGameModel:TransEGamePhase(value)
	--[准备阶段时间-毫秒，押分阶段时间-毫秒，亮牌阶段时间-毫秒，结算阶段-毫秒]
	if value == "WAIT_READY" or "START_GAME" == 0  then return 1 end
	if value == "BET" then return 2 end
	if value == "PLAY_CART" or "GAME_ROUND_OVER_SETTLEMENT" then return 3 end
	--if value == "GAME_ROUND_OVER_SETTLEMENT" then return 4 end
	return 5
end

function BirdsAnimalsGameModel:SetHistory(tables)
	local history = {}
	if not tables then return history end
	for i=1,#tables do
		table.insert(history,tables[i].betIdxId)
	end
	return history
end

return BirdsAnimalsGameModel