--
--time:{time}
--{paramdesc} 
--@desc 
--
---@class DicePointsSumSizeConfig
local DicePointsSumSizeConfig = Class("DicePointsSumSizeConfig")
local this = DicePointsSumSizeConfig;

---游戏事件名
this.GameEventName = {
    UPDATE_PLAYER = "UPDATE_PLAYER",
    UPDATE_GAME_STATUS = "UPDATE_GAME_STATUS",
    REQUEST_BET = "REQUEST_BET",
    RES_BET_RESULT = "RES_BET_RESULT",
    UPDATE_GAME_INFO = "UPDATE_GAME_INFO",
    GAME_SETTLEMENT = "GAME_SETTLEMENT",
    SELF_SETTLEMENT = "SELF_SETTLEMENT",
    START_SIMULATION_SERVER = "START_SIMULATION_SERVER",
    STOP_SIMULATION_SERVER = "STOP_SIMULATION_SERVER",
    SYNC_TOTAL_BETS = "SYNC_TOTAL_BETS",
    NOTIFY_PLAYER_BET = "NOTIFY_PLAYER_BET",
    REQUEST_RANKLIST = "REQUEST_RANKLIST",
    RES_RANLKIST = "RES_RANKLIST",
}

---游戏阶段
this.GameState = {
    Prepare = 1,    --准备阶段
    Bet = 2,        --下注阶段
    Settlement = 3, --结算阶段
}

---骰子点数和类型
this.DiceSumType = {
    Small = 1,
    Big = 2,
    TypeCount = 2,
}

this.prepareStateDuration = 5      ---准备阶段持续时间
this.betStateDuration = 14         ---下注阶段持续时间
this.settlementStateDuration = 11  ---结算阶段持续时间
this.selfTestPlayerId = 1314       ---测试用自己的ID
this.otherTestPlayerStartId = 5000 ---测试用其他用户的起始ID

---底注数值
this.betValuesArr = {1,10,50,100,500,1000,5000}
--- 每个押注区域直接显示筹码数限制
this.Area_Show_Chip_Max_Num = 60

--- 每局下注限制金额
this.Bet_Limit_Info = {100000000,100000000,100000000,100000000,100000000,100000000}

this.ABNames={
    ChipPool="SingleGames/DicePointsSumSize/prefabs/Pool",--筹码
    diceRecordsIcon="SingleGames/DicePointsSumSize/atlas/dice/1",--游戏记录的骰子icon
    diceResultIcon="SingleGames/DicePointsSumSize/atlas/dice/2",--游戏结果的骰子icon
    mainIcon="SingleGames/DicePointsSumSize/atlas/main",--资源主路径
    commonMain = "Common/GameArtsCommon/GameFight/alats/main",--通用资源主路径
}

---获取对应筹码的预支名字
function this.GetChipPoolName(betIndex)
    return "DicePointsSumSizeChip_" .. betIndex
end

this.diceCount = 3  --每局骰子数量
this.diceSideCount = 6  --每个骰子面数
this.showRecordCount = 3  --显示记录条数
this.chipItemShowCount = 5 --下注的时候显示可选筹码数量

--点数之和类型对应的点数和的字体颜色
this.diceSumShowData = {{ r = 0.8196079, g = 0.3372549, b = 0.3372549, a = 1}, 
                       { r = 0.7294118, g = 0.3843137, b = 0.6862745, a = 1},}

---游戏记录的骰子
this.diceRecords_Pics = {}
function this.InitDiceRecordsPic()
    local pics=resMgr:LoadAllAssets(this.ABNames.diceRecordsIcon,typeof(UnityEngine.Sprite))
    for i = 0, pics.Length-1 do
        local pic=pics[i];
        this.diceRecords_Pics[pic.name]=pic;
    end
end

---游戏结果的骰子
this.diceResult_Pics = {}
function this.InitDiceResultPic()
    local pics=resMgr:LoadAllAssets(this.ABNames.diceResultIcon,typeof(UnityEngine.Sprite))
    for i = 0, pics.Length-1 do
        local pic=pics[i];
        this.diceResult_Pics[pic.name]=pic;
    end
end

---通用资源
this.commonMain_Pics = {}
function this.InitCommonMainPic()
    local pics=resMgr:LoadAllAssets(this.ABNames.commonMain,typeof(UnityEngine.Sprite))
    for i = 0, pics.Length-1 do
        local pic=pics[i];
        this.commonMain_Pics[pic.name]=pic;
    end
end

---Main里面的图片
this.icon_Pics={}
function this.InitIconPic()
    local pics=resMgr:LoadAllAssets(this.ABNames.mainIcon,typeof(UnityEngine.Sprite))
    for i = 0, pics.Length-1 do
        local pic=pics[i];
        this.icon_Pics[pic.name]=pic;
    end
end

return this