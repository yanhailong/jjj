---
---Create by Administrator
---DateTime: 2025-07-19 10:09:17
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
    self.trans_root=ComponentUtilGet.Transform(self.transform,"content/trans_root");
    self.txt_mejor=ComponentUtilGet.Text(self.transform,"content/top/mejor/txt_mejor");
    self.txt_mini=ComponentUtilGet.Text(self.transform,"content/top/mini/txt_mini");
    self.txt_grand=ComponentUtilGet.Text(self.transform,"content/top/grand/txt_grand");
    self.txt_minor=ComponentUtilGet.Text(self.transform,"content/top/minor/txt_minor");
    self.txt_gold=ComponentUtilGet.Text(self.transform,"content/top/gold/txt_gold");
    self.btn_skip=ComponentUtilGet.Button(self.transform,"content/buttom/btn_skip");
    self.txt_value=ComponentUtilGet.Text(self.transform,"content/buttom/txt_value");
    self.txt_trainLeft=ComponentUtilGet.Text(self.transform,"content/buttom/txt_trainLeft");
    self.trans_startPos=ComponentUtilGet.Transform(self.transform,"content/trans_startPos");
    self.trans_centerPos=ComponentUtilGet.Transform(self.transform,"content/trans_centerPos");
    self.trans_endPos=ComponentUtilGet.Transform(self.transform,"content/trans_endPos");
    self.trans_effects=ComponentUtilGet.Transform(self.transform,"content/trans_effects");
    self.trans_txtMidd=ComponentUtilGet.Transform(self.transform,"content/trans_txtMidd");
    self.ani=ComponentUtilGet.Animator(self.transform)
end

---清空组件
function USDollarExpressCarView:ClearComponents()
    self.trans_root=nil;
    self.txt_mejor=nil;
    self.txt_mini=nil;
    self.txt_grand=nil;
    self.txt_minor=nil;
    self.txt_gold=nil;
    self.btn_skip=nil;
    self.txt_value=nil;
    self.txt_trainLeft=nil;
    self.trans_startPos=nil;
    self.trans_centerPos=nil;
    self.trans_endPos=nil;
    self.trans_effects=nil;
end

---初始化View数据
function USDollarExpressCarView:InitPanelData(args)
	
end

---关闭界面
function USDollarExpressCarView:Close()   
    self.super.Close(self);
end

return USDollarExpressCarView

