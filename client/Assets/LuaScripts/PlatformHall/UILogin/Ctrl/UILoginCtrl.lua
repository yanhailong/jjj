---
---Create by Administrator
---DateTime: 2025-05-23 14:52:23
---
---@class UILoginCtrl:BaseCtrl
local UILoginCtrl=Class("UILoginCtrl",BaseCtrl)
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
		--SuspensionTipsUtil.SuspensionTips("暂未开放！")
	--	Camera mainCamera = Camera.main;
	--
	--	// 将视口坐标(0,0.5,0)转换为世界坐标
	--// x=0表示屏幕最左侧，y=0.5表示垂直居中
	--Vector3 spawnPosition = mainCamera.ViewportToWorldPoint(new Vector3(0, 0.5f, 0));
	--
	--// 调整x坐标，减去物体的宽度/2(假设物体中心是锚点)
	--// 如果你知道物体宽度，可以直接减去宽度
	--spawnPosition.x -= objectToSpawn.GetComponent<SpriteRenderer>().bounds.extents.x;
	--
	--// 确保z坐标为0(2D空间)
	--spawnPosition.z = 0;
	--
	--// 实例化物体
	--Instantiate(objectToSpawn, spawnPosition, Quaternion.identity);
		
		look("CS.UnityEngine.Screen.width",CS.UnityEngine.Screen.width)
		local spawPos=CS.UnityEngine.Screen.width/2
		local rectTrans=ComponentUtilGet.RectTransform(self.view.obj_test.transform)
		local pos =rectTrans.rect.width/2+spawPos
		logError("需要实例化的位"..pos)
		---@type UnityEngine.GameObject
		local obj= Tools.Instance(self.view.obj_test,self.view.obj_test.transform.parent)
		obj:SetActive(true)
		local rect=ComponentUtilGet.RectTransform(obj.transform)
		rect.anchoredPosition=Vector2(-pos,0)
		
		
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