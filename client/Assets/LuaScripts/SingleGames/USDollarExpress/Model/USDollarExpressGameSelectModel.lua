---
---Create by Administrator
---DateTime: 2025-07-04 13:37:43
---
---@class USDollarExpressGameSelectModel:BaseModel
local USDollarExpressGameSelectModel=Class("USDollarExpressGameSelectModel",BaseModel)

function USDollarExpressGameSelectModel:Awake()
	self.super.Awake(self);
	---@type USDollarExpressGameSelectCtrl
	self.ctrl=self.ctrl
end

function USDollarExpressGameSelectModel:Close()
    self.super.Close(self);
end

function USDollarExpressGameSelectModel:AddEvent()
	WebNetEvent.AddListener(pb_USDollarExpress.ResChooseFreeModel,self.ResChooseFreeModel,self)
end

function USDollarExpressGameSelectModel:RemoveEvent()

end

---int32 status = 1;  //选择类型  3.普通火车  4.黄金火车   5.免费游戏
function USDollarExpressGameSelectModel:ReqChooseFreeModel(status)
	local data={}
	data.status=status
	WebNetworkManager.SendMsg(pb_USDollarExpress.ReqChooseFreeModel,data)
end

function USDollarExpressGameSelectModel:ResChooseFreeModel(msg)
	look("选择类型返回信息",msg)
end


return USDollarExpressGameSelectModel