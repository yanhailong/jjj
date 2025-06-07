-- 定义全局模块
IsShowLog = true;
require "Logic/ZLancher/HeaderFile"
logError("Tools.GetPlatformType():"..Tools.GetPlatformType())
if Tools.GetPlatformType()==-1 then
    require "Debug/EmmyLuaDebugger"
end
main = {}

function main:init(lancher)
    ---@type UnityEngine.Canvas
    local canvas=GameObject.Find("Global/Canvas").transform:GetComponent("Canvas")
    canvas.pixelPerfect=true
    Application.targetFrameRate=60
    require("PlatformHall/UIHall/MVCHead")

    CtrlManager.SingleShow(CtrlNames.UIHall, function
    ()
       lancher:PreLoadingClose()
    end)
end

