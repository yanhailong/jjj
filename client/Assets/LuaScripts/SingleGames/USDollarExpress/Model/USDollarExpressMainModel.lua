---
---Create by Administrator
---DateTime: 2025-06-18 10:32:48
---
---@class USDollarExpressMainModel:BaseModel
local USDollarExpressMainModel=Class("USDollarExpressMainModel",BaseModel)

function USDollarExpressMainModel:Awake()
	self.super.Awake(self);
	---@type USDollarExpressMainCtrl
	self.ctrl=self.ctrl
	self:InitCardData()
end

function USDollarExpressMainModel:Close()
    self.super.Close(self);
end

function USDollarExpressMainModel:AddEvent()
	--WebNetEvent.AddListener(pb_USDollarExpress.ResStartGame,self.ResStartGame,self)
	local str= resMgr:LoadTextAssetStr("SingleGames/USDollarExpress","slotData.txt")
	self.slotData=jsonDecode(str)
end

function USDollarExpressMainModel:RemoveEvent()
	WebNetEvent.RemoveAllTo(self)
end

function USDollarExpressMainModel:ReqStartGame(stakeVlue)
	--local data={}
	--data.stakeVlue=stakeVlue
	--WebNetworkManager.SendMsg(pb_USDollarExpress.ReqStartGame,data)
	self:ResStartGame(self.slotData)
	
end

function USDollarExpressMainModel:ResStartGame(msg)
	look("收到请求开始游戏返回",msg)
	self:InitCardPos(msg.iconList)

	self.resultLineInfoList=msg.resultLineInfoList		---中奖信息
	self.allWinGold=tonumber(msg.allWinGold) 			---累计中奖金币
	self.specialType=msg.specialType					---特殊游戏id
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



--region 事件方法
function USDollarExpressMainModel:InitCardData()
	self.CardPos={}
	for i=1,5 do
		self.CardPos[i]={}
		for j=1,4 do
			self.CardPos[i][j]=1
		end
	end
end
--endregion


return USDollarExpressMainModel