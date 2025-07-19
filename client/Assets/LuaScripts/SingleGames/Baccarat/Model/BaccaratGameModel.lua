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
end

function BaccaratGameModel:AddEvent()

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

--region 事件方法

--endregion


return BaccaratGameModel