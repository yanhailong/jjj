---@class NetworkPing
local NetworkPing = Class("NetworkPing")

local pingTime = 10;
local timeout = 60;

function NetworkPing:ctor(connect)
    ---@type WebNetworkManager
    self.connect = connect;
    self.sendTime = nil;
    
    WebNetEvent.AddListener(MsgId.ResHeartBeat, self.ResHeartBeat, self)
    self.timer = TimerManager.CreateTimer(self, function()
        self:SendPing();
    end, pingTime, 1, true)

    self.timeoutTimer = TimerManager.CreateTimer(self, function()
        self:SendTimeout();
    end, timeout, 1, true);
end

function NetworkPing:Start()
    self.timer:Start()
    self.timeoutTimer:Start()
end

function NetworkPing:Stop()
    if self.timer.running then
        self.timer:Stop();
    end
    self:StopTimeoutTimer();
end

---停止心跳超时计时器
function NetworkPing:StopTimeoutTimer()
    if self.timeoutTimer.running then
        self.timeoutTimer:Stop();
    end
end

---发送ping消息
function NetworkPing:SendPing()
    if not self.connect.IsConnect() then
        return
    end
    local heartMsg = self:GetHeratMsg()
    self.connect.SendMsg(MsgId.ReqHeartBeat, heartMsg);
    self:StopTimeoutTimer();
    self:ResetStartTimer(self.timeoutTimer);
end

function NetworkPing:GetHeratMsg()
    local data = {}
    data.none=true
    return data
end

---返回ping消息
function NetworkPing:ResHeartBeat(msg)
    self.currentTime=msg.time
    self:StopTimeoutTimer();
    self:ResetStartTimer(self.timer);
    ServerTimeSync:SyncTimeStamp(self.currentTime)
end

---接收消息超时
function NetworkPing:SendTimeout()
    self:Stop()
    WebNetworkManager.Close()
    TimerManager.StopAllTimer(self)
    WebNetEvent.RemoveAllTo(self)
end

---重置计时器
function NetworkPing:ResetStartTimer(timer)
    timer:Restart();
end

function NetworkPing:OnDestory()
    self:Stop()
    TimerManager.StopAllTimer(self)
    WebNetEvent.RemoveAllTo(self)
end

---@return NetworkPing
return NetworkPing