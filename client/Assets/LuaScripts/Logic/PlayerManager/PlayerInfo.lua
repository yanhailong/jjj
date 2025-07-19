---@class PlayerInfo
PlayerInfo = {}
local this = PlayerInfo
---初始化玩家信息
---@param data 玩家的数据结构
function PlayerInfo.InitPlayerData(data)
    --玩家ID
    this.playerId = data.playerId;
    --玩家名字
    this.playerName = data.nickName;
    --玩家vip等级
    this.vipLevel = data.vipLevel;
    --玩家当前的金币数量
    this.goldNum = data.gold;
    --玩家当前的钻石数量
    this.diamondNum = data.diamond;
end

---获取玩家ID
function PlayerInfo.GetPlayerId()
    return  this.playerId;
end

---获取玩家名字
function PlayerInfo.GetPlayerName()
    return this.playerName
end 

---修改玩家名字
function PlayerInfo.ChangePlayerName(name)
    this.playerName = name
end

---获取玩家vip等级
function PlayerInfo.GetPlayerVipLevel()
    return this.vipLevel
end
---获取玩家当前的金币数量
function PlayerInfo.GetPlayerGoldNum()
    return this.goldNum
end

---增加玩家当前的金币数量
function PlayerInfo.AddPlayerGoldNum(goldNum)
    this.goldNum = this.goldNum+goldNum;
end

---赋值玩家金币数量
function PlayerInfo.ChangePlayerGoldNum(goldNum)
    this.goldNum = goldNum;
end 