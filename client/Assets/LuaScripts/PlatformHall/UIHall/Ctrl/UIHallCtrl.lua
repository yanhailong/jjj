---
---Create by Administrator
---DateTime: 2025-05-24 09:23:06
---
---@class UIHallCtrl:BaseCtrl
local UIHallCtrl=Class("UIHallCtrl",BaseCtrl)

---构造函数
function UIHallCtrl:ctor(ctrlName,param)
    self.layer=2;
    self.abName="PlatformHall/prefabs/UIHall";
    self.prefabName="UIHall"
    self.super.ctor(self,ctrlName,param);
	---@type UIHallView
	self.view = self.view
	---@type UIHallModel
	self.model = self.model
end

---初始化
function UIHallCtrl:CtrlInit(args)
	self.super.CtrlInit(self,args);
end

function UIHallCtrl:Close()
    self.super.Close(self);
end

---添加UI事件
function UIHallCtrl:AddUIEvent()
	self.uiEventListener:AddClick(self.view.btn_close,function(obj)
		look("obj",obj)
		self:Close()
	end )

	self.uiEventListener:AddLongPress(self.view.btn_close.gameObject,function(obj)
		logError("AddLongPress")
	end )
	self.uiEventListener:AddPressDown(self.view.btn_close.gameObject,function(obj)
		logError("AddPressDown")
	end )
	self.uiEventListener:AddPressUp(self.view.btn_close.gameObject,function(obj)
		logError("AddPressUp")
	end )
	
	self.uiEventListener:AddBeginDrag(self.view.btn_close.gameObject, function
	(args)
		--look("AddBeginDrag===？",args)
	end)
	self.uiEventListener:AddDrag(self.view.btn_close.gameObject, function
	(args)
		--look("AddDrag===？",args)
		-----@type UnityEngine.EventSystems.PointerEventData
		--local args=args
		--self.view.btn_close.gameObject.transform.position=args.position
	end)
	self.uiEventListener:AddEndDrag(self.view.btn_close.gameObject, function
	(args)
		---@type UnityEngine.EventSystems.PointerEventData
		local args=args
		look("args",args)

		local worldPos= Camera.main.ScreenToWorldPoint(args.position)
		look("worldPos",worldPos)
		self.view.btn_close.gameObject.transform.position=worldPos
	end)

end

---移除UI事件
function UIHallCtrl:RemoveEvent()
	self.super.RemoveEvent(self);
end

--region UI事件方法

--endregion


---销毁UI
function UIHallCtrl:RealCloseDestroy()
	self.super.RealCloseDestroy(self);
end

return UIHallCtrl