---
---Create by Administrator
---DateTime: 2025-05-28 10:26:55
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
    self.tmp_login=ComponentUtilGet.TextMeshProUGUI(self.transform,"content/tmp_login");
    self.btn_login=ComponentUtilGet.Button(self.transform,"content/btn_login");
end

---清空组件
function UILoginView:ClearComponents()
    self.tmp_login=nil;
    self.btn_login=nil;
end

---初始化View数据
function UILoginView:InitPanelData(args)
	
end

---关闭界面
function UILoginView:Close()   
    self.super.Close(self);
end

return UILoginView

