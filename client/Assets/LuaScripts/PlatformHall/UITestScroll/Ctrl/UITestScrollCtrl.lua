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
	}
	for i = 1, 100 do
		local data1={name=i .. ""}
		data[i]=data1
	end
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
	self.uiEventListener:AddClick(self.view.test, function
	()
		self.udy_awardmeri:ScrollToIndex(50,0,DG.Tweening.Ease.Linear)
		CorManager.StartCor(self, function
		()
			coroutine.wait(0.5)
			self.udy_awardmeri:ScrollToIndex(4,3,DG.Tweening.Ease.Linear)---111
			coroutine.wait(3)
			self.udy_awardmeri:ScrollToIndex(0,1,DG.Tweening.Ease.OutQuart)
		end)
	end)
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