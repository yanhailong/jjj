---
---Create by Administrator
---DateTime: 2025-06-18 10:32:48
---
---@class USDollarExpressMainView:BaseView
local USDollarExpressMainView=Class("USDollarExpressMainView",BaseView)

---初始化panel
function USDollarExpressMainView:InitView()
	---@type USDollarExpressMainCtrl
    self.ctrl=self.ctrl
	self:InitComponents()
    self:InitWheelRoot()
end

---获取组件
function USDollarExpressMainView:InitComponents()
    self.trans_slots=ComponentUtilGet.Transform(self.transform,"content/gameCenter/slotsMain/wheelRoot/trans_slots");
    self.img_icon=ComponentUtilGet.Image(self.transform,"content/gameCenter/item/img_icon");
    self.txt_grand=ComponentUtilGet.Text(self.transform,"content/gameCenter/obj_top1/jackPots/grand/txt_grand")
    self.txt_mejor=ComponentUtilGet.Text(self.transform,"content/gameCenter/obj_top1/jackPots/mejor/txt_mejor")
    self.txt_minor=ComponentUtilGet.Text(self.transform,"content/gameCenter/obj_top1/jackPots/minor/txt_minor")
    self.txt_mini=ComponentUtilGet.Text(self.transform,"content/gameCenter/obj_top1/jackPots/mini/txt_mini")
    self.rootEffects=ComponentUtilGet.Transform(self.transform,"content/effects")
    self.obj_top1=ComponentUtilGet.GameObject(self.transform,"content/gameCenter/obj_top1")
    self.obj_top2=ComponentUtilGet.GameObject(self.transform,"content/gameCenter/obj_top2")
    self.txt_repeatWin=ComponentUtilGet.Text(self.transform,"content/gameCenter/obj_top2/txt_repeatWin")
    self.img_slider=ComponentUtilGet.Image(self.transform,"content/gameCenter/img_slider")
end

---清空组件
function USDollarExpressMainView:ClearComponents()
    self.trans_slots=nil;
    self.img_icon=nil;
    self.btn_start=nil;
    self.txt_grand=nil
    self.txt_mejor=nil
    self.txt_minor=nil
    self.txt_mini=nil
end

function USDollarExpressMainView:InitWheelRoot()
    self.wheelRootList={}
    self.wheelMasks={}
    for i = 1, 5 do
        self.wheelRootList[i]=ComponentUtilGet.Transform(self.transform,"content/gameCenter/slotsMain/wheelRoot/trans_slots/slotColumn"..i)
        self.wheelMasks[i]=ComponentUtilGet.GameObject(self.wheelRootList[i],"newobj/mask")
    end
    
    self.cardPrefab=self.transform:Find("content/gameCenter/item").gameObject
    self.cardPrefab:SetActive(false)
    self:IsShowBl(false)
end
function USDollarExpressMainView:IsShowBl(isShow)
    for i = 1, 5 do
        self.wheelMasks[i]:SetActive(isShow)
    end
end
---初始化View数据
function USDollarExpressMainView:InitPanelData(args)
	
end

---关闭界面
function USDollarExpressMainView:Close()   
    self.super.Close(self);
end

return USDollarExpressMainView

