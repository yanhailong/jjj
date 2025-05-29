---
---Create by Administrator
---DateTime: 2025-05-29 13:46:04
---
---@class Game002MainView:BaseView
local Game002MainView=Class("Game002MainView",BaseView)

---初始化panel
function Game002MainView:InitView()
	---@type Game002MainCtrl
    self.ctrl=self.ctrl
	self:InitComponents()
end

---获取组件
function Game002MainView:InitComponents()
    self.tmp_gameName=ComponentUtilGet.TextMeshProUGUI(self.transform,"content/tmp_gameName");
    self.btn_close=ComponentUtilGet.Button(self.transform,"content/btn_close");
end

---清空组件
function Game002MainView:ClearComponents()
    self.tmp_gameName=nil;
    self.btn_close=nil;
end

---初始化View数据
function Game002MainView:InitPanelData(args)
	
end

---关闭界面
function Game002MainView:Close()   
    self.super.Close(self);
end

return Game002MainView

