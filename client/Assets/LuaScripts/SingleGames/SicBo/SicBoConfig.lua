local SicBoConfig = {}
local this = SicBoConfig
this.GameState = {
    START_GAME = 0,                --游戏开始
    BET = 1,                       --下注
    PLAY_CART = 2,                 --出牌
    DISS_MISS = 3,                 --解散房间
    WAIT_READY = 4,                --等待开始
    GAME_ROUND_OVER_SETTLEMENT = 5 --游戏一个回合结束进行结算
}





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
