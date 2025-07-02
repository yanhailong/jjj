---
---Create by Administrator
---DateTime: 2025-07-02 08:53:42
---
---@class CarLogoPlayersModel:BaseModel
local CarLogoPlayersModel=Class("CarLogoPlayersModel",BaseModel)

function CarLogoPlayersModel:Awake()
	self.super.Awake(self);
	---@type CarLogoPlayersCtrl
	self.ctrl=self.ctrl
end

function CarLogoPlayersModel:Close()
    self.super.Close(self);
end

function CarLogoPlayersModel:AddEvent()
	GlobalEvent.AddListener("RECT_CARLOGO_PLAYER",self.ResRankInfo,self)
end

function CarLogoPlayersModel:RemoveEvent()
	GlobalEvent.Remove("RECT_CARLOGO_PLAYER",self.ResRankInfo,self)
end

--region 事件方法
function CarLogoPlayersModel:ResRankInfo()
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


return CarLogoPlayersModel