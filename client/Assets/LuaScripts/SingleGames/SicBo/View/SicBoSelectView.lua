---
---Create by Administrator
---DateTime: 2025-07-31 17:40:22
---
---@class SicBoSelectView:BaseView
local SicBoSelectView = Class("SicBoSelectView", BaseView)

---初始化panel
function SicBoSelectView:InitView()
    ---@type SicBoSelectCtrl
    self.ctrl = self.ctrl
    self:InitComponents()
end

---获取组件
function SicBoSelectView:InitComponents()
    self.img_title = ComponentUtilGet.Image(self.transform, "BackGround/img_title");
    self.btn_coinAdd = ComponentUtilGet.Button(self.transform, "content/top/SelfHead/Money/btn_coinAdd");
    self.btn_close = ComponentUtilGet.Button(self.transform, "content/top/btn_close");
    self.btn_car = ComponentUtilGet.Button(self.transform, "content/center/item/btn_car");
    self.btn_car_item = ComponentUtilGet.Button(self.transform, "content/center/item (1)/btn_car");
    self.btn_car_item = ComponentUtilGet.Button(self.transform, "content/center/item (2)/btn_car");
end

---清空组件
function SicBoSelectView:ClearComponents()
    self.img_title = nil;
    self.btn_coinAdd = nil;
    self.btn_close = nil;
    self.btn_car = nil;
    self.btn_car_item = nil;
    self.btn_car_item = nil;
end

---初始化View数据
function SicBoSelectView:InitPanelData(args)

end

---关闭界面
function SicBoSelectView:Close()
    self.super.Close(self);
end

return SicBoSelectView
