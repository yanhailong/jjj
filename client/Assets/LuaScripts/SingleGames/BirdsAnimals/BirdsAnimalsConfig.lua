---@class BirdsAnimalsConfig
local BirdsAnimalsConfig=Class("BirdsAnimalsConfig")
local  this = BirdsAnimalsConfig;

---车标数量
BirdsAnimalsConfig.ANIMAL_MAX=28;

---筹码配置,必须从小到大排列
BirdsAnimalsConfig.CHOUMAS = {1,10,50,100,500};


--飞禽走兽类型 飞禽、 金雕、天鹅、火烈鸟、鸽子、走兽、狮子、熊、鹿、猴子
BirdsAnimalsConfig.ANIMAL_TYPE={
    JINSHA  = 1, --金鲨
    YINSHA  = 2, --银鲨
    TIANE   = 3, --天鹅
    GEZI    = 4, --鸽子
    HUOLIENIAO = 5, --火烈鸟
    DIAO    = 6, --金雕
    LUZI    = 7, --鹿
    HOUZI   = 8, --猴子
    XION    = 9, --熊
    SHIZI   = 10, --狮子
    TONGSHA = 11, --通杀
    TONGPEI = 12, --通赔
    FeiQin  = 13, --飞禽类
    ZouShou = 14, --走兽类

}

---@see 飞禽走兽历史记录排序
BirdsAnimalsConfig.ANIMA_HISTORY = {
    this.ANIMAL_TYPE.TIANE,
    this.ANIMAL_TYPE.GEZI,
    this.ANIMAL_TYPE.FeiQin,
    this.ANIMAL_TYPE.ZouShou,
    this.ANIMAL_TYPE.HOUZI,
    this.ANIMAL_TYPE.LUZI,
    this.ANIMAL_TYPE.HUOLIENIAO,
    this.ANIMAL_TYPE.DIAO,
    this.ANIMAL_TYPE.JINSHA,
    this.ANIMAL_TYPE.YINSHA,
    this.ANIMAL_TYPE.SHIZI,
    this.ANIMAL_TYPE.XION
}

--- 飞禽走兽中等Logo
BirdsAnimalsConfig.ANIMA_ICON_IMAGES = {
    [this.ANIMAL_TYPE.TONGSHA]="BirdsAnimals_TONGSHA_01",
    [this.ANIMAL_TYPE.TONGPEI]="BirdsAnimals_TONGPEI_01",
    [this.ANIMAL_TYPE.JINSHA] ="BirdsAnimals_JINSHA_01",
    [this.ANIMAL_TYPE.YINSHA] ="BirdsAnimals_YINSHA_01",
    [this.ANIMAL_TYPE.TIANE]  ="BirdsAnimals_TIANE_01",
    [this.ANIMAL_TYPE.GEZI]   ="BirdsAnimals_GEZI_01",
    [this.ANIMAL_TYPE.HUOLIENIAO]="BirdsAnimals_HULIENIAO_01",
    [this.ANIMAL_TYPE.DIAO]   ="BirdsAnimals_LAOYING_01",
    [this.ANIMAL_TYPE.LUZI]   ="BirdsAnimals_LU_01",
    [this.ANIMAL_TYPE.HOUZI]  ="BirdsAnimals_HOUZI_01",
    [this.ANIMAL_TYPE.XION]="BirdsAnimals_XIONG_01",
    [this.ANIMAL_TYPE.SHIZI]  ="BirdsAnimals_SHIZI_01",
}

--- 飞禽走兽小Logo
BirdsAnimalsConfig.ANIMA_SMALL_IMAGES = {
    [this.ANIMAL_TYPE.TONGSHA]="BirdsAnimals_TONGSHA_02",
    [this.ANIMAL_TYPE.TONGPEI]="BirdsAnimals_TONGPEI_02",
    [this.ANIMAL_TYPE.JINSHA] ="BirdsAnimals_JINSHA_02",
    [this.ANIMAL_TYPE.YINSHA] ="BirdsAnimals_YINSHA_02",
    [this.ANIMAL_TYPE.TIANE]  ="BirdsAnimals_TIANE_02",
    [this.ANIMAL_TYPE.GEZI]   ="BirdsAnimals_GEZI_02",
    [this.ANIMAL_TYPE.HUOLIENIAO]="BirdsAnimals_HULIENIAO_02",
    [this.ANIMAL_TYPE.DIAO]   ="BirdsAnimals_LAOYING_02",
    [this.ANIMAL_TYPE.LUZI]   ="BirdsAnimals_LU_02",
    [this.ANIMAL_TYPE.HOUZI]  ="BirdsAnimals_HOUZI_02",
    [this.ANIMAL_TYPE.XION]="BirdsAnimals_XIONG_02",
    [this.ANIMAL_TYPE.SHIZI]  ="BirdsAnimals_SHIZI_02",
}

