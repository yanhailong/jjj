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

function USDollarExpressMainModel:ReqStartGame(_dataSpin)
	--if _dataSpin then
	--	self.dataSpin=_dataSpin
	--end
	--if self.dataSpin then
	--	look("点击按钮传入事件",self.dataSpin)
	--	if self.dataSpin.isAuto==true then
	--		config.selfMotionNum=self.dataSpin.autoNum
	--	end
	--end
	--
	--local data={}
	--data.stakeVlue=self.dataSpin.betInfo
	--WebNetworkManager.SendMsg(pb_USDollarExpress.ReqStartGame,data)
	
	self:ResStartGame({})
end

function USDollarExpressMainModel:RollStop()
	self.ctrl:StopRollState()
end

function USDollarExpressMainModel:NoticeStopAuto()
	config.selfMotionNum=0
end

function USDollarExpressMainModel:ResStartGame(msg)
	look("收到请求开始游戏返回",msg)

	msg={
		["trainInfoList"] =
		{
		},
		["code"] = 200,
		["dollarsInfo"] =
		{
			["goldTrainCount"] = 6,
			["dollarValueList"] =
			{
				[1] = 1640,
				[2] = 1640,
				[3] = 1640,
				[4] = 1640,
				[5] = 1640,
				[6] = 1640,
				[7] = 1640,
				[8] = 1640,
				[9] = 1640,
				[10] = 1640,
				[11] = 1640,
				[12] = 1640,
			},
			["coinIndexId"] = 0,
			["dollarIndexIds"] =
			{
				[1] = 1,
				[2] = 2,
				[3] = 3,
				[4] = 4,
				[5] = 5,
				[6] = 6,
				[7] = 7,
				[8] = 8,
				[9] = 9,
				[10] = 12,
				[11] = 13,
				[12] = 16,
			},
		},
		["iconList"] =
		{
			[1] = 18,
			[2] = 18,
			[3] = 18,
			[4] = 18,
			[5] = 18,
			[6] = 18,
			[7] = 18,
			[8] = 18,
			[9] = 18,
			[10] = 3,
			[11] = 3,
			[12] = 18,
			[13] = 18,
			[14] = 1,
			[15] = 8,
			[16] = 18,
			[17] = 15,
			[18] = 4,
			[19] = 6,
			[20] = 6,
		},
		["status"] = 4,
		["allWinGold"] = 118080,
		["totalDollars"] = 0,
		["remainFreeCount"] = 0,
		["resultLineInfoList"] =
		{
		},
	}
	
	
	self:InitCardPos(msg.iconList)

	self.resultLineInfoList=msg.resultLineInfoList		---中奖信息
	self.allWinGold=tonumber(msg.allWinGold) 			---累计中奖金币
	self.status=msg.status					---//当前状态 0.正常  1.普通二选一  2.黄金列车二选一  3.二选一之拉普通火车  4.二选一之拉黄金火车  5.二选一之免费模式
	self.freeCount=msg.freeCount						---免费次数
	self.goldTrainInFree=msg.goldTrainInFree			---免费游戏中是否触发了金火车
	self.trainInfoList=msg.trainInfoList				---火车模式数据
	self.remainFreeCount=msg.remainFreeCount

	local dollarsInfo={}
	self.isHasDollars=false
	if msg.dollarsInfo then
		self.isHasDollars=true
		local dollarValueList= msg.dollarsInfo.dollarValueList
		local dollarIndexIds= msg.dollarsInfo.dollarIndexIds
		for i=1,#dollarIndexIds do
			local id=dollarIndexIds[i]
			dollarsInfo[id]=dollarValueList[i]
		end
		self:InitDollars(dollarsInfo)
	end
	look("self.dollarsInfo",self.dollarsInfo)
	
	
	
	

	self.ctrl:OnStartDoSpin()
	
	---

	--if self.status==0 then
	--	config.gameTypeState=0
	--	self.ctrl:OnStartDoSpin()--0.正常
	--end
	--if self.status==1 then--1.普通二选一
	--	config.gameTypeState=1
	--	self.ctrl:OnStartDoSpin()--还是要先转动一次
	--end
	--if self.status==2 then--2.黄金列车二选一
	--	config.gameTypeState=2
	--	self.ctrl:OnStartDoSpin()
	--end
	--if self.status==3 then--3.二选一之拉普通火车
	--	config.gameTypeState=3
	--	self.ctrl:OnStartDoSpin()
	--end
	--if self.status==4 then--4.二选一之拉黄金火车
	--	config.gameTypeState=4
	--	self.ctrl:OnStartDoSpin()
	--end
	--if self.status==5 then--5.二选一之免费模式
	--	config.gameTypeState=5
	--	self.ctrl:OnStartDoSpin()
	--end
end

---初始化卡牌位置
function USDollarExpressMainModel:InitCardPos(pos)
	self.CardPos={}
	local rows, cols = 4, 5

	-- 先遍历列，再遍历行（但仍然填充到行优先结构）
	for i = 1, cols do
		self.CardPos[i] = {}
		for j = 1, rows do
			local index = (i-1)*rows + j  -- 计算原始索引
			self.CardPos[i][j] = pos[index]  -- 填充到行优先结构
		end
	end
	
	look("处理后的数据",self.CardPos)

end

function USDollarExpressMainModel:InitDollars(dollarsInfo)
	local rows, cols = 4, 5
	self.dollarsInfo={}
	-- 先遍历列，再遍历行（但仍然填充到行优先结构）
	for i = 1, cols do
		self.dollarsInfo[i] = {}
		for j = 1, rows do
			local index = (i-1)*rows + j  -- 计算原始索引
			local dv= dollarsInfo[index]
			if dv and dv>0 then
				self.dollarsInfo[i][j]=dv
			end
		end
	end
end

---位置转坐标
function USDollarExpressMainModel:IndexToPos(index)
	
end

function USDollarExpressMainModel:ResConfigInfo(betInfos)
	self.ctrl:ResConfigInfo(betInfos)
end

function USDollarExpressMainModel:ReqConfigInfo()
	WebNetworkManager.SendMsg(pb_USDollarExpress.ReqConfigInfo)
end


return USDollarExpressMainModel