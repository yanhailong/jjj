--
--time:{time}
--{paramdesc} 
--@desc 
--
---@class DragonTigerFightConfig
local DragonTigerFightConfig=Class("DragonTigerFightConfig")
local this = DragonTigerFightConfig;

---玩家信息
this.selfPlayer = {
     playerId = 9999,
     nickName = "9999",
     gold = 9999,
     diamond = 9999,
     vipLevel = 1,
}
---游戏ID
this.gameID = 200101
---当前选中的底注
this.dizhuIndex = 1
---底注数值
this.dizhuNumArr = {10,50,100,500,1000,5000,10000}
this.dizhuImgAtlas = "Common/GameArtsCommon/GameFight/alats/main"
---筹码颜色
this.dizhuColor = "yx_ph_cm_"
---当前是否可以下注
this.allow = true
---本局结果
this.side = 0
---当前总底注
this.totalDiZhuNums = {0,0,0}
---当前个人底注
this.selfDiZhuNums = {0,0,0}
this.selfXiaZhuInfo = {}
---玩家真实金币数量
this.goldRealNum = 100000
---流程状态信息 当前房间阶段 1=等待押注,2=押注冻结，等待开牌,3=本局结束
this.currStatus = 1
---阶段时间 [准备阶段时间-毫秒，押分阶段时间-毫秒，亮牌阶段时间-毫秒，结算阶段-毫秒]
this.StageTime = {3000,15000,5000,5000}
---当前状态剩余秒数 13
this.lessSeconds = 13
---房间总人数
this.totalPlayerNum = 66

--- 每个押注区域直接显示筹码数限制
this.Side_Show_Chouma_Num = 60

--- 每局下注限制金额
this.XiaZhu_Limit_Info = {1000000,1000000,120000}  -- 1 龙  2 虎   3 和

---闪烁时间
this.fadeTime = 0.5
---闪烁次数
this.fadeTimes = 1

---要押注最小金额
this.GameMinMoney = 5000

--- 其他玩家下注显示筹码数限制
this.OtherPlayer_ChouMaLimit = {80,80,60}

---复投
this.lastXiaZhuInfo = {}
---本局是否使用了复投
this.isRepeat = false


---下注时间
DRAGON_TIGER_FIGHT_GAME_TIME = 5

DRAGON_TIGER_FIGHT_WIN_SIDE = {
    LONG = 1,
    HU = 2,
    HE = 3
}

DRAGON_TIGER_FIGHT_ROAD_SIDE = {
    YES = 2,
    NO = 1
}

return this