---
---Create by Administrator
---DateTime: 2025-05-24 09:23:06
---
---@class UIHallView:BaseView
local UIHallView=Class("UIHallView",BaseView)

---初始化panel
function UIHallView:InitView()
	---@type UIHallCtrl
    self.ctrl=self.ctrl
	self:InitComponents()
end

---获取组件
function UIHallView:InitComponents()
    self.tmp_sy=ComponentUtilGet.TextMeshProUGUI(self.transform,"content/tmp_sy");
end

---清空组件
function UIHallView:ClearComponents()
    self.tmp_sy=nil;
end

---初始化View数据
function UIHallView:InitPanelData(args)
	
end

---关闭界面
function UIHallView:Close()   
    self.super.Close(self);
end

return UIHallView

