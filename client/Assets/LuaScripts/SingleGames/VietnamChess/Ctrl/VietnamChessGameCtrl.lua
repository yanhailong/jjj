---
---Create by Administrator
---DateTime: 2025-07-10 15:51:08
---
---@class VietnamChessGameCtrl:BaseCtrl
local VietnamChessGameCtrl=Class("VietnamChessGameCtrl",BaseCtrl)
local VietnamChessConfig=require("SingleGames/VietnamChess/VietnamChessConfig")
---构造函数
function VietnamChessGameCtrl:ctor(ctrlName,param)
    self.layer=2;
    self.abName="SingleGames/VietnamChess/prefabs/VietnamChessGamePanel";
    self.prefabName="VietnamChessGamePanel"
    self.super.ctor(self,ctrlName,param);
	---@type VietnamChessGameView
	self.view = self.view
	---@type VietnamChessGameModel
	self.model = self.model
end

---初始化
function VietnamChessGameCtrl:CtrlInit(args)
	self.super.CtrlInit(self,args);
	self:InitData()
end

---初始化数据
function VietnamChessGameCtrl:InitData()
	
end

function VietnamChessGameCtrl:Close()
    self.super.Close(self);
end

---添加UI事件
function VietnamChessGameCtrl:AddUIEvent()
	self.uiEventListener:AddClick(self.view.btn_close,function()
		self:Close()
	end)
	self.uiEventListener:AddClick(self.view.btn_help,function()
		CtrlManager.SingleShow(CtrlNames.VietnamChessRule)
	end)
	self.uiEventListener:AddClick(self.view.btn_setting,function()
		look("打开设置界面")
	end)
	self.uiEventListener:AddClick(self.view.btn_nav,function()
		self.view:NavRoleView()
	end)
	---压注按钮
	for i=1,#self.view.chipInfos do
		self.uiEventListener:AddClick(self.view.chipInfos[i].obj,function()
			if VietnamChessConfig.allow then
				self.view:ChangeDiZhu(i)
				look("btn 抵住数值"..VietnamChessConfig.dizhuNumArr[VietnamChessConfig.dizhuIndex])
				---测试数据生成 龙虎和 对应前三个币
				GlobalEvent.Notify("UPDATE_HIS_ITEMS",i)
			end
		end)
	end
	---下注区域
	for i=1,self.view.clickRect.childCount do
		self.uiEventListener:AddClick(self.view.clickRect:GetChild(i-1),function()
			self:OnClickCenterYaZhuSide(i)
		end)
	end

	self.uiEventListener:AddClick(self.view.btn_players,function(obj)
		CtrlManager.SingleShow(CtrlNames.DragonTigerFightPlayerRank)
	end)
	self.uiEventListener:AddClick(self.view.btn_1,function()
		self:Test()
		
		VietnamChessConfig.sideColor = {Tools.RandomInt(0,1),Tools.RandomInt(0,1),Tools.RandomInt(0,1),Tools.RandomInt(0,1)}
		--显示路信息
		GlobalEvent.Notify("UPDATE_HIS_ITEMS")
	end)
	self.uiEventListener:AddClick(self.view.btn_muen,function()
		self.view:SettingFade()
	end)
	self.uiEventListener:AddClick(self.view.btn_touch,function()
		self.view:SettingFade()
	end)
	self.uiEventListener:AddClick(self.view.btn_repeat,function()
		if #VietnamChessConfig.lastXiaZhuInfo>0 and VietnamChessConfig.isRepeat == false then
			VietnamChessConfig.isRepeat=true
			for i=1,#VietnamChessConfig.lastXiaZhuInfo do
				if VietnamChessConfig.allow == false or VietnamChessConfig.currStatus ~= 1 or VietnamChessConfig.dizhuNumArr[VietnamChessConfig.lastXiaZhuInfo[i].index]>VietnamChessConfig.goldRealNum then
					break
				end
				self:XiaZhu(VietnamChessConfig.lastXiaZhuInfo[i])
				self.view:PayXiaZhuCoinFly(VietnamChessConfig.lastXiaZhuInfo[i].side)
			end
			self.view.btn_repeat.interactable = false
		end
	end)
