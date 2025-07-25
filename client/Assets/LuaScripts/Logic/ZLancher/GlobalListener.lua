---@class GlobalListener
GlobalListener=Class("GlobalListener")

function GlobalListener:AddListener()
    self:RemoveListener()
    GlobalEvent.AddListener(pb_PlatformHall.NoticeBaseInfoChange,self.RefreshPlayerInfos,self)
end

function GlobalListener:RemoveListener()
    GlobalEvent.RemoveAllTo(self)
end

---通知玩家信息更新
function GlobalListener:RefreshPlayerInfos(msg)
    look("RefreshPlayerInfos",msg)
    local playerInfo=PlayerManager:GetPlayerInfo()
    playerInfo.vipLevel=msg.vipLevel
    playerInfo.goldNum=msg.gold
    playerInfo.diamondNum=msg.diamond
    PlayerManager:SetPlayerInfo(playerInfo)

end