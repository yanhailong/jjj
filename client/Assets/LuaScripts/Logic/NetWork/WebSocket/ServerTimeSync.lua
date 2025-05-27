---@class ServerTimeSync
ServerTimeSync = {}

function ServerTimeSync:Init()
    self.curTimeStamp = Util.GetTimeStamp()--默认获取本地
    TimerManager.StartTimer(self, function
    ()
        self:UpdateSecond()
    end, 1, -1, true)
end

function ServerTimeSync:UpdateSecond()
    self.curTimeStamp = self.curTimeStamp + 1000
end

function ServerTimeSync:GetTimeStamp()
    return self.curTimeStamp
end

function ServerTimeSync:SyncTimeStamp(javaTimeStamp)
    self.curTimeStamp = javaTimeStamp
end