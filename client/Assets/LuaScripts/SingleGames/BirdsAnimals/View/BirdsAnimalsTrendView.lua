---
---Create by Administrator
---DateTime: 2025-07-03 13:19:02
---
---@class BirdsAnimalsTrendView:BaseView
local BirdsAnimalsTrendView=Class("BirdsAnimalsTrendView",BaseView)
local BirdsAnimalsConfig =require("SingleGames/BirdsAnimals/BirdsAnimalsConfig")
local BirdsAnimalsGameModel =require("SingleGames/BirdsAnimals/Model/BirdsAnimalsGameModel")
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
    self.rateTmps={}
    for i=1,12 do
        if i==3 or i==4 then
            table.insert(self.rateTmps,ComponentUtilGet.Text(self.rateTrs:GetChild(i-1),"num"))
        else
            table.insert(self.rateTmps,ComponentUtilGet.TextMeshProUGUI(self.rateTrs:GetChild(i-1),"num"))
        end
    end
    self.resultsItems={}
    table.insert(  self.resultsItems,self:InitResultItem(self.resultsTrs:GetChild(0)))
    for i=1,49 do
        table.insert(self.resultsItems, self:InitResultItem(Tools.Instance(self.resultsTrs:GetChild(0),self.resultsTrs)))
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
    self:UpdateHistory()
end

function BirdsAnimalsTrendView:InitRateUI()
    for i=1,12 do
        local img = ComponentUtilGet.Image(self.rateTrs:GetChild(i-1),"icon")
        local logo_id = BirdsAnimalsConfig.ANIMA_HISTORY[i]
        if logo_id <=12 then
            img.sprite = BirdsAnimalsHelper.LoadLogoSprite(logo_id)
        elseif logo_id ==BirdsAnimalsConfig.ANIMAL_TYPE.FeiQin then
            img.sprite = BirdsAnimalsHelper.LoadTxtSprite("BirdsAnimals_FeiQin")
        elseif logo_id ==BirdsAnimalsConfig.ANIMAL_TYPE.ZouShou then
            img.sprite = BirdsAnimalsHelper.LoadTxtSprite("BirdsAnimals_Beast")
        end
    end
end

function BirdsAnimalsTrendView:InitResultItem(transform)
    local table = {}
    table.icon = ComponentUtilGet.Image(transform, "icon");
    table.new = ComponentUtilGet.Image(transform,"new");
    table.ShowLogo = function(logo_id)
        if logo_id then
            table.icon.sprite = BirdsAnimalsHelper.LoadLogoSprite(logo_id);
            table.new.gameObject:SetActive(false)
            table.icon.gameObject:SetActive(true)
        else
            table.new.gameObject:SetActive(false)
            table.icon.gameObject:SetActive(false)
        end
    end

    table.ShowNew=function(show)
        table.new.gameObject:SetActive(show)
    end

    return table
end

function BirdsAnimalsTrendView:UpdateHistory()
    ---测试
    BirdsAnimalsGameModel.historyList = {}
    for i=1,Tools.RandomInt(30,50) do
        table.insert(BirdsAnimalsGameModel.historyList,{logo_index=1,logo_id=Tools.RandomInt(1,12)})
    end
    ---
    local index = #BirdsAnimalsGameModel.historyList
    for i=1,50 do
        if index>0 then
            self.resultsItems[i].ShowLogo(BirdsAnimalsGameModel.historyList[index].logo_id)
            index = index - 1
            if i==1 then self.resultsItems[1].ShowNew(true) end
        else
            self.resultsItems[i].ShowLogo()
        end
    end

    ---概率
    self.rateData = {0,0,0,0,0,0,0,0,0,0,0,0}
    local offset=math.max(#BirdsAnimalsGameModel.historyList-49,1)
    local count = #BirdsAnimalsGameModel.historyList-offset+1
    for i=#BirdsAnimalsGameModel.historyList,offset,-1 do
        self.rateData[BirdsAnimalsGameModel.historyList[i].logo_id]=self.rateData[BirdsAnimalsGameModel.historyList[i].logo_id]+1
    end

    self.rateData[BirdsAnimalsConfig.ANIMAL_TYPE.FeiQin]=0
    self.rateData[BirdsAnimalsConfig.ANIMAL_TYPE.ZouShou]=0

    if count>0 then
        for i=1,12 do
            local logo_id=BirdsAnimalsConfig.ANIMA_HISTORY[i]
            if logo_id<=12 then
                self.rateData[logo_id]=math.floor(self.rateData[logo_id]*1000/count)/10
                self.rateTmps[i].text = self.rateData[logo_id].."%"
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
                self.rateTmps[i].text = self.rateData[BirdsAnimalsConfig.ANIMAL_TYPE.FeiQin].."%"
            elseif logo_id==BirdsAnimalsConfig.ANIMAL_TYPE.ZouShou then
                self.rateTmps[i].text = self.rateData[BirdsAnimalsConfig.ANIMAL_TYPE.ZouShou].."%" 
            end
        end
    end
end

---关闭界面
function BirdsAnimalsTrendView:Close()   
    self.super.Close(self);
end

return BirdsAnimalsTrendView

