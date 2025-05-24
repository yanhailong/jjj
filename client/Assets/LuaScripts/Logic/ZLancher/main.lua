-- 定义全局模块
IsShowLog = true;
require "Logic/ZLancher/HeaderFile"
main = {}
require("Common/LocalManager/LocalManager")

function main:init(lancher)
    GameObject.Find("Reporter").gameObject:SetActive(false)
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

