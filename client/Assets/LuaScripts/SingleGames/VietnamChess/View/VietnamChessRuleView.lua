---
---Create by Administrator
---DateTime: 2025-07-10 15:47:34
---
---@class VietnamChessRuleView:BaseView
local VietnamChessRuleView=Class("VietnamChessRuleView",BaseView)

---初始化panel
function VietnamChessRuleView:InitView()
	---@type VietnamChessRuleCtrl
    self.ctrl=self.ctrl
	self:InitComponents()
end

---获取组件
function VietnamChessRuleView:InitComponents()
    self.img_title=ComponentUtilGet.Image(self.transform,"content/BackGround/img_title");
    self.btn_close=ComponentUtilGet.Button(self.transform,"content/BackGround/btn_close");
end

---清空组件
function VietnamChessRuleView:ClearComponents()
    self.img_title=nil;
    self.btn_close=nil;
end

---初始化View数据
function VietnamChessRuleView:InitPanelData(args)
	
end

---关闭界面
function VietnamChessRuleView:Close()   
    self.super.Close(self);
end

return VietnamChessRuleView

