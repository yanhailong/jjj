---
---Create by Administrator
---DateTime: 2025-05-29 13:45:59
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
    self.tmp_gameName=ComponentUtilGet.TextMeshProUGUI(self.transform,"content/tmp_gameName");
    self.btn_close=ComponentUtilGet.Button(self.transform,"content/btn_close");
end

---清空组件
function GameMainView:ClearComponents()
    self.tmp_gameName=nil;
    self.btn_close=nil;
end

---初始化View数据
function GameMainView:InitPanelData(args)
	
end

---关闭界面
function GameMainView:Close()   
    self.super.Close(self);
end

return GameMainView

