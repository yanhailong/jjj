--
--time:{time}
--{paramdesc} 
--@desc 
--
---@class DiceSizeSimulationServer
DiceSizeSimulationServer = Class("DiceSizeSimulationServer")
local DicePointsSumSizeConfig = require("SingleGames/DicePointsSumSize/DicePointsSumSizeConfig")

local this = DiceSizeSimulationServer

this.isRunning = false
this.timeoutTimer = nil
this.status = nil
this.playerArr = {}
this.stateStartTime = Time.time;
this.dices = {}
this.areasBetInfo = {0, 0}

this.playerAutoBetDataArr = {}
this.autoBetTickTimer = nil

function this:StartServer()
    if this.isRunning then
        ---正在运行中，就直接把服务器数据发送给客户端
        GlobalEvent.Notify(DicePointsSumSizeConfig.GameEventName.UPDATE_GAME_INFO, this.getGameInfo())
        GlobalEvent.Notify(DicePointsSumSizeConfig.GameEventName.UPDATE_PLAYER, this.playerArr)
        if this.status == DicePointsSumSizeConfig.GameState.Bet then
            GlobalEvent.Notify(DicePointsSumSizeConfig.GameEventName.SYNC_TOTAL_BETS, this.areasBetInfo)
        end
    else
        this.StartStateMachine()
        this.AddEvent()
        this.isRunning = true
        --自动下注
        if this.autoBetTickTimer ~= nil and this.autoBetTickTimer.isRunning then
            TimerManager.StopTimer(this.autoBetTickTimer)
            this.autoBetTickTimer = nil
        end
        this.autoBetTickTimer = TimerManager.StartTimer(this, function()
            this.AutoBetTick();
        end, 1, -1, true);

        --创建自己数据
        local selfPlayerInfo = this.createPlayer(DicePointsSumSizeConfig.selfTestPlayerId)
        this.playerArr[selfPlayerInfo.id] = selfPlayerInfo
        --创建其他人数据
        local otherCount = Tools.RandomInt(1,50) + 10
        for i = 1, otherCount do
            local otherPlayer = this.createPlayer(DicePointsSumSizeConfig.otherTestPlayerStartId + i)
            this.playerArr[otherPlayer.id] = otherPlayer
        end

        ---把服务器数据发送给客户端
        GlobalEvent.Notify(DicePointsSumSizeConfig.GameEventName.UPDATE_GAME_INFO, this.getGameInfo())
        GlobalEvent.Notify(DicePointsSumSizeConfig.GameEventName.UPDATE_PLAYER, this.playerArr)
        if this.status == DicePointsSumSizeConfig.GameState.Bet then
            GlobalEvent.Notify(DicePointsSumSizeConfig.GameEventName.SYNC_TOTAL_BETS, this.areasBetInfo)
        end
    end
end

function this.getGameInfo()
    local gameInfo = {status = this.status}
    if this.status == DicePointsSumSizeConfig.GameState.Prepare then
        gameInfo.remaining_time = DicePointsSumSizeConfig.prepareStateDuration - (Time.time - this.stateStartTime)
    elseif this.status == DicePointsSumSizeConfig.GameState.Bet then
        gameInfo.remaining_time = DicePointsSumSizeConfig.betStateDuration - (Time.time - this.stateStartTime)
    elseif this.status == DicePointsSumSizeConfig.GameState.Settlement then
        gameInfo.remaining_time = DicePointsSumSizeConfig.settlementStateDuration - (Time.time - this.stateStartTime)
        gameInfo.dices = this.dices
    end

    return gameInfo
end

function this.createPlayer(playerId)
    local newPlayer = { id = playerId }
    newPlayer.coin = Tools.RandomInt(1,1000000) + 50000
    newPlayer.nickname = "Test" .. playerId
    newPlayer.betInfo = {0, 0, 0, 0, 0, 0}

    return newPlayer
end

function this.GenerateDices()
    local dices = {}
    for i = 1, DicePointsSumSizeConfig.diceCount do
        table.insert(dices, Tools.RandomInt(1, DicePointsSumSizeConfig.diceSideCount))
    end

    return dices
end

