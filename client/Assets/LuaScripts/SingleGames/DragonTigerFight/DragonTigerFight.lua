require("SingleGames/DragonTigerFight/MVCHead")
local DragonTigerFight=Class("DragonTigerFight",SubGame)

function DragonTigerFight:ctor(gameName,param)
    self.super.ctor(self,gameName,param)
    -- 无加载界面
    --self.gameLoadingLuaPath="Logic/SubGame/GameLoading";
    --self.gameLoadingPanelPath="SingleGames/DragonTigerFight/prefabs/DragonTigerFightLoading";
    self.isLoadAllAssets=false;--是否进入游戏时加载所有资源
    self.isLoadAsync=true;--异步加载游戏资源
end
function DragonTigerFight:Init()
    require("SingleGames/DragonTigerFight/MsgPro/pb_DragonTigerFight")
end

function DragonTigerFight:EnterGame()
    if CtrlManager.IsOpen(CtrlNames.DragonTigerFight) then
        self.super.EnterGame(self);
    else
        local ctrl=CtrlManager.SingleShow(CtrlNames.DragonTigerFight);
        ctrl:AddAsyncOpenCallback(function ()
            self.super.EnterGame(self);
        end)
    end
end

return DragonTigerFight