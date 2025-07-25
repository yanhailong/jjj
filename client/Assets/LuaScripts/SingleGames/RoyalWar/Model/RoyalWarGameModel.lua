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
	WebNetEvent.AddListener(pb_RoyalWar.NotifyPlayerBet, self.NotifyPlayerBet, self)
	WebNetEvent.AddListener(pb_RoyalWar.RespTablePlayerInfo, self.RespTablePlayerInfo, self)
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
		self.ctrl:NotifyRedBlackWarInfo(msg);
	end
end
---通知红黑大战VS（开始下一局）
function RoyalWarGameModel:NotifyRoomReadyWait()
	if(msg.code == 200) then
		look("通知红黑大战VS（开始下一局）")
	end
end

---红黑大战开始下注通知
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
---@param betData 下注列表
function RoyalWarGameModel:ReqBet(betData)
	local data ={}
	data.reqBetBeans = betData;
	look("请求红黑大战的押注",data)
	WebNetworkManager.SendMsg(pb_RoyalWar.ReqBet,data)
end

---推送下注信息
function RoyalWarGameModel:NotifyPlayerBet(data)
	if(data.code == 200) then
		look("推送下注信息成功",data)
		self.ctrl:PlayerBet(data)
	else
		look("推送下注信息失败",data.code)
	end
end

---请求红黑大战的玩家列表信息
function RoyalWarGameModel:ReqTablePlayerInfo()
	look("请求百家乐房间的玩家列表信息")
	WebNetworkManager.SendMsg(pb_RoyalWar.ReqTablePlayerInfo)
end
---返回红黑大战房间的玩家列表信息
function RoyalWarGameModel:RespTablePlayerInfo(data)
	if(data.code == 200) then
		look("返回红黑大战房间的玩家列表信息成功")
		require("Logic/Common/PlayerRankPanel/MVCHead")
		CtrlManager.SingleShow(CtrlNames.PlayerRankPanel,data.tablePlayerInfo)
	end
end
--region 事件方法

--endregion


return RoyalWarGameModel