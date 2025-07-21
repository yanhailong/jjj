---
---Create by Administrator
---DateTime: 2025-07-21 16:36:00
---
---@class UIGMCtrl:BaseCtrl
local UIGMCtrl=Class("UIGMCtrl",BaseCtrl)

---构造函数
function UIGMCtrl:ctor(ctrlName,param)
    self.layer=5;
    self.abName="PlatformHall/UIHall/Prefabs/UIGM";
    self.prefabName="UIGM"
    self.super.ctor(self,ctrlName,param);
	---@type UIGMView
	self.view = self.view
	---@type UIGMModel
	self.model = self.model
end

---初始化
function UIGMCtrl:CtrlInit(args)
	self.super.CtrlInit(self,args);
	self:InitData()
end

---初始化数据
function UIGMCtrl:InitData()
	
end

function UIGMCtrl:Close()
    self.super.Close(self);
end

---添加UI事件
function UIGMCtrl:AddUIEvent()
	self.uiEventListener:AddClick(self.view.btn_send, function
	()
		local str=self.view.ipt_gmcode.text
		if str~="" then
			self.model:ReqGm(str)
		else
			SuspensionTipsUtil.SuspensionTips("请输入GM码!")
		end
	end)
	
	self.isShow=false
	self.uiEventListener:AddClick(self.view.btn_gmshow, function
	()
		self.isShow= not self.isShow
		self.view.obj_isShow:SetActive(self.isShow)
	end)
end

---移除UI事件
function UIGMCtrl:RemoveEvent()
	self.super.RemoveEvent(self);
end

--region UI事件方法

--endregion


---销毁UI
function UIGMCtrl:RealCloseDestroy()
	self.super.RealCloseDestroy(self);
end

return UIGMCtrl