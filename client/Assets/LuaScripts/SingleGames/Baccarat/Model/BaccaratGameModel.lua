---
---Create by Administrator
---DateTime: 2025-06-21 17:21:49
---
---@class BaccaratGameModel:BaseModel
local BaccaratGameModel=Class("BaccaratGameModel",BaseModel)

function BaccaratGameModel:Awake()
	self.super.Awake(self);
	---@type BaccaratGameCtrl
	self.ctrl=self.ctrl
end

function BaccaratGameModel:Close()
    self.super.Close(self);
	WebNetEvent.RemoveAllTo(self)
end

function BaccaratGameModel:AddEvent()
	WebNetEvent.AddListener(pb_comonFight.NotifyPlayerBet, self.NotifyPlayerBet, self)
	WebNetEvent.AddListener(pb_comonFight.NotifyBaccaratBetStart, self.NotifyBaccaratBetStart, self)
	WebNetEvent.AddListener(pb_comonFight.NotifyBaccaratSettlementInfo, self.NotifyBaccaratSettlementInfo, self)
	WebNetEvent.AddListener(pb_comonFight.RespExitRoomInGame, self.RespExitRoomInGame, self)
	WebNetEvent.AddListener(pb_comonFight.RespTablePlayerInfo, self.RespTablePlayerInfo, self)
	WebNetEvent.AddListener(pb_comonFight.NotifyTableRoomPlayerInfoChange, self.NotifyTableRoomPlayerInfoChange, self)
end

function BaccaratGameModel:RemoveEvent()

end
--region 事件方法

---请求下注
---@param betData 下注列表
function BaccaratGameModel:ReqBet(betData)
	local data ={}
	data.reqBetBeans = betData;
	look("请求下注",data)
	WebNetworkManager.SendMsg(pb_comonFight.ReqBet,data)
end
---推送下注信息
function BaccaratGameModel:NotifyPlayerBet(data)
	if(data.code == 200) then
		look("推送下注信息成功",data)
		self.ctrl:PlayerBet(data)
	else
		look("推送下注信息失败",data.code)
	end
end

---推送百家乐通知新的一局开始
function BaccaratGameModel:NotifyBaccaratBetStart(data)
	look("推送百家乐通知新的一局开始",data)
	self.ctrl:NotifyBaccaratRoundStart(data);
end

---推送百家乐结算
function BaccaratGameModel:NotifyBaccaratSettlementInfo(data)
	if(data.code == 200) then
		look("推送百家乐结算",data)
		self.ctrl:NotifyBaccaratSettlementInfo(data);
	end
end
---通知押注类房间玩家信息变化
function BaccaratGameModel:NotifyTableRoomPlayerInfoChange(data)
	if(data.code == 200) then
		look("通知押注类房间玩家信息变化",data)
		self.ctrl:NotifyTableRoomPlayerInfoChange(data);
	end
end
---请求退出房间
function BaccaratGameModel:ReqExitRoomInGame()
	look("请求退出房间")
	WebNetworkManager.SendMsg(pb_comonFight.ReqExitRoomInGame)
end
---返回推出房间
function BaccaratGameModel:RespExitRoomInGame(data)
	if(data.code == 200) then
		look("返回推出房间成功")
		self.ctrl:Close();
		CtrlManager.SingleShow(CtrlNames.BaccaratMain);
	end
end
---请求百家乐房间的玩家列表信息
function BaccaratGameModel:ReqTablePlayerInfo()
	look("请求百家乐房间的玩家列表信息")
	WebNetworkManager.SendMsg(pb_comonFight.ReqTablePlayerInfo)
end
---返回百家乐房间的玩家列表信息
function BaccaratGameModel:RespTablePlayerInfo(data)
	if(data.code == 200) then
		look("返回百家乐房间的玩家列表信息成功")
		require("Logic/Common/PlayerRankPanel/MVCHead")
		CtrlManager.SingleShow(pb_comonFight.PlayerRankPanel,data.tablePlayerInfo)
	end
end

--endregion


return BaccaratGameModel