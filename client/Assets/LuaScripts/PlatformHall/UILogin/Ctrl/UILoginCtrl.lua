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
    self.abName="PlatformHall/UILogin/Prefabs/UILogin";
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
	
	---@type ObjectPoolUtil
	self.pool=ObjectPoolUtil.New(self.ctrlName)
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
		SuspensionTipsUtil.SuspensionTips("请求登录！")
		self:ReqLogin()
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
	self:CreateSocket()
	
end
function UILoginCtrl:CreateSocket()
	local uri=self.serverInfo.gameserver
	log("uri:"..uri)
	WebNetworkManager.CreateWebSocket(uri)
end

---请求登录
function UILoginCtrl:ReqLogin()
	local reqLogin = {}
	reqLogin.token = self.serverInfo.token
	WebNetworkManager.SendMsg(MsgId.ReqLogin, reqLogin)
end

---销毁UI
function UILoginCtrl:RealCloseDestroy()
	self.super.RealCloseDestroy(self);
end

return UILoginCtrl