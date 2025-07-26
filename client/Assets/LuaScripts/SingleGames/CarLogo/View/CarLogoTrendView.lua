---
---Create by Administrator
---DateTime: 2025-06-30 15:05:35
---
---@class CarLogoTrendView:BaseView
local CarLogoTrendView=Class("CarLogoTrendView",BaseView)
local CarLogoConfig =require("SingleGames/CarLogo/CarLogoConfig")
local CarLogoHelper=require("SingleGames/CarLogo/CarLogoHelper")

---初始化panel
function CarLogoTrendView:InitView()
	---@type CarLogoTrendCtrl
    self.ctrl=self.ctrl
	self:InitComponents()
end

---获取组件
function CarLogoTrendView:InitComponents()
    self.img_title=ComponentUtilGet.Image(self.transform,"content/background/img_title");
    self.btn_close=ComponentUtilGet.Button(self.transform,"content/background/btn_close");
    self.resultsTrs=ComponentUtilGet.Transform(self.transform,"content/results")
    self.rateTrs=ComponentUtilGet.Transform(self.transform,"content/rate")
    self.rateTmps={}
    for i=1,self.rateTrs.childCount do
        table.insert(self.rateTmps,ComponentUtilGet.TextMeshProUGUI(self.rateTrs:GetChild(i-1),"num"))
    end
    self.resultsItems={}
    table.insert(  self.resultsItems,self:InitResultItem(self.resultsTrs:GetChild(0)))
    for i=1,49 do
        table.insert(self.resultsItems, self:InitResultItem(Tools.Instance(self.resultsTrs:GetChild(0),self.resultsTrs)))
    end
end

---清空组件
function CarLogoTrendView:ClearComponents()
    self.img_title=nil;
    self.btn_close=nil;
end

---初始化View数据
function CarLogoTrendView:InitPanelData(args)
    self:InitRateUI()
    self:UpdateHistory(args or {})
end

function CarLogoTrendView:InitRateUI()
    for i=1,self.rateTrs.childCount do
        local img = ComponentUtilGet.Image(self.rateTrs:GetChild(i-1),"icon")
        img.sprite = CarLogoHelper.LoadLogoSprite(i)
    end
end

function CarLogoTrendView:InitResultItem(transform)
    local table = {}
    table.obj = transform.gameObject
    table.icon = ComponentUtilGet.Image(transform, "icon");
    table.new = ComponentUtilGet.Image(transform,"new");
    table.ShowLogo = function(index)
        if index then
            local logoId = CarLogoConfig.FindIndexByLogoId(index)
            table.icon.sprite = CarLogoHelper.LoadLogoSprite(logoId);
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

function CarLogoTrendView:UpdateHistory(history)
    ---测试
    local historyList = history
    local total = #historyList
    for i=1,50 do
        if i <= total then
            self.resultsItems[i].ShowLogo(historyList[i])
            if i==total then self.resultsItems[i].ShowNew(true) end
        else
            self.resultsItems[i].ShowLogo()
        end
    end
    
    ---概率
    self.rateData = {0,0,0,0,0,0,0,0}
    local offset=math.max(#historyList-49,1)
    local count = #historyList-offset+1
    for i=#historyList,offset,-1 do
        local logoId = CarLogoConfig.FindIndexByLogoId(historyList[i])
        self.rateData[logoId]=self.rateData[logoId]+1
    end

    for i=1,8 do
        self.rateData[i]=count>0 and math.floor(self.rateData[i]*1000/count)/10 or 0
        self.rateTmps[i].text = self.rateData[i].."%"
    end
end

---关闭界面
function CarLogoTrendView:Close()   
    self.super.Close(self);
end

return CarLogoTrendView

