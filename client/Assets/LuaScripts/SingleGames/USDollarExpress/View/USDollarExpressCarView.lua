---
---Create by Administrator
---DateTime: 2025-06-21 15:39:44
---
---@class USDollarExpressCarView:BaseView
local USDollarExpressCarView=Class("USDollarExpressCarView",BaseView)

---初始化panel
function USDollarExpressCarView:InitView()
	---@type USDollarExpressCarCtrl
    self.ctrl=self.ctrl
	self:InitComponents()
end

---获取组件
function USDollarExpressCarView:InitComponents()
    self.tmp_loading=ComponentUtilGet.TextMeshProUGUI(self.transform,"content/tmp_loading");
    self.trans_root=ComponentUtilGet.Transform(self.transform,"content/trans_root");
    self.tmp_value=ComponentUtilGet.TextMeshProUGUI(self.transform,"content/tmp_value");
    
    self.btn_skip=ComponentUtilGet.Button(self.transform,"content/btn_skip")
    self.objCar=ComponentUtilGet.GameObject(self.transform,"content/trans_root/car")
    self.objCar:SetActive(false)
end

---清空组件
function USDollarExpressCarView:ClearComponents()
    self.tmp_loading=nil;
    self.trans_root=nil;
    self.tmp_value=nil;
end

---初始化View数据
function USDollarExpressCarView:InitPanelData(args)
	
end

---关闭界面
function USDollarExpressCarView:Close()   
    self.super.Close(self);
end

return USDollarExpressCarView

