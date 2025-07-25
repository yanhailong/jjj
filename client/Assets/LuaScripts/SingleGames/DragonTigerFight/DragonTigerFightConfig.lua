--
--time:{time}
--{paramdesc} 
--@desc 
--
---@class DragonTigerFightConfig
local DragonTigerFightConfig=Class("DragonTigerFightConfig")
local this = DragonTigerFightConfig;

---游戏ID
this.gameID = 200101
---阶段时间 [准备阶段时间-毫秒，押分阶段时间-毫秒，亮牌阶段时间-毫秒，结算阶段-毫秒]
this.StageTime = {2000,13000,13000,0}
---结算各动画阶段时间
this.ResultStageTime = {1,0.5,1,1,2,3,2.5,1}

---当前选中的底注
this.dizhuIndex = 0
---底注数值
this.dizhuImgAtlas = "Common/GameArtsCommon/GameFight/alats/main"
---当前是否可以下注
this.allow = true
---当前总底注
this.totalDiZhuNums = {0,0,0}
---当前个人底注
this.selfDiZhuNums = {0,0,0}
---当前状态剩余秒数 13
this.lessSeconds = 13
---闪烁时间
this.fadeTime = 0.5
---闪烁次数
this.fadeTimes = 1
--- 玩家下注显示筹码数限制
this.AreaChouMaLimit = { 80, 80, 60}

---复投
this.lastXiaZhuInfo = {}
---本局下注数据
this.selfXiaZhuInfo = {}
---本局是否使用了复投
this.isRepeat = false

this.AUDIO_KEY = {
    ADD_CHIP=1,  --玩家下注筹码飞行音效
    BET_READY=2,  --准备阶段音效
    BET_END =3,  --下注阶段结束音效
    BET_START=4,  --下注阶段开始音效
    DJS_NUM =5,  --倒计时音效
    DJS_END=6,  --倒计时结束音效
    DEAL=7,  --发牌音效
    END_COIN_FLY=8,  --结算阶段分筹码音效
    FLIP_CARD=9,--翻牌音效
}
---龙虎斗结果值定义
DRAGON_TIGER_FIGHT_WIN_SIDE = {
    LONG = 1,
    HU = 2,
    HE = 3
}
---龙虎斗路信息有无规则定义
DRAGON_TIGER_FIGHT_ROAD_SIDE = {
    YES = 2,
    NO = 1
}

return this