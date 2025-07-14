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
end

function BaccaratMainModel:AddEvent()
	WebNetEvent.AddListener(pb_Baccarat.RespBaccaratTableSummaryList, self.RespBaccaratTableSummaryList, self)
	WebNetEvent.AddListener(pb_Baccarat.RespBaccaratTableSummary, self.ResBaccaratTableSummary, self)
end

function BaccaratMainModel:RemoveEvent()

end

---请求进入到百家乐大厅（大厅协议）
function BaccaratMainModel:ReqBaccaratTableSummaryList(wareId)
	local data={}
	data.wareId=wareId;
	look("请求进入到百家乐大厅",data)
	WebNetworkManager.SendMsg(pb_Baccarat.ReqBaccaratTableSummaryList,data)
end
---返回进入到百家乐大厅
function BaccaratMainModel:ResBaccaratTableSummaryList(data)
	look("返回进入到百家乐大厅",data)
	self.ctrl:InitSelectModel(data)
end
---请求百家乐游戏进入下一个阶段（大厅协议）
function BaccaratMainModel:ReqBaccaratTableSummary(roomId,roundId)
	local data={}
	data.roomId=roomId;
	data.roundId=roundId;
	look("请求百家乐游戏进入下一个阶段",data)
	WebNetworkManager.SendMsg(pb_Baccarat.ReqBaccaratTableSummary,data)
end
---响应百家乐游戏进入下一个阶段
function BaccaratMainModel:ResBaccaratTableSummary(data)
	look("请求百家乐游戏进入下一个阶段",data)
	self.ctrl:RefreshSelectModel(data)
end

--region 事件方法

--endregion


return BaccaratMainModel