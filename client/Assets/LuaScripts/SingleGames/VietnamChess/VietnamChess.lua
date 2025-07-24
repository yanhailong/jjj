require("SingleGames/VietnamChess/MVCHead")
local VietnamChess=Class("VietnamChess",SubGame)

function VietnamChess:ctor(gameName,param)
    self.super.ctor(self,gameName,param)
    --self.gameLoadingLuaPath="Logic/SubGame/GameLoading";
    --self.gameLoadingPanelPath="SingleGames/VietnamChess/prefabs/VietnamChessLoading";
    self.isLoadAllAssets=false;--是否进入游戏时加载所有资源
    self.isLoadAsync=true;--异步加载游戏资源
end
function VietnamChess:Init()
    require("SingleGames/VietnamChess/MsgPro/pb_VietnamChess")
end

function VietnamChess:EnterGame()
    if CtrlManager.IsOpen(CtrlNames.VietnamChessGame) then
        self.super.EnterGame(self);
    else
        local ctrl=CtrlManager.SingleShow(CtrlNames.VietnamChessGame);
        ctrl:AddAsyncOpenCallback(function ()
            self.super.EnterGame(self);
        end)
    end
end

return VietnamChess