-- 定义全局模块
IsShowLog = true;
require "Logic/ZLancher/HeaderFile"
require("Logic/PlayerManager/PlayerManager")
require("PlatformHall/MsgPro/pb_PlatformHall")
require("Logic/Config/HallConfig")
require("Logic/SubGame/GameCenter")
require("Logic/MainState/MainStateCtrl")
--
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

    main:LoadCommonAssets(function
    ()
        CtrlManager.SingleShow(CtrlNames.UILogin):AddAsyncOpenCallback(function
        ()
            lancher:PreLoadingClose()
        end)
    end)
    GlobalListener:AddListener()
end


---加载公共资源
function main:LoadCommonAssets(finishedFunc)
    if AppConst.DebugMode then
        finishedFunc()
        return
    end
    --预加载资源名
    local preLoadAssetName={
        "Common/GameArtsCommon/GameFight/alats/card",
        "Common/GameArtsCommon/GameFight/alats/lan_en",
        "Common/GameArtsCommon/GameFight/alats/main",
        "Common/GameArtsCommon/GameFight/alats/player",
        "Common/GameArtsCommon/GameFight/fonts/chipfont",
        "Common/GameArtsCommon/GameFight/texture",
        "Common/Effects/prefab/Eff_dating_changjing_liuguang_gx",
        "Common/Effects/prefab/Eff_dating_fangjian_blue_down",
        "Common/Effects/prefab/Eff_dating_fangjian_blue_up",
        "Common/Effects/prefab/Eff_dating_fangjian_violet_down",
        "Common/Effects/prefab/Eff_dating_fangjian_violet_up",
        "Common/Effects/prefab/Eff_dating_fangjian_yellow_down",
        "Common/Effects/prefab/Eff_dating_fangjian_yellow_up",
        "Common/Effects/prefab/effect_Common_couma_bk",
        "Common/GameArtsCommon/GameFight/spine/naozhong",
        "Common/Material"
    }

    local count=#preLoadAssetName;
    local loadFinishedCount=0;
    for i = 1, count do
        local abName=preLoadAssetName[i];
        resMgr:LoadBundleAsync(abName,function (ab)
            if ab==nil then
                SuspensionTipsUtil.SuspensionTips("资源加载错误:"..abName);
                return;
            end
            loadFinishedCount=loadFinishedCount+1;
            --公共资源是否加载完成
            if loadFinishedCount==count then
                finishedFunc();
            end
        end);
    end


end