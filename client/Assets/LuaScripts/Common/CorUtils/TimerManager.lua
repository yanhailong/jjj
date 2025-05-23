---@class TimerManager
TimerManager = {}
local Timer = require "Common/CorUtils/Timer"
local this = TimerManager
local m_timerList = {}

function this.StartTimer(luaClass, func, duration, loop, unscaled, stipCall)
    if luaClass.curTimers == nil then
        luaClass.curTimers = {}
        table.insert(m_timerList, luaClass)
    end
    local timer = Timer.New(func, duration, loop, unscaled)
    if stipCall then
        timer:AddStopFunc(stipCall)
    end
    table.insert(luaClass.curTimers, timer)
    timer:Start()
    return timer
end

function this.CreateTimer(luaClass, func, duration, loop, unscaled, stipCall, usFrame, ...)
    if luaClass.curTimers == nil then
        luaClass.curTimers = {}
        table.insert(m_timerList, luaClass)
    end
    local timer = Timer.New(func, duration, loop, unscaled, usFrame, ...)
    if stipCall then
        timer:AddStopFunc(stipCall)
    end
    table.insert(luaClass.curTimers, timer)
    return timer
end

function this.Restart(timer, loop, duration)
    timer:Restart(loop, duration)
end

function this.StopTimer(luaClass, timer)
    if luaClass and timer then
        if timer.running == true then
            timer:Stop()
        end
    end
    for k, v in pairs(luaClass.curTimers) do
        if v == timer then
            luaClass.curTimers[k] = nil
        end
    end
end

function this.StopAllTimer(luaClass)
    if luaClass and luaClass.curTimers then
        for k, v in pairs(luaClass.curTimers) do
            if v.running == true then
                v:Stop()
                luaClass.curTimers[v] = nil
            end
        end
    end
    luaClass.curTimers = {}
end
---关闭所有的计时器一般关闭场景时使用
function this.StopAllClassTimer()
    for k, v in pairs(m_timerList) do
        this.StopAllTimer(v)
    end
end
