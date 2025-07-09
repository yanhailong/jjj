---
---Create by Administrator
---DateTime: 2025-07-08 17:28:05
---
---@class BaccaratMainView:BaseView
local BaccaratMainView=Class("BaccaratMainView",BaseView)

---初始化panel
function BaccaratMainView:InitView()
	---@type BaccaratMainCtrl
    self.ctrl=self.ctrl
	self:InitComponents()
end

---获取组件
function BaccaratMainView:InitComponents()
    self.btn_close=ComponentUtilGet.Button(self.transform,"content/btn_close");
    self.btn_Help=ComponentUtilGet.Button(self.transform,"content/btn_Help");
    self.obj_Content=ComponentUtilGet.GameObject(self.transform,"content/Scroll View/Viewport/obj_Content");
end

---清空组件
function BaccaratMainView:ClearComponents()
    self.btn_close=nil;
    self.btn_Help=nil;
    self.obj_Content=nil;
end

---初始化View数据
function BaccaratMainView:InitPanelData(args)
	
end

---关闭界面
function BaccaratMainView:Close()   
    self.super.Close(self);
end

return BaccaratMainView

