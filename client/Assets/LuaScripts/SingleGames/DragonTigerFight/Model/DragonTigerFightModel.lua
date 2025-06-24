---
---Create by Administrator
---DateTime: 2025-06-21 15:09:13
---
---@class DragonTigerFightModel:BaseModel
local DragonTigerFightModel=Class("DragonTigerFightModel",BaseModel)

local EventBinner = {
	XIAZHU = "XIAZHU",
	UPDATE_PLAYER = "UPDATE_PLAYER",
	XIAZHU_END = "XIAZHU_END",
}

function DragonTigerFightModel:Awake()
	self.super.Awake(self);
	---@type DragonTigerFightCtrl
	self.ctrl=self.ctrl

	self.players = {}
	self.allXiaZhuData = {}
end

function DragonTigerFightModel:Close()
    self.super.Close(self);
end
---网络监听
function DragonTigerFightModel:AddEvent()
	GlobalEvent.AddListener(EventBinner.XIAZHU,self.PlayerXiaZhu,self)
	GlobalEvent.AddListener(EventBinner.UPDATE_PLAYER,self.OnPlayerMsg,self)
	GlobalEvent.AddListener(EventBinner.XIAZHU_END,self.OnXiaZhuComplete,self)
end

function DragonTigerFightModel:RemoveEvent()
	GlobalEvent.Remove(EventBinner.XIAZHU,self.PlayerXiaZhu,self)
	GlobalEvent.Remove(EventBinner.UPDATE_PLAYER,self.OnPlayerMsg,self)
	GlobalEvent.Remove(EventBinner.XIAZHU_END,self.OnXiaZhuComplete,self)
end

--region 事件方法

---收到玩家下注消息
function DragonTigerFightModel:PlayerXiaZhu()
	local data  = {id=Tools.RandomInt(1,30),xiazhuNum=Tools.RandomInt(1,10),dizhuType=Tools.RandomInt(1,5),areaType=Tools.RandomInt(1,3)}
	self.allXiaZhuData[#self.allXiaZhuData+1] = data
	self.ctrl.view:PayOtherXiaZhuCoinFly(data)
end

---更新玩家信息
function DragonTigerFightModel:OnPlayerMsg()
	look("OnPlayerMsg")
	self.players = {}
	for i=1,50 do
		self.players[i] = {id=i,name="role"..i,coin=Tools.RandomInt(1,10000)}
	end
	self.ctrl.view:UpdatePlayers(self.players)
end

---下注完成结算
function DragonTigerFightModel:OnXiaZhuComplete()
	---牌面结果信息
	local cards = {Tools.RandomInt(1,13),Tools.RandomInt(1,13)}
	---显示结果动画
	---回收金币奖励动画
	self.ctrl.view:PlayCompeleCoinFLy(self.allXiaZhuData,self.players,cards)
	
	---清理下注数据
	self.allXiaZhuData = {}
end
--endregion


return DragonTigerFightModel