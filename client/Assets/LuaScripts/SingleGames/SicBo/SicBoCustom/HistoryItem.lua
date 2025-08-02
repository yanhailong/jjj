local HistoryItem = {}
HistoryItem.__index = HistoryItem

function HistoryItem.New(transform,index, sicBoMainCtrl)
    local self = setmetatable({}, HistoryItem)
    self.transform = transform
    self.sicBoMainCtrl = sicBoMainCtrl
    self:Init()
    return self
end

local SmallColor = Color(209 / 255, 86 / 255, 86 / 255, 1)
local BigColor = Color(43 / 255, 173 / 255, 227 / 255, 1)
function HistoryItem:Init()
    self.Icon = self.transform:Find("icon_Image"):GetComponent(typeof(CS.UnityEngine.UI.Image))        --大小图标
    self.number_Text = self.transform:Find("number_Text"):GetComponent(typeof(CS.UnityEngine.UI.Text)) --点子数
    self.DiceImage1 = self.transform:Find("DiceImage1"):GetComponent(typeof(CS.UnityEngine.UI.Image))  --筛子1
    self.DiceImage2 = self.transform:Find("DiceImage2"):GetComponent(typeof(CS.UnityEngine.UI.Image))  --筛子2
    self.DiceImage3 = self.transform:Find("DiceImage3"):GetComponent(typeof(CS.UnityEngine.UI.Image))  --筛子3
end

function HistoryItem:Ctrate()
    --self.sicBoMainCtrl.config.SmallBigIcon[1] --大图标
   -- self.sicBoMainCtrl.config.SmallBigIcon[1] --小图标
end

return HistoryItem
