---@class BaccaratChipItems
local BaccaratChipItems = Class("BaccaratChipItems")
---@type BaccaratConfig
local config=require("SingleGames/Baccarat/BaccaratConfig")
function BaccaratChipItems:ctor(obj,ctrl)
    ---@type UnityEngine.GameObject
    self.gameObject = obj
    ---@type UnityEngine.Transform
    self.transform = obj.transform
    ---@type BaccaratGameCtrl
    self.ctrl=ctrl
    self.icon = ComponentUtilGet.Image(self.transform);
    self.checked = ComponentUtilGet.GameObject(self.transform,"checked")
    self.number = ComponentUtilGet.Text(self.transform,"number")
    self.btn = ComponentUtilGet.Button(self.transform);
    self.ctrl.uiEventListener:AddClick(self.btn,function()
        self.ctrl:SetCheckedShow(self)
    end )
end

---初始化UI显示
function BaccaratChipItems:InitUIShow(index,number)
    self.num = number;
    self.index = index;
    self.icon.sprite = config.GetCommonMainPic("yx_ph_cm_"..index);
    self.number.text = number;
    self.checked:SetActive(false)
end

---点击选中哪个按钮
function BaccaratChipItems:RefreshChecked(index)
    self.checked:SetActive(self.index == index)
end

---是不是自己
function BaccaratChipItems:IsSelf(num)
    return self.num == num;
end

return BaccaratChipItems