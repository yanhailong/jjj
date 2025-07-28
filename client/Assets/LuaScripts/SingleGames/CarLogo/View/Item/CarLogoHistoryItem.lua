local CarLogoHelper=require("SingleGames/CarLogo/CarLogoHelper")
local CarLogoConfig = require("SingleGames/CarLogo/CarLogoConfig")

---@class CarLogoHistoryItem
local CarLogoHistoryItem=Class("CarLogoHistoryItem")

function CarLogoHistoryItem:ctor(gameObject)
    self.gameObject = gameObject;
    ---@type UnityEngine.Transform
    self.transform = gameObject.transform;
    self.content = ComponentUtilGet.Transform(self.transform,"mask/content")
    self.position = ComponentUtilGet.Transform(self.transform,"mask/position")
    
    self.logos = {};

    for i=1,self.content.childCount do
        self.content:GetChild(i-1).gameObject:SetActive(false)
        table.insert(self.logos,self:InitHistoryItem(self.content:GetChild(i-1)))
    end
    
    ---logo飞行目标点
    self.point = self.position.position
    self:UpdateCarLogo()
end

function CarLogoHistoryItem:GetPoint()
    return self.point
end

function CarLogoHistoryItem:InitHistoryItem(transform)
    local table = {}
    table.obj = transform.gameObject
    table.choose = ComponentUtilGet.GameObject(transform, "effect_CarLogo_right_xz_bk"):GetComponent("ParticleSystem");
    table.tag = ComponentUtilGet.GameObject(transform, "New");
    table.image = ComponentUtilGet.Image(transform, "Icon")
    table.ShowLogo = function(winSide,showNew)
        local logoId = CarLogoConfig.FindIndexByLogoId(winSide)
        table.image.sprite = CarLogoHelper.LoadLogoSprite(logoId);
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
function CarLogoHistoryItem:UpdateCarLogo(history)
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


function CarLogoHistoryItem:PlayMoveAni(history)
    self.logos[1].ShowLogoNew(false)
    self.content:DOLocalMoveY(-110,1):OnComplete(function ()
        self.content.localPosition = Vector3.Zero()
        self:UpdateCarLogo(history)
    end)
end

return CarLogoHistoryItem