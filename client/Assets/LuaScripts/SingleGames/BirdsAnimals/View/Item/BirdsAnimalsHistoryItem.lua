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
    self.position = ComponentUtilGet.Transform(self.transform,"mask/position")

    self.logos = {};
    local item = self.content:GetChild(0)
    table.insert(self.logos,self:InitHistoryItem(item))
    for i=2,SHOW_NUM do
        local obj = Tools.Instance(item.gameObject)
        obj.transform:SetParent(self.content,false)
        table.insert(self.logos,self:InitHistoryItem(obj.transform))
    end
    
    ---logo飞行目标点
    self.point = self.position.position
    
    self:UpdateBirdsAnimals()
end

function BirdsAnimalsHistoryItem:GetPoint()
    return self.point
end

function BirdsAnimalsHistoryItem:InitHistoryItem(transform)
    local table = {}
    table.obj = transform.gameObject
    table.choose = ComponentUtilGet.GameObject(transform, "effect_BirdsAnimals_right_xz_bk"):GetComponent("ParticleSystem");
    table.tag = ComponentUtilGet.GameObject(transform, "New");
    table.image = ComponentUtilGet.Image(transform, "Icon")
    table.ShowLogo = function(winSide,showNew)
        local logoId = BirdsAnimalsConfig.FindIndexByLogoId(winSide)
        table.image.sprite = BirdsAnimalsHelper.LoadLogoSprite(logoId);
        table.obj:SetActive(true)
        table.ShowLogoNew(showNew)
    end

    table.ShowLogoNew=function(showNew)
        table.choose.gameObject:SetActive(showNew)
        table.tag:SetActive(showNew)
        if showNew and table.choose.isStopped  then
            table.choose:Play();
        end
    end

    return table
end

--直接显示没有动画
function BirdsAnimalsHistoryItem:UpdateBirdsAnimals(history)
    local historyList = history or {}
    for i=#historyList+1,#self.logos do
        self.logos[i].obj:SetActive(false)
    end
    if #historyList>0 then
        local endIndex = math.max(1,#historyList-#self.logos+1)
        local index = 1
        for i = #historyList,endIndex,-1 do
            self.logos[index].ShowLogo(historyList[i],index==1)
            index=index+1
        end
    end
    
end


function BirdsAnimalsHistoryItem:PlayMoveAni(history)
    self.logos[1].ShowLogoNew(false)
    self.content:DOLocalMoveY(-133,1):OnComplete(function ()
        self.content.localPosition = Vector3(-18,-23,0)
        self:UpdateBirdsAnimals(history)
    end)
end

return BirdsAnimalsHistoryItem