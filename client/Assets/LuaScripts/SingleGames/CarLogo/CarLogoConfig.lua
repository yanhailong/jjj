---@class CarLogoConfig
local CarLogoConfig=Class("CarLogoConfig")
local  this = CarLogoConfig;

---车标数量
CarLogoConfig.LOGO_MAX = 24;

---车标类型
CarLogoConfig.LOGO_TYPE = {
    BJD = 1,
    FLL = 2,
    LBJN = 3,
    BSJ = 4,
    BC = 5,
    BM = 6,
    JB = 7,
    KDLK = 8
}

---车标图片 Car_cb_  Car_
CarLogoConfig.LOGO_IMAGES = {
    [this.LOGO_TYPE.BJD] = "bjd", --法拉利 布加迪
    [this.LOGO_TYPE.FLL] = "fll", --保时捷  法拉利
    [this.LOGO_TYPE.LBJN] = "lbjn", --玛莎拉蒂 兰博基尼
    [this.LOGO_TYPE.BSJ] = "bsj",  --奔驰 保时捷
    [this.LOGO_TYPE.BC] = "bc",  --宝马 奔驰
    [this.LOGO_TYPE.BM] = "bm",--凯迪拉克 宝马
    [this.LOGO_TYPE.JB] = "jb",  --大众 捷豹
    [this.LOGO_TYPE.KDLK] = "kdlk" --马自达 凯迪拉克
}

---车标赔率
CarLogoConfig.LOGO_ODDS = {
    [this.LOGO_TYPE.BJD]   = 40,
    [this.LOGO_TYPE.FLL]   = 30,
    [this.LOGO_TYPE.LBJN]   = 20,
    [this.LOGO_TYPE.BSJ]   = 10,
    [this.LOGO_TYPE.BC]   = 5,
    [this.LOGO_TYPE.BM]   = 5,
    [this.LOGO_TYPE.JB]   = 5,
    [this.LOGO_TYPE.KDLK]   = 5
};

---车标所在位置(从1开始，顺时针)
CarLogoConfig.LOGO_IDX = {
    [this.LOGO_TYPE.BJD] = { 4, 16},
    [this.LOGO_TYPE.FLL] = { 10, 22},
    [this.LOGO_TYPE.LBJN] = { 1, 13},
    [this.LOGO_TYPE.BSJ] = { 7, 19},
    [this.LOGO_TYPE.BC] = { 3, 9, 15, 21},
    [this.LOGO_TYPE.BM] = { 6, 12, 18, 24},
    [this.LOGO_TYPE.JB] = { 5, 11, 17, 23},
    [this.LOGO_TYPE.KDLK] = { 2, 8, 14, 20}
};

CarLogoConfig.LOGO_HISTORY = {
    this.LOGO_TYPE.BJD,
    this.LOGO_TYPE.FLL,
    this.LOGO_TYPE.LBJN,
    this.LOGO_TYPE.BSJ,
    this.LOGO_TYPE.BC,
    this.LOGO_TYPE.BM,
    this.LOGO_TYPE.JB,
    this.LOGO_TYPE.KDLK
}

CarLogoConfig.AUDIO_KEY = {
    KaiShiXiaZhu=1,  --开始下注
    StopXiaZhu=2,  --停止下注
    Running =3,  --旋转
    DaoJiShi=4,  --倒计时音效
    StopXiaZhuEnd =5,  --停止下注吹哨
    KaiShiXiaZhuEnd=6,  --开始下注播放完毕播放该音效
    Bet=7,  --筹码音效
    WinBet=8,  --筹码赢奖
}

---曲线关键帧
CarLogoConfig.CURVE_KEYS = {
    {0, 0},
    {0.217001, 0.2185733},
    {0.3953623, 0.6170632},
    {0.5479923, 0.8335034},
    {0.6578649, 0.9386156},
    {0.7526295, 0.9679444},
    {1, 1}
}

this.dizhuImgAtlas = "Common/GameArtsCommon/GameFight/alats/main"
this.effectPath = "SingleGames/CarLogo/effects/prefab"

---游戏ID
this.gameID = 200400
---当前选中的底注
this.dizhuIndex = 1
---底注数值
this.dizhuNumArr = {1,10,50,100,500,1000,2000}
---结算各动画阶段时间
this.ResultStageTime = {1,0.5,1,1,2,3,2.5,1}
---当前是否可以下注
this.allow = false
---当前总底注
this.totalDiZhuNums = {0,0,0,0,0,0,0,0}
---当前个人底注
this.selfDiZhuNums = {0,0,0,0,0,0,0,0}
this.selfXiaZhuInfo = {}
---阶段时间 [准备阶段时间-毫秒，押分阶段时间-毫秒，亮牌阶段时间-毫秒，结算阶段-毫秒]
this.StageTime = {0,15000,11000,0 }
---当前状态剩余秒数 13
this.lessSeconds = 13
--- 其他玩家下注显示筹码数限制
this.AreaChouMaLimit = { 60, 60, 60, 60, 60, 60, 60, 60}

---复投
this.lastXiaZhuInfo = {}
---本局是否使用了复投
this.isRepeat = false
---根据位置返回logoID
this.FindIndexByLogoId = function(index)
    for logo_id, pos in pairs(this.LOGO_IDX) do
        for i, ix in ipairs(pos) do
            if ix == index then return logo_id end
        end
    end
end

return this