---
---Create by Administrator
---DateTime: 2025-07-02 15:39:02
---
---@class USDollarExpressMapSelectView:BaseView
local USDollarExpressMapSelectView=Class("USDollarExpressMapSelectView",BaseView)

---初始化panel
function USDollarExpressMapSelectView:InitView()
	---@type USDollarExpressMapSelectCtrl
    self.ctrl=self.ctrl
	self:InitComponents()
end

---获取组件
function USDollarExpressMapSelectView:InitComponents()
    self.obj_des=ComponentUtilGet.GameObject(self.transform,"content/obj_des");
    self.txt_leftNum=ComponentUtilGet.Text(self.transform,"content/obj_des/txt_leftNum");
end

---清空组件
function USDollarExpressMapSelectView:ClearComponents()
    self.obj_des=nil;
    self.txt_leftNum=nil;
end

---初始化View数据
function USDollarExpressMapSelectView:InitPanelData(args)
	
end

---关闭界面
function USDollarExpressMapSelectView:Close()   
    self.super.Close(self);
end

return USDollarExpressMapSelectView

