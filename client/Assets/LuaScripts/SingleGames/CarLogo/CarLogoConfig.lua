---@class CarLogoConfig
local CarLogoConfig=Class("CarLogoConfig")
local  this = CarLogoConfig;

---车标数量
CarLogoConfig.LOGO_MAX = 24;

---筹码配置,必须从小到大排列
CarLogoConfig.CHOUMAS = {1,10,50,100,500};

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
    [this.LOGO_TYPE.LOGO1] = "CarLogo5",
    [this.LOGO_TYPE.LOGO2] = "CarLogo7",
    [this.LOGO_TYPE.LOGO3] = "CarLogo1",
    [this.LOGO_TYPE.LOGO4] = "CarLogo2",
    [this.LOGO_TYPE.LOGO5] = "CarLogo3",
    [this.LOGO_TYPE.LOGO6] = "CarLogo4",
    [this.LOGO_TYPE.LOGO7] = "CarLogo8",
    [this.LOGO_TYPE.LOGO8] = "CarLogo6"
}

---车标背景图
CarLogoConfig.LOGO_BG = {
    [this.LOGO_TYPE.LOGO1] = "CarLogo_Floor_BIG",
    [this.LOGO_TYPE.LOGO2] = "CarLogo_Floor_BIG",
    [this.LOGO_TYPE.LOGO3] = "CarLogo_Floor_SMALL",
    [this.LOGO_TYPE.LOGO4] = "CarLogo_Floor_SMALL",
    [this.LOGO_TYPE.LOGO5] = "CarLogo_Floor_SMALL",
    [this.LOGO_TYPE.LOGO6] = "CarLogo_Floor_BIG",
    [this.LOGO_TYPE.LOGO7] = "CarLogo_Floor_SMALL",
    [this.LOGO_TYPE.LOGO8] = "CarLogo_Floor_BIG"
}

---车标打灯
CarLogoConfig.LOGO_LIGHT = {
    [this.LOGO_TYPE.LOGO1] = "CarLogo_lighting_03",
    [this.LOGO_TYPE.LOGO2] = "CarLogo_lighting_03",
    [this.LOGO_TYPE.LOGO3] = "CarLogo_lighting_02",
    [this.LOGO_TYPE.LOGO4] = "CarLogo_lighting_02",
    [this.LOGO_TYPE.LOGO5] = "CarLogo_lighting_02",
    [this.LOGO_TYPE.LOGO6] = "CarLogo_lighting_03",
    [this.LOGO_TYPE.LOGO7] = "CarLogo_lighting_02",
    [this.LOGO_TYPE.LOGO8] = "CarLogo_lighting_03"
}

---车标选中
CarLogoConfig.LOGO_CHOOSE = {
    [this.LOGO_TYPE.LOGO1] = "CarLogo_Choose_Violet_01",
    [this.LOGO_TYPE.LOGO2] = "CarLogo_Choose_Violet_01",
    [this.LOGO_TYPE.LOGO3] = "CarLogo_Choose_Green_01",
    [this.LOGO_TYPE.LOGO4] = "CarLogo_Choose_Green_01",
    [this.LOGO_TYPE.LOGO5] = "CarLogo_Choose_Green_01",
    [this.LOGO_TYPE.LOGO6] = "CarLogo_Choose_Violet_01",
    [this.LOGO_TYPE.LOGO7] = "CarLogo_Choose_Green_01",
    [this.LOGO_TYPE.LOGO8] = "CarLogo_Choose_Violet_01"
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
    [this.LOGO_TYPE.LOGO1] = "CarLogoResult1_FRL_",
    [this.LOGO_TYPE.LOGO2] = "CarLogoResult1_PORSCHE_",
    [this.LOGO_TYPE.LOGO3] = "CarLogoResult1_MSR_",
    [this.LOGO_TYPE.LOGO4] = "CarLogoResult1_BENZ_",
    [this.LOGO_TYPE.LOGO5] = "CarLogoResult1_BWM_",
    [this.LOGO_TYPE.LOGO6] = "CarLogoResult1_CDL_",
    [this.LOGO_TYPE.LOGO7] = "CarLogoResult1_Result_VW_",
    [this.LOGO_TYPE.LOGO8] = "CarLogoResult1_MZD_"
}

---特殊效果类型，1=随机炸，2=跑火车，3=大四喜，4=小四喜，5=系统通杀
CarLogoConfig.SpecialEffects = {
    --随机炸
    RANDOM_BOOM = 1,
    --跑火车
    TRAIN = 2,
    --大四喜
    BIG_4_WINDS = 3,
    --小四喜
    SMALL_4_WINDS = 4,
    --系统通杀
    SYS_WIN = 5,
}

---基础时间
CarLogoConfig.BaseTime = 12;

---特殊效果额外的时间
CarLogoConfig.SpecTimes = {
    [this.SpecialEffects.RANDOM_BOOM] = 2,
    [this.SpecialEffects.TRAIN] = 4.5,
    [this.SpecialEffects.BIG_4_WINDS] = 0,
    [this.SpecialEffects.SMALL_4_WINDS] = 0,
    [this.SpecialEffects.SYS_WIN] = 0,
}

---每个押注区域直接显示筹码数限制
CarLogoConfig.Side_Show_Chouma_Num = 30

---押注時間
CarLogoConfig.BetTime = 15

---每局下注限制金额
CarLogoConfig.XiaZhu_Limit_Num = 2000000

--每一个区域场外玩家扔筹码的数量限制
CarLogoConfig.EveryArea_OtherPlayer_ThrowChouMa_Limit = 40

---当前选中的底注
this.dizhuIndex = 1
---底注数值
this.dizhuNumArr = {1,10,50,100,500}
---当前是否可以下注
this.allow = false
---本局结果
this.side = 0
---当前总底注
this.totalDiZhuNums = {0,0,0,0,0,0,0,0}
---当前个人底注
this.selfDiZhuNums = {0,0,0,0,0,0,0,0}
this.selfXiaZhuInfo = {}
---玩家真实金币数量
this.goldRealNum = 100000
---流程状态信息 当前房间阶段 1=等待押注,2=押注冻结，等待开牌,3=本局结束
this.currStatus = 1
---当前状态剩余秒数 13
this.lessSeconds = 13
---房间总人数
this.totalPlayerNum = 66

--- 每个押注区域直接显示筹码数限制
this.Side_Show_Chouma_Num = 60

--- 每局下注限制金额
this.XiaZhu_Limit_Info = {1000000,1000000,1000000,1000000,1000000,1000000,1000000,1000000} 

---闪烁时间
this.fadeTime = 0.5
---闪烁次数
this.fadeTimes = 1

---要押注最小金额
this.GameMinMoney = 5000

--- 其他玩家下注显示筹码数限制
this.OtherPlayer_ChouMaLimit = {60,60,60,60,60,60,60,60}

---复投
this.lastXiaZhuInfo = {}
---本局是否使用了复投
this.isRepeat = false
---本局下注数据
this.allXiaZhuData = {}

---下注时间
CAR_LOGO_GAME_TIME = 5

this.EventBinner = {
    XIAZHU = "CAR_LOGO_XIAZHU",
    XIAZHU_END = "CAR_LOGO_XIAZHU_END",
}

return this