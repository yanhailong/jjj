--
--time:{time}
--{paramdesc} 
--@desc 
---@class DataManager
DataManager=Class("DataManager")
---@type PlayerInfo
local PlayerInfo=require("GameScripts/DataManager/PlayerInfo")


---@param 初始化
function DataManager:Init()
    ---@type PlayerInfo
    self.playerInfo=PlayerInfo.New()
    self.playerInfo.userId="1111"
    
end

