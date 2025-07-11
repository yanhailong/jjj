---
---Create by Administrator
---DateTime: 2025-07-10 15:51:08
---
---@class VietnamChessGameModel:BaseModel
local VietnamChessGameModel=Class("VietnamChessGameModel",BaseModel)
local VietnamChessConfig=require("SingleGames/VietnamChess/VietnamChessConfig")

local EventBinner = {
	XIAZHU = "XIAZHU",
	UPDATE_PLAYER = "UPDATE_PLAYER",
	XIAZHU_END = "XIAZHU_END",
	UPDATE_HIS_ITEMS = "UPDATE_HIS_ITEMS",
}

function VietnamChessGameModel:Awake()
	self.super.Awake(self);
	---@type VietnamChessGameCtrl
	self.ctrl=self.ctrl

	self.players = {}
	self.allXiaZhuData = {}
end

function VietnamChessGameModel:Close()
    self.super.Close(self);
end

function VietnamChessGameModel:AddEvent()
	GlobalEvent.AddListener(EventBinner.XIAZHU,self.PlayerXiaZhu,self)
	GlobalEvent.AddListener(EventBinner.UPDATE_PLAYER,self.OnPlayerMsg,self)
	GlobalEvent.AddListener(EventBinner.XIAZHU_END,self.OnXiaZhuComplete,self)
	GlobalEvent.AddListener(EventBinner.UPDATE_HIS_ITEMS,self.UpdateHistoryRecord,self)
end

function VietnamChessGameModel:RemoveEvent()
	GlobalEvent.Remove(EventBinner.XIAZHU,self.PlayerXiaZhu,self)
	GlobalEvent.Remove(EventBinner.UPDATE_PLAYER,self.OnPlayerMsg,self)
	GlobalEvent.Remove(EventBinner.XIAZHU_END,self.OnXiaZhuComplete,self)
	GlobalEvent.Remove(EventBinner.UPDATE_HIS_ITEMS,self.UpdateHistoryRecord,self)
end

--region 事件方法
---收到玩家下注消息
function VietnamChessGameModel:PlayerXiaZhu()
	local data  = {id=Tools.RandomInt(1,30),dizhuType=Tools.RandomInt(1,5),areaType=Tools.RandomInt(1,3)}
	VietnamChessConfig.allXiaZhuData[#VietnamChessConfig.allXiaZhuData+1] = data
	VietnamChessConfig.totalDiZhuNums[data.areaType] = VietnamChessConfig.totalDiZhuNums[data.areaType]+VietnamChessConfig.dizhuNumArr[data.dizhuType]

	self.ctrl.view:PayOtherXiaZhuCoinFly(data)
end

---更新玩家信息
function VietnamChessGameModel:OnPlayerMsg()
	look("OnPlayerMsg")
	self.players = {}
	for i=1,50 do
		self.players[i] = {id=i,name="role"..i,coin=Tools.RandomInt(1,10000)}
	end
	self.ctrl.view:UpdatePlayers(self.players)
end

---下注完成结算
function VietnamChessGameModel:OnXiaZhuComplete()
	---牌面结果信息
	local cards = {Tools.RandomInt(1,13),Tools.RandomInt(1,13)}
	---显示结果动画
	---回收金币奖励动画
	self.ctrl.view:PlayCompeleCoinFLy(VietnamChessConfig.allXiaZhuData,self.players,cards)

	---清理下注数据
	VietnamChessConfig.allXiaZhuData = {}
end

---更新历史信息
function VietnamChessGameModel:UpdateHistoryRecord()
	--测试数据
	
	if self.game_his_items == nil then
		self.game_his_items = {}
	end
	if #self.game_his_items >=30 then
		self.game_his_items = {}
	end
	table.insert(self.game_his_items,VietnamChessConfig.sideColor)
	self.ctrl.view:UpdateRoleView(self.game_his_items)
	
end
--endregion


return VietnamChessGameModel