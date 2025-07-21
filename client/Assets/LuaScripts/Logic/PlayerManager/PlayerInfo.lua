---@class PlayerInfo
local PlayerInfo=Class("PlayerInfo")

function PlayerInfo:ctor(data)
    self.playerId= data.playerId;
    self.playerName=data.nickName or ""
    --玩家vip等级
    self.vipLevel = data.vipLevel;
    --玩家当前的金币数量
    self.goldNum = data.gold;
    --玩家当前的钻石数量
    self.diamondNum = data.diamond;
end

return PlayerInfo