---@class SlotItem1
local SlotItem1=Class("SlotItem1")

function SlotItem1:ctor(go)
   self.gameObject = go
   self.transform=self.gameObject.transform
   self.img_icon=ComponentUtilGet.Image(self.transform,"img_icon");
   self.tmp_name=ComponentUtilGet.TextMeshProUGUI(self.transform,"tmp_name");
end

function SlotItem1:SetSprite(icon,index)
   self.img_icon.sprite=icon
   --self.img:SetNativeSize()
   self.iconIndex=index
   self.tmp_name.text=index
end

function SlotItem1:SetActive(active)
   if self.gameObject==nil then
      return
   end
   if self.gameObject.activeSelf~=active then
      self.gameObject:SetActive(active);
   end
end
function SlotItem1:GetPosition()
   return self.transform.position
end
function SlotItem1:GetCurSprite()
   return self.img.sprite
end
function SlotItem1:GetIconIndex()
   return self.iconIndex
end

return SlotItem1