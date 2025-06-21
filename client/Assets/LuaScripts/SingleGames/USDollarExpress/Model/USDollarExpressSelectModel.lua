---
---Create by Administrator
---DateTime: 2025-06-21 10:15:12
---
---@class USDollarExpressSelectModel:BaseModel
local USDollarExpressSelectModel=Class("USDollarExpressSelectModel",BaseModel)
require("SingleGames/USDollarExpress/Protol/pb_USDollarExpress")

function USDollarExpressSelectModel:Awake()
	self.super.Awake(self);
	---@type USDollarExpressSelectCtrl
	self.ctrl=self.ctrl
end

function USDollarExpressSelectModel:Close()
    self.super.Close(self);
end

function USDollarExpressSelectModel:AddEvent()
	WebNetEvent.AddListener(pb_USDollarExpress.NoticeConfigInfo,self.NoticeConfigInfo,self)
end

function USDollarExpressSelectModel:RemoveEvent()
	WebNetEvent.RemoveAllTo(self)
end

--region 事件方法

function USDollarExpressSelectModel:NoticeConfigInfo(msg)
	CtrlManager.SingleShow(CtrlNames.USDollarExpressMain,msg)
end


--endregion


return USDollarExpressSelectModel