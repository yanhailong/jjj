---
---Create by Administrator
---DateTime: 2025-05-23 14:52:23
---
---@class UILoginModel:BaseModel
local UILoginModel=Class("UILoginModel",BaseModel)

function UILoginModel:Awake()
	self.super.Awake(self);
	---@type UILoginCtrl
	self.ctrl=self.ctrl
end

function UILoginModel:Close()
    self.super.Close(self);
end

function UILoginModel:AddEvent()
	GlobalEvent.AddListener(WebNetworkConnectEvent.connectSuccess,self.OnConnectSuccess,self)
	GlobalEvent.AddListener(WebNetworkConnectEvent.connectFailed,self.connectFailed,self)
	WebNetEvent.AddListener(MsgId.ResLogin, self.ResLogin, self)
end

function UILoginModel:RemoveEvent()
	GlobalEvent.Remove(WebNetworkConnectEvent.connectSuccess,self.OnConnectSuccess,self)
	GlobalEvent.Remove(WebNetworkConnectEvent.connectFailed,self.connectFailed,self)
	WebNetEvent.Remove(MsgId.ResLogin, self.ResLogin, self)
end

	
--region 事件方法
function UILoginModel:Login()
	local deviceId = LocalData:GetJsonByKey("jjqdeviceId")
	if deviceId=="" then
		deviceId=Util.GetTimeStamp(true)
	end
	LocalData:Save("jjqdeviceId",deviceId)
	local data = {}
	data.guest = deviceId;
	local reqData = jsonEncode(data);
	
	HttpManager.SendHttpPost(HttpApi.Guestlogin, reqData, function(args)
		if args=="FailPost" then
			logError("网络错误")
			return
		end
		local qdata = jsonDecode(args)
		if qdata then
			if qdata.code == 200 then
				self.ctrl:InitLogin(qdata)
			else
				logError("服务器错误：code"..qdata.code)
			end
		end
	end)
end

function UILoginModel:OnConnectSuccess()
	logError("链接服务器成功！")
end

function UILoginModel:connectFailed()
	logError("服务器关闭")
end

function UILoginModel:ResLogin(msg)
	look("登录成功",msg)
	CtrlManager.SingleShow(CtrlNames.UIHall)
end

return UILoginModel