--
--time:{time}
--{paramdesc} 
--@desc 
--
---@class DragonTigerFightConfig
local DragonTigerFightConfig=Class("DragonTigerFightConfig")
local  this = DragonTigerFightConfig;

---当前选中的底注
this.dizhuIndex = 1
---底注数值
this.dizhuNumArr = {1,10,50,100,500}
---当前是否可以下注
this.allow = true
---当前总底注
this.totalDiZhuNums = {0,0,0}
this.selfDiZhuNums = {0,0,0}

return this