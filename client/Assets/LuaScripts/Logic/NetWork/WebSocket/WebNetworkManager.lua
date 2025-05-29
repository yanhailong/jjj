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

---@param 创建连接
function this.CreateWebSocket(url)
    ---@param 重连间隔时间
    this.reconnectDelay = 10
    ---@param 重连次数
    this.maxconnectCount = 3
    ---@type WebSocketClient
    WebSocketClient:Run(url, Handler(this, this.OnReceive), Handler(this, this.OnSocketConnentState))
    this.Connect()
end

---@param 开始连接
function this.Connect()
    WebSocketClient:ConnectAsync()
end

---@param 开始心跳
function this.StartHeart()
    if this.ping then
        this.ping:OnDestory()
    end
    ---@type NetworkPing
    this.ping = NetworkPing.New(this)
    this.ping:Start()
end

function this.StopHeart()
    if this.ping then
        this.ping:Stop()
        this.ping:OnDestory()
        this.ping=nil
    end
end

function this:OnSocketConnentState(msg)
    if msg == "Success" then
        log("webSockt连接成功！")
        TimerManager.StopAllTimer(this)
        isContent = true
        WebNetEvent.Notify(WebNetworkConnectEvent.connectSuccess, msg)
        this.StartHeart()
        return
    end
    if msg == "OnClose" then
        log("服务器关闭连接！")
        isContent = false
        WebNetEvent.Notify(WebNetworkConnectEvent.connectFailed, msg)
        this.Close()
        return
    end
    if msg == "ReOpen" then
        log("webSockt关闭！请求重新连接！")
        isContent = false
        this.Reconnect()
        WebNetEvent.Notify(WebNetworkConnectEvent.connectClose, msg)
        return
    end
    logError(msg)
end

function this.Close()
    WebSocketClient:DisConnect()
    this.StopHeart()
    ---心跳超时 开始重新连接
    isContent = false
    this.Reconnect()
end

---@param 发送消息
function this.SendMsg(id, pbMsg)
    if pbMsg == nil then
        pbMsg = {}
    end
    this.MsgLog(false, id, pbMsg)
    pbMsg = PBHelper.EnCode(id, pbMsg)
    WebSocketClient:Send(pbMsg)
end

---@param 接收消息
function this:OnReceive(bytes)
    local msgId,msgTab = PBHelper.Decode(bytes)
    this.MsgLog(true, msgId, msgTab)
    WebNetEvent.Notify(msgId, msgTab)
end

---@param 是否连接
function this.IsConnect()
    return isContent
end

---@param 重连
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
                this.reconnectTimer=nil
                log("重连成功！")
                return
            end
            this.Connect()
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
