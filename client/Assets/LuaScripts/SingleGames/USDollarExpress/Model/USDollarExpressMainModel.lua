---
---Create by Administrator
---DateTime: 2025-06-18 10:32:48
---
---@class USDollarExpressMainModel:BaseModel
local USDollarExpressMainModel=Class("USDollarExpressMainModel",BaseModel)
---@type USDollarExpressConfig
local config=require("SingleGames/USDollarExpress/USDollarExpressConfig")


function USDollarExpressMainModel:Awake()
	self.super.Awake(self);
	---@type USDollarExpressMainCtrl
	self.ctrl=self.ctrl
end

function USDollarExpressMainModel:Close()
    self.super.Close(self);
end

function USDollarExpressMainModel:AddEvent()
	WebNetEvent.AddListener(pb_USDollarExpress.ResStartGame,self.ResStartGame,self)
	GlobalEvent.AddListener(SlotGlobal.gameEventName.StartSpin,self.ReqStartGame,self)
	GlobalEvent.AddListener(SlotGlobal.gameEventName.BackHome,self.BackHome,self)
	GlobalEvent.AddListener(SlotGlobal.gameEventName.OpenHelp,self.OpenHelp,self)
	GlobalEvent.AddListener(SlotGlobal.gameEventName.NoticeStopAuto,self.NoticeStopAuto,self)
	GlobalEvent.AddListener(SlotGlobal.gameEventName.RollStop,self.RollStop,self)
	WebNetEvent.AddListener(pb_USDollarExpress.ResConfigInfo,self.ResConfigInfo,self)
end

function USDollarExpressMainModel:BackHome()
	self.ctrl:BackHome()
end
function USDollarExpressMainModel:OpenHelp()
	CtrlManager.SingleShow(CtrlNames.USDollarExpressHelp)
end

function USDollarExpressMainModel:RemoveEvent()
	WebNetEvent.RemoveAllTo(self)
	GlobalEvent.RemoveAllTo(self)
end

function USDollarExpressMainModel:ReqStartGame(dataSpin)

	local _dataSpin=dataSpin
	if _dataSpin then
		look("点击按钮传入事件",_dataSpin)
		if _dataSpin.isAuto==true then
			config.selfMotionNum=_dataSpin.autoNum
		end
	end
	
	local data={}
	data.stakeVlue=_dataSpin.betInfo
	WebNetworkManager.SendMsg(pb_USDollarExpress.ReqStartGame,data)
end

function USDollarExpressMainModel:RollStop()
	self.ctrl:StopRollState()
end

function USDollarExpressMainModel:NoticeStopAuto()
	config.selfMotionNum=0
end

function USDollarExpressMainModel:ResStartGame(msg)
	look("收到请求开始游戏返回",msg)
	self:InitCardPos(msg.iconList)

	self.resultLineInfoList=msg.resultLineInfoList		---中奖信息
	self.allWinGold=tonumber(msg.allWinGold) 			---累计中奖金币
	self.status=msg.status					---//当前状态 0.正常  1.普通二选一  2.黄金列车二选一  3.二选一之拉普通火车  4.二选一之拉黄金火车  5.二选一之免费模式
	self.freeCount=msg.freeCount						---免费次数
	self.goldTrainInFree=msg.goldTrainInFree			---免费游戏中是否触发了金火车
	self.trainInfoList=msg.trainInfoList				---火车模式数据
	if self.specialType~=-1 then
		self.ctrl:OnStartDoSpin()--普通模式
	end
end

---初始化卡牌位置
function USDollarExpressMainModel:InitCardPos(pos)
	self.CardPos={}
	local rows, cols = 4, 5

	-- 先遍历列，再遍历行（但仍然填充到行优先结构）
	for j = 1, cols do
		self.CardPos[j] = {}
		for i = 1, rows do
			local index = (i-1)*cols + j  -- 计算原始索引
			self.CardPos[j][i] = pos[index]  -- 填充到行优先结构
		end
	end
	
	look("处理后的数据",self.CardPos)

end

function USDollarExpressMainModel:ResConfigInfo(betInfos)
	self.ctrl:ResConfigInfo(betInfos)
end

function USDollarExpressMainModel:ReqConfigInfo()
	WebNetworkManager.SendMsg(pb_USDollarExpress.ReqConfigInfo)
end


return USDollarExpressMainModel