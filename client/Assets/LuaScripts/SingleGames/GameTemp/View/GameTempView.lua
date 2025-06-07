---
---Create by Administrator
---DateTime: 2025-06-06 17:07:38
---
---@class GameTempView:BaseView
local GameTempView=Class("GameTempView",BaseView)

---初始化panel
function GameTempView:InitView()
	---@type GameTempCtrl
    self.ctrl=self.ctrl
	self:InitComponents()
    self:InitWheelRoot()
end

---获取组件
function GameTempView:InitComponents()
    self.trans_slots=ComponentUtilGet.Transform(self.transform,"content/gameCenter/slotsMain/wheelRoot/trans_slots");
    self.btn_start=ComponentUtilGet.Button(self.transform,"content/buttom/btn_start");
    self.btn_close=ComponentUtilGet.Button(self.transform,"content/top/btn_clsoe");
end

function GameTempView:InitWheelRoot()
    self.wheelRootList={}
    for i = 1, 5 do
        self.wheelRootList[i]=ComponentUtilGet.Transform(self.transform,"content/gameCenter/slotsMain/wheelRoot/trans_slots/slotColumn"..i)
    end
    
    self.cardPrefab=self.transform:Find("content/gameCenter/item").gameObject
    self.cardPrefab:SetActive(false)
end



---清空组件
function GameTempView:ClearComponents()
    self.trans_slots=nil;
    self.btn_start=nil;
    self.btn_close=nil;
end

---初始化View数据
function GameTempView:InitPanelData(args)
	
end

---关闭界面
function GameTempView:Close()   
    self.super.Close(self);
end

return GameTempView

