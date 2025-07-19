---
---Create by Administrator
---DateTime: 2025-07-18 17:14:55
---
---@class FishPrawnCrabPlayersModel:BaseModel
local FishPrawnCrabPlayersModel=Class("FishPrawnCrabPlayersModel",BaseModel)
local FishPrawnCrabConfig = require("SingleGames/FishPrawnCrab/FishPrawnCrabConfig")

function FishPrawnCrabPlayersModel:Awake()
	self.super.Awake(self);
	---@type FishPrawnCrabPlayersCtrl
	self.ctrl=self.ctrl
end

function FishPrawnCrabPlayersModel:Close()
    self.super.Close(self);
end

function FishPrawnCrabPlayersModel:AddEvent()
	GlobalEvent.AddListener(FishPrawnCrabConfig.GameEventName.RES_RANKLIST,self.ResRankInfo,self)
end

function FishPrawnCrabPlayersModel:RemoveEvent()
	GlobalEvent.Remove(FishPrawnCrabConfig.GameEventName.RES_RANKLIST,self.ResRankInfo,self)
end

--region 事件方法
function FishPrawnCrabPlayersModel:ResRankInfo(playerData)
	---测试数据
	--local rankData = {}
	--for i=1,50 do
	--	table.insert(rankData,
	--			{rank=i,succeed=Tools.RandomInt(1,15),xiazhu=Tools.RandomInt(1,10000),
	--			 game=Tools.RandomInt(1,50),name="name_"..i,coin=Tools.RandomInt(100,54564),
	--			 vip=Tools.RandomInt(1,15),head=Tools.RandomInt(1,5)})
	--end
	table.sort(playerData, function(a, b)
		return a.coin > b.coin
	end)
	for i = 1, #playerData do
		playerData[i].rank = i
	end
	self.ctrl.view:UpdateData(playerData)
end

--endregion


return FishPrawnCrabPlayersModel