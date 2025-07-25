---
---Create by Administrator
---DateTime: 2025-06-30 16:46:28
---
---@class RoyalWarGameModel:BaseModel
local RoyalWarGameModel=Class("RoyalWarGameModel",BaseModel)

function RoyalWarGameModel:Awake()
	self.super.Awake(self);
	---@type RoyalWarGameCtrl
	self.ctrl=self.ctrl
end

function RoyalWarGameModel:Close()
    self.super.Close(self);
	WebNetEvent.RemoveAllTo(self)
end

function RoyalWarGameModel:AddEvent()
	WebNetEvent.AddListener(pb_RoyalWar.NotifyPhaseChangInfo, self.NotifyPhaseChangInfo, self)
	WebNetEvent.AddListener(pb_RoyalWar.NotifyRedBlackWarInfo, self.NotifyRedBlackWarInfo, self)
	WebNetEvent.AddListener(pb_RoyalWar.NotifyRedBlackWarSettleInfo, self.NotifyRedBlackWarSettleInfo, self)
end

function RoyalWarGameModel:RemoveEvent()

end
---请求红黑大战房间信息
function RoyalWarGameModel:ReqRoomBaseInfo()
	look("请求红黑大战房间信息")
	WebNetworkManager.SendMsg(pb_RoyalWar.ReqRoomBaseInfo)
end

---通知红黑大战桌上信息
function RoyalWarGameModel:NotifyRedBlackWarInfo(msg)
	if(msg.code == 200) then
		look("通知红黑大战桌上信息成功")
	end
end

---红黑大战阶段变化通知
function RoyalWarGameModel:NotifyPhaseChangInfo(msg)
	if(msg.code == 200) then
		look("红黑大战阶段变化通知成功")
	end
end
---通知红黑大战结算
function RoyalWarGameModel:NotifyRedBlackWarSettleInfo(msg)
	if(msg.code == 200) then
		look("通知红黑大战结算成功")
	end
end
---请求红黑大战的押注
function RoyalWarGameModel:ReqBet(bet)
	
end
--region 事件方法

--endregion


return RoyalWarGameModel