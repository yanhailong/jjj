---
---Create by Administrator
---DateTime: 2025-07-03 09:54:21
---
---@class BirdsAnimalsPlayersModel:BaseModel
local BirdsAnimalsPlayersModel=Class("BirdsAnimalsPlayersModel",BaseModel)

function BirdsAnimalsPlayersModel:Awake()
	self.super.Awake(self);
	---@type BirdsAnimalsPlayersCtrl
	self.ctrl=self.ctrl
end

function BirdsAnimalsPlayersModel:Close()
    self.super.Close(self);
end

function BirdsAnimalsPlayersModel:AddEvent()
	GlobalEvent.AddListener("RECT_BIRDSANIMALS_PLAYER",self.ResRankInfo,self)
end

function BirdsAnimalsPlayersModel:RemoveEvent()
	GlobalEvent.Remove("RECT_BIRDSANIMALS_PLAYER",self.ResRankInfo,self)
end

--region 事件方法
function BirdsAnimalsPlayersModel:ResRankInfo()
	---测试数据
	local rankData = {}
	for i=1,50 do
		table.insert(rankData,
				{rank=i,succeed=Tools.RandomInt(1,15),xiazhu=Tools.RandomInt(1,10000),
				 game=Tools.RandomInt(1,50),name="name_"..i,coin=Tools.RandomInt(100,54564),
				 vip=Tools.RandomInt(1,15),head=Tools.RandomInt(1,5)})
	end
	self.ctrl.view:UpdateData(rankData)
end
--endregion


return BirdsAnimalsPlayersModel