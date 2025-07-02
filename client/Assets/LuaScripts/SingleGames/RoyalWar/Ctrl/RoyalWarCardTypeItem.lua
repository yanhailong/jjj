---@class RoyalWarCardTypeItem
local RoyalWarCardTypeItem = Class("RoyalWarCardTypeItem")
---@type RoyalWarConfig
local config=require("SingleGames/RoyalWar/RoyalWarConfig")

function RoyalWarCardTypeItem:ctor(obj,ctrl)
    ---@type UnityEngine.GameObject
    self.gameObject = obj
    ---@type UnityEngine.Transform
    self.transform = obj.transform
    self.img_Type = ComponentUtilGet.Image(self.transform,"img_Type")
    self.tmp_Type = ComponentUtilGet.TextMeshProUGUI(self.transform,"img_Type/tmp_Type")
    ---@type RoyalWarGameCtrl
    self.ctrl=ctrl
end

function RoyalWarCardTypeItem:RefreshShow(type)
    if(type~=config.CardType.DanZhang) then
        self.img_Type.sprite = config.GetIconPic("royaWarBack_D03")
    else
        self.img_Type.sprite = config.GetIconPic("rwn_lanBg")
    end
    
    self.tmp_Type.text = config.GetCardTypeTrueName(type);
end

function RoyalWarCardTypeItem:Destroy()
    
end


return RoyalWarCardTypeItem