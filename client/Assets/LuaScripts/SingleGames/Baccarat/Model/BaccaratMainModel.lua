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
end

function BaccaratMainModel:RemoveEvent()

end

---请求进入到百家乐大厅
function BaccaratMainModel:ReqBaccaratTableSummaryList(wareId)
	pb_Baccarat.ReqBaccaratTableSummaryList(wareId);
end
---返回百家乐场次界面的数据
function BaccaratMainModel:RespBaccaratTableSummaryList(msg)
	self.ctrl:RefreshSelectModel(msg)
end

--region 事件方法

--endregion


return BaccaratMainModel