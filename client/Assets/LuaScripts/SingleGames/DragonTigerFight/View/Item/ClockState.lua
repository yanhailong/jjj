--
--time:{time}
--{paramdesc} 
--@desc 
--
---@class ClockState
local ClockState=Class("ClockState")

function ClockState:ctor(go)
    self.gameObject = go
    self.transform=self.gameObject.transform
    self.clockStateTips = ComponentUtilGet.TextMeshProUGUI(self.transform,"clockStateTips")
    self.colockStateTime = ComponentUtilGet.Transform(self.transform,"Timer/colockStateTime")
    self.LockAnim = ComponentUtilGet.GameObject(self.transform,"Timer/LockAnim")
    self.LockLeftTime = ComponentUtilGet.TextMeshProUGUI(self.LockAnim.transform,"LeftTime")
end

---
function ClockState:UpdateTimer()

end

return ClockState