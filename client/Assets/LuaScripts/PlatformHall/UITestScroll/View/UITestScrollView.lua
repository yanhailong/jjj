---
---Create by Administrator
---DateTime: 2025-06-21 16:49:45
---
---@class UITestScrollView:BaseView
local UITestScrollView=Class("UITestScrollView",BaseView)

---初始化panel
function UITestScrollView:InitView()
	---@type UITestScrollCtrl
    self.ctrl=self.ctrl
	self:InitComponents()
end

---获取组件
function UITestScrollView:InitComponents()
    self.udy_test=ComponentUtilGet.SimpleScroll(self.transform,"content/udy_test");
end

---清空组件
function UITestScrollView:ClearComponents()
    self.udy_test=nil;
    self.txt_name=nil;
end

---初始化View数据
function UITestScrollView:InitPanelData(args)
	
end

---关闭界面
function UITestScrollView:Close()   
    self.super.Close(self);
end

return UITestScrollView

