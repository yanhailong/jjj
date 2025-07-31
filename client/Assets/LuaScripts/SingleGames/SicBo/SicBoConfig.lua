local SicBoConfig = Class("SicBoConfig");
local this = SicBoConfig;
this.ABNames = {
    chipPool = "SingleGames/SicBo/prefabs",
    audios = "SingleGames/SicBo/audios/",
    commonMain = "Common/GameArtsCommon/GameFight/alats/main",
}

this.ChipIcon = {}
function this.InitChipIcon()
    local ChipName = {}
    for i = 1, 7 do
        ChipName[i] = "yx_ph_cm_" .. i
    end
    local pics = resMgr:LoadSprite_List(this.ABNames.commonMain, ChipName)
    for i = 0, pics.Count - 1 do
        this.ChipIcon[i + 1] = pics[i]
    end
end

this.ChipPrefab = nil
function this.InitChipPrefab()
    this.ChipPrefab = resMgr:LoadGameObject(this.ABNames.chipPool, "Chip")
end

function this.Init()
    this.InitChipPrefab()
    this.InitChipIcon()
    require("PlatformHall/comonFight/MsgPro/pb_comonFight")


end

return this;
