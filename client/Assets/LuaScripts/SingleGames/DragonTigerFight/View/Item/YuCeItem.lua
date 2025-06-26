--
--time:{time}
--{paramdesc} 
--@desc 
--
---@class YuCeItem
local YuCeItem=Class("YuCeItem")

function YuCeItem:ctor(go)
    self.gameObject = go
    self.transform=self.gameObject.transform
    self.Long=ComponentUtilGet.GameObject(self.transform,"img_xian")
    self.Hu=ComponentUtilGet.GameObject(self.transform,"img_zhuang")
end

---
function YuCeItem:ResetInfo()
    self.Long:SetActive(false)
    self.Hu:SetActive(false)
    self.side = nil
end

function YuCeItem:UpdateInfo(side)
    if side == nil then
        self:ResetInfo()
    else
        self:ResetInfo()

        self.side = side
        if side == DRAGON_TIGER_FIGHT_WIN_SIDE.LONG then      --龍win
            self.Long:SetActive(true)
        elseif side == DRAGON_TIGER_FIGHT_WIN_SIDE.HU then  --虎win
            self.Hu:SetActive(true)
        end
        
    end
end

return YuCeItem