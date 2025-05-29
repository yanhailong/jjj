---
---Create by Administrator
---DateTime: 2025-05-24 09:23:06
---
---@class UIHallCtrl:BaseCtrl
local UIHallCtrl=Class("UIHallCtrl",BaseCtrl)
require("SingleGames/Game001/MVCHead")
require("SingleGames/Game002/MVCHead")


---构造函数
function UIHallCtrl:ctor(ctrlName,param)
    self.layer=2;
    self.abName="PlatformHall/UIHall/Prefabs/UIHall";
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

	self.pool=ObjectPoolUtil.New(self.ctrlName)
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
	end)
	self.uiEventListener:AddDrag(self.view.btn_close.gameObject, function
	(args)
		---@type UnityEngine.EventSystems.PointerEventData
		local args=args
		local vew=Vector3(args.position.x,args.position.y,0)
		local worldPos= Tools.GetUICamera():ScreenToWorldPoint(vew)
		self.view.btn_close.gameObject.transform.position=worldPos
	end)
	self.uiEventListener:AddEndDrag(self.view.btn_close.gameObject, function
	(args)
		---@type UnityEngine.EventSystems.PointerEventData
		local args=args
		local vew=Vector3(args.position.x,args.position.y,0)
		
		look("Tools.GetUICamera():",Tools.GetUICamera())
		local worldPos= Tools.GetUICamera():ScreenToWorldPoint(vew)
		self.view.btn_close.gameObject.transform.position=worldPos
	end)
	
	self.uiEventListener:AddClick(self.view.btn_game001, function
	()
		CtrlManager.SingleShow(CtrlNames.GameMain)
	end)
	self.uiEventListener:AddClick(self.view.btn_game002, function
	()
		CtrlManager.SingleShow(CtrlNames.Game002Main)
	end)


	self.view.tmp_sy.text=LocalManager.GetStrById(10001)

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