function this:StopServer()
    if this.isRunning then
        this.RemoveEvent()
        TimerManager.StopAllTimer(this)
        this.isRunning = false
        this.autoBetTickTimer = nil
        this.timeoutTimer = nil
    end
end

function this.StartStateMachine()
    this.SwitchToPrepareState()
end

function this.SwitchToPrepareState()
    if this.timeoutTimer and this.timeoutTimer.isRunning then
        this.timeoutTimer:Stop()
    end
    this.timeoutTimer = TimerManager.StartTimer(this, function()
        this.SwitchToBetState();
    end, DicePointsSumSizeConfig.prepareStateDuration, 1, true);
    this.stateStartTime = Time.time
    --清空自动下注参数
    this.playerAutoBetDataArr = {}
    --
    this.areasBetInfo = {0, 0}
    for k,v in pairs(this.playerArr) do
        v.betInfo = {0, 0}
    end

    this.status = DicePointsSumSizeConfig.GameState.Prepare

    local msg = {}
    msg.status = this.status
    msg.remaining_time = DicePointsSumSizeConfig.prepareStateDuration
    GlobalEvent.Notify(DicePointsSumSizeConfig.GameEventName.UPDATE_GAME_STATUS, msg)

    GlobalEvent.Notify(DicePointsSumSizeConfig.GameEventName.UPDATE_PLAYER, this.playerArr)
end

function this.SwitchToBetState()
    if this.timeoutTimer and this.timeoutTimer.isRunning then
        this.timeoutTimer:Stop()
    end
    this.timeoutTimer = TimerManager.StartTimer(this, function()
        this.SwitchToSettlementState();
    end, DicePointsSumSizeConfig.betStateDuration, 1, true);
    this.stateStartTime = Time.time

    this.status = DicePointsSumSizeConfig.GameState.Bet
    local msg = {}
    msg.status = this.status
    msg.remaining_time = DicePointsSumSizeConfig.betStateDuration
    GlobalEvent.Notify(DicePointsSumSizeConfig.GameEventName.UPDATE_GAME_STATUS, msg)
end

function this.SwitchToSettlementState()
    if this.timeoutTimer and this.timeoutTimer.isRunning then
        this.timeoutTimer:Stop()
    end
    this.timeoutTimer = TimerManager.StartTimer(this, function()
        this.SwitchToPrepareState();
    end, DicePointsSumSizeConfig.settlementStateDuration, 1, true);
    this.stateStartTime = Time.time

    this.status = DicePointsSumSizeConfig.GameState.Settlement
    local msg = {}
    msg.status = this.status
    msg.remaining_time = DicePointsSumSizeConfig.settlementStateDuration
    GlobalEvent.Notify(DicePointsSumSizeConfig.GameEventName.UPDATE_GAME_STATUS, msg)

    this.dices = this.GenerateDices()
    local resultInfo = {}
    if #this.dices == DicePointsSumSizeConfig.diceCount then
        local dicePointsSum = 0
        for i = 1, #this.dices do
            dicePointsSum = dicePointsSum + this.dices[i]
        end
        if dicePointsSum >= 3 and dicePointsSum <= 10 then
            table.insert(resultInfo, { anim_index = DicePointsSumSizeConfig.DiceSumType.Small, odd = 2 * 0.99})
        elseif dicePointsSum >= 11 and dicePointsSum <= 18 then
            table.insert(resultInfo, { anim_index = DicePointsSumSizeConfig.DiceSumType.Big, odd = 2 * 0.99})
        else
            logError("点数之和出bug了，总和：" .. dicePointsSum)
        end

        local winList = {}
        for k, player in pairs(this.playerArr) do
            local playerWinAreaList = { }
            local winTotal = 0
            for i = 1, #resultInfo do
                local animIndex = resultInfo[i].anim_index
                local odd = resultInfo[i].odd
                if player.betInfo[animIndex] > 0 then
                    local oddAmount = player.betInfo[animIndex] * odd
                    player.coin = player.coin + oddAmount
                    winTotal = winTotal + oddAmount
                    table.insert(playerWinAreaList, { anim_index = animIndex, oddAmount = oddAmount, betAmount = player.betInfo[animIndex]})
                end
            end

            if #playerWinAreaList > 0 then
                table.insert(winList, {playerid = k, win_info = playerWinAreaList, winAmount = winTotal})
            end
        end

        local settlementMsg = {dices = this.dices,
                               dice_result = resultInfo,
                               win_info = winList}
        --look("Server settlementMsg：" .. jsonEncode(settlementMsg))
        GlobalEvent.Notify(DicePointsSumSizeConfig.GameEventName.GAME_SETTLEMENT, settlementMsg)
    else
        look("DiceSizeSimulationServer GenerateDices err")
    end
