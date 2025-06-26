---
---Create by Administrator
---DateTime: 2025-06-26 17:17:27
---
---@class RuleView:BaseView
local RuleView=Class("RuleView",BaseView)

---初始化panel
function RuleView:InitView()
	---@type RuleCtrl
    self.ctrl=self.ctrl
	self:InitComponents()
end

---获取组件
function RuleView:InitComponents()
    self.img_title=ComponentUtilGet.Image(self.transform,"content/BackGround/img_title");
    self.btn_close=ComponentUtilGet.Button(self.transform,"content/BackGround/btn_close");
end

---清空组件
function RuleView:ClearComponents()
    self.img_title=nil;
    self.btn_close=nil;
end

---初始化View数据
function RuleView:InitPanelData(args)
	
end

---关闭界面
function RuleView:Close()   
    self.super.Close(self);
end

return RuleView

