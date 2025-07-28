require("SingleGames/Baccarat/MVCHead")
local Baccarat=Class("Baccarat",SubGame)

function Baccarat:ctor(gameName,param)
    self.super.ctor(self,gameName,param)
    --self.gameLoadingLuaPath="Logic/SubGame/GameLoading";
    --self.gameLoadingPanelPath="SingleGames/Baccarat/prefabs/BaccaratLoading";
    self.isLoadAllAssets=true;--是否进入游戏时加载所有资源
    self.isLoadAsync=true;--异步加载游戏资源
end
function Baccarat:Init()
    require("PlatformHall/comonFight/MsgPro/pb_comonFight")
end

function Baccarat:EnterGame()
    if CtrlManager.IsOpen(CtrlNames.BaccaratMain) then
        self.super.EnterGame(self);
    else
        local ctrl=CtrlManager.SingleShow(CtrlNames.BaccaratMain);
        ctrl:AddAsyncOpenCallback(function ()
            self.super.EnterGame(self);
        end)
    end
end

return Baccarat