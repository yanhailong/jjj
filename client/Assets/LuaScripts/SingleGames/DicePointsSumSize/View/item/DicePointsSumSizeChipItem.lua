--
--time:{time}
--{paramdesc} 
--@desc 
--
---@class DicePointsSumSizeChipItem
local DicePointsSumSizeChipItem = Class("DicePointsSumSizeChipItem")
---@type DicePointsSumSizeConfig
local config = require("SingleGames/DicePointsSumSize/DicePointsSumSizeConfig")
function DicePointsSumSizeChipItem:ctor(obj,ctrl)
    ---@type UnityEngine.GameObject
    self.gameObject = obj
    ---@type UnityEngine.Transform
    self.transform = obj.transform
    ---@type DicePointsSumSizeGameCtrl
    self.ctrl=ctrl
    self.icon = ComponentUtilGet.Image(self.transform);
    self.checked = ComponentUtilGet.GameObject(self.transform,"checked")
    self.number = ComponentUtilGet.Text(self.transform,"number")
    self.btn = ComponentUtilGet.Button(self.transform);
    self.ctrl.uiEventListener:AddClick(self.btn, function()
        self.ctrl:SetCheckedShow(self)
    end)
end

---初始化UI显示
function DicePointsSumSizeChipItem:InitUIShow(index, betAmount)
    self.num = betAmount;
    self.index = index;
    self.icon.sprite = config.commonMain_Pics["yx_ph_cm_" .. index];
    self.number.text = tostring(betAmount);
    self.checked:SetActive(false)
end

---点击选中哪个按钮
function DicePointsSumSizeChipItem:RefreshChecked(index)
    self.checked:SetActive(self.index == index)
end

---是不是自己
function DicePointsSumSizeChipItem:IsSelf(num)
    return self.num == num;
end

return DicePointsSumSizeChipItem