---@class CarLogoConfig
local CarLogoConfig=Class("CarLogoConfig")
local  this = CarLogoConfig;

---车标数量
CarLogoConfig.LOGO_MAX = 24;

---车标类型
CarLogoConfig.LOGO_TYPE = {
    LOGO1   = 1,
    LOGO2   = 2,
    LOGO3   = 3,
    LOGO4   = 4,
    LOGO5   = 5,
    LOGO6   = 6,
    LOGO7   = 7,
    LOGO8   = 8
}

---车标图片
CarLogoConfig.LOGO_IMAGES = {
    [this.LOGO_TYPE.LOGO1] = "Car_cb_bjd",
    [this.LOGO_TYPE.LOGO2] = "Car_cb_fll",
    [this.LOGO_TYPE.LOGO3] = "Car_cb_lbjn",
    [this.LOGO_TYPE.LOGO4] = "Car_cb_bsj",
    [this.LOGO_TYPE.LOGO5] = "Car_cb_bc",
    [this.LOGO_TYPE.LOGO6] = "Car_cb_bm",
    [this.LOGO_TYPE.LOGO7] = "Car_cb_jb",
    [this.LOGO_TYPE.LOGO8] = "Car_cb_kdlk"
}

---车标赔率
CarLogoConfig.LOGO_ODDS = {
    [this.LOGO_TYPE.LOGO1]   = 40,
    [this.LOGO_TYPE.LOGO2]   = 30,
    [this.LOGO_TYPE.LOGO3]   = 20,
    [this.LOGO_TYPE.LOGO4]   = 10,
    [this.LOGO_TYPE.LOGO5]   = 5,
    [this.LOGO_TYPE.LOGO6]   = 5,
    [this.LOGO_TYPE.LOGO7]   = 5,
    [this.LOGO_TYPE.LOGO8]   = 5
};

---车标所在位置(从1开始，顺时针)
CarLogoConfig.LOGO_IDX = {
    [this.LOGO_TYPE.LOGO1] = {1,13},
    [this.LOGO_TYPE.LOGO2] = {7, 19},
    [this.LOGO_TYPE.LOGO3] = {10, 22},
    [this.LOGO_TYPE.LOGO4] = {4, 16},
    [this.LOGO_TYPE.LOGO5] = {6, 12, 18, 24},
    [this.LOGO_TYPE.LOGO6] = {3, 9, 15, 21},
    [this.LOGO_TYPE.LOGO7] = {2, 8, 14, 20},
    [this.LOGO_TYPE.LOGO8] = {5, 11, 17, 23}
};

---车标选中
CarLogoConfig.LOGO_RESULT = {
    [this.LOGO_TYPE.LOGO1] = "Car_bjd",
    [this.LOGO_TYPE.LOGO2] = "Car_fll",
    [this.LOGO_TYPE.LOGO3] = "Car_lbjn",
    [this.LOGO_TYPE.LOGO4] = "Car_bsj",
    [this.LOGO_TYPE.LOGO5] = "Car_bc",
    [this.LOGO_TYPE.LOGO6] = "Car_bm",
    [this.LOGO_TYPE.LOGO7] = "Car_jb",
    [this.LOGO_TYPE.LOGO8] = "Car_kdlk"
}

CarLogoConfig.LOGO_HISTORY = {
    this.LOGO_TYPE.LOGO1,
    this.LOGO_TYPE.LOGO2,
    this.LOGO_TYPE.LOGO3,
    this.LOGO_TYPE.LOGO4,
    this.LOGO_TYPE.LOGO5,
    this.LOGO_TYPE.LOGO6,
    this.LOGO_TYPE.LOGO7,
    this.LOGO_TYPE.LOGO8
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

return this