
---@class BaccaratZhuPanItem
local BaccaratZhuPanItem=Class("BaccaratZhuPanItem")

function BaccaratZhuPanItem:ctor(obj,ctrl)
    ---@type UnityEngine.GameObject
    self.gameObject = obj
    ---@type UnityEngine.Transform
    self.transform = obj.transform
    self.img_show = ComponentUtilGet.Image(self.transform,"img_show")
    self.img_point = ComponentUtilGet.Image(self.transform,"img_show/img_point")
    self.img_point.gameObject:SetActive(false);
    ---@type USDollarExpressCarCtrl
    self.ctrl=ctrl
end

function BaccaratZhuPanItem:SetSprite(sprite)
    self.img_show.sprite = sprite;
end

function BaccaratZhuPanItem:SetPointSprite(sprite)
    self.img_point.sprite = sprite;
    self.img_point.gameObject:SetActive(true);
end

function BaccaratZhuPanItem:GetImage()
    return self.img_show;
end

return BaccaratZhuPanItem;