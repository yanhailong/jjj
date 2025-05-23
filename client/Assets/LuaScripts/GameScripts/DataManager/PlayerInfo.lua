--
--time:{time}
--{paramdesc} 
--@desc 
---@class PlayerInfo
local PlayerInfo=Class("PlayerInfo")

function PlayerInfo:ctor(param)
	self.userName=""
    self.userId=""
end

return PlayerInfo