---
---Create by Administrator
---DateTime: 2025-07-02 13:47:40
---
---@class USDollarExpressHelpView:BaseView
local USDollarExpressHelpView=Class("USDollarExpressHelpView",BaseView)

---初始化panel
function USDollarExpressHelpView:InitView()
	---@type USDollarExpressHelpCtrl
    self.ctrl=self.ctrl
	self:InitComponents()
end

---获取组件
function USDollarExpressHelpView:InitComponents()
    self.btn_back=ComponentUtilGet.Button(self.transform,"content/btn_back");
    self.btn_left=ComponentUtilGet.Button(self.transform,"content/btn_left");
    self.btn_right=ComponentUtilGet.Button(self.transform,"content/btn_right");

    self.peilvPage = { }
    for i = 1, 8 do
        self.peilvPage[i] = ComponentUtilGet.GameObject(self.transform,"content/pages/page"..i)
        self.peilvPage[i]:SetActive(false)
    end
end

---清空组件
function USDollarExpressHelpView:ClearComponents()
    self.btn_back=nil;
    self.btn_left=nil;
    self.btn_right=nil;
end

---初始化View数据
function USDollarExpressHelpView:InitPanelData(args)
	
end

function USDollarExpressHelpView:SetButtonState(bol1, bol2)
    self.btn_left.interactable = bol1;
    self.btn_right.interactable = bol2;
end

---关闭界面
function USDollarExpressHelpView:Close()   
    self.super.Close(self);
end

return USDollarExpressHelpView

