local BirdsAnimalsHelper=require("SingleGames/BirdsAnimals/BirdsAnimalsHelper")
local BirdsAnimalsConfig = require("SingleGames/BirdsAnimals/BirdsAnimalsConfig")

---@class BirdsAnimalsHistoryItem
local BirdsAnimalsHistoryItem=Class("BirdsAnimalsHistoryItem")
local SHOW_NUM = 4

function BirdsAnimalsHistoryItem:ctor(gameObject)
    self.gameObject = gameObject;
    ---@type UnityEngine.Transform
    self.transform = gameObject.transform;
    self.content = ComponentUtilGet.Transform(self.transform,"mask/content")
    self.postion = ComponentUtilGet.Transform(self.transform,"mask/postion")
    ---@type UnityEngine.Transform[]
    self.logos = {};

    for i=2,SHOW_NUM do
        local obj = Tools.Instance(self.content:GetChild(0).gameObject)
        obj.transform:SetParent(self.content,false)
    end
    
    for i=1,SHOW_NUM do
        self.content:GetChild(i-1).gameObject:SetActive(false)
        table.insert(self.logos,self.content:GetChild(i-1))
    end
    
    ---logo飞行目标点
    self.point = self.postion.position
    
    self:UpdateBirdsAnimals()
end

function BirdsAnimalsHistoryItem:GetPoint()
    return self.point
end

--直接显示没有动画
function BirdsAnimalsHistoryItem:UpdateBirdsAnimals(history)
    local historyList = history or {}
    for i=#historyList+1,#self.logos do
        self.logos[i].gameObject:SetActive(false)
    end
    if #historyList>0 then
        local endIndex = math.max(1,#historyList-#self.logos+1)
        local index = 1
        for i = #historyList,endIndex,-1 do
            self:ShowLogo(self.logos[index],historyList[i].animalId,index==1)
            index=index+1
        end
    end
    
end

function BirdsAnimalsHistoryItem:ShowLogo(transform,winSide,showNew)
    local image = ComponentUtilGet.Image(transform, "Icon")
    image.sprite = BirdsAnimalsHelper.LoadLogoSprite(winSide);
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

function BirdsAnimalsHistoryItem:PlayMoveAni(history)
    self:ShowLogoNew(self.logos[1],false)
    self.content:DOLocalMoveY(-133,1):OnComplete(function ()
        self.content.localPosition = Vector3(-18,-23,0)
        self:UpdateBirdsAnimals(history)
    end)
end

return BirdsAnimalsHistoryItem