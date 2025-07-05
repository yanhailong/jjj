---
---Create by Administrator
---DateTime: 2025-07-04 13:37:43
---
---@class USDollarExpressGameSelectView:BaseView
local USDollarExpressGameSelectView=Class("USDollarExpressGameSelectView",BaseView)

---初始化panel
function USDollarExpressGameSelectView:InitView()
	---@type USDollarExpressGameSelectCtrl
    self.ctrl=self.ctrl
	self:InitComponents()
end

---获取组件
function USDollarExpressGameSelectView:InitComponents()
    self.obj_des=ComponentUtilGet.GameObject(self.transform,"content/obj_des");
    self.btn_SelectTrain=ComponentUtilGet.Button(self.transform,"content/btn_SelectTrain");
    self.btn_SelectFree=ComponentUtilGet.Button(self.transform,"content/btn_SelectFree");
    self.txt_freeNum=ComponentUtilGet.Text(self.transform,"content/btn_SelectFree/txt_freeNum");
end

---清空组件
function USDollarExpressGameSelectView:ClearComponents()
    self.obj_des=nil;
    self.btn_SelectTrain=nil;
    self.btn_SelectFree=nil;
    self.txt_freeNum=nil;
end

---初始化View数据
function USDollarExpressGameSelectView:InitPanelData(args)
	
end

---关闭界面
function USDollarExpressGameSelectView:Close()   
    self.super.Close(self);
end

return USDollarExpressGameSelectView

