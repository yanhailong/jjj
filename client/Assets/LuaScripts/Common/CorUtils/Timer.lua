---@class Timer
local Timer = {}

--unscaled false 采用deltaTime计时，true 采用 unscaledDeltaTime计时
---@return Timer
function Timer.New(func, duration, loop, unscaled, usFrame, ...)
    local self = {}
    setmetatable(self, {__index = Timer})
    self.func = func
    self.duration = duration
    self.time = duration
    self.loop = loop or 0
    self.unscaled = unscaled
    self.running = false
    self.tempLoop = self.loop
    self.params = SafePack(...)
    self.usFrame = usFrame or false
    return self
end

---添加结束回调
function Timer:AddStopFunc(stopFunc)
    self.stopFunc = stopFunc
end

---重新开始计算器
function Timer:Restart(loop, duration)
    self.loop = loop or self.tempLoop
    self.duration = duration or self.duration
    self.running = true
    self.time = self.duration
    if not self.updateId then
        self.updateId = UpdateManager.AddUpdate(self, self.Update)
    end
end

function Timer:Start()
    self.running = true
    if not self.updateId then
        self.updateId = UpdateManager.AddUpdate(self, self.Update)
    end
end

function Timer:Reset(func, duration, loop, unscaled)
    self.duration = duration
    self.loop = loop or 1
    self.unscaled = unscaled
    self.func = func
    self.time = duration
end

function Timer:Stop()
    self.running = false
    if self.updateId then
        UpdateManager.RemoveUpdate(self, self.updateId)
        self.updateId = nil
    end
    if self.stopFunc then
        self.stopFunc()
    end
end

function Timer:Update()
    if not self.running then
        return
    end
    if self.usFrame then
        local delta = self.unscaled and Time.unscaledFrameCount or Time.frameCount
        self.time = self.time - delta
        if self.time <= 0 then
            if self.params then
                self.func(SafeUnpack(self.params))
            else
                self.func()
            end

            if self.loop > 0 then
                self.loop = self.loop - 1
                self.time = self.time + self.duration
            end

            if self.loop == 0 then
                self:Stop()
            elseif self.loop < 0 then
                self.time = self.time + self.duration
            end
        end
    else
        local delta = self.unscaled and Time.unscaledDeltaTime or Time.deltaTime
        self.time = self.time - delta
        if self.time <= 0 then
            if self.params then
                self.func(SafeUnpack(self.params))
            else
                self.func()
            end

            if self.loop > 0 then
                self.loop = self.loop - 1
                self.time = self.time + self.duration
            end

            if self.loop == 0 then
                self:Stop()
            elseif self.loop < 0 then
                self.time = self.time + self.duration
            end
        end
    end
end

---@return Timer
return Timer
