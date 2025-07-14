--
--time:{time}
--{paramdesc} 
--@desc 
--
---@class
local FishPrawnCrabGameConfig = Class("FishPrawnCrabGameConfig")
local this = FishPrawnCrabGameConfig;

---当前选中的底注
this.anteIndex = 1;
---当前是否可以下注
this.allowBet = true
return this