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
    Dice2d = "SingleGames/SicBo/alats/Dice/2d",
    Dice3d = "SingleGames/SicBo/alats/Dice/3d",
    SmallBigIcon = "SingleGames/SicBo/alats/SmallBigIcon",
}
this.SmallBigIcon = {}
function this.InitSmallBigIcon()
    local Name = { "tb_big", "tb_small" }
    local pics = resMgr:LoadSprite_List(this.ABNames.SmallBigIcon, Name)
    for i = 0, pics.Count - 1 do
        this.SmallBigIcon[i + 1] = pics[i]
    end
end

this.Dice2dIcon = {}
function this.InitDice2dIcon()
    local Name = {}
    for i = 1, 6 do
        Name[i] = "tb_tz_" .. i
    end
    local pics = resMgr:LoadSprite_List(this.ABNames.Dice2d, Name)
    for i = 0, pics.Count - 1 do
        this.Dice2dIcon[i + 1] = pics[i]
    end
end

this.Dice3dIcon = {}
function this.InitDice3dIcon()
    local Name = {}
    for i = 1, 6 do
        Name[i] = "tb_tz_" .. i
    end
    local pics = resMgr:LoadSprite_List(this.ABNames.Dice3d, Name)
    for i = 0, pics.Count - 1 do
        this.Dice3dIcon[i + 1] = pics[i]
    end
end

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
    this.InitDice2dIcon()
    this.InitDice3dIcon()
    this.InitSmallBigIcon()
    require("PlatformHall/comonFight/MsgPro/pb_comonFight")
end

return this;
