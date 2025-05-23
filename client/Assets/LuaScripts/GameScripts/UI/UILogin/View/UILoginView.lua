---
---Create by Administrator
---DateTime: 2025-05-08 14:49:10
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
    self.btn_test=ComponentUtilGet.Button(self.transform,"content/btn_test");
    self.tmp_title=ComponentUtilGet.TextMeshProUGUI(self.transform,"content/tmp_title");
    self.tmp_title.text="你打大大的"
end

---清空组件
function UILoginView:ClearComponents()
    self.btn_test=nil;
    self.tmp_title=nil;
    
end

---初始化View数据
function UILoginView:InitPanelData(args)
	
end

---关闭界面
function UILoginView:Close()   
    self.super.Close(self);
end

return UILoginView

