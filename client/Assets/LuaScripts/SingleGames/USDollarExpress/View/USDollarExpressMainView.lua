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
    self:InitJackPot()
end

---获取组件
function USDollarExpressMainView:InitComponents()
    self.trans_slots=ComponentUtilGet.Transform(self.transform,"content/gameCenter/slotsMain/wheelRoot/trans_slots");
    self.img_icon=ComponentUtilGet.Image(self.transform,"content/gameCenter/item/img_icon");
    self.txt_grand=ComponentUtilGet.Text(self.transform,"content/gameCenter/jackPots/grand/txt_grand")
    self.txt_mejor=ComponentUtilGet.Text(self.transform,"content/gameCenter/jackPots/mejor/txt_mejor")
    self.txt_minor=ComponentUtilGet.Text(self.transform,"content/gameCenter/jackPots/minor/txt_minor")
    self.txt_mini=ComponentUtilGet.Text(self.transform,"content/gameCenter/jackPots/mini/txt_mini")
    self.rootEffects=ComponentUtilGet.Transform(self.transform,"content/effects")
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
    for i = 1, 5 do
        self.wheelRootList[i]=ComponentUtilGet.Transform(self.transform,"content/gameCenter/slotsMain/wheelRoot/trans_slots/slotColumn"..i)
    end

    self.cardPrefab=self.transform:Find("content/gameCenter/item").gameObject
    self.cardPrefab:SetActive(false)
end

function USDollarExpressMainView:InitJackPot()
    self.jackPotTexts={}
    self.jackPotTexts[1]=ComponentUtilGet.Text(self.transform,"content/gameCenter/jackPots/grand/txt_grand")
    self.jackPotTexts[2]=ComponentUtilGet.Text(self.transform,"content/gameCenter/jackPots/mejor/txt_mejor")
    self.jackPotTexts[3]=ComponentUtilGet.Text(self.transform,"content/gameCenter/jackPots/minor/txt_minor")
    self.jackPotTexts[4]=ComponentUtilGet.Text(self.transform,"content/gameCenter/jackPots/mini/txt_mini")
    self:SetJackPot()
end

function USDollarExpressMainView:SetJackPot()
    self.numTween= Tools.NumJump(1,100000,60, function
    (v)
        self.jackPotTexts[1].text=tonumber(v)
    end, function
    ()
    
    end)
end

---初始化View数据
function USDollarExpressMainView:InitPanelData(args)
	
end

---关闭界面
function USDollarExpressMainView:Close()   
    self.super.Close(self);
    self.numTween:Kill()
end

return USDollarExpressMainView

