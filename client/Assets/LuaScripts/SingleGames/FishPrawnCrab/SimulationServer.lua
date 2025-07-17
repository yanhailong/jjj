--
--time:{time}
--{paramdesc} 
--@desc 
--
---@class SimulationServer
SimulationServer = Class("SimulationServer")
local FishPrawnCrabConfig = require("SingleGames/FishPrawnCrab/FishPrawnCrabConfig")

local this = SimulationServer

this.isRunning = false
this.timeoutTimer = nil
this.status = nil
this.playerArr = {}
this.stateStartTime = Time.time;
this.dices = {}
this.areasBetInfo = {0, 0, 0, 0, 0, 0}

function this:StartServer()
    if this.isRunning then
        ---正在运行中，就直接把服务器数据发送给客户端
        GlobalEvent.Notify(FishPrawnCrabConfig.GameEventName.UPDATE_GAME_INFO, this.getGameInfo())
        GlobalEvent.Notify(FishPrawnCrabConfig.GameEventName.UPDATE_PLAYER, this.playerArr)
        if this.status == FishPrawnCrabConfig.GameState.Bet then
            GlobalEvent.Notify(FishPrawnCrabConfig.GameEventName.SYNC_TOTAL_BETS, this.areasBetInfo)
        end
    else
        this.StartStateMachine()
        this.AddEvent()
        this.isRunning = true

        --创建自己数据
        local selfPlayerInfo = this.createPlayer(FishPrawnCrabConfig.selfTestPlayerId)
        this.playerArr[selfPlayerInfo.id] = selfPlayerInfo
        --创建其他人数据
        local otherCount = Tools.RandomInt(1,50) + 10
        for i = 1, otherCount do
            local otherPlayer = this.createPlayer(FishPrawnCrabConfig.otherTestPlayerStartId + i)
            this.playerArr[otherPlayer.id] = otherPlayer
        end

        ---把服务器数据发送给客户端
        GlobalEvent.Notify(FishPrawnCrabConfig.GameEventName.UPDATE_GAME_INFO, this.getGameInfo())
        GlobalEvent.Notify(FishPrawnCrabConfig.GameEventName.UPDATE_PLAYER, this.playerArr)
        if this.status == FishPrawnCrabConfig.GameState.Bet then
            GlobalEvent.Notify(FishPrawnCrabConfig.GameEventName.SYNC_TOTAL_BETS, this.areasBetInfo)
        end
    end
end

function this.getGameInfo()
    local gameInfo = {status = this.status}
    if this.status == FishPrawnCrabConfig.GameState.Prepare then
        gameInfo.remaining_time = FishPrawnCrabConfig.prepareStateDuration - (Time.time - this.stateStartTime)
    elseif this.status == FishPrawnCrabConfig.GameState.Bet then
        gameInfo.remaining_time = FishPrawnCrabConfig.betStateDuration - (Time.time - this.stateStartTime)
    elseif this.status == FishPrawnCrabConfig.GameState.Settlement then
        gameInfo.remaining_time = FishPrawnCrabConfig.settlementStateDuration - (Time.time - this.stateStartTime)
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
    for i = 1, FishPrawnCrabConfig.diceCount do
        table.insert(dices, Tools.RandomInt(1, FishPrawnCrabConfig.diceSideCount))
    end
    
    return dices
end

function this:StopServer()
    if this.isRunning then
        this.RemoveEvent()
        TimerManager.StopAllTimer(this)
        this.isRunning = false
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
    end, FishPrawnCrabConfig.prepareStateDuration, 1, true);
    this.stateStartTime = Time.time
    --
    this.areasBetInfo = {0, 0, 0, 0, 0, 0}
    for k,v in pairs(this.playerArr) do
        v.betInfo = {0, 0, 0, 0, 0, 0}
    end

    this.status = FishPrawnCrabConfig.GameState.Prepare
    
    local msg = {}
    msg.status = this.status
    msg.remaining_time = FishPrawnCrabConfig.prepareStateDuration
    GlobalEvent.Notify(FishPrawnCrabConfig.GameEventName.UPDATE_GAME_STATUS, msg)

    GlobalEvent.Notify(FishPrawnCrabConfig.GameEventName.UPDATE_PLAYER, this.playerArr)
