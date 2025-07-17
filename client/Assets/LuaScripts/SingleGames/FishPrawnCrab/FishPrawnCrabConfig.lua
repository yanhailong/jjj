--
--time:{time}
--{paramdesc} 
--@desc 
--
---@class
local FishPrawnCrabConfig = Class("FishPrawnCrabConfig")
local this = FishPrawnCrabConfig;

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
}

---游戏阶段
this.GameState = {
    Prepare = 1,    --准备阶段
    Bet = 2,        --下注阶段
    Settlement = 3, --结算阶段
}

this.prepareStateDuration = 3      ---准备阶段持续时间
this.betStateDuration = 14         ---下注阶段持续时间
this.settlementStateDuration = 11  ---结算阶段持续时间
this.selfTestPlayerId = 1314       ---测试用自己的ID
this.otherTestPlayerStartId = 5000 ---测试用其他用户的起始ID

---底注数值
this.betValuesArr = {1000,5000,10000,50000,100000,500000,1000000}
--- 每个押注区域直接显示筹码数限制
this.Area_Show_Chip_Max_Num = 60

--- 每局下注限制金额
this.Bet_Limit_Info = {100000000,100000000,100000000,100000000,100000000,100000000}

this.ABNames={
    ChipPool="SingleGames/FishPrawnCrab/prefabs/Pool",--筹码
}
--筹码的预支名列表
this.chipPrefabNamesArr = {
    "FishPrawnCrabChip1K",
    "FishPrawnCrabChip5K",
    "FishPrawnCrabChip10K",
    "FishPrawnCrabChip50K",
    "FishPrawnCrabChip100K",
    "FishPrawnCrabChip500K",
    "FishPrawnCrabChip1M"
}

---获取对应筹码的预支名字
function this.GetChipPoolName(betIndex)
    return this.chipPrefabNamesArr[betIndex]
end

--动物序号对应的显示数据
this.animalShowData = {{color = { r = 0.627451, g = 0.3333333, b = 0.3294118, a = 1}, name = "山羊"},
                       {color = { r = 0.4196078, g = 0.5882353, b = 0.2588235, a = 1}, name = "葫蘆"},
                       {color = { r = 0, g = 0.4941176, b = 0.7803922, a = 1}, name = "雞"},
                       {color = { r = 0, g = 0.4784314, b = 0.7686275, a = 1}, name = "魚"},
                       {color = { r = 0.3921569, g = 0.4039216, b = 0.682353, a = 1}, name = "螃蟹"},
                       {color = { r = 0.6392157, g = 0.3490196, b = 0.3490196, a = 1}, name = "蝦"}}
this.diceCount = 3  --每局骰子数量
this.diceSideCount = 6  --每个骰子面数
--押中某个动物出现的次数对应的赔率表
this.odds = {1, 2, 3}

return this