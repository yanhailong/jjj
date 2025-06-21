---
---Create by Administrator
---DateTime: 2025-05-24 09:23:06
---
---@class UIHallModel:BaseModel
local UIHallModel=Class("UIHallModel",BaseModel)

function UIHallModel:Awake()
	self.super.Awake(self);
	---@type UIHallCtrl
	self.ctrl=self.ctrl
end

function UIHallModel:Close()
    self.super.Close(self);
end

function UIHallModel:AddEvent()
	WebNetEvent.AddListener(pb_PlatformHall.ResChooseGame,self.ResChooseGame,self)
end
function UIHallModel:RemoveEvent()

end

--region 事件方法
---@param gameType
function UIHallModel:ReqEnterGame(gameType)
	local data = {}
	data.gameType = gameType;
	WebNetworkManager.SendMsg(pb_PlatformHall.ReqChooseGame,data)
end


function UIHallModel:ResChooseGame(msg)
	look("收到进入游戏返回",msg)
	if msg.code==200 then
		require(GameConfig[GameNames.USDollarExpress].Manager)
		CtrlManager.SingleShow(CtrlNames.USDollarExpressSelect,msg)
	end
	 


end
--endregion


return UIHallModel