---
---Create by Administrator
---DateTime: 2025-06-18 13:55:05
---
---@class USDollarExpressLoadingView:BaseView
local USDollarExpressLoadingView=Class("USDollarExpressLoadingView",BaseView)

---初始化panel
function USDollarExpressLoadingView:InitView()
	---@type USDollarExpressLoadingCtrl
    self.ctrl=self.ctrl
	self:InitComponents()
end

---获取组件
function USDollarExpressLoadingView:InitComponents()
    self.tmp_loading=ComponentUtilGet.TextMeshProUGUI(self.transform,"content/tmp_loading");
    self.slider_pro=ComponentUtilGet.Slider(self.transform,"content/slider_pro");
end

---清空组件
function USDollarExpressLoadingView:ClearComponents()
    self.tmp_loading=nil;
    self.slider_pro=nil;
end

---初始化View数据
function USDollarExpressLoadingView:InitPanelData(args)
	
end

---关闭界面
function USDollarExpressLoadingView:Close()   
    self.super.Close(self);
end

return USDollarExpressLoadingView

