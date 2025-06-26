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
	UPDATE_HIS_ITEMS = "UPDATE_HIS_ITEMS",
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
	GlobalEvent.AddListener(EventBinner.UPDATE_HIS_ITEMS,self.UpdateHistoryRecord,self)
end

function DragonTigerFightModel:RemoveEvent()
	GlobalEvent.Remove(EventBinner.XIAZHU,self.PlayerXiaZhu,self)
	GlobalEvent.Remove(EventBinner.UPDATE_PLAYER,self.OnPlayerMsg,self)
	GlobalEvent.Remove(EventBinner.XIAZHU_END,self.OnXiaZhuComplete,self)
	GlobalEvent.Remove(EventBinner.UPDATE_HIS_ITEMS,self.UpdateHistoryRecord,self)
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

---更新历史信息
function DragonTigerFightModel:UpdateHistoryRecord(side)
	--测试数据
	--local game_his_items = {}
	--if self.total then
	--	self.total=self.total+1
	--	if self.total>100 then
	--		self.total = 60
	--		self.game_his_items = {}
	--		for i=1,self.total do
	--			table.insert(self.game_his_items,{seri_id=i,win_side=Tools.RandomInt(1,3)})
	--		end
	--	else
	--		local sade = Tools.RandomInt(1,2)
	--		for i=self.total,self.total+7 do
	--			table.insert(self.game_his_items,{seri_id=i,win_side=sade})
	--		end
	--		self.total = self.total + 7
	--	end
	--else
	--	self.total = 60
	--	self.game_his_items = {
	--		{seri_id=1,win_side=1},
	--		{seri_id=2,win_side=1},
	--		{seri_id=3,win_side=1},
	--		{seri_id=4,win_side=1},
	--		{seri_id=5,win_side=1},
	--		{seri_id=6,win_side=1},
	--		{seri_id=7,win_side=1},
	--		{seri_id=8,win_side=1},
	--		
	--	}
	--	for i=9,self.total do
	--		table.insert(self.game_his_items,{seri_id=i,win_side=Tools.RandomInt(1,3)})
	--	end
	--	
	--end
	if self.game_his_items == nil then
		self.game_his_items = {}
	end
	if #self.game_his_items >=60 then
		self.game_his_items = {}
	end
	table.insert(self.game_his_items,{seri_id=#self.game_his_items+1,win_side=side})
	self.ctrl.view:UpdateRoleView(self.game_his_items)
end

--endregion


return DragonTigerFightModel