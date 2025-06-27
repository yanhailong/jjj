---@class BaccaratAllChildLuItem
local BaccaratAllChildLuItem = Class("BaccaratAllChildLuItem")
---@type BaccaratConfig
local config=require("SingleGames/Baccarat/BaccaratConfig")
function BaccaratAllChildLuItem:ctor(obj,ctrl)
    ---@type UnityEngine.GameObject
    self.gameObject = obj
    ---@type UnityEngine.Transform
    self.transform = obj.transform
    self.obj_Banker = ComponentUtilGet.GameObject(self.transform,"obj_Banker")
    self.obj_Player = ComponentUtilGet.GameObject(self.transform,"obj_Player")
    ---@type USDollarExpressCarCtrl
    self.ctrl=ctrl
end

---初始化状态
function BaccaratAllChildLuItem:InitState()
    self.obj_Banker:SetActive(false);
    self.obj_Player:SetActive(false);
end

---自己是否显示了
function BaccaratAllChildLuItem:IsActive()
    return self.obj_Banker.activeSelf or self.obj_Player.activeSelf;
end
---刷新显示
function BaccaratAllChildLuItem:RefreshShow(dataTable)
    self.obj_Banker:SetActive(dataTable);
    self.obj_Player:SetActive(not dataTable);
end
---初始化索引
function BaccaratAllChildLuItem:InitIndex(index)
    self.Index = index;
end

---获取索引
function BaccaratAllChildLuItem:GetIndex()
    return self.Index ;
end
function BaccaratAllChildLuItem:Destroy()
   
end

return BaccaratAllChildLuItem;