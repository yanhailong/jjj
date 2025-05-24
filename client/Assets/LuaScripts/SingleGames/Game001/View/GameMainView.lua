---
---Create by Administrator
---DateTime: 2025-05-23 16:55:00
---
---@class GameMainView:BaseView
local GameMainView=Class("GameMainView",BaseView)

---初始化panel
function GameMainView:InitView()
	---@type GameMainCtrl
    self.ctrl=self.ctrl
	self:InitComponents()
end

---获取组件
function GameMainView:InitComponents()
    self.tmp_login=ComponentUtilGet.TextMeshProUGUI(self.transform,"content/tmp_login");
    self.btn_login=ComponentUtilGet.Button(self.transform,"content/btn_login");
end

---清空组件
function GameMainView:ClearComponents()
    self.tmp_login=nil;
    self.btn_login=nil;
end

---初始化View数据
function GameMainView:InitPanelData(args)
	
end

---关闭界面
function GameMainView:Close()   
    self.super.Close(self);
end

return GameMainView

