local BirdsAnimalsHelper=require("SingleGames/BirdsAnimals/BirdsAnimalsHelper")
local BirdsAnimalsConfig = require("SingleGames/BirdsAnimals/BirdsAnimalsConfig")
local BirdsAnimalsGameModel =require("SingleGames/BirdsAnimals/Model/BirdsAnimalsGameModel")

---@class BirdsAnimalsHistoryItem
local BirdsAnimalsHistoryItem=Class("BirdsAnimalsHistoryItem")

---右侧历史记录显示的条数
local ShowItemCount = 8

function BirdsAnimalsHistoryItem:ctor(gameObject)
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
    
    self:UpdateBirdsAnimals()
end

function BirdsAnimalsHistoryItem:GetPoint()
    return self.point
end

--直接显示没有动画
function BirdsAnimalsHistoryItem:UpdateBirdsAnimals()
    for i=#BirdsAnimalsGameModel.historyList+1,#self.logos do
        self.logos[i].gameObject:SetActive(false)
    end
    if #BirdsAnimalsGameModel.historyList>0 then
        local endIndex = math.max(1,#BirdsAnimalsGameModel.historyList-5)
        local index = 1
        for i = #BirdsAnimalsGameModel.historyList,endIndex,-1 do
            self:ShowLogo(self.logos[index],BirdsAnimalsGameModel.historyList[i],index==1)
            index=index+1
        end
    end
    
end

function BirdsAnimalsHistoryItem:ShowLogo(transform,data,showNew)
    local image = ComponentUtilGet.Image(transform, "Icon")
    image.sprite = BirdsAnimalsHelper.LoadLogoSprite(data.logo_id);
    image:SetNativeSize()
    transform.gameObject:SetActive(true)
    self:ShowLogoNew(transform,showNew)
end

function BirdsAnimalsHistoryItem:ShowLogoNew(transform,showNew)
    local choose = ComponentUtilGet.GameObject(transform, "Choose");
    local tag = ComponentUtilGet.GameObject(transform, "New");
    choose:SetActive(showNew)
    tag:SetActive(showNew)
end

function BirdsAnimalsHistoryItem:PlayMoveAni()
    self:ShowLogoNew(self.logos[1],false)
    self.content:DOLocalMoveY(-110,1):OnComplete(function ()
        self.content.localPosition = Vector3.Zero()
        self:UpdateBirdsAnimals()
    end)
end

return BirdsAnimalsHistoryItem