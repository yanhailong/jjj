---
---Create by Administrator
---DateTime: 2025-06-21 16:49:45
---
---@class UITestScrollCtrl:BaseCtrl
local UITestScrollCtrl=Class("UITestScrollCtrl",BaseCtrl)
---@type UITestScrollItem
local UITestScrollItem=require("PlatformHall/UITestScroll/Ctrl/UITestScrollItem")

---构造函数
function UITestScrollCtrl:ctor(ctrlName,param)
    self.layer=2;
    self.abName="PlatformHall/UIHall/Prefabs/UITestScroll";
    self.prefabName="UITestScroll"
    self.super.ctor(self,ctrlName,param);
	---@type UITestScrollView
	self.view = self.view
	---@type UITestScrollModel
	self.model = self.model
end

---初始化
function UITestScrollCtrl:CtrlInit(args)
	self.super.CtrlInit(self,args);
	self:InitData()
end




---初始化数据
function UITestScrollCtrl:InitData()
	local data={
		{name="10"},
		{name="20"},
		{name="30"},
		{name="1"},
		{name="5"},
		{name="6"},
		{name="7"},
		{name="8"},
		{name="9"},
		{name="10"},
		{name="11"},
	}
	---@type SimpleScroll
	self.udy_awardmeri=SimpleScroll.New()
	self.udy_awardmeri:Init(self.view.udy_test,Handler(self,self.InitItem))
	self.udy_awardmeri:InitData(data)
end

function UITestScrollCtrl:InitItem(go)
	local item=UITestScrollItem.New(go)
	return item
end


function UITestScrollCtrl:Close()
    self.super.Close(self);
end

---添加UI事件
function UITestScrollCtrl:AddUIEvent()

end

---移除UI事件
function UITestScrollCtrl:RemoveEvent()
	self.super.RemoveEvent(self);
end

--region UI事件方法

--endregion


---销毁UI
function UITestScrollCtrl:RealCloseDestroy()
	self.super.RealCloseDestroy(self);
end

return UITestScrollCtrl