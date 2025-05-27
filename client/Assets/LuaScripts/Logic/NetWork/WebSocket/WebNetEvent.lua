---@class WebNetEvent
WebNetEvent = {}
local this=WebNetEvent

function this.AddListener(msgId,handle,cls)
    if not handle or type(handle)~="function" then
        logError("handle not is function ")
    end
    GlobalEvent.AddListener(msgId,handle,cls)
end

function this.Notify(msgId,msg)
    GlobalEvent.Notify(msgId,msg)
end

function this.RemoveAllTo(cls)
    GlobalEvent.RemoveAllTo(cls)
end

function this.RemoveEvent(msgId)
    GlobalEvent.RemoveAllByEventName(msgId)
end

---@return WebNetEvent
return WebNetEvent