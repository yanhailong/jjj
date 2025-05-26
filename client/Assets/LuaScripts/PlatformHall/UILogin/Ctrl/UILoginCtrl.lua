---
---Create by Administrator
---DateTime: 2025-05-23 14:52:23
---
---@class UILoginCtrl:BaseCtrl
local UILoginCtrl=Class("UILoginCtrl",BaseCtrl)
require("PlatformHall/UIHall/MVCHead")
---构造函数
function UILoginCtrl:ctor(ctrlName,param)
    self.layer=2;
    self.abName="PlatformHall/prefabs/UILogin";
    self.prefabName="UILogin"
    self.super.ctor(self,ctrlName,param);
	---@type UILoginView
	self.view = self.view
	---@type UILoginModel
	self.model = self.model
end

---初始化
function UILoginCtrl:CtrlInit(args)
	self.super.CtrlInit(self,args);
	self:InitData()
	self.model:Login()
end

function UILoginCtrl:InitData()
	self.serverInfo=nil
end

function UILoginCtrl:Close()
    self.super.Close(self);
end

---添加UI事件
function UILoginCtrl:AddUIEvent()
	self.view.btn_login.gameObject:SetActive(false)
	self.uiEventListener:AddClick(self.view.btn_login.gameObject, function
	()
		
	end)
end

---移除UI事件
function UILoginCtrl:RemoveEvent()
	self.super.RemoveEvent(self);
end

function UILoginCtrl:InitLogin(serverInfo)
	look("收到服务器信息",serverInfo)
	self.serverInfo=serverInfo.data
	self.view.btn_login.gameObject:SetActive(true)
	
end
function UILoginCtrl:CreateSocket()
	local uri=self.serverInfo.gameserver
	logError("uri:"..uri)
end

function UILoginCtrl:ReqLogin()

end


---销毁UI
function UILoginCtrl:RealCloseDestroy()
	self.super.RealCloseDestroy(self);
end

return UILoginCtrl