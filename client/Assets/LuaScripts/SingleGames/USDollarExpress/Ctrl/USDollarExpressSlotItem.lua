---@class USDollarExpressSlotItem
local USDollarExpressSlotItem=Class("USDollarExpressSlotItem")

function USDollarExpressSlotItem:ctor(go)
    self.gameObject = go
    self.transform=self.gameObject.transform
    self.img_icon=ComponentUtilGet.Image(self.transform,"img_icon");
    self.tmp_name=ComponentUtilGet.TextMeshProUGUI(self.transform,"tmp_name");
end

function USDollarExpressSlotItem:SetSprite(icon,index)
    self.img_icon.sprite=icon
    self.img_icon:SetNativeSize()
    self.iconIndex=index
    self.tmp_name.text=index
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

return USDollarExpressSlotItem