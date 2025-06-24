---
---Create by Administrator
---DateTime: 2025-06-24 15:49:59
---
---@class UILoginView:BaseView
local UILoginView=Class("UILoginView",BaseView)

---初始化panel
function UILoginView:InitView()
	---@type UILoginCtrl
    self.ctrl=self.ctrl
	self:InitComponents()
end

---获取组件
function UILoginView:InitComponents()
    self.btn_phone=ComponentUtilGet.Button(self.transform,"content/btn_phone");
    self.btn_google=ComponentUtilGet.Button(self.transform,"content/btn_google");
    self.btn_youke=ComponentUtilGet.Button(self.transform,"content/btn_youke");
end

---清空组件
function UILoginView:ClearComponents()
    self.btn_phone=nil;
    self.btn_google=nil;
    self.btn_youke=nil;
end

---初始化View数据
function UILoginView:InitPanelData(args)
	
end

---关闭界面
function UILoginView:Close()   
    self.super.Close(self);
end

return UILoginView

