---
---Create by Administrator
---DateTime: 2025-07-21 16:36:00
---
---@class UIGMView:BaseView
local UIGMView=Class("UIGMView",BaseView)

---初始化panel
function UIGMView:InitView()
	---@type UIGMCtrl
    self.ctrl=self.ctrl
	self:InitComponents()
end

---获取组件
function UIGMView:InitComponents()
    self.obj_isShow=ComponentUtilGet.GameObject(self.transform,"obj_isShow");
    self.ipt_gmcode=ComponentUtilGet.InputField(self.transform,"obj_isShow/ipt_gmcode");
    self.btn_send=ComponentUtilGet.Button(self.transform,"obj_isShow/btn_send");
    self.btn_gmshow=ComponentUtilGet.Button(self.transform,"btn_gmshow");
    self.obj_isShow:SetActive(false)
end

---清空组件
function UIGMView:ClearComponents()
    self.obj_isShow=nil;
    self.ipt_gmcode=nil;
    self.btn_send=nil;
    self.btn_gmshow=nil;
end

---初始化View数据
function UIGMView:InitPanelData(args)
	
end

---关闭界面
function UIGMView:Close()   
    self.super.Close(self);
end

return UIGMView

