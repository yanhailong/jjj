---
---Create by Administrator
---DateTime: 2025-06-06 18:16:33
---
---@class GameTemp2View:BaseView
local GameTemp2View=Class("GameTemp2View",BaseView)

---初始化panel
function GameTemp2View:InitView()
	---@type GameTemp2Ctrl
    self.ctrl=self.ctrl
	self:InitComponents()
    self:InitWheelRoot()
end

---获取组件
function GameTemp2View:InitComponents()
    self.trans_slots=ComponentUtilGet.Transform(self.transform,"content/gameCenter/slotsMain/wheelRoot/trans_slots");
    self.img_icon=ComponentUtilGet.Image(self.transform,"content/gameCenter/item/img_icon");
    self.tmp_name=ComponentUtilGet.TextMeshProUGUI(self.transform,"content/gameCenter/item/tmp_name");
    self.btn_start=ComponentUtilGet.Button(self.transform,"content/buttom/btn_start");
    self.btn_close=ComponentUtilGet.Button(self.transform,"content/top/btn_close");
end

function GameTemp2View:InitWheelRoot()
    self.wheelRootList={}
    for i = 1, 5 do
        self.wheelRootList[i]=ComponentUtilGet.Transform(self.transform,"content/gameCenter/slotsMain/wheelRoot/trans_slots/slotColumn"..i)
    end

    self.cardPrefab=self.transform:Find("content/gameCenter/item").gameObject
    self.cardPrefab:SetActive(false)
end

---清空组件
function GameTemp2View:ClearComponents()
    self.trans_slots=nil;
    self.img_icon=nil;
    self.tmp_name=nil;
    self.btn_start=nil;
    self.btn_close=nil
end

---初始化View数据
function GameTemp2View:InitPanelData(args)
	
end

---关闭界面
function GameTemp2View:Close()   
    self.super.Close(self);
end

return GameTemp2View

