---
---Create by Administrator
---DateTime: 2025-07-02 18:28:37
---
---@class BirdsAnimalsGameModel:BaseModel
local BirdsAnimalsGameModel=Class("BirdsAnimalsGameModel",BaseModel)
local BirdsAnimalsConfig =require("SingleGames/BirdsAnimals/BirdsAnimalsConfig")

--GameStatus:当前牌局状态,1=等待押注,2=押注冻结，等待开牌,3=本局结束
BirdsAnimalsGameModel.GameStatus = {
	WaitBet = 1,
	WaitResult = 2,
	GameEnd = 3,
}


--玩家列表
BirdsAnimalsGameModel.playerList = {};
--历史记录
BirdsAnimalsGameModel.historyList = {};
--状态，默认为游戏结束
BirdsAnimalsGameModel.status = BirdsAnimalsGameModel.GameStatus.GameEnd;
--上局下注信息
BirdsAnimalsGameModel.isXuYaing = false;
--续押列表
BirdsAnimalsGameModel.lastBetList = {}
-- 当前轮压注列表
BirdsAnimalsGameModel.curBetList = {}
--最低携带可玩金额
BirdsAnimalsGameModel.minBetMoney = 10;
--最大连庄次数
BirdsAnimalsGameModel.maxRemainBankerTimes = 10;
--是否需要刷新房间
BirdsAnimalsGameModel.refreshRoom = false
-- 是否播放历史动画
BirdsAnimalsGameModel.isPlayingHistory = false
-- 历史记录最大显示50条
BirdsAnimalsGameModel.HistoryListMax = 50

function BirdsAnimalsGameModel:Awake()
	self.super.Awake(self);
	---@type BirdsAnimalsGameCtrl
	self.ctrl=self.ctrl
end

function BirdsAnimalsGameModel:Close()
    self.super.Close(self);
end

function BirdsAnimalsGameModel:AddEvent()
	GlobalEvent.AddListener(BirdsAnimalsConfig.EventBinner.XIAZHU,self.PlayerXiaZhu,self)
	GlobalEvent.AddListener(BirdsAnimalsConfig.EventBinner.XIAZHU_END,self.OnXiaZhuComplete,self)
end

function BirdsAnimalsGameModel:RemoveEvent()
	GlobalEvent.Remove(BirdsAnimalsConfig.EventBinner.XIAZHU,self.PlayerXiaZhu,self)
	GlobalEvent.Remove(BirdsAnimalsConfig.EventBinner.XIAZHU_END,self.OnXiaZhuComplete,self)
end

--region 事件方法
---收到玩家下注消息
function BirdsAnimalsGameModel:PlayerXiaZhu()
	local data  = {id=Tools.RandomInt(1,30),dizhuType=Tools.RandomInt(1,5),areaType=Tools.RandomInt(1,8)}
	BirdsAnimalsConfig.allXiaZhuData[#BirdsAnimalsConfig.allXiaZhuData+1] = data
	BirdsAnimalsConfig.totalDiZhuNums[data.areaType] = BirdsAnimalsConfig.totalDiZhuNums[data.areaType]+BirdsAnimalsConfig.dizhuNumArr[data.dizhuType]

	self.ctrl.view:PayOtherXiaZhuCoinFly(data)
end

---下注完成结算
function BirdsAnimalsGameModel:OnXiaZhuComplete()
	---牌面结果信息
	local cards = {Tools.RandomInt(1,13),Tools.RandomInt(1,13)}
	---显示结果动画
	---回收金币奖励动画
	self.ctrl.view:PlayCompeleCoinFLy(BirdsAnimalsConfig.allXiaZhuData,self.players,cards)

	---清理下注数据
	BirdsAnimalsConfig.allXiaZhuData = {}
end

--endregion


return BirdsAnimalsGameModel