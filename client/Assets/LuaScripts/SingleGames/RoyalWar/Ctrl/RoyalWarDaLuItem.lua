---@class RoyalWarDaLuItem
local RoyalWarDaLuItem=Class("RoyalWarDaLuItem")
---@type RoyalWarConfig
local config=require("SingleGames/RoyalWar/RoyalWarConfig")
function RoyalWarDaLuItem:ctor(obj,ctrl)
    ---@type ObjectPoolUtil
    self.objPools=ObjectPoolUtil.New()
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
function RoyalWarDaLuItem:InitState()
    self.obj_Red:SetActive(false);
    self.obj_Black:SetActive(false);
end
---初始化索引
function RoyalWarDaLuItem:InitIndex(index)
    self.Index = index;
end
---自己是否显示了
function RoyalWarDaLuItem:IsActive()
    return self.obj_Red.activeSelf or self.obj_Black.activeSelf;
end
---刷新显示
function RoyalWarDaLuItem:RefreshShow(dataTable)
    self.obj_Red:SetActive(dataTable);
    self.obj_Black:SetActive(not dataTable);
end

---获取索引
function RoyalWarDaLuItem:GetIndex()
    return self.Index ;
end

function RoyalWarDaLuItem:Destroy()

end


return RoyalWarDaLuItem