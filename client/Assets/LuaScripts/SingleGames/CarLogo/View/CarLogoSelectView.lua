---
---Create by Administrator
---DateTime: 2025-07-22 17:17:10
---
---@class CarLogoSelectView:BaseView
local CarLogoSelectView=Class("CarLogoSelectView",BaseView)

---初始化panel
function CarLogoSelectView:InitView()
	---@type CarLogoSelectCtrl
    self.ctrl=self.ctrl
	self:InitComponents()
end

---获取组件
function CarLogoSelectView:InitComponents()
    self.img_title=ComponentUtilGet.Image(self.transform,"BackGround/img_title");
    self.btn_coinAdd=ComponentUtilGet.Button(self.transform,"content/top/SelfHead/Money/btn_coinAdd");
    self.btn_close=ComponentUtilGet.Button(self.transform,"content/top/btn_close");
    self.btn_car1=ComponentUtilGet.Button(self.transform,"content/center/item/btn_car1");
    self.btn_car2=ComponentUtilGet.Button(self.transform,"content/center/item (1)/btn_car2");
    self.btn_car3=ComponentUtilGet.Button(self.transform,"content/center/item (2)/btn_car3");
end

---清空组件
function CarLogoSelectView:ClearComponents()
    self.img_title=nil;
    self.btn_coinAdd=nil;
    self.btn_close=nil;
    self.btn_car1=nil;
    self.btn_car2=nil;
    self.btn_car3=nil;
end

---初始化View数据
function CarLogoSelectView:InitPanelData(args)
	
end

---关闭界面
function CarLogoSelectView:Close()   
    self.super.Close(self);
end

return CarLogoSelectView