end

---移除UI事件
function VietnamChessGameCtrl:RemoveEvent()
	self.super.RemoveEvent(self);
end

--region UI事件方法
---模拟测试游戏流程 
---准备阶段 3s→下注阶段 14s→结算阶段 11s→准备阶段
function VietnamChessGameCtrl:Test()
	self.view:InitUI()
	
	--进房间更新玩家信息
	GlobalEvent.Notify("UPDATE_PLAYER",{})

	VietnamChessConfig.allow=true
	VietnamChessConfig.currStatus=1
	VietnamChessConfig.selfXiaZhuInfo = {}
	VietnamChessConfig.isRepeat = false
	self.view:UpdateDiZhuBtnState()
	self.view:SetRepeatState(VietnamChessConfig.isRepeat)
	--复投功能
	self.view.btn_repeat.interactable = #VietnamChessConfig.lastXiaZhuInfo>0

	--准备3s 
	self.view:StartEffect(function()

		--下注
		local times= Tools.RandomInt(3,10)
		TimerManager.StartTimer(self, function
		()
			self.view:ChangeDiZhu(Tools.RandomInt(1,3))
			self:OnClickCenterYaZhuSide(Tools.RandomInt(1,6))
		end, 0.2, times, true)
		--其他玩家下注消息
		TimerManager.StartTimer(self, function
		()
			GlobalEvent.Notify("XIAZHU",{})
		end, 0.1, times*2, true)
		--下注结束结算
		TimerManager.StartTimer(self, function
		()
			--测试数据
			VietnamChessConfig.sideColor = {Tools.RandomInt(0,1),Tools.RandomInt(0,1),Tools.RandomInt(0,1),Tools.RandomInt(0,1)}
			--结果展示
			self.view:ResultEffect()

			TimerManager.StartTimer(self, function
			()
				self:Test()
			end,6,0,false)
			
			---复投功能
			if VietnamChessConfig.isRepeat then
				VietnamChessConfig.lastXiaZhuInfo={}
			else
				VietnamChessConfig.lastXiaZhuInfo = VietnamChessConfig.selfXiaZhuInfo
			end
			VietnamChessConfig.selfXiaZhuInfo = {}
		end, VIETNAM_CHESS_GAME_TIME+0.5, 0, true)

	end)
end

---中心下注区域
function VietnamChessGameCtrl:OnClickCenterYaZhuSide(side)
	look("点击了下注节点：",side)
	if VietnamChessConfig.allow == false or VietnamChessConfig.currStatus ~= 1 or VietnamChessConfig.dizhuNumArr[VietnamChessConfig.dizhuIndex]>VietnamChessConfig.goldRealNum then
		return
	end

	local data = {side=side,index=VietnamChessConfig.dizhuIndex}
	self:XiaZhu(data)
	self.view:PayXiaZhuCoinFly(side)

	self.view:UpdateDiZhuBtnState()
	self.view:UpdateSelfGoldCount()
end

function VietnamChessGameCtrl:XiaZhu(data)
	VietnamChessConfig.selfDiZhuNums[data.side] = VietnamChessConfig.selfDiZhuNums[data.side] + VietnamChessConfig.dizhuNumArr[data.index]
	VietnamChessConfig.totalDiZhuNums[data.side] = VietnamChessConfig.totalDiZhuNums[data.side] + VietnamChessConfig.dizhuNumArr[data.index]
	VietnamChessConfig.goldRealNum = VietnamChessConfig.goldRealNum - VietnamChessConfig.dizhuNumArr[data.index]
	table.insert(VietnamChessConfig.selfXiaZhuInfo,data)
	self.view:UpdateXiaZhuLabel()
end
--endregion


---销毁UI
function VietnamChessGameCtrl:RealCloseDestroy()
	self.super.RealCloseDestroy(self);
end

return VietnamChessGameCtrl