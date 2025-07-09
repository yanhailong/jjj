---@class BaccaratDaLuItem
local BaccaratDaLuItem=Class("BaccaratAllLuItem")
---@type BaccaratConfig
local config=require("SingleGames/Baccarat/BaccaratConfig")
function BaccaratDaLuItem:ctor(obj,ctrl)
    ---@type ObjectPoolUtil
    self.objPools=ObjectPoolUtil.New()
    ---@type UnityEngine.GameObject
    self.gameObject = obj
    ---@type UnityEngine.Transform
    self.transform = obj.transform
    self.obj_Banker = ComponentUtilGet.GameObject(self.transform,"obj_Banker")
    self.obj_Player = ComponentUtilGet.GameObject(self.transform,"obj_Player")
    self.txt_HeNum = ComponentUtilGet.Text(self.transform,"txt_HeNum")
    ---@type BaccaratGameCtrl
    self.ctrl=ctrl
end
---初始化状态
function BaccaratDaLuItem:InitState()
    self.obj_Banker:SetActive(false);
    self.obj_Player:SetActive(false);
    self.txt_HeNum.gameObject:SetActive(false);
end
---初始化索引
function BaccaratDaLuItem:InitIndex(index)
    self.Index = index;
end
---自己是否显示了
function BaccaratDaLuItem:IsActive()
    return self.obj_Banker.activeSelf or self.obj_Player.activeSelf or self.txt_HeNum.gameObject.activeSelf;
end
---刷新显示
function BaccaratDaLuItem:RefreshShow(dataTable)
    self.obj_Banker:SetActive(dataTable == config.WhoWin.BankerWin);
    self.obj_Player:SetActive(dataTable == config.WhoWin.PlayerWin);
end
---刷新和的次数显示
function BaccaratDaLuItem:RefreshTieNumShow(num)
    self.txt_HeNum.gameObject:SetActive(true)
    self.txt_HeNum.text = num;
end
---获取索引
function BaccaratDaLuItem:GetIndex()
    return self.Index ;
end

function BaccaratDaLuItem:Destroy()
    
end


return BaccaratDaLuItem