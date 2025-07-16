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

function this.StartServer()
    if this.isRunning then
        ---正在运行中，就直接把服务器数据发送给客户端
    else
        this.StartStateMachine()
        this.AddEvent()
        this.isRunning = true
    end
end

function this.StopServer()
    if this.isRunning then
        this.RemoveEvent()
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

    this.status = FishPrawnCrabConfig.GameState.Prepare
    local msg = {}
    msg.status = this.status
    GlobalEvent.Notify(FishPrawnCrabConfig.GameEventName.UPDATE_GAME_STATUS, msg)
end

function this.SwitchToBetState()
    if this.timeoutTimer and this.timeoutTimer.isRunning then
        this.timeoutTimer:Stop()
    end
    this.timeoutTimer = TimerManager.StartTimer(this, function()
        this.SwitchToSettlementState();
    end, FishPrawnCrabConfig.betStateDuration, 1, true);
    
    this.status = FishPrawnCrabConfig.GameState.Bet
    local msg = {}
    msg.status = this.status
    GlobalEvent.Notify(FishPrawnCrabConfig.GameEventName.UPDATE_GAME_STATUS, msg)
end

function this.SwitchToSettlementState()
    if this.timeoutTimer and this.timeoutTimer.isRunning then
        this.timeoutTimer:Stop()
    end
    this.timeoutTimer = TimerManager.StartTimer(this, function()
        this.SwitchToPrepareState();
    end, FishPrawnCrabConfig.settlementStateDuration, 1, true);

    this.status = FishPrawnCrabConfig.GameState.Settlement
    local msg = {}
    msg.status = this.status
    GlobalEvent.Notify(FishPrawnCrabConfig.GameEventName.UPDATE_GAME_STATUS, msg)
end

function this.AddEvent()
    GlobalEvent.AddListener(FishPrawnCrabConfig.GameEventName.START_SIMULATION_SERVER, this.StartServer, this)
    GlobalEvent.AddListener(FishPrawnCrabConfig.GameEventName.STOP_SIMULATION_SERVER, this.StopServer, this)
    GlobalEvent.AddListener(FishPrawnCrabConfig.GameEventName.REQUEST_BET, this.PlayerBet, this)
end

function this.PlayerBet(message)
    if message ~= nil and message.playerid ~= nil then
        
    end
end

function this.RemoveEvent()
    GlobalEvent.RemoveAllTo(this)
end

return this