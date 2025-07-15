
---@class GameConnect
local GameConnect=Class("GameConnect")

function GameConnect:ctor()
    logError("初始化游戏监听")
    self:AddListener();
end

function GameConnect:AddListener()
    WebNetEvent.AddListener(pb_PlatformHall.ResChooseGame,self.ResChooseGame, self)
end

function GameConnect:ReqChooseGame(gameType)
    local data={}
    data.gameType=gameType
    WebNetworkManager.SendMsg(pb_PlatformHall.ReqChooseGame,data)
end


---连接验证成功
function GameConnect:ResChooseGame(msg)
    GameCenter.ResChooseGame(msg);
end

return GameConnect;