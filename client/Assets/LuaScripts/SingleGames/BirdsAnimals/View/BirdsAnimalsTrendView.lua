---
---Create by Administrator
---DateTime: 2025-07-03 13:19:02
---
---@class BirdsAnimalsTrendView:BaseView
local BirdsAnimalsTrendView=Class("BirdsAnimalsTrendView",BaseView)
local BirdsAnimalsConfig =require("SingleGames/BirdsAnimals/BirdsAnimalsConfig")
local BirdsAnimalsHelper=require("SingleGames/BirdsAnimals/BirdsAnimalsHelper")

---初始化panel
function BirdsAnimalsTrendView:InitView()
	---@type BirdsAnimalsTrendCtrl
    self.ctrl=self.ctrl
	self:InitComponents()
end

---获取组件
function BirdsAnimalsTrendView:InitComponents()
    self.img_title=ComponentUtilGet.Image(self.transform,"content/background/img_title");
    self.btn_close=ComponentUtilGet.Button(self.transform,"content/background/btn_close");
    self.resultsTrs=ComponentUtilGet.Transform(self.transform,"content/results")
    self.rateTrs=ComponentUtilGet.Transform(self.transform,"content/rate")
    self.rateText ={}
    for i=1,12 do
        table.insert(self.rateText,ComponentUtilGet.TextMeshProUGUI(self.rateTrs:GetChild(i-1),"num"))
    end
    self.resultsItems={}
    local itemTrs = self.resultsTrs:GetChild(0)
    table.insert(  self.resultsItems,self:InitResultItem(itemTrs))
    for i=1,49 do
        table.insert(self.resultsItems, self:InitResultItem(Tools.Instance(itemTrs,self.resultsTrs).transform))
    end
end

---清空组件
function BirdsAnimalsTrendView:ClearComponents()
    self.img_title=nil;
    self.btn_close=nil;
end

---初始化View数据
function BirdsAnimalsTrendView:InitPanelData(args)
    self:InitRateUI()
    self:UpdateHistory(args or {})
end

function BirdsAnimalsTrendView:InitRateUI()
    for i=1,12 do
        local img = ComponentUtilGet.Image(self.rateTrs:GetChild(i-1),"icon")
        local logo_id = BirdsAnimalsConfig.ANIMA_HISTORY[i]
        if logo_id ~=BirdsAnimalsConfig.ANIMAL_TYPE.FeiQin and logo_id ~=BirdsAnimalsConfig.ANIMAL_TYPE.ZouShou  then
            img.sprite = BirdsAnimalsHelper.LoadLogoSprite(logo_id)
        end
    end
end

function BirdsAnimalsTrendView:InitResultItem(transform)
    local table = {}
    table.obj = transform.gameObject
    table.icon = ComponentUtilGet.Image(transform, "icon");
    table.new = ComponentUtilGet.Image(transform,"new");
    table.ShowLogo = function(index)
        if index then
            local logoId = BirdsAnimalsConfig.FindIndexByLogoId(index)
            table.icon.sprite = BirdsAnimalsHelper.LoadLogoSprite(logoId);
            table.new.gameObject:SetActive(false)
            table.icon.gameObject:SetActive(true)
            table.obj:SetActive(true)
        else
            --table.new.gameObject:SetActive(false)
            --table.icon.gameObject:SetActive(false)
            table.obj:SetActive(false)
        end
    end

    table.ShowNew=function(show)
        table.new.gameObject:SetActive(show)
    end

    return table
end

function BirdsAnimalsTrendView:UpdateHistory(history)
    local historyList = history
    local total = #historyList
    local offset=math.max(total-49,1)
    for i=1,50 do
        if offset <= total then
            self.resultsItems[i].ShowLogo(historyList[offset])
            if offset==total then self.resultsItems[i].ShowNew(true) end
            offset=offset+1
        else
            self.resultsItems[i].ShowLogo()
        end
    end

    ---概率
    self.rateData = {0,0,0,0,0,0,0,0,0,0,0,0}
    local offset2 =math.max(#historyList-49,1)
    local count = #historyList- offset2 +1
    for i= offset2,#historyList do
        local logoId = BirdsAnimalsConfig.FindIndexByLogoId(historyList[i])
        if self.rateData[logoId] then
            self.rateData[logoId]=self.rateData[logoId]+1
        end
    end

    self.rateData[BirdsAnimalsConfig.ANIMAL_TYPE.FeiQin]=0
    self.rateData[BirdsAnimalsConfig.ANIMAL_TYPE.ZouShou]=0

    for i=1,12 do
        local logo_id=BirdsAnimalsConfig.ANIMA_HISTORY[i]
        if logo_id<=12 then
            self.rateData[logo_id]=count>0 and math.floor(self.rateData[logo_id]*1000/count)/10 or 0
            self.rateText[i].text = self.rateData[logo_id].."%"
            if BirdsAnimalsHelper.IsFeiQinType(logo_id) then
                self.rateData[BirdsAnimalsConfig.ANIMAL_TYPE.FeiQin]=self.rateData[BirdsAnimalsConfig.ANIMAL_TYPE.FeiQin]+self.rateData[logo_id]
            elseif BirdsAnimalsHelper.IsZouShouType(logo_id) then
                self.rateData[BirdsAnimalsConfig.ANIMAL_TYPE.ZouShou]=self.rateData[BirdsAnimalsConfig.ANIMAL_TYPE.ZouShou]+self.rateData[logo_id]
            end
        end
    end
    for i=1,12 do
        local logo_id=BirdsAnimalsConfig.ANIMA_HISTORY[i]
        if logo_id==BirdsAnimalsConfig.ANIMAL_TYPE.FeiQin then
            self.rateText[i].text = self.rateData[BirdsAnimalsConfig.ANIMAL_TYPE.FeiQin].."%"
        elseif logo_id==BirdsAnimalsConfig.ANIMAL_TYPE.ZouShou then
            self.rateText[i].text = self.rateData[BirdsAnimalsConfig.ANIMAL_TYPE.ZouShou].."%"
        end
    end
end

---关闭界面
function BirdsAnimalsTrendView:Close()   
    self.super.Close(self);
end

return BirdsAnimalsTrendView

