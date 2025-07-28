require("SingleGames/BirdsAnimals/MVCHead")
local BirdsAnimals=Class("BirdsAnimals",SubGame)

function BirdsAnimals:ctor(gameName,param)
    self.super.ctor(self,gameName,param)
    --self.gameLoadingLuaPath="Logic/SubGame/GameLoading";
    --self.gameLoadingPanelPath="SingleGames/BirdsAnimals/prefabs/BirdsAnimalsLoading";
    self.isLoadAllAssets=false;--是否进入游戏时加载所有资源
    self.isLoadAsync=true;--异步加载游戏资源
end
function BirdsAnimals:Init()
    require("PlatformHall/comonFight/MsgPro/pb_comonFight")
    require("PlatformHall/comonFight/MVCHead")
    require("Logic/Common/PlayerRankPanel/MVCHead")
end

function BirdsAnimals:EnterGame()
    if CtrlManager.IsOpen(CtrlNames.BirdsAnimalsGame) then
        self.super.EnterGame(self);
    else
        local ctrl=CtrlManager.SingleShow(CtrlNames.BirdsAnimalsGame);
        ctrl:AddAsyncOpenCallback(function ()
            self.super.EnterGame(self);
        end)
    end
end

return BirdsAnimals