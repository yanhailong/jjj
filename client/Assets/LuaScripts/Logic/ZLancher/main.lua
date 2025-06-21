-- 定义全局模块
IsShowLog = true;
require "Logic/ZLancher/HeaderFile"
require("PlatformHall/Protol/pb_PlatformHall")
if Tools.GetPlatformType()==-1 then
    require "Debug/EmmyLuaDebugger"
end
main = {}

function main:init(lancher)
    ---@type UnityEngine.Canvas
    local canvas=GameObject.Find("Global/Canvas").transform:GetComponent("Canvas")
    canvas.pixelPerfect=true
    Application.targetFrameRate=60
    require("PlatformHall/UILogin/MVCHead")

    CtrlManager.SingleShow(CtrlNames.UILogin, function
    ()
       lancher:PreLoadingClose()
    end)
end

