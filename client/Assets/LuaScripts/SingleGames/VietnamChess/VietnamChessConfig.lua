--
--time:{time}
--{paramdesc} 
--@desc 
--
---@class VietnamChessConfig
local VietnamChessConfig=Class("VietnamChessConfig")
local this = VietnamChessConfig;

---棋子颜色对应ID
this.QICOLOR={
    WHITE = 0,--偶 白-红
    BLACK = 1 --奇 黑
}
---棋型序号定义 1-5 对应 index 通过判断白子数确定
this.CHESS_TYPE={
    1,--3 1
    3,--1 2
    4,--0 3
    2,--2 4
    0,--4 5
}
---倍率类型 区域序号定义
this.CHESS_ODS_TYPE = {
    OUSHU=3,
    JISHU=4,
    WHITEONE=5,
    BLACKONE=6,
    WHITEALL=2,
    BLACKALL=1,
}
---棋型倍率
this.CHESS_ODS = {
    [this.CHESS_ODS_TYPE.OUSHU]=1.98,
    [this.CHESS_ODS_TYPE.JISHU]=1.98,
    [this.CHESS_ODS_TYPE.WHITEONE]=3.9,
    [this.CHESS_ODS_TYPE.BLACKONE]=3.9,
    [this.CHESS_ODS_TYPE.WHITEALL]=15,
    [this.CHESS_ODS_TYPE.BLACKALL]=15
}
---对应CHESS_TYPE
this.CHESS_ODS_GROUP = {
    [this.CHESS_ODS_TYPE.OUSHU]={3,4,5},
    [this.CHESS_ODS_TYPE.JISHU]={1,2},
    [this.CHESS_ODS_TYPE.WHITEONE]={1},
    [this.CHESS_ODS_TYPE.BLACKONE]={2},
    [this.CHESS_ODS_TYPE.WHITEALL]={3},
    [this.CHESS_ODS_TYPE.BLACKALL]={5}
}

---当前选中的底注
this.dizhuIndex = 1
---底注数值
this.dizhuNumArr = {1,10,50,100,500}
---当前是否可以下注
this.allow = true
---本局结果
this.side = 0
this.isouNum = true
this.sideArea = {}
---本局棋子颜色
this.sideColor = {0,0,0,0}
---当前总底注
this.totalDiZhuNums = {0,0,0,0,0,0}
---当前个人底注
this.selfDiZhuNums = {0,0,0,0,0,0}
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
this.XiaZhu_Limit_Info = {1000000,1000000,120000,1000000,1000000,120000} 

---闪烁时间
this.fadeTime = 0.5
---闪烁次数
this.fadeTimes = 1

---要押注最小金额
this.GameMinMoney = 5000

--- 其他玩家下注显示筹码数限制
this.OtherPlayer_ChouMaLimit = {80,80,80,80,80,80}

---复投
this.lastXiaZhuInfo = {}
---本局是否使用了复投
this.isRepeat = false
---本局下注数据
this.allXiaZhuData = {}

---下注时间
VIETNAM_CHESS_GAME_TIME = 5
---路列数
VIETNAM_CHESS_ROAD_COL = 10
return this