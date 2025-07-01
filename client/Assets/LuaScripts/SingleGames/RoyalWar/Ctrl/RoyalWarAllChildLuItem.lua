---@class RoyalWarAllChildLuItem
local RoyalWarAllChildLuItem = Class("RoyalWarAllChildLuItem")
---@type RoyalWarConfig
local config=require("SingleGames/RoyalWar/RoyalWarConfig")
function RoyalWarAllChildLuItem:ctor(obj,ctrl)
    ---@type UnityEngine.GameObject
    self.gameObject = obj
    ---@type UnityEngine.Transform
    self.transform = obj.transform
    self.obj_Red = ComponentUtilGet.GameObject(self.transform,"obj_Red")
    self.obj_Black = ComponentUtilGet.GameObject(self.transform,"obj_Black")
    ---@type RoyalWarGameCtrl
    self.ctrl=ctrl
end

---初始化状态
function RoyalWarAllChildLuItem:InitState()
    self.obj_Red:SetActive(false);
    self.obj_Black:SetActive(false);
end

---自己是否显示了
function RoyalWarAllChildLuItem:IsActive()
    return self.obj_Red.activeSelf or self.obj_Black.activeSelf;
end
---刷新显示
function RoyalWarAllChildLuItem:RefreshShow(dataTable)
    self.obj_Red:SetActive(dataTable);
    self.obj_Black:SetActive(not dataTable);
end
---初始化索引
function RoyalWarAllChildLuItem:InitIndex(index)
    self.Index = index;
end

---获取索引
function RoyalWarAllChildLuItem:GetIndex()
    return self.Index ;
end
function RoyalWarAllChildLuItem:Destroy()

end

return RoyalWarAllChildLuItem;