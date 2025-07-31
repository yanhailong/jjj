require("SingleGames/SicBo/MVCHead")
local SicBo = Class("SicBo", SubGame)

function SicBo:ctor(gameName, param)
    self.super.ctor(self, gameName, param)
    --self.secondUICtrlName = CtrlNames.SicBoMain
    self.secondUICtrlName = CtrlNames.SicBoSelect
    --self.gameLoadingLuaPath="Logic/SubGame/GameLoading";
    --self.gameLoadingPanelPath="SingleGames/CarLogo/prefabs/CarLogoLoading";
    self.isLoadAllAssets = false; --是否进入游戏时加载所有资源
    self.isLoadAsync = true;    --异步加载游戏资源
end

function SicBo:Init()
    require("PlatformHall/comonFight/MsgPro/pb_comonFight")
    require("PlatformHall/comonFight/MVCHead")
    require("Logic/Common/PlayerRankPanel/MVCHead")
end

function SicBo:EnterGame()
    if CtrlManager.IsOpen(CtrlNames.SicBoMain) then
        self.super.EnterGame(self);
    else
        local ctrl = CtrlManager.SingleShow(CtrlNames.SicBoMain);
        ctrl:AddAsyncOpenCallback(function()
            self.super.EnterGame(self);
        end)
    end
end

return SicBo
