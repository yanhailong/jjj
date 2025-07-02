local CarLogoHelper=require("SingleGames/CarLogo/CarLogoHelper")
local CarLogoConfig = require("SingleGames/CarLogo/CarLogoConfig")
local CarLogoGameModel =require("SingleGames/CarLogo/Model/CarLogoGameModel")

---@class CarLogoHistoryItem
local CarLogoHistoryItem=Class("CarLogoHistoryItem")

---右侧历史记录显示的条数
local ShowItemCount = 8

function CarLogoHistoryItem:ctor(gameObject)
    self.gameObject = gameObject;
    ---@type UnityEngine.Transform
    self.transform = gameObject.transform;
    self.content = ComponentUtilGet.Transform(self.transform,"mask/content")
    ---@type UnityEngine.Transform[]
    self.logos = {};

    for i=1,self.content.childCount do
        self.content:GetChild(i-1).gameObject:SetActive(false)
        table.insert(self.logos,self.content:GetChild(i-1))
    end
    
    ---logo飞行目标点
    self.point = self.logos[1].position
    
    self:UpdateCarLogo()
end

function CarLogoHistoryItem:GetPoint()
    return self.point
end

--直接显示没有动画
function CarLogoHistoryItem:UpdateCarLogo()
    for i=#CarLogoGameModel.historyList+1,#self.logos do
        self.logos[i].gameObject:SetActive(false)
    end
    if #CarLogoGameModel.historyList>0 then
        local endIndex = math.max(1,#CarLogoGameModel.historyList-7)
        local index = 1
        for i = #CarLogoGameModel.historyList,endIndex,-1 do
            self:ShowLogo(self.logos[index],CarLogoGameModel.historyList[i],index==1)
            index=index+1
        end
    end
    
end

function CarLogoHistoryItem:ShowLogo(transform,data,showNew)
    local image = ComponentUtilGet.Image(transform, "Icon")
    image.sprite = CarLogoHelper.LoadLogoSprite(data.logo_id);
    transform.gameObject:SetActive(true)
    self:ShowLogoNew(transform,showNew)
end

function CarLogoHistoryItem:ShowLogoNew(transform,showNew)
    local choose = ComponentUtilGet.GameObject(transform, "Choose");
    local tag = ComponentUtilGet.GameObject(transform, "New");
    choose:SetActive(showNew)
    tag:SetActive(showNew)
end

function CarLogoHistoryItem:PlayMoveAni()
    self:ShowLogoNew(self.logos[1],false)
    self.content:DOLocalMoveY(-110,1):OnComplete(function ()
        self.content.localPosition = Vector3.Zero()
        self:UpdateCarLogo()
    end)
end

return CarLogoHistoryItem