require("Logic/Protoc/PBHelper")
require("Logic/Protoc/MsgId")
---@class WebNetworkManager
WebNetworkManager = {}
local this = WebNetworkManager
local WebSocketClient = CS.WebSocketClient.Instance
---@type WebNetEvent
WebNetEvent = require "Logic/NetWork/WebSocket/WebNetEvent"
-----@type NetworkPing
local NetworkPing = require "Logic/NetWork/WebSocket/NetworkPing"
require("Logic/NetWork/WebSocket/ServerTimeSync")
local isContent = false
local curContentUrl = nil
local isOpenMsgLog = true
local eventPool = {}
---网络连接事件
WebNetworkConnectEvent = {
    --连接成功
    connectSuccess = "WebNetworkConnectEvent_ConnectSuccess",
    --连接失败
    connectFailed = "WebNetworkConnectEvent_ConnectFailed",
    --连接关闭
    connectClose = "WebNetworkConnectEvent_connectClose"
}

function this.Connect(url)
    WebSocketClient:Close()
    WebSocketClient:Run(url, Handler(this, this.OnReceive), Handler(this, this.OnSocketConnentState))
    curContentUrl = url
    if this.ping then
        this.ping:OnDestory()
    end
    ---@type NetworkPing
    this.ping = NetworkPing.New(this)
    this.ping:Start()

    ---@param 重连间隔时间
    this.reconnectDelay = 10
    ---@param 重连次数
    this.maxconnectCount = 3
end

function this.Close()
    WebSocketClient:Close()
    this.ping:Stop()
end

function this.PingStart()
    this.ping:Start()
end

---@param 发送消息
function this.SendMsg(id, pbMsg)
    if pbMsg == nil then
        pbMsg = {}
    end
    this.MsgLog(false, id, pbMsg)
    pbMsg = PBHelper.EnCode(id, pbMsg)
    --local msgTab = PBHelper.Decode(id, pbMsg)
    WebSocketClient:Send(pbMsg)
end

function this:OnSocketConnentState(msg)
    if msg == "Success" then
        log("webSockt连接成功！")
        isContent = true
        WebNetEvent.Notify(WebNetworkConnectEvent.connectSuccess, msg)
        return
    end
    if msg == "OnClose" then
        log("链接服务器失败！")
        isContent = false
        WebNetEvent.Notify(WebNetworkConnectEvent.connectFailed, msg)
        return
    end
    if msg == "ReOpen" then
        log("webSockt关闭！")
        isContent = false
        this.Reconnect()
        WebNetEvent.Notify(WebNetworkConnectEvent.connectClose, msg)
        return
    end
    logError(msg)
end

function this:OnReceive(bytes)
    local msgId,msgTab = PBHelper.Decode(bytes)
    this.MsgLog(true, msgId, msgTab)
    WebNetEvent.Notify(msgId, msgTab)
end

function this.NotifyEvent(eventName, data)
    if table.HasKey(eventPool, eventName) then
        eventPool[eventName](data)
        eventPool[eventName] = nil
    else
        WebNetEvent.Notify(eventName, data)
    end
end

function this.IsConnect()
    return isContent
end

function this.Reconnect()
    if this.reconnectTimer then
        TimerManager.StopAllTimer(this)
    end
    this.reconnectTimer =
        TimerManager.StartTimer(
        this,
        function()
            if isContent == true then
                this.reconnectTimer:Stop()
                log("重连成功！")
                return
            end
            this.ping:SendTimeout()
        end,
        this.reconnectDelay,
        this.maxconnectCount
    )
end

function this.MsgLog(isRecive, msgID, msgTab)
    if not isOpenMsgLog then
        return
    end
    if msgID == MsgId.ResHeartBeat  or msgID == MsgId.ReqHeartBeat then
       return
    end
    if isRecive then
        
        look("接收消息：", msgID, msgTab)
    else
        look("发送消息：", msgID, msgTab)
    end
end
