---
---Create by Administrator
---DateTime: 2025-07-09 15:11:31
---
---@class BaccaratRuleView:BaseView
local BaccaratRuleView=Class("BaccaratRuleView",BaseView)

---初始化panel
function BaccaratRuleView:InitView()
	---@type BaccaratRuleCtrl
    self.ctrl=self.ctrl
	self:InitComponents()
end

---获取组件
function BaccaratRuleView:InitComponents()
    self.btn_close=ComponentUtilGet.Button(self.transform,"content/BackGround/btn_close");
end

---清空组件
function BaccaratRuleView:ClearComponents()
    self.btn_close=nil;
end

---初始化View数据
function BaccaratRuleView:InitPanelData(args)
	
end

---关闭界面
function BaccaratRuleView:Close()   
    self.super.Close(self);
end

return BaccaratRuleView

