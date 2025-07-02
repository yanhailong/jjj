---
---Create by Administrator
---DateTime: 2025-06-30 15:05:04
---
---@class CarLogoGameModel:BaseModel
local CarLogoGameModel=Class("CarLogoGameModel",BaseModel)
local CarLogoConfig =require("SingleGames/CarLogo/CarLogoConfig")

--GameStatus:当前牌局状态,1=等待押注,2=押注冻结，等待开牌,3=本局结束
CarLogoGameModel.GameStatus = {
	WaitBet = 1,
	WaitResult = 2,
	GameEnd = 3,
}
--玩家列表
CarLogoGameModel.playerList = {};
--历史记录
CarLogoGameModel.historyList = {};
--状态，默认为游戏结束
CarLogoGameModel.status = CarLogoGameModel.GameStatus.GameEnd;
--上局下注信息
CarLogoGameModel.isXuYaing = false;
--续押列表
CarLogoGameModel.lastBetList = {}
-- 当前轮压注列表
CarLogoGameModel.curBetList = {}
--最低携带可玩金额
CarLogoGameModel.minBetMoney = 10;
--最大下注金额
CarLogoGameModel.maxBetMoney = 100000;
--是否需要刷新房间
CarLogoGameModel.refreshRoom = false
-- 是否播放历史动画
CarLogoGameModel.isPlayingHistory = false
-- 历史记录最大显示50条
CarLogoGameModel.HistoryListMax = 50

function CarLogoGameModel:Awake()
	self.super.Awake(self);
	---@type CarLogoGameCtrl
	self.ctrl=self.ctrl
end

function CarLogoGameModel:Close()
    self.super.Close(self);
end

function CarLogoGameModel:AddEvent()
	GlobalEvent.AddListener(CarLogoConfig.EventBinner.XIAZHU,self.PlayerXiaZhu,self)
	GlobalEvent.AddListener(CarLogoConfig.EventBinner.XIAZHU_END,self.OnXiaZhuComplete,self)
end

function CarLogoGameModel:RemoveEvent()
	GlobalEvent.Remove(CarLogoConfig.EventBinner.XIAZHU,self.PlayerXiaZhu,self)
	GlobalEvent.Remove(CarLogoConfig.EventBinner.XIAZHU_END,self.OnXiaZhuComplete,self)
end

--region 事件方法
---收到玩家下注消息
function CarLogoGameModel:PlayerXiaZhu()
	local data  = {id=Tools.RandomInt(1,30),dizhuType=Tools.RandomInt(1,5),areaType=Tools.RandomInt(1,8)}
	CarLogoConfig.allXiaZhuData[#CarLogoConfig.allXiaZhuData+1] = data
	CarLogoConfig.totalDiZhuNums[data.areaType] = CarLogoConfig.totalDiZhuNums[data.areaType]+CarLogoConfig.dizhuNumArr[data.dizhuType]

	self.ctrl.view:PayOtherXiaZhuCoinFly(data)
end

---下注完成结算
function CarLogoGameModel:OnXiaZhuComplete()
	---牌面结果信息
	local cards = {Tools.RandomInt(1,13),Tools.RandomInt(1,13)}
	---显示结果动画
	---回收金币奖励动画
	self.ctrl.view:PlayCompeleCoinFLy(CarLogoConfig.allXiaZhuData,self.players,cards)

	---清理下注数据
	CarLogoConfig.allXiaZhuData = {}
end

--endregion


return CarLogoGameModel