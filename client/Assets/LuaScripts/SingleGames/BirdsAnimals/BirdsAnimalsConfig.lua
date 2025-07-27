---@class BirdsAnimalsConfig
local BirdsAnimalsConfig=Class("BirdsAnimalsConfig")
local  this = BirdsAnimalsConfig;

---车标数量
BirdsAnimalsConfig.ANIMAL_MAX=28;

--飞禽走兽类型
BirdsAnimalsConfig.ANIMAL_TYPE={
    YINGWU = 1, --鹦鹉
    GEZI    = 2, --鸽子  
    FeiQin  = 3, --飞禽类
    ZouShou = 4, --走兽类
    TIGER = 5, --老虎
    HAONIU = 6, --耗牛
    HUOLIENIAO = 7, --火烈鸟
    LAOYING = 8, --老鹰
    JINSHA  = 9, --金鲨
    YINSHA  = 10, --银鲨
    SHIZI   = 11, --狮子
    XION    = 12, --熊
    TONGSHA = 13, --通杀
    TONGPEI = 14, --通赔

}

---@see 飞禽走兽历史记录排序
BirdsAnimalsConfig.ANIMA_HISTORY = {
    this.ANIMAL_TYPE.YINGWU,
    this.ANIMAL_TYPE.GEZI,
    this.ANIMAL_TYPE.FeiQin,
    this.ANIMAL_TYPE.ZouShou,
    this.ANIMAL_TYPE.TIGER,
    this.ANIMAL_TYPE.HAONIU,
    this.ANIMAL_TYPE.HUOLIENIAO,
    this.ANIMAL_TYPE.LAOYING,
    this.ANIMAL_TYPE.JINSHA,
    this.ANIMAL_TYPE.YINSHA,
    this.ANIMAL_TYPE.SHIZI,
    this.ANIMAL_TYPE.XION
}

--- 飞禽走兽中等Logo
BirdsAnimalsConfig.ANIMA_ICON_IMAGES = {
    [this.ANIMAL_TYPE.TONGSHA]="fqzs_ph_xz",
    [this.ANIMAL_TYPE.TONGPEI]="fqzs_ph_zd",
    [this.ANIMAL_TYPE.JINSHA] ="fqzs_ph_js",
    [this.ANIMAL_TYPE.YINSHA] ="fqzs_ph_ys",
    [this.ANIMAL_TYPE.YINGWU]  ="fqzs_ph_n",
    [this.ANIMAL_TYPE.GEZI]   ="fqzs_ph_gz",
    [this.ANIMAL_TYPE.HUOLIENIAO]="fqzs_ph_hln",
    [this.ANIMAL_TYPE.LAOYING]   ="fqzs_ph_ly",
    [this.ANIMAL_TYPE.TIGER]   ="fqzs_ph_tiger",
    [this.ANIMAL_TYPE.HAONIU]  ="fqzs_ph_dx",
    [this.ANIMAL_TYPE.XION]= "fqzs_ph_x",
    [this.ANIMAL_TYPE.SHIZI]  ="fqzs_ph_sz",
}

BirdsAnimalsConfig.ANIMA_NAME_LANGUAGE = {
    [this.ANIMAL_TYPE.JINSHA] =200300030,
    [this.ANIMAL_TYPE.YINSHA] =200300031,
    [this.ANIMAL_TYPE.YINGWU] =200300020,
    [this.ANIMAL_TYPE.GEZI]   =200300021,
    [this.ANIMAL_TYPE.HUOLIENIAO]=200300024,
    [this.ANIMAL_TYPE.LAOYING]   =200300025,
    [this.ANIMAL_TYPE.TIGER]   =200300027,
    [this.ANIMAL_TYPE.HAONIU]  =200300026,
    [this.ANIMAL_TYPE.XION]   =200300028,
    [this.ANIMAL_TYPE.SHIZI]  =200300029,
    [this.ANIMAL_TYPE.FeiQin] = 200300022,
    [this.ANIMAL_TYPE.ZouShou] = 200300023,
    [this.ANIMAL_TYPE.TONGSHA] = 200300033,
    [this.ANIMAL_TYPE.TONGPEI] = 200300032,
}

BirdsAnimalsConfig.ANIMAL_TAG =
{
    FeiQin = 1,
    ZouShou = 2,
}

