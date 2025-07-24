require("SingleGames/CarLogo/MVCHead")
local CarLogo=Class("CarLogo",SubGame)

function CarLogo:ctor(gameName,param)
    self.super.ctor(self,gameName,param)
    --self.gameLoadingLuaPath="Logic/SubGame/GameLoading";
    --self.gameLoadingPanelPath="SingleGames/CarLogo/prefabs/CarLogoLoading";
    self.isLoadAllAssets=false;--是否进入游戏时加载所有资源
    self.isLoadAsync=true;--异步加载游戏资源
end
function CarLogo:Init()
    require("SingleGames/CarLogo/MsgPro/pb_CarLogo")
end

function CarLogo:EnterGame()
    if CtrlManager.IsOpen(CtrlNames.CarLogoGame) then
        self.super.EnterGame(self);
    else
        local ctrl=CtrlManager.SingleShow(CtrlNames.CarLogoGame);
        ctrl:AddAsyncOpenCallback(function ()
            self.super.EnterGame(self);
        end)
    end
end

return CarLogo