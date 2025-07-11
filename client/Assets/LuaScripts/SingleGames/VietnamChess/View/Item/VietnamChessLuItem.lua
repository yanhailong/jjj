--
--time:{time}
--{paramdesc} 
--@desc 
--
---@class VietnamChessLuItem
local VietnamChessLuItem=Class("VietnamChessLuItem")
local VietnamChessConfig=require("SingleGames/VietnamChess/VietnamChessConfig")

function VietnamChessLuItem:ctor(go)
    self.gameObject = go
    self.transform=self.gameObject.transform
    self.A=ComponentUtilGet.Transform(self.transform,"A")
    self.B=ComponentUtilGet.Transform(self.transform,"B")
    self.num=ComponentUtilGet.TextMeshProUGUI(self.transform,"num")
end

---
function VietnamChessLuItem:ResetInfo()
    self.A.gameObject:SetActive(false)
    self.B.gameObject:SetActive(false)
    self.num.text = ""
end

function VietnamChessLuItem:UpdateInfo(data, showFade)
    if data == nil then
        self:ResetInfo()
    else
        self:ResetInfo()
        local activeObj = nil
        self.num.text = data[2]
        
        if data[1] == VietnamChessConfig.QICOLOR.WHITE then      --偶白
            self.B.gameObject:SetActive(true)
            if showFade then
                activeObj = self.B
            end
        else  --奇黑
            self.A.gameObject:SetActive(true)
            if showFade then
                activeObj = self.A
            end
        end

        if showFade and activeObj then
            Tools.StopTweeners(self.tweenTable)
            self.tweenTable = nil
            self.tweenTable = Tools.FadeParentAndChild(activeObj,VietnamChessConfig.fadeTime,VietnamChessConfig.fadeTimes)
        end
    end
end

return VietnamChessLuItem