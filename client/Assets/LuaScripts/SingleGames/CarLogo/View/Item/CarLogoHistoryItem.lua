local CarLogoHelper=require("SingleGames/CarLogo/CarLogoHelper")
local CarLogoConfig = require("SingleGames/CarLogo/CarLogoConfig")

---@class CarLogoHistoryItem
local CarLogoHistoryItem=Class("CarLogoHistoryItem")

function CarLogoHistoryItem:ctor(gameObject)
    self.gameObject = gameObject;
    ---@type UnityEngine.Transform
    self.transform = gameObject.transform;
    self.content = ComponentUtilGet.Transform(self.transform,"mask/content")
    self.positon = ComponentUtilGet.Transform(self.transform,"mask/positon")
    ---@type UnityEngine.Transform[]
    self.logos = {};

    for i=1,self.content.childCount do
        self.content:GetChild(i-1).gameObject:SetActive(false)
        table.insert(self.logos,self.content:GetChild(i-1))
    end
    
    ---logo飞行目标点
    self.point = self.positon.position
    self:UpdateCarLogo()
end

function CarLogoHistoryItem:GetPoint()
    return self.point
end

--直接显示没有动画
function CarLogoHistoryItem:UpdateCarLogo(history)
    local historyList = history or {}
    for i=#historyList+1,#self.logos do
        self.logos[i].gameObject:SetActive(false)
    end
    if #historyList>0 then
        local endIndex = math.max(1,#historyList-#self.logos+1)
        local index = 1
        for i = #historyList,endIndex,-1 do
            self:ShowLogo(self.logos[index],historyList[i],index==1)
            index=index+1
        end
    end
    
end

function CarLogoHistoryItem:ShowLogo(transform,winSide,showNew)
    local image = ComponentUtilGet.Image(transform, "Icon")
    image.sprite = CarLogoHelper.LoadLogoSprite(winSide);
    transform.gameObject:SetActive(true)
    self:ShowLogoNew(transform,showNew)
end

function CarLogoHistoryItem:ShowLogoNew(transform,showNew)
    local choose = ComponentUtilGet.GameObject(transform, "Choose");
    local tag = ComponentUtilGet.GameObject(transform, "New");
    choose:SetActive(showNew)
    tag:SetActive(showNew)
end

function CarLogoHistoryItem:PlayMoveAni(history)
    self:ShowLogoNew(self.logos[1],false)
    self.content:DOLocalMoveY(-110,1):OnComplete(function ()
        self.content.localPosition = Vector3.Zero()
        self:UpdateCarLogo(history)
    end)
end

return CarLogoHistoryItem