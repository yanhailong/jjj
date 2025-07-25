
---@class MahjongWaysMainView:BaseView
local MahjongWaysMainView=Class("MahjongWaysMainView",BaseView)

---初始化panel
function MahjongWaysMainView:InitView()
	---@type MahjongWaysMainCtrl
    self.ctrl=self.ctrl
	self:InitComponents()
end

---获取组件
function MahjongWaysMainView:InitComponents()
    self.obj_root=ComponentUtilGet.GameObject(self.transform,"content/obj_root");
    self.btn_Start=ComponentUtilGet.Button(self.transform,"content/obj_root/btn_Start");
    self.btn_Stop=ComponentUtilGet.Button(self.transform,"content/obj_root/btn_Stop");
end

---清空组件
function MahjongWaysMainView:ClearComponents()
    self.obj_root=nil;
    self.btn_Start=nil;
    self.btn_Stop=nil;
end

---初始化View数据
function MahjongWaysMainView:InitPanelData(args)
	
end

---关闭界面
function MahjongWaysMainView:Close()   
    self.super.Close(self);
end

return MahjongWaysMainView

