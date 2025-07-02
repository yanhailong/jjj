---
---Create by Administrator
---DateTime: 2025-06-30 15:05:25
---
---@class CarLogoRuleView:BaseView
local CarLogoRuleView=Class("CarLogoRuleView",BaseView)

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
end

---清空组件
function CarLogoRuleView:ClearComponents()
    self.img_title=nil;
    self.btn_close=nil;
end

---初始化View数据
function CarLogoRuleView:InitPanelData(args)
	
end

---关闭界面
function CarLogoRuleView:Close()   
    self.super.Close(self);
end

return CarLogoRuleView

