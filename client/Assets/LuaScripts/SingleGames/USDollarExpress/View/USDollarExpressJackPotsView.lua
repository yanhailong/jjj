---
---Create by Administrator
---DateTime: 2025-07-19 11:25:15
---
---@class USDollarExpressJackPotsView:BaseView
local USDollarExpressJackPotsView=Class("USDollarExpressJackPotsView",BaseView)

---初始化panel
function USDollarExpressJackPotsView:InitView()
	---@type USDollarExpressJackPotsCtrl
    self.ctrl=self.ctrl
	self:InitComponents()
end

---获取组件
function USDollarExpressJackPotsView:InitComponents()
    self.obj_eff_tc_grand_red=ComponentUtilGet.GameObject(self.transform,"content/obj_eff_tc_grand_red");
    self.txt_grand=ComponentUtilGet.Text(self.transform,"content/obj_eff_tc_grand_red/txt_grand");
    self.obj_eff_tc_mejor_violet=ComponentUtilGet.GameObject(self.transform,"content/obj_eff_tc_mejor_violet");
    self.txt_mejor=ComponentUtilGet.Text(self.transform,"content/obj_eff_tc_mejor_violet/txt_mejor");
    self.obj_eff_tc_mini_green=ComponentUtilGet.GameObject(self.transform,"content/obj_eff_tc_mini_green");
    self.txt_mini=ComponentUtilGet.Text(self.transform,"content/obj_eff_tc_mini_green/txt_mini");
    self.obj_eff_tc_minor_blue=ComponentUtilGet.GameObject(self.transform,"content/obj_eff_tc_minor_blue");
    self.txt_minor=ComponentUtilGet.Text(self.transform,"content/obj_eff_tc_minor_blue/txt_minor");
    self.obj_eff_tc_youwon_yellow=ComponentUtilGet.GameObject(self.transform,"content/obj_eff_tc_youwon_yellow");
    self.txt_youwon=ComponentUtilGet.Text(self.transform,"content/obj_eff_tc_youwon_yellow/txt_youwon");
end

---清空组件
function USDollarExpressJackPotsView:ClearComponents()
    self.obj_eff_tc_grand_red=nil;
    self.txt_grand=nil;
    self.obj_eff_tc_mejor_violet=nil;
    self.txt_mejor=nil;
    self.obj_eff_tc_mini_green=nil;
    self.txt_mini=nil;
    self.obj_eff_tc_minor_blue=nil;
    self.txt_minor=nil;
    self.obj_eff_tc_youwon_yellow=nil;
    self.txt_youwon=nil;
end

---初始化View数据
function USDollarExpressJackPotsView:InitPanelData(args)
	
end

---关闭界面
function USDollarExpressJackPotsView:Close()   
    self.super.Close(self);
end

return USDollarExpressJackPotsView

