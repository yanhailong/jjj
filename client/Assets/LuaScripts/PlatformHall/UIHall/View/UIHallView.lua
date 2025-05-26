---
---Create by Administrator
---DateTime: 2025-05-26 15:24:36
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
    self.btn_game001=ComponentUtilGet.Button(self.transform,"content/ScrollView/Viewport/Content/btn_game001");
    self.tmp_sy=ComponentUtilGet.TextMeshProUGUI(self.transform,"content/tmp_sy");
    self.btn_close=ComponentUtilGet.Button(self.transform,"content/btn_close");
end

---清空组件
function UIHallView:ClearComponents()
    self.btn_game001=nil;
    self.tmp_sy=nil;
    self.btn_close=nil;
end

---初始化View数据
function UIHallView:InitPanelData(args)
	
end

---关闭界面
function UIHallView:Close()   
    self.super.Close(self);
end

return UIHallView

