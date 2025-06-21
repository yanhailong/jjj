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
    self:InitChipInfo()
end

---获取组件
function USDollarExpressMainView:InitComponents()
    self.btn_close=ComponentUtilGet.Button(self.transform,"content/top/btn_close");
    self.trans_slots=ComponentUtilGet.Transform(self.transform,"content/gameCenter/slotsMain/wheelRoot/trans_slots");
    self.img_icon=ComponentUtilGet.Image(self.transform,"content/gameCenter/item/img_icon");
    self.tmp_name=ComponentUtilGet.TextMeshProUGUI(self.transform,"content/gameCenter/item/tmp_name");
    self.btn_start=ComponentUtilGet.Button(self.transform,"content/buttom/btn_start");
end

---清空组件
function USDollarExpressMainView:ClearComponents()
    self.btn_close=nil;
    self.trans_slots=nil;
    self.img_icon=nil;
    self.tmp_name=nil;
    self.btn_start=nil;
end

function USDollarExpressMainView:InitWheelRoot()
    self.wheelRootList={}
    for i = 1, 5 do
        self.wheelRootList[i]=ComponentUtilGet.Transform(self.transform,"content/gameCenter/slotsMain/wheelRoot/trans_slots/slotColumn"..i)
    end

    self.cardPrefab=self.transform:Find("content/gameCenter/item").gameObject
    self.cardPrefab:SetActive(false)
end


---:初始化ChipInfo
function USDollarExpressMainView:InitChipInfo()
    self.btn_add=ComponentUtilGet.Button(self.transform,"content/buttom/chipInfo/btn_add")
    self.btn_reduce=ComponentUtilGet.Button(self.transform,"content/buttom/chipInfo/btn_reduce")
    self.btn_max=ComponentUtilGet.Button(self.transform,"content/buttom/chipInfo/btn_max")
    self.txt_chipInfo=ComponentUtilGet.TextMeshProUGUI(self.transform,"content/buttom/chipInfo/txt_chipInfo")
end
function USDollarExpressMainView:SetChipText(num)
    self.txt_chipInfo.text=num
end

---初始化View数据
function USDollarExpressMainView:InitPanelData(args)
	
end

---关闭界面
function USDollarExpressMainView:Close()   
    self.super.Close(self);
end

return USDollarExpressMainView

