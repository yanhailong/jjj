---@type PlayerInfo
local PlayerInfo= require("Logic/PlayerManager/PlayerInfo")
---@class PlayerManager
PlayerManager=Class("PlayerManager")

---玩家信息改变事件
PlayerInfoEvent={
    ---玩家信息改变
    playerInfoChange="playerInfoChange",
}

function PlayerManager:Init(data)
    ---玩家信息
     self.playerInfo=PlayerInfo.New(data);
end

---@return PlayerInfo 
function PlayerManager:GetPlayerInfo()
    return self.playerInfo;
end

function PlayerManager:SetPlayerInfo(playerInfo)
    self.playerInfo=playerInfo
    GlobalEvent.Dispatch(PlayerInfoEvent.playerInfoChange,self.playerInfo)
end