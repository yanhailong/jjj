require("SingleGames/USDollarExpress/MVCHead")
local USDollarExpress=Class("USDollarExpress",SubGame)

function USDollarExpress:ctor(gameName,param)
    self.super.ctor(self,gameName,param)
    self.gameLoadingLuaPath="Logic/SubGame/GameLoading";
    self.gameLoadingPanelPath="SingleGames/USDollarExpress/prefabs/USDollarExpressLoading";
    self.isLoadAllAssets=true;--是否进入游戏时加载所有资源
    self.isLoadAsync=true;--异步加载游戏资源
end
function USDollarExpress:Init()
    require("SingleGames/USDollarExpress/MsgPro/pb_USDollarExpress")
end

function USDollarExpress:EnterGame()
    if CtrlManager.IsOpen(CtrlNames.USDollarExpressMain) then
        self.super.EnterGame(self);
    else
        local ctrl=CtrlManager.SingleShow(CtrlNames.USDollarExpressMain);
        ctrl:AddAsyncOpenCallback(function ()
            self.super.EnterGame(self);
        end)
    end
end

return USDollarExpress