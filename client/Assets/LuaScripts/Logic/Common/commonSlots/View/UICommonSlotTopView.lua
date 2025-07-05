---
---Create by Administrator
---DateTime: 2025-07-01 16:18:52
---
---@class UICommonSlotTopView:BaseView
local UICommonSlotTopView=Class("UICommonSlotTopView",BaseView)

---初始化panel
function UICommonSlotTopView:InitView()
	---@type UICommonSlotTopCtrl
    self.ctrl=self.ctrl
	self:InitComponents()
end

---获取组件
function UICommonSlotTopView:InitComponents()
    self.btn_home=ComponentUtilGet.Button(self.transform,"content/top/btn_home");
    self.btn_gift=ComponentUtilGet.Button(self.transform,"content/top/btn_gift");
    self.btn_coinAdd=ComponentUtilGet.Button(self.transform,"content/top/coin/btn_coinAdd");
    self.tmp_coinNum=ComponentUtilGet.TextMeshProUGUI(self.transform,"content/top/coin/tmp_coinNum");
    self.btn_buy=ComponentUtilGet.Button(self.transform,"content/top/btn_buy");
    self.btn_Sale=ComponentUtilGet.Button(self.transform,"content/top/btn_Sale");
    self.tmp_time=ComponentUtilGet.TextMeshProUGUI(self.transform,"content/top/btn_Sale/tmp_time");
    self.img_fill=ComponentUtilGet.Image(self.transform,"content/top/pro/img_fill");
    self.txt_value=ComponentUtilGet.Text(self.transform,"content/top/pro/txt_value");
    self.btn_pig=ComponentUtilGet.Button(self.transform,"content/top/btn_pig");
    self.btn_set=ComponentUtilGet.Button(self.transform,"content/top/btn_set");
end

---清空组件
function UICommonSlotTopView:ClearComponents()
    self.btn_home=nil;
    self.btn_gift=nil;
    self.btn_coinAdd=nil;
    self.tmp_coinNum=nil;
    self.btn_buy=nil;
    self.btn_Sale=nil;
    self.tmp_time=nil;
    self.img_fill=nil;
    self.txt_value=nil;
    self.btn_pig=nil;
    self.btn_set=nil;
end

---初始化View数据
function UICommonSlotTopView:InitPanelData(args)
	
end

---关闭界面
function UICommonSlotTopView:Close()   
    self.super.Close(self);
end

return UICommonSlotTopView

