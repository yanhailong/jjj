---
---Create by Administrator
---DateTime: 2025-07-23 15:35:06
---
---@class USDollarExpressMapMainCtrl:BaseCtrl
local USDollarExpressMapMainCtrl=Class("USDollarExpressMapMainCtrl",BaseCtrl)

---构造函数
function USDollarExpressMapMainCtrl:ctor(ctrlName,param)
    self.layer=2;
    self.abName="SingleGames/USDollarExpress/prefabs/USDollarExpressMapMain";
    self.prefabName="USDollarExpressMapMain"
    self.super.ctor(self,ctrlName,param);
	---@type USDollarExpressMapMainView
	self.view = self.view
	---@type USDollarExpressMapMainModel
	self.model = self.model
end

---初始化
function USDollarExpressMapMainCtrl:CtrlInit(args)
	self.super.CtrlInit(self,args);
	self:InitData()
	self.USDollarExpresszhuanchang=ComponentUtilGet.GameObject(self.view.transform,"USDollarExpresszhuanchang")
	self.USDollarExpresszhuanchang:SetActive(true)
	self.canvasGroup=ComponentUtilGet.CanvasGroup(self.view.transform,"USDollarExpresszhuanchang")
	self.objspine=ComponentUtilGet.GameObject(self.USDollarExpresszhuanchang.transform,"eff_zhuanchang/SkeletonGraphic (guochang)")
	CorManager.StartCor(self, function
	()
		coroutine.wait(1.5)
		self.objspine:SetActive(false)
		self.canvasGroup:DOFade(0,1).onComplete= function()
			self.USDollarExpresszhuanchang:SetActive(false)
			self.canvasGroup.alpha=1
			self.objspine:SetActive(true)
		end
	end)
	self.choosableAreas=args
	look("投资小游戏区域数据",self.choosableAreas)
	for i = 1, #self.choosableAreas do
		local id=self.choosableAreas[i]
		self.view.maps[id].obj:SetActive(true)
	end

end

function USDollarExpressMapMainCtrl:InitAreas()
	
end


---初始化数据
function USDollarExpressMapMainCtrl:InitData()
	
end

function USDollarExpressMapMainCtrl:Close()
    self.super.Close(self);
	CorManager.StopAll(self)
end

---添加UI事件
function USDollarExpressMapMainCtrl:AddUIEvent()
	for i = 1, 8 do
		self.uiEventListener:AddClick(self.view.maps[i].obj, function
		()
			CorManager.StartCor(self, function
			()
				self.view.maps[i].objSelect:SetActive(true)
				coroutine.wait(1)
				CtrlManager.SingleShow(CtrlNames.USDollarExpressMapSelect,i)
			end)
		end)
	end
end

---移除UI事件
function USDollarExpressMapMainCtrl:RemoveEvent()
	self.super.RemoveEvent(self);
end

--region UI事件方法

--endregion


---销毁UI
function USDollarExpressMapMainCtrl:RealCloseDestroy()
	self.super.RealCloseDestroy(self);
	CorManager.StopAll(self)
end

return USDollarExpressMapMainCtrl