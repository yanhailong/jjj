---@class SlotItem2
local SlotItem2=Class("SlotItem2")

function SlotItem2:ctor(go,rowIndex,colIndex)
   self.gameObject = go
   self.transform=go.transform
   self.rectTrans=ComponentUtilGet.RectTransform(self.transform)
   self.img_icon=ComponentUtilGet.Image(self.transform,"img_icon");
   self.tmp_name=ComponentUtilGet.TextMeshProUGUI(self.transform,"tmp_name");
   self.rowIndex=rowIndex
   self.colIndex=colIndex
   self:InitData()
end

function SlotItem2:InitData()
   self.curTween=nil
   self.initPos=nil
   self.stopMove=false
end

function SlotItem2:SetSprite(icon,index)
   self.img_icon.sprite=icon
   self.img_icon:SetNativeSize()
   self.iconIndex=index
   self.tmp_name.text=index
end

function SlotItem2:InitAnchoredPos(v3)
   self.rectTrans.anchoredPosition=v3
   self.initPos=self.rectTrans.anchoredPosition
end

---@return UnityEngine.Vector3
function SlotItem2:GetInitAnchorPos()
   return self.initPos
end

---@return UnityEngine.RectTransform
function SlotItem2:GetRectTrans()
   return self.rectTrans
end

function SlotItem2:SetActive(active)
   if self.gameObject==nil then
      return
   end
   if self.gameObject.activeSelf~=active then
      self.gameObject:SetActive(active);
   end
end
--function SlotItem2:GetPosition()
--   return self.transform.position
--end
--function SlotItem2:GetCurSprite()
--   return self.img_icon.sprite
--end
--function SlotItem2:GetIconIndex()
--   return self.iconIndex
--end

return SlotItem2