BirdsAnimalsConfig.ANIMAL_GROUP = {
    [this.ANIMAL_TAG.FeiQin] = {  --飞禽类
        [this.ANIMAL_TYPE.YINGWU]   = 1,
        [this.ANIMAL_TYPE.GEZI]    = 1,
        [this.ANIMAL_TYPE.HUOLIENIAO] = 1,
        [this.ANIMAL_TYPE.LAOYING]    = 1
    },
    [this.ANIMAL_TAG.ZouShou] = {  --走兽类
        [this.ANIMAL_TYPE.HAONIU]    = 1,
        [this.ANIMAL_TYPE.TIGER]     = 1,
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
    [this.ANIMAL_TYPE.YINGWU]  =6,    --鹦鹉
    [this.ANIMAL_TYPE.GEZI]   =8,    --鸽子
    [this.ANIMAL_TYPE.HUOLIENIAO]=8,    --火烈鸟
    [this.ANIMAL_TYPE.LAOYING]   =12,   --老鹰
    [this.ANIMAL_TYPE.TIGER]   =8,    --老虎
    [this.ANIMAL_TYPE.HAONIU]  =6,    --耗牛
    [this.ANIMAL_TYPE.XION]   =8,    --熊
    [this.ANIMAL_TYPE.SHIZI]  =12,   --狮子
}

--类型所在位置(从1开始，顺时针)
BirdsAnimalsConfig.LOGO_IDX={
    [this.ANIMAL_TYPE.TONGSHA]={27},    --通杀
    [this.ANIMAL_TYPE.TONGPEI]={13},   --通赔
    [this.ANIMAL_TYPE.JINSHA] ={6}, --金鲨
    [this.ANIMAL_TYPE.YINSHA] ={20},   --银鲨
    [this.ANIMAL_TYPE.YINGWU]  ={ 3, 4, 5},    --鹦鹉
    [this.ANIMAL_TYPE.GEZI]   ={1,2,28},    --鸽子
    [this.ANIMAL_TYPE.HUOLIENIAO]={24,25,26},    --火烈鸟
    [this.ANIMAL_TYPE.LAOYING]   ={ 21, 22, 23},   --老鹰
    [this.ANIMAL_TYPE.TIGER]   ={ 10, 11, 12},    --老虎
    [this.ANIMAL_TYPE.HAONIU]  ={ 7, 8, 9},    --耗牛
    [this.ANIMAL_TYPE.XION]=  {14,15,16},   --熊
    [this.ANIMAL_TYPE.SHIZI]  ={17,18,19},   --狮子
}

BirdsAnimalsConfig.AUDIO_KEY = {
    KaiShiXiaZhu=1,  --开始下注
    StopXiaZhu=2,  --停止下注
    XuanZhuan=3,  --旋转 开始旋转的时候，慢速旋转的音效，单次播放
    DaoJiShi=4,  --倒计时音效
    StopXiaZhuEnd =5,  --停止下注吹哨
    End=6,  --转轴停止的音效
    Running=7,  --转轴旋转 转轴旋转的音效，单次播放
    WinBet=8,  --筹码赢奖
    Bet=9,  --筹码音效
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

this.dizhuImgAtlas = "Common/GameArtsCommon/GameFight/alats/main"

---游戏ID
this.gameID = 200300
---当前选中的底注
this.dizhuIndex = 1
---底注数值
this.dizhuNumArr = {1,10,50,100,500,1000,2000}
---结算各动画阶段时间
this.ResultStageTime = {1,0.5,1,1,2,3,2.5,1}
---当前是否可以下注
this.allow = false
---当前总底注
this.totalDiZhuNums = {0,0,0,0,0,0,0,0,0,0,0,0,0,0}
---当前个人底注
this.selfDiZhuNums = {0,0,0,0,0,0,0,0,0,0,0,0,0,0}
this.selfXiaZhuInfo = {}
---阶段时间 [准备阶段时间-毫秒，押分阶段时间-毫秒，亮牌阶段时间-毫秒，结算阶段-毫秒]
this.StageTime = {0,15000,16000,0 }
---当前状态剩余秒数 13
this.lessSeconds = 13
--- 其他玩家下注显示筹码数限制
this.AreaChouMaLimit = { 60, 60, 60, 60, 60, 60, 60, 60, 60, 60, 60, 60, 60, 60}

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