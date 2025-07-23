---
---Create by Administrator
---DateTime: 2025-06-30 16:37:31
---
---@class UICommonSelectionView:BaseView
local UICommonSelectionView=Class("UICommonSelectionView",BaseView)

---初始化panel
function UICommonSelectionView:InitView()
	---@type UICommonSelectionCtrl
    self.ctrl=self.ctrl
	self:InitComponents()
end

---获取组件
function UICommonSelectionView:InitComponents()
    self.btn_close=ComponentUtilGet.Button(self.transform,"content/btn_close");
end

---清空组件
function UICommonSelectionView:ClearComponents()
    self.btn_close=nil;
end

---初始化View数据
function UICommonSelectionView:InitPanelData(args)
	
end

---关闭界面
function UICommonSelectionView:Close()   
    self.super.Close(self);
end

return UICommonSelectionView

