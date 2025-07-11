---
---Create by Administrator
---DateTime: 2025-07-11 14:23:07
---
---@class UICommonSlotBtnsView:BaseView
local UICommonSlotBtnsView=Class("UICommonSlotBtnsView",BaseView)

---初始化panel
function UICommonSlotBtnsView:InitView()
	---@type UICommonSlotBtnsCtrl
    self.ctrl=self.ctrl
	self:InitComponents()
end

---获取组件
function UICommonSlotBtnsView:InitComponents()
    self.btn_startmask=ComponentUtilGet.Button(self.transform,"content/btn_startmask");
    self.btn_huodong=ComponentUtilGet.Button(self.transform,"content/buttom/phspin/btn_huodong");
    self.tmp_spin=ComponentUtilGet.TextMeshProUGUI(self.transform,"content/buttom/phspin/tmp_spin");
    self.btn_reduce=ComponentUtilGet.Button(self.transform,"content/buttom/chipInfo/btn_reduce");
    self.btn_add=ComponentUtilGet.Button(self.transform,"content/buttom/chipInfo/btn_add");
    self.tmp_chip=ComponentUtilGet.TextMeshProUGUI(self.transform,"content/buttom/chipInfo/tmp_chip");
    self.txt_win=ComponentUtilGet.Text(self.transform,"content/buttom/win/txt_win");
    self.btn_max=ComponentUtilGet.Button(self.transform,"content/buttom/btn_max");
    self.btn_closeFreeMask=ComponentUtilGet.Button(self.transform,"content/buttom/btn_closeFreeMask");
    self.obj_auto=ComponentUtilGet.GameObject(self.transform,"content/buttom/obj_auto");
    self.btn_wx=ComponentUtilGet.Button(self.transform,"content/buttom/obj_auto/di_bg/btn_wx");
    self.tmp_value=ComponentUtilGet.TextMeshProUGUI(self.transform,"content/buttom/obj_auto/di_bg/btn_wx/tmp_value");
    self.btn_500=ComponentUtilGet.Button(self.transform,"content/buttom/obj_auto/di_bg/btn_500");
    self.tmp_value_btn_500=ComponentUtilGet.TextMeshProUGUI(self.transform,"content/buttom/obj_auto/di_bg/btn_500/tmp_value");
    self.btn_200=ComponentUtilGet.Button(self.transform,"content/buttom/obj_auto/di_bg/btn_200");
    self.tmp_value_btn_200=ComponentUtilGet.TextMeshProUGUI(self.transform,"content/buttom/obj_auto/di_bg/btn_200/tmp_value");
    self.btn_100=ComponentUtilGet.Button(self.transform,"content/buttom/obj_auto/di_bg/btn_100");
    self.tmp_value_btn_100=ComponentUtilGet.TextMeshProUGUI(self.transform,"content/buttom/obj_auto/di_bg/btn_100/tmp_value");
    self.btn_50=ComponentUtilGet.Button(self.transform,"content/buttom/obj_auto/di_bg/btn_50");
    self.tmp_value_btn_50=ComponentUtilGet.TextMeshProUGUI(self.transform,"content/buttom/obj_auto/di_bg/btn_50/tmp_value");
    self.btn_25=ComponentUtilGet.Button(self.transform,"content/buttom/obj_auto/di_bg/btn_25");
    self.tmp_value_btn_25=ComponentUtilGet.TextMeshProUGUI(self.transform,"content/buttom/obj_auto/di_bg/btn_25/tmp_value");
    self.btn_start=ComponentUtilGet.Button(self.transform,"content/buttom/btn_start");
    self.btn_stop=ComponentUtilGet.Button(self.transform,"content/buttom/btn_stop");
    self.btn_auto=ComponentUtilGet.Button(self.transform,"content/buttom/btn_auto");
    self.txt_StopNum=ComponentUtilGet.Text(self.transform,"content/buttom/btn_auto/txt_StopNum");
    self.btn_stop_buttom=ComponentUtilGet.Button(self.transform,"content/buttom/btn_stop");
    self.btn_free=ComponentUtilGet.Button(self.transform,"content/buttom/btn_free");
    self.txt_freeNum=ComponentUtilGet.Text(self.transform,"content/buttom/btn_free/txt_freeNum");
end

---清空组件
function UICommonSlotBtnsView:ClearComponents()
    self.btn_startmask=nil;
    self.btn_huodong=nil;
    self.tmp_spin=nil;
    self.btn_reduce=nil;
    self.btn_add=nil;
    self.tmp_chip=nil;
    self.txt_win=nil;
    self.btn_max=nil;
    self.btn_closeFreeMask=nil;
    self.obj_auto=nil;
    self.btn_wx=nil;
    self.tmp_value=nil;
    self.btn_500=nil;
    self.tmp_value_btn_500=nil;
    self.btn_200=nil;
    self.tmp_value_btn_200=nil;
    self.btn_100=nil;
    self.tmp_value_btn_100=nil;
    self.btn_50=nil;
    self.tmp_value_btn_50=nil;
    self.btn_25=nil;
    self.tmp_value_btn_25=nil;
    self.btn_start=nil;
    self.btn_stop=nil;
    self.btn_auto=nil;
    self.txt_StopNum=nil;
    self.btn_stop_buttom=nil;
    self.btn_free=nil;
    self.txt_freeNum=nil;
end

---初始化View数据
function UICommonSlotBtnsView:InitPanelData(args)
	
end

---关闭界面
function UICommonSlotBtnsView:Close()   
    self.super.Close(self);
end

return UICommonSlotBtnsView

