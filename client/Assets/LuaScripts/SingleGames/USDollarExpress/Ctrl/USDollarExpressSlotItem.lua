---@class USDollarExpressSlotItem
local USDollarExpressSlotItem=Class("USDollarExpressSlotItem")

function USDollarExpressSlotItem:ctor(go)
    self.gameObject = go
    ---@type UnityEngine.Transform
    self.transform=self.gameObject.transform
    self.img_icon=ComponentUtilGet.Image(self.transform,"img_icon");
end

function USDollarExpressSlotItem:SetSprite(icon,index)
    self.img_icon.sprite=icon
    self.img_icon:SetNativeSize()
    self.iconIndex=index
end

function USDollarExpressSlotItem:SetActive(active)
    if self.gameObject==nil then
        return
    end
    if self.gameObject.activeSelf~=active then
        self.gameObject:SetActive(active);
    end
end
function USDollarExpressSlotItem:GetPosition()
    return self.transform.position
end
function USDollarExpressSlotItem:GetCurSprite()
    return self.img_icon.sprite
end
function USDollarExpressSlotItem:GetIconIndex()
    return self.iconIndex
end


---播放动画
function USDollarExpressSlotItem:SetIsAward(isred)
    if isred==true then
        self.img_icon.color=Color.red
    else
        self.img_icon.color=Color.white
    end

    
end

return USDollarExpressSlotItem