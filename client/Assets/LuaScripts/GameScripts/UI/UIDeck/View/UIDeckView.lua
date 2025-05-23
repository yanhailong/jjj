---
---Create by Administrator
---DateTime: 2025-05-07 16:45:54
---
---@class UIDeckView:BaseView
local UIDeckView=Class("UIDeckView",BaseView)

---初始化panel
function UIDeckView:InitView()
	---@type UIDeckCtrl
    self.ctrl=self.ctrl
	self:InitComponents()
end

---获取组件
function UIDeckView:InitComponents()
    self.img_drag = ComponentUtilGet.Image(self.transform,"content/drag_root/img_drag");
    self.trans_tile_root = ComponentUtilGet.Transform(self.transform,"content/trans_tile_root");

end

---清空组件
function UIDeckView:ClearComponents()
    self.img_drag=nil;
    self.trans_tile_root = nil;
end

---初始化View数据
function UIDeckView:InitPanelData(args)
	
end

---关闭界面
function UIDeckView:Close()   
    self.super.Close(self);
end

return UIDeckView

