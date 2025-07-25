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
	self.players = {} -- 前6玩家信息
	self.sideBetInfos={}
	self.history = {}
	self.Result = {}
	self.AreaChipTotals = {0,0,0,0,0,0,0,0,0,0,0,0,0,0}
	self.playersNum=0
	--请求进入房间
	self:ReqEnterRoom()
end

function BirdsAnimalsGameModel:Close()
    self.super.Close(self);
end

function BirdsAnimalsGameModel:AddEvent()
	WebNetEvent.AddListener(pb_BirdsAnimals.NotifyAnimalsTableInfo, self.OnEnterRoom, self)
	WebNetEvent.AddListener(pb_BirdsAnimals.NotifyRoomReadyWait, self.OnGameStatus, self)
	WebNetEvent.AddListener(pb_BirdsAnimals.NotifyAnimalsSettlement, self.OnGameResult, self)
	WebNetEvent.AddListener(pb_BirdsAnimals.NotifyPlayerBet, self.OnBetting, self)
	WebNetEvent.AddListener(pb_BirdsAnimals.NotifyTableRoomPlayerInfoChange, self.UpdatePlayerInfo, self)
	WebNetEvent.AddListener(pb_BirdsAnimals.RespTablePlayerInfo,self.UpdateAllPlayers,self)
	WebNetEvent.AddListener(pb_BirdsAnimals.NotifyPhaseChangInfo,self.OnStartXiaZhu,self)
end

function BirdsAnimalsGameModel:RemoveEvent()
	WebNetEvent.RemoveAllTo(self)
end

--region 事件方法
-- 进入房间请求
function BirdsAnimalsGameModel:ReqEnterRoom()
	WebNetworkManager.SendMsg(pb_BirdsAnimals.ReqRoomBaseInfo)
end
-- 押注
function BirdsAnimalsGameModel:Bet(data)
	WebNetworkManager.SendMsg(pb_BirdsAnimals.ReqBet, data)
end
--退出房间
function BirdsAnimalsGameModel:ExitRoom()
	WebNetworkManager.SendMsg(pb_PlatformHall.ReqExitGame)
end
--获取房间玩家信息
function BirdsAnimalsGameModel:ReqRoomPlayers()
	WebNetworkManager.SendMsg(pb_BirdsAnimals.ReqTablePlayerInfo)
end
-- 进入房间返回 NotifyLoongTigerWarInfo
function BirdsAnimalsGameModel:OnEnterRoom(msg)
	self.betPointList = msg.betPointList
	self.sideBetInfos = msg.tableAreaInfos
	self.history = msg.histories
	self.players = msg.playerInfos
	self.status = self:TransEGamePhase(msg.gamePhase)
	self.endTime = msg.tableCountDownTime
	self.playersNum = msg.totalPlayerNum
	self.Result = msg.settleInfos --NotifyLoongTigerWarSettleInfo 结算信息
	self.ctrl.view:UpdateRoomInfo(self)
	self.initState = true
	--如果有结果直接显示
	if self.Result then
		self:ShowResult()
	end
end

-- 广播玩家押注信息 NotifyPlayerBet 
function BirdsAnimalsGameModel:OnBetting(msg)
	if msg and msg.code == 200 and self.initState then
		for _, value in ipairs(msg.betTableInfoList or {}) do
			local bet = {
				side = value.betIdx<config.gameID and value.betIdx or value.betIdx-config.gameID*100,
				index = self:FindBetIndex(value.betValue),
				currency = msg.playerCurGold,
				playerId = msg.playerId,
				betValue = value.betValue,
				betIdxTotal = value.betIdxTotal,--区域下标的总的押注数量
			}
			self.ctrl.view:PayOtherXiaZhuCoinFly(bet)
		end
	end
end

-- 重新开始游戏的消息 NotifyRoomReadyWait
function BirdsAnimalsGameModel:OnGameStatus(msg)
	if  not self.initState then return end
	self.status = 1
	self.endTime = msg.waitEndTime
	self.ctrl.view:OnGameStatus(self.status)
end
--收到开始下注消息
function BirdsAnimalsGameModel:OnStartXiaZhu(msg)
	self.status = 2
	self.endTime = msg.waitEndTime
	self.ctrl.view:OnGameStatus(self.status)
end

-- 房间玩家信息更新
function BirdsAnimalsGameModel:UpdatePlayerInfo(msg)
	if self.initState and msg.tableChangedPlayerInfos then
		self.players = msg.tableChangedPlayerInfos
		self.playersNum = msg.totalPlayerNum
		self.ctrl.view:UpdatePlayers(self.players)
	end
end

-- 广播结算信息 NotifyLoongTigerWarSettleInfo
function BirdsAnimalsGameModel:OnGameResult(msg)
	if not self.initState then return end
	self.Result = msg;
	if #self.history>=50 then
		self.history = {}
	end
	table.insert(self.history,msg.winState)

	--切换状态
	self.status = 3
	self.ctrl.view:OnGameStatus(self.status)

	self:ShowResult()
end

function BirdsAnimalsGameModel:ShowResult()
	self.players = self.Result.playerInfos --前6玩家信息
	---显示牌面结果
	self.ctrl.view:ResultEffect(self.Result)
end
--玩家列表信息返回 
function BirdsAnimalsGameModel:UpdateAllPlayers(msg)
	if msg.code == 200 and msg.tablePlayerInfo then
		require("Logic/Common/PlayerRankPanel/MVCHead")
		CtrlManager.SingleShow(CtrlNames.PlayerRankPanel,msg.tablePlayerInfo)
	end
end

function BirdsAnimalsGameModel:ResetConfig()
	for i=1,#config.selfDiZhuNums do
		config.selfDiZhuNums[i]=0
		config.totalDiZhuNums[i]=0
	end
	self.sideBetInfos={}
	self.Result = {}
	self.AreaChipTotals = {0,0,0,0,0,0,0,0,0,0,0,0,0,0}
end

--endregion
function BirdsAnimalsGameModel:FindBetIndex(value)
	for i=1,#self.betPointList do
		if self.betPointList[i]==value then
			return i
		end
	end
	return nil
end

function BirdsAnimalsGameModel:TransEGamePhase(value)
	--[准备阶段时间-毫秒，押分阶段时间-毫秒，亮牌阶段时间-毫秒，结算阶段-毫秒]
	if value == "WAIT_READY" or "START_GAME" == 0  then return 1 end
	if value == "BET" then return 2 end
	if value == "PLAY_CART" then return 3 end
	if value == "GAME_ROUND_OVER_SETTLEMENT" then return 4 end
	return 5
end


return BirdsAnimalsGameModel