end

function this.SwitchToBetState()
    if this.timeoutTimer and this.timeoutTimer.isRunning then
        this.timeoutTimer:Stop()
    end
    this.timeoutTimer = TimerManager.StartTimer(this, function()
        this.SwitchToSettlementState();
    end, FishPrawnCrabConfig.betStateDuration, 1, true);
    this.stateStartTime = Time.time
    
    this.status = FishPrawnCrabConfig.GameState.Bet
    local msg = {}
    msg.status = this.status
    msg.remaining_time = FishPrawnCrabConfig.betStateDuration
    GlobalEvent.Notify(FishPrawnCrabConfig.GameEventName.UPDATE_GAME_STATUS, msg)
end

function this.SwitchToSettlementState()
    if this.timeoutTimer and this.timeoutTimer.isRunning then
        this.timeoutTimer:Stop()
    end
    this.timeoutTimer = TimerManager.StartTimer(this, function()
        this.SwitchToPrepareState();
    end, FishPrawnCrabConfig.settlementStateDuration, 1, true);
    this.stateStartTime = Time.time

    this.status = FishPrawnCrabConfig.GameState.Settlement
    local msg = {}
    msg.status = this.status
    msg.remaining_time = FishPrawnCrabConfig.settlementStateDuration
    GlobalEvent.Notify(FishPrawnCrabConfig.GameEventName.UPDATE_GAME_STATUS, msg)
    
    this.dices = this.GenerateDices()
    local resultInfo = {}
    if #this.dices == FishPrawnCrabConfig.diceCount then
        table.sort(this.dices)
        local curAnimCount = 1
        for i = 2, #this.dices do
            if this.dices[i] == this.dices[i - 1] then
                curAnimCount = curAnimCount + 1
            else
                table.insert(resultInfo, { anim_index = this.dices[i - 1], odd = FishPrawnCrabConfig.odds[curAnimCount]})
                curAnimCount = 1
            end

            if i == 3 then
                table.insert(resultInfo, { anim_index = this.dices[i], odd = FishPrawnCrabConfig.odds[curAnimCount]})
            end
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
                    player.coin = player.coin + oddAmount + player.betInfo[animIndex]
                    winTotal = winTotal + oddAmount + player.betInfo[animIndex]
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
        GlobalEvent.Notify(FishPrawnCrabConfig.GameEventName.GAME_SETTLEMENT, settlementMsg)
    else
        look("SimulationServer GenerateDices err")
    end
end

function this.AddEvent()
    GlobalEvent.AddListener(FishPrawnCrabConfig.GameEventName.START_SIMULATION_SERVER, this.StartServer, this)
    GlobalEvent.AddListener(FishPrawnCrabConfig.GameEventName.STOP_SIMULATION_SERVER, this.StopServer, this)
    GlobalEvent.AddListener(FishPrawnCrabConfig.GameEventName.REQUEST_BET, this.PlayerBet, this)
end

function this:PlayerBet(message)
    local resMsg = {result = 0}
    if message ~= nil and message.playerid ~= nil 
            and message.area ~= nil and message.chip ~= nil then
        local targetPlayer = this.playerArr[message.playerid]
        if targetPlayer == nil then
            resMsg.result = 2
        else
            local betAmount = FishPrawnCrabConfig.betValuesArr[message.chip]
            if betAmount > targetPlayer.coin then
                resMsg.result = 3
            else
                targetPlayer.betInfo[message.area] = targetPlayer.betInfo[message.area] + betAmount
                targetPlayer.coin = targetPlayer.coin - betAmount
                this.areasBetInfo[message.area] = this.areasBetInfo[message.area] + betAmount
                resMsg.area = message.area
                resMsg.chip = message.chip
                resMsg.remaining_coin = targetPlayer.coin
                
                GlobalEvent.Notify(FishPrawnCrabConfig.GameEventName.SYNC_TOTAL_BETS, this.areasBetInfo)
            end
        end
    else
        resMsg.result = 1
    end
    
    GlobalEvent.Notify(FishPrawnCrabConfig.GameEventName.RES_BET_RESULT, resMsg)
end

function this.RemoveEvent()
    GlobalEvent.RemoveAllTo(this)
end

return this