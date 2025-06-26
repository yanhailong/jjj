--
--time:{time}
--{paramdesc} 
--@desc 
--
---@class YueYouLuItem
local YueYouLuItem=Class("YueYouLuItem")
local config=require("SingleGames/DragonTigerFight/DragonTigerFightConfig")

function YueYouLuItem:ctor(go)
    self.gameObject = go
    self.transform=self.gameObject.transform
    self.Long=ComponentUtilGet.GameObject(self.transform,"img_xian")
    self.Hu=ComponentUtilGet.GameObject(self.transform,"img_zhuang")
end

---
function YueYouLuItem:ResetInfo()
    self.Long:SetActive(false)
    self.Hu:SetActive(false)
end

function YueYouLuItem:UpdateInfo(data, isMove, enable)
    if data == nil then
        self:ResetInfo()
    else
        self:ResetInfo()
        local activeObj = nil

        self.infoData = data
        if data.win_side == DRAGON_TIGER_FIGHT_WIN_SIDE.LONG then      --龍win
            self.Long:SetActive(true)
            if isMove then
                activeObj = self.Long
            end
        elseif data.win_side == DRAGON_TIGER_FIGHT_WIN_SIDE.HU then  --虎win
            self.Hu:SetActive(true)
            if isMove then
                activeObj = self.Hu
            end
        end

        if isMove and activeObj and enable then
            Tools.StopTweeners(self.tweenTable)
            self.tweenTable = nil
            self.tweenTable = Tools.FadeParentAndChild(activeObj,config.fadeTime,config.fadeTimes)
        end
    end
end

return YueYouLuItem