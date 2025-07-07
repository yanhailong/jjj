---
---Create by Administrator
---DateTime: 2025-06-30 15:05:25
---
---@class CarLogoRuleView:BaseView
local CarLogoRuleView=Class("CarLogoRuleView",BaseView)
local CarLogoConfig=require("SingleGames/CarLogo/CarLogoConfig")
local CarLogoHelper=require("SingleGames/CarLogo/CarLogoHelper")
---初始化panel
function CarLogoRuleView:InitView()
	---@type CarLogoRuleCtrl
    self.ctrl=self.ctrl
	self:InitComponents()
end

---获取组件
function CarLogoRuleView:InitComponents()
    self.img_title=ComponentUtilGet.Image(self.transform,"content/BackGround/img_title");
    self.btn_close=ComponentUtilGet.Button(self.transform,"content/BackGround/btn_close");
    self.tmp_desc=ComponentUtilGet.Text(self.transform,"content/Scroll View/Viewport/Content/tmp_desc")
    self.gridTrs=ComponentUtilGet.Transform(self.transform,"content/Scroll View/Viewport/Content/grid")
    self.LineItems={}
    for i=1,self.gridTrs.childCount do
        table.insert(self.LineItems,{
            img_name=ComponentUtilGet.Image(self.gridTrs:GetChild(i-1),"img_name"),
            txt_beilv=ComponentUtilGet.Text(self.gridTrs:GetChild(i-1),"txt_beilv")
        })
    end
end

---清空组件
function CarLogoRuleView:ClearComponents()
    self.img_title=nil;
    self.btn_close=nil;
end

---初始化View数据
function CarLogoRuleView:InitPanelData(args)
    for i=1,#CarLogoConfig.LOGO_ODDS do
        self.LineItems[i].img_name.sprite = CarLogoHelper.LoadLogoNameSprite(i)
        self.LineItems[i].txt_beilv.text = CarLogoConfig.LOGO_ODDS[i].."X"
        self.LineItems[i].img_name:SetNativeSize()
    end
    self.tmp_desc.text = LocalManager.GetStrById(200300003)
end

---关闭界面
function CarLogoRuleView:Close()   
    self.super.Close(self);
end

return CarLogoRuleView

