---
---Create by Administrator
---DateTime: 2025-06-26 17:12:30
---
---@class PlayerRankModel:BaseModel
local PlayerRankModel=Class("PlayerRankModel",BaseModel)

function PlayerRankModel:Awake()
	self.super.Awake(self);
	---@type PlayerRankCtrl
	self.ctrl=self.ctrl
end

function PlayerRankModel:Close()
    self.super.Close(self);
end

function PlayerRankModel:AddEvent()
	GlobalEvent.AddListener("RECT_RANK_INFO",self.ResRankInfo,self)
end

function PlayerRankModel:RemoveEvent()
	GlobalEvent.Remove("RECT_RANK_INFO",self.ResRankInfo,self)
end

--region 事件方法

function PlayerRankModel:ResRankInfo()
	---测试数据
	local rankData = {}
	for i=1,50 do
		table.insert(rankData,{rank=i,succeed=Tools.RandomInt(1,15),xiazhu=Tools.RandomInt(1,10000),
		game=Tools.RandomInt(1,50),name="name_"..i,coin=Tools.RandomInt(100,54564),
		vip=Tools.RandomInt(1,15),head=Tools.RandomInt(1,5)})
	end
	self.ctrl.view:UpdateData(rankData)
end

--endregion


return PlayerRankModel