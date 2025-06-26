--
--time:{time}
--{paramdesc} 
--@desc 
--
---@class ZhuPianItem
local ZhuPianItem=Class("ZhuPianItem")
local config=require("SingleGames/DragonTigerFight/DragonTigerFightConfig")

function ZhuPianItem:ctor(go)
    self.gameObject = go
    self.transform=self.gameObject.transform
    self.Long=ComponentUtilGet.GameObject(self.transform,"img_xian")
    self.Hu=ComponentUtilGet.GameObject(self.transform,"img_zhuang")
    self.He=ComponentUtilGet.GameObject(self.transform,"img_he")
    self.LongDian=ComponentUtilGet.GameObject(self.transform,"img_xiandian")
    self.HuDian=ComponentUtilGet.GameObject(self.transform,"img_zhuangdian")
end

---
function ZhuPianItem:ResetInfo()
    self.Long:SetActive(false)
    self.LongDian:SetActive(false)
    self.He:SetActive(false)
    self.HuDian:SetActive(false)
    self.Hu:SetActive(false)
end

function ZhuPianItem:UpdateInfo(data, showFade)
    if data == nil then
        self:ResetInfo()
    else
        self:ResetInfo()
        local activeObj = nil

        self.infoData = data
        if data.win_side == DRAGON_TIGER_FIGHT_WIN_SIDE.LONG then      --龍win
            self.Long:SetActive(true)
            if showFade then
                activeObj = self.Long
            end
        elseif data.win_side == DRAGON_TIGER_FIGHT_WIN_SIDE.HU then  --虎win
            self.Hu:SetActive(true)
            if showFade then
                activeObj = self.Hu
            end
        elseif data.win_side == DRAGON_TIGER_FIGHT_WIN_SIDE.HE then  --和win
            self.He:SetActive(true)
            if showFade then
                activeObj = self.He
            end
        end

        if showFade and activeObj then
            Tools.StopTweeners(self.tweenTable)
            self.tweenTable = nil
            self.tweenTable = Tools.FadeParentAndChild(activeObj,config.fadeTime,config.fadeTimes)
        end
    end
end

return ZhuPianItem