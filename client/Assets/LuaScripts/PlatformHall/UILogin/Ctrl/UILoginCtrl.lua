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
	--self.model:Login()
	
	---@type ObjectPoolUtil
	self.pool=ObjectPoolUtil.New(self.ctrlName)

	require("SingleGames/DragonTigerFight/MVCHead")
	CtrlManager.SingleShow(CtrlNames.DragonTigerFight)
end

function UILoginCtrl:InitData()
	self.serverInfo=nil
end

function UILoginCtrl:Close()
    self.super.Close(self);
end

---添加UI事件
function UILoginCtrl:AddUIEvent()
	self.uiEventListener:AddClick(self.view.btn_youke, function
	()
		self:ReqLogin()
	end)

	self.uiEventListener:AddClick(self.view.btn_google, function
	()
		SuspensionTipsUtil.SuspensionTips("暂未开放！")
	end)
	self.uiEventListener:AddClick(self.view.btn_phone, function
	()
		SuspensionTipsUtil.SuspensionTips("暂未开放！")
	end)
	
end

---移除UI事件
function UILoginCtrl:RemoveEvent()
	self.super.RemoveEvent(self);
end

function UILoginCtrl:InitLogin(serverInfo)
	look("收到服务器信息",serverInfo)
	self.serverInfo=serverInfo.data
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
	reqLogin.playerId=self.serverInfo.playerId
	WebNetworkManager.SendMsg(pb_PlatformHall.ReqLogin, reqLogin)
end

---销毁UI
function UILoginCtrl:RealCloseDestroy()
	self.super.RealCloseDestroy(self);
end

return UILoginCtrl