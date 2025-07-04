---
---Create by Administrator
---DateTime: 2025-07-03 10:40:03
---
---@class BirdsAnimalsRuleView:BaseView
local BirdsAnimalsRuleView=Class("BirdsAnimalsRuleView",BaseView)

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
end

---清空组件
function BirdsAnimalsRuleView:ClearComponents()
    self.img_title=nil;
    self.btn_close=nil;
end

---初始化View数据
function BirdsAnimalsRuleView:InitPanelData(args)
	
end

---关闭界面
function BirdsAnimalsRuleView:Close()   
    self.super.Close(self);
end

return BirdsAnimalsRuleView

