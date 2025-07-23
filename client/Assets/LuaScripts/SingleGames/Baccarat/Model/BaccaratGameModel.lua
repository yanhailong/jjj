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
	WebNetEvent.AddListener(pb_Baccarat.NotifyPlayerBet, self.NotifyPlayerBet, self)
	WebNetEvent.AddListener(pb_Baccarat.NotifyBaccaratRoundStart, self.NotifyBaccaratRoundStart, self)
	WebNetEvent.AddListener(pb_Baccarat.NotifyBaccaratSettlementInfo, self.NotifyBaccaratSettlementInfo, self)
end

function BaccaratGameModel:RemoveEvent()

end
---请求下注
---@param betData 下注列表
function BaccaratGameModel:ReqBet(betData)
	local data ={}
	data.reqBetBeans = betData;
	look("请求下注",data)
	WebNetworkManager.SendMsg(pb_Baccarat.ReqBet,data)
end
---推送下注信息
function BaccaratGameModel:NotifyPlayerBet(data)
	if(data.code == 200) then
		look("推送下注信息成功",data)
		self.ctrl:PlayerBet()
	else
		look("推送下注信息失败",data.code)
	end
end

---推送百家乐通知新的一局开始
function BaccaratGameModel:NotifyBaccaratRoundStart(data)
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

--region 事件方法

--endregion


return BaccaratGameModel