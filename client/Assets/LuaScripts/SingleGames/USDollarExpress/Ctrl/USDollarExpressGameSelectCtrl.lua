---
---Create by Administrator
---DateTime: 2025-07-04 13:37:43
---
---@class USDollarExpressGameSelectCtrl:BaseCtrl
local USDollarExpressGameSelectCtrl=Class("USDollarExpressGameSelectCtrl",BaseCtrl)

---构造函数
function USDollarExpressGameSelectCtrl:ctor(ctrlName,param)
    self.layer=2;
    self.abName="SingleGames/USDollarExpress/prefabs/USDollarExpressGameSelect";
    self.prefabName="USDollarExpressGameSelect"
    self.super.ctor(self,ctrlName,param);
	---@type USDollarExpressGameSelectView
	self.view = self.view
	---@type USDollarExpressGameSelectModel
	self.model = self.model
end

---初始化
function USDollarExpressGameSelectCtrl:CtrlInit(args)
	self.super.CtrlInit(self,args);
	self:InitData()
	self:InitAnimator()
end

---获取动画相关
function USDollarExpressGameSelectCtrl:InitAnimator()
	self.stateAnimator = ComponentUtilGet.Animator(self.view.transform,"content")
	self.stateAnimator.gameObject:SetActive(true)
	CorManager.StartCor(self, function
	()
		coroutine.wait(0.5)
		self.stateAnimator:Play("USDollarExpressGameSelect_chuchang_idle")
	end)

end

---初始化数据
function USDollarExpressGameSelectCtrl:InitData()
	
end

function USDollarExpressGameSelectCtrl:Close()
    self.super.Close(self);
end

---添加UI事件
function USDollarExpressGameSelectCtrl:AddUIEvent()
	self.uiEventListener:AddClick(self.view.btn_SelectTrain, function
	()
		CorManager.StartCor(self, function
		()
			self.stateAnimator:Play("USDollarExpressGameSelect_chuchang_xuanzuo")
			coroutine.wait(0.6)
			self.model:ReqChooseFreeModel(3)
		end)
	end)
	self.uiEventListener:AddClick(self.view.btn_SelectFree, function
	()
		CorManager.StartCor(self, function
		()
			self.stateAnimator:Play("USDollarExpressGameSelect_chuchang_xuanyou")
			coroutine.wait(0.6)
			self.model:ReqChooseFreeModel(5)
		end)
	end)
end

---移除UI事件
function USDollarExpressGameSelectCtrl:RemoveEvent()
	self.super.RemoveEvent(self);
end

--region UI事件方法

--endregion


---销毁UI
function USDollarExpressGameSelectCtrl:RealCloseDestroy()
	self.super.RealCloseDestroy(self);
end

return USDollarExpressGameSelectCtrl