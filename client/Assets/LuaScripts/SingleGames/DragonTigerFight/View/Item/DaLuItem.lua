--
--time:{time}
--{paramdesc} 
--@desc 
--
---@class DaLuItem
local DaLuItem=Class("DaLuItem")
local config=require("SingleGames/DragonTigerFight/DragonTigerFightConfig")

function DaLuItem:ctor(go)
    self.gameObject = go
    self.transform=self.gameObject.transform
    self.Long=ComponentUtilGet.GameObject(self.transform,"img_xian")
    self.Hu=ComponentUtilGet.GameObject(self.transform,"img_zhuang")
    self.HeNum=ComponentUtilGet.TextMeshProUGUI(self.transform,"tmp_he")
end

---
function DaLuItem:ResetInfo()
    self.Long:SetActive(false)
    self.Hu:SetActive(false)
    self.HeNum.gameObject:SetActive(false)
end

function DaLuItem:UpdateInfo(data, showFade)
    if data == nil or #data ~= 2 then
        self:ResetInfo()
    else
        self:ResetInfo()
        
        local side = data[1]
        local heTimes = data[2]
        self:SetHeNum(heTimes)

        if side == DRAGON_TIGER_FIGHT_WIN_SIDE.HE then
            return
        end
        
        local activeObj = nil
        
        if side == DRAGON_TIGER_FIGHT_WIN_SIDE.LONG then      --龍win
            self.Long:SetActive(true)
            if showFade then
                activeObj = self.Long
            end
        elseif side == DRAGON_TIGER_FIGHT_WIN_SIDE.HU then  --虎win
            self.Hu:SetActive(true)
            if showFade then
                activeObj = self.Hu
            end
        end

        if showFade and activeObj then
            Tools.StopTweeners(self.tweenTable)
            self.tweenTable = nil
            self.tweenTable = Tools.FadeParentAndChild(activeObj,config.fadeTime,config.fadeTimes)
        end
    end
end


function DaLuItem:SetHeNum(num)
    if num>0 then
        self.HeNum.gameObject:SetActive(true)
        self.HeNum.text = num
    end
end

return DaLuItem