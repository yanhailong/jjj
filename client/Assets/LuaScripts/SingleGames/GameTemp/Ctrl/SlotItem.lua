---@class SlotItem
local SlotItem=Class("SlotItem")

function SlotItem:ctor(go)
   self.gameObject = go
   self.transform=self.gameObject.transform
   self.img_icon=ComponentUtilGet.Image(self.transform,"img_icon");
   self.tmp_name=ComponentUtilGet.TextMeshProUGUI(self.transform,"tmp_name");
end

function SlotItem:SetSprite(icon,index)
   self.img_icon.sprite=icon
   --self.img:SetNativeSize()
   self.iconIndex=index
   self.tmp_name.text=index
end

function SlotItem:SetActive(active)
   if self.gameObject==nil then
      return
   end
   if self.gameObject.activeSelf~=active then
      self.gameObject:SetActive(active);
   end
end
function SlotItem:GetPosition()
   return self.transform.position
end
function SlotItem:GetCurSprite()
   return self.img.sprite
end
function SlotItem:GetIconIndex()
   return self.iconIndex
end

return SlotItem