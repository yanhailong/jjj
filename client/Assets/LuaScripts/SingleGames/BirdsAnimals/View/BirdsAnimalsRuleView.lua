---
---Create by Administrator
---DateTime: 2025-07-03 10:40:03
---
---@class BirdsAnimalsRuleView:BaseView
local BirdsAnimalsRuleView=Class("BirdsAnimalsRuleView",BaseView)
local BirdsAnimalsHelper=require("SingleGames/BirdsAnimals/BirdsAnimalsHelper")
local BirdsAnimalsConfig=require("SingleGames/BirdsAnimals/BirdsAnimalsConfig")
---初始化panel
function BirdsAnimalsRuleView:InitView()
	---@type BirdsAnimalsRuleCtrl
    self.ctrl=self.ctrl
	self:InitComponents()
end

---获取组件
function BirdsAnimalsRuleView:InitComponents()
    self.img_title=ComponentUtilGet.Image(self.transform,"content/BackGround/img_title");
    self.btn_close=ComponentUtilGet.Button(self.transform,"content/BackGround/btn_close");
    self.group=ComponentUtilGet.Transform(self.transform,"content/Scroll View/Viewport/Content/Rule/group")
    
end

---清空组件
function BirdsAnimalsRuleView:ClearComponents()
    self.img_title=nil;
    self.btn_close=nil;
end

---初始化View数据
function BirdsAnimalsRuleView:InitPanelData(args)
    local index = 1
    for logo_id,v in pairs(BirdsAnimalsConfig.ANIMAL_GROUP[BirdsAnimalsConfig.ANIMAL_TAG.FeiQin]) do
        self:getImgByIndex(index,logo_id)
        index = index + 1
    end
    for logo_id,v in pairs(BirdsAnimalsConfig.ANIMAL_GROUP[BirdsAnimalsConfig.ANIMAL_TAG.ZouShou]) do
        self:getImgByIndex(index,logo_id)
        index = index + 1
    end
    self:getImgByIndex(index,BirdsAnimalsConfig.ANIMAL_TYPE.JINSHA)
    self:getImgByIndex(index+1,BirdsAnimalsConfig.ANIMAL_TYPE.YINSHA)
    self:getImgByIndex(index+2,BirdsAnimalsConfig.ANIMAL_TYPE.TONGSHA,true)
    self:getImgByIndex(index+3,BirdsAnimalsConfig.ANIMAL_TYPE.TONGPEI,true)
end

function BirdsAnimalsRuleView:getImgByIndex(index,logo_id,hiden)
    local trs = self.group:GetChild(index-1)
    local img = ComponentUtilGet.Image(trs,"Image/icon")
    local rate = ComponentUtilGet.Image(trs,"rate")
    img.sprite = BirdsAnimalsHelper.LoadLogoSprite(logo_id)
    img:SetNativeSize()
    if hiden then
        rate.gameObject:SetActive(false)
    else
        rate.sprite = BirdsAnimalsHelper.LoadTxtSprite("fqzs_txt_"..BirdsAnimalsConfig.ODDS[logo_id].."x")
        rate:SetNativeSize() 
    end
end
---关闭界面
function BirdsAnimalsRuleView:Close()   
    self.super.Close(self);
end

return BirdsAnimalsRuleView

