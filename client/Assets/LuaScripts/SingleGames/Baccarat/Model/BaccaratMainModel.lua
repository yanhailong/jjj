---
---Create by Administrator
---DateTime: 2025-07-08 17:28:05
---
---@class BaccaratMainModel:BaseModel
local BaccaratMainModel=Class("BaccaratMainModel",BaseModel)

function BaccaratMainModel:Awake()
	self.super.Awake(self);
	---@type BaccaratMainCtrl
	self.ctrl=self.ctrl
end

function BaccaratMainModel:Close()
    self.super.Close(self);
	WebNetEvent.RemoveAllTo(self)
end

function BaccaratMainModel:AddEvent()
	WebNetEvent.AddListener(pb_comonFight.RespBaccaratTableSummaryList, self.RespBaccaratTableSummaryList, self)
	WebNetEvent.AddListener(pb_comonFight.NotifyBaccaratTableSummary, self.NotifyBaccaratTableSummary, self)
	WebNetEvent.AddListener(pb_comonFight.RespJoinRoomInGame, self.RespJoinRoomInGame, self)
	WebNetEvent.AddListener(pb_comonFight.RespBaccaratTableInfo, self.RespBaccaratTableInfo, self)
end

function BaccaratMainModel:RemoveEvent()
	
end

---请求进入到百家乐大厅（大厅协议）
function BaccaratMainModel:ReqBaccaratTableSummaryList(wareId)
	local data={}
	data.wareId=wareId;
	look("请求进入到百家乐大厅",data)
	WebNetworkManager.SendMsg(pb_comonFight.ReqBaccaratTableSummaryList,data)
end
---返回进入到百家乐大厅
function BaccaratMainModel:RespBaccaratTableSummaryList(data)
	if data.code == 200 then
		look("返回进入到百家乐大厅",data)
		self.ctrl:InitSelectModel(data)
	else
		look("返回进入到百家乐大厅失败，错误码是",data.code)
	end
 
end
---请求百家乐游戏进入下一个阶段（大厅协议）
function BaccaratMainModel:ReqBaccaratTableSummary(roomId,roundId)
	local data={}
	data.roomId=roomId;
	data.roundId=roundId;
	look("请求百家乐游戏进入下一个阶段",data)
	WebNetworkManager.SendMsg(pb_comonFight.ReqBaccaratTableSummary,data)
end
---通知百家乐游戏进入下一个阶段
function BaccaratMainModel:NotifyBaccaratTableSummary(data)
	look("通知百家乐游戏进入下一个阶段",data)
	self.ctrl:RefreshSelectModel(data)
end
---请求进入百家乐房间
---@param roomId 房间ID
---@param gameType 游戏类型
---@param wareId 场次ID
function BaccaratMainModel:ReqJoinRoomInGame(roomId,gameType,wareId)
	local data={}
	data.roomId=roomId;
	data.gameType=gameType;
	data.wareId=wareId;
	look("请求进入百家乐房间",data)
	WebNetworkManager.SendMsg(pb_comonFight.ReqJoinRoomInGame,data)
end
---进入百家类房间返回
function BaccaratMainModel:RespJoinRoomInGame(msg)
	if (msg.code == 200) then
		look("进入百家类房间返回成功")
		self:ReqBaccaratTableInfo()
	else
		look("进入百家类房间返回失败，错误码是",msg.code)
	end
end

---请求百家乐房间数据
function BaccaratMainModel:ReqBaccaratTableInfo()
	look("请求百家乐房间数据")
	WebNetworkManager.SendMsg(pb_comonFight.ReqBaccaratTableInfo)
end
---返回百家乐房间数据
function BaccaratMainModel:RespBaccaratTableInfo(msg)
	if(msg.code == 200) then
		look("返回百家乐房间数据",msg)
		CtrlManager.SingleShow(CtrlNames.BaccaratGame,msg)
		self.ctrl:Close()
	else
		look("返回百家乐房间数据失败",msg.code)
	end
end

--region 事件方法

--endregion


return BaccaratMainModel