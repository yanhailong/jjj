-- 定义全局模块
IsShowLog = true;
require "Logic/ZLancher/HeaderFile"
require("PlatformHall/MsgPro/pb_PlatformHall")
require("Logic/Config/HallConfig")
require("Logic/SubGame/GameCenter")
--require "Debug/EmmyLuaDebugger"

main = {}

function main:init(lancher)
    ---@type UnityEngine.Canvas
    local canvas=GameObject.Find("Global/Canvas").transform:GetComponent("Canvas")
    canvas.pixelPerfect=true
    Application.targetFrameRate=60
    require("PlatformHall/UILogin/MVCHead")
    require("PlatformHall/UIHall/MVCHead")
    require("PlatformHall/UICommonSelection/MVCHead")


    CtrlManager.SingleShow(CtrlNames.UILogin, function
    ()
        lancher:PreLoadingClose()
    end)
end