--- 飞禽走兽名称文字
BirdsAnimalsConfig.ANIMA_NAME_IMAGES = {
    [this.ANIMAL_TYPE.JINSHA] ="BirdsAnimals_JINGSHA_Zi",
    [this.ANIMAL_TYPE.YINSHA] ="BirdsAnimals_YINSHA_Zi",
    [this.ANIMAL_TYPE.TIANE]  ="BirdsAnimals_TIANE_Zi",
    [this.ANIMAL_TYPE.GEZI]   ="BirdsAnimals_GEZI_Zi",
    [this.ANIMAL_TYPE.HUOLIENIAO]="BirdsAnimals_HUOLIENIAO_Zi",
    [this.ANIMAL_TYPE.DIAO]   ="BirdsAnimals_YING_Zi",
    [this.ANIMAL_TYPE.LUZI]   ="BirdsAnimals_LU_Zi",
    [this.ANIMAL_TYPE.HOUZI]  ="BirdsAnimals_HOUZI_Zi",
    [this.ANIMAL_TYPE.XION]="BirdsAnimals_XIONG_Zi",
    [this.ANIMAL_TYPE.SHIZI]  ="BirdsAnimals_SHIZI_Zi",
}

BirdsAnimalsConfig.ANIMA_NAME_LANGUAGE = {
    [this.ANIMAL_TYPE.JINSHA] ="Golden Shark",
    [this.ANIMAL_TYPE.YINSHA] ="Golden Eagle",
    [this.ANIMAL_TYPE.TIANE]  ="Swan",
    [this.ANIMAL_TYPE.GEZI]   ="Pigeon",
    [this.ANIMAL_TYPE.HUOLIENIAO]="Flamingo",
    [this.ANIMAL_TYPE.DIAO]   ="Sliver Shark",
    [this.ANIMAL_TYPE.LUZI]   ="Deer",
    [this.ANIMAL_TYPE.HOUZI]  ="Monkey",
    [this.ANIMAL_TYPE.XION]="Dear",
    [this.ANIMAL_TYPE.SHIZI]  ="Lion",
}

BirdsAnimalsConfig.ANIMAL_TAG =
{
    FeiQin = 1,
    ZouShou = 2,
}

BirdsAnimalsConfig.ANIMAL_GROUP = {
    [this.ANIMAL_TAG.FeiQin] = {  --飞禽类
        [this.ANIMAL_TYPE.TIANE]   = 1,
        [this.ANIMAL_TYPE.GEZI]    = 1,
        [this.ANIMAL_TYPE.HUOLIENIAO] = 1,
        [this.ANIMAL_TYPE.DIAO]    = 1
    }    ,
    [this.ANIMAL_TAG.ZouShou] = {  --走兽类
        [this.ANIMAL_TYPE.LUZI]     = 1,
        [this.ANIMAL_TYPE.HOUZI]    = 1,
        [this.ANIMAL_TYPE.XION]     = 1,
        [this.ANIMAL_TYPE.SHIZI]    = 1,
    }
};

--各种类型的赔率
BirdsAnimalsConfig.ODDS={
    [this.ANIMAL_TYPE.FeiQin]        =2,    --飞禽类
    [this.ANIMAL_TYPE.ZouShou]       =2,    --走兽类
    [this.ANIMAL_TYPE.TONGSHA]=1,    --通杀
    [this.ANIMAL_TYPE.TONGPEI]=-1,   --通赔
    [this.ANIMAL_TYPE.JINSHA] =100, --金鲨
    [this.ANIMAL_TYPE.YINSHA] =24,   --银鲨
    [this.ANIMAL_TYPE.TIANE]  =6,    --天鹅
    [this.ANIMAL_TYPE.GEZI]   =8,    --鸽子
    [this.ANIMAL_TYPE.HUOLIENIAO]=8,    --火烈鸟
    [this.ANIMAL_TYPE.DIAO]   =12,   --金雕
    [this.ANIMAL_TYPE.LUZI]   =6,    --鹿
    [this.ANIMAL_TYPE.HOUZI]  =8,    --猴子
    [this.ANIMAL_TYPE.XION]   =8,    --熊
    [this.ANIMAL_TYPE.SHIZI]  =12,   --狮子
}