end

function this.AddEvent()
    GlobalEvent.AddListener(DicePointsSumSizeConfig.GameEventName.START_SIMULATION_SERVER, this.StartServer, this)
    GlobalEvent.AddListener(DicePointsSumSizeConfig.GameEventName.STOP_SIMULATION_SERVER, this.StopServer, this)
    GlobalEvent.AddListener(DicePointsSumSizeConfig.GameEventName.REQUEST_BET, this.PlayerBet, this)
    GlobalEvent.AddListener(DicePointsSumSizeConfig.GameEventName.REQUEST_RANKLIST, this.GetRankList, this)
end

function this:GetRankList()
    local rankData = {}
    for k, player in pairs(this.playerArr) do
        table.insert(rankData, player)
    end
    GlobalEvent.Notify(DicePointsSumSizeConfig.GameEventName.RES_RANKLIST, rankData)
end

function this:PlayerBet(message)
    local resMsg = {result = 0}
    if message ~= nil and message.playerid ~= nil
            and message.area ~= nil and message.chip ~= nil then
        local targetPlayer = this.playerArr[message.playerid]
        if targetPlayer == nil then
            resMsg.result = 2
        else
            local betAmount = DicePointsSumSizeConfig.betValuesArr[message.chip]
            if betAmount > targetPlayer.coin then
                resMsg.result = 3
            else
                targetPlayer.betInfo[message.area] = targetPlayer.betInfo[message.area] + betAmount
                targetPlayer.coin = targetPlayer.coin - betAmount
                this.areasBetInfo[message.area] = this.areasBetInfo[message.area] + betAmount
                resMsg.area = message.area
                resMsg.chip = message.chip
                resMsg.remaining_coin = targetPlayer.coin

                GlobalEvent.Notify(DicePointsSumSizeConfig.GameEventName.SYNC_TOTAL_BETS, this.areasBetInfo)
                if message.playerid ~= DicePointsSumSizeConfig.selfTestPlayerId then
                    local playerBetMsg = {}
                    playerBetMsg.area = message.area
                    playerBetMsg.playerid = message.playerid
                    playerBetMsg.chip = message.chip
                    GlobalEvent.Notify(DicePointsSumSizeConfig.GameEventName.NOTIFY_PLAYER_BET, playerBetMsg)
                end
            end
        end
    else
        resMsg.result = 1
    end

    if message ~= nil and message.playerid ~= nil and message.playerid == DicePointsSumSizeConfig.selfTestPlayerId then
        GlobalEvent.Notify(DicePointsSumSizeConfig.GameEventName.RES_BET_RESULT, resMsg)
    end
end

function this.RemoveEvent()
    GlobalEvent.RemoveAllTo(this)
end

function this.AutoBetTick()
    if this.status == DicePointsSumSizeConfig.GameState.Bet then
        for k, player in pairs(this.playerArr) do
            if k ~= DicePointsSumSizeConfig.selfTestPlayerId then
                local params = this.playerAutoBetDataArr[k]
                if params == nil then
                    params = {lastBetTime = Time.time}
                    params.betCD = Tools.RandomInt(0, 5)
                    this.playerAutoBetDataArr[k] = params
                end

                if params.lastBetTime + params.betCD >= Time.time then
                    local betMsg = {}
                    betMsg.area = Tools.RandomInt(1, DicePointsSumSizeConfig.DiceSumType.TypeCount)
                    betMsg.chip = Tools.RandomInt(1, #DicePointsSumSizeConfig.betValuesArr)
                    betMsg.playerid = k
                    this:PlayerBet(betMsg)

                    params.lastBetTime = Time.time
                    params.betCD= Tools.RandomInt(0, 5)
                end
            end
        end
    end
end

return this