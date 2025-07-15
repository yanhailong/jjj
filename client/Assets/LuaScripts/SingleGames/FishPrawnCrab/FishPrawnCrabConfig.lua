--
--time:{time}
--{paramdesc} 
--@desc 
--
---@class
local FishPrawnCrabConfig = Class("FishPrawnCrabConfig")
local this = FishPrawnCrabConfig;

---游戏阶段
this.GameState = {
    Prepare = 1,    --准备阶段
    Bet = 2,        --下注阶段
    Settlement = 3, --结算阶段
}

this.prepareStateDuration = 3      ---准备阶段持续时间
this.betStateDuration = 14         ---下注阶段持续时间
this.settlementStateDuration = 11  ---结算阶段持续时间

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

return this