--类型所在位置(从1开始，顺时针)
BirdsAnimalsConfig.LOGO_IDX={
    [this.ANIMAL_TYPE.TONGSHA]={22},    --通杀
    [this.ANIMAL_TYPE.TONGPEI]={8},   --通赔
    [this.ANIMAL_TYPE.JINSHA] ={1}, --金鲨
    [this.ANIMAL_TYPE.YINSHA] ={15},   --银鲨
    [this.ANIMAL_TYPE.TIANE]  ={23,24,25},    --天鹅
    [this.ANIMAL_TYPE.GEZI]   ={26,27,28},    --鸽子
    [this.ANIMAL_TYPE.HUOLIENIAO]={19,20,21},    --火烈鸟
    [this.ANIMAL_TYPE.DIAO]   ={16,17,18},   --金雕
    [this.ANIMAL_TYPE.LUZI]   ={5,6,7},    --鹿
    [this.ANIMAL_TYPE.HOUZI]  ={2,3,4},    --猴子
    [this.ANIMAL_TYPE.XION]=  {9,10,11},   --熊
    [this.ANIMAL_TYPE.SHIZI]  ={12,13,14},   --狮子
}

---曲线关键帧
BirdsAnimalsConfig.CURVE_KEYS = {
    {0, 0},
    {0.217001, 0.2185733},
    {0.3953623, 0.6170632},
    {0.5479923, 0.8335034},
    {0.6578649, 0.9386156},
    {0.7526295, 0.9679444},
    {1, 1}
}


--基础时间
BirdsAnimalsConfig.BaseTime = 17;

--上庄
BirdsAnimalsConfig.UpBanker = {
    maxBetTimes = 3,--最大下注倍数
    maxRemainBankerTimes = 10,--最大连庄次数
    minBetMoney = 10,--最低携带可玩金额
}

---@see 每个押注区域直接显示筹码数限制
BirdsAnimalsConfig.Side_Show_Chouma_Num = 30

---@see 押注倒計時特別提醒
BirdsAnimalsConfig.COUNTDOWN = 3

--每一个区域场外玩家扔筹码的数量限制
BirdsAnimalsConfig.EveryArea_OtherPlayer_ThrowChouMa_Limit = 40

---当前选中的底注
this.dizhuIndex = 1
---底注数值
this.dizhuNumArr = {1,10,50,100,500}
---当前是否可以下注
this.allow = false
---本局结果
this.side = 0
---当前总底注
this.totalDiZhuNums = {0,0,0,0,0,0,0,0,0,0,0,0,0,0}
---当前个人底注
this.selfDiZhuNums = {0,0,0,0,0,0,0,0,0,0,0,0,0,0}
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
this.XiaZhu_Limit_Info = {1000000,1000000,1000000,1000000,1000000,1000000,1000000,1000000,1000000,1000000,1000000,1000000,1000000,1000000} 

---闪烁时间
this.fadeTime = 0.5
---闪烁次数
this.fadeTimes = 1

---要押注最小金额
this.GameMinMoney = 5000

--- 其他玩家下注显示筹码数限制
this.OtherPlayer_ChouMaLimit = {60,60,60,60,60,60,60,60,60,60,60,60,60,60}

---复投
this.lastXiaZhuInfo = {}
---本局是否使用了复投
this.isRepeat = false
---本局下注数据
this.allXiaZhuData = {}

---下注时间
BIRDS_ANIMALS_GAME_TIME = 5

this.EventBinner = {
    XIAZHU = "BIRDS_ANIMALS_XIAZHU",
    XIAZHU_END = "BIRDS_ANIMALS_XIAZHU_END",
}

return this