require("SingleGames/RoyalWar/MVCHead")
local RoyalWar=Class("RoyalWar",SubGame)

function RoyalWar:ctor(gameName,param)
    self.super.ctor(self,gameName,param)
    --self.gameLoadingLuaPath="Logic/SubGame/GameLoading";
    --self.gameLoadingPanelPath="SingleGames/RoyalWar/prefabs/RoyalWarLoading";
    self.isLoadAllAssets=true;--是否进入游戏时加载所有资源
    self.isLoadAsync=true;--异步加载游戏资源
end
function RoyalWar:Init()
    require("SingleGames/RoyalWar/MsgPro/pb_RoyalWar")
end

function RoyalWar:EnterGame()
    if CtrlManager.IsOpen(CtrlNames.RoyalWarGame) then
        self.super.EnterGame(self);
    else
        local ctrl=CtrlManager.SingleShow(CtrlNames.RoyalWarGame);
        ctrl:AddAsyncOpenCallback(function ()
            self.super.EnterGame(self);
        end)
    end
end

return RoyalWar