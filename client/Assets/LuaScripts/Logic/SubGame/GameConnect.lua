
---@class GameConnect
local GameConnect=Class("GameConnect")

function GameConnect:ctor()
    logError("初始化游戏监听")
    self:AddListener();
end

function GameConnect:AddListener()
    WebNetEvent.AddListener(pb_PlatformHall.ResChooseGame,self.ResChooseGame, self)
    WebNetEvent.AddListener(pb_PlatformHall.ResExitGame,self.ResExitGame, self)
end

function GameConnect:ReqChooseGame(gameType)
    local data={}
    data.gameType=gameType
    WebNetworkManager.SendMsg(pb_PlatformHall.ReqChooseGame,data)
end


function GameConnect:ReqExitGame()
    WebNetworkManager.SendMsg(pb_PlatformHall.ReqExitGame)
end

function GameConnect:ResExitGame(msg)
    look("退出游戏返回....",msg)
    GameCenter.LeaveGameResultMsg(msg)
end


---连接验证成功
function GameConnect:ResChooseGame(msg)
    GameCenter.ResChooseGame(msg);
end

return GameConnect;