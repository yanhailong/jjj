---
---Create by Administrator
---DateTime: 2025-07-02 18:28:37
---
---@class BirdsAnimalsGameCtrl:BaseCtrl
local BirdsAnimalsGameCtrl=Class("BirdsAnimalsGameCtrl",BaseCtrl)
local BirdsAnimalsConfig =require("SingleGames/BirdsAnimals/BirdsAnimalsConfig")

---构造函数
function BirdsAnimalsGameCtrl:ctor(ctrlName,param)
    self.layer=2;
    self.abName="SingleGames/BirdsAnimals/prefabs/BirdsAnimalsGamePanel";
    self.prefabName="BirdsAnimalsGamePanel"
    self.super.ctor(self,ctrlName,param);
	---@type BirdsAnimalsGameView
	self.view = self.view
	---@type BirdsAnimalsGameModel
	self.model = self.model
end

---初始化
function BirdsAnimalsGameCtrl:CtrlInit(args)
	self.super.CtrlInit(self,args);
	self:InitData()
end

---初始化数据
function BirdsAnimalsGameCtrl:InitData()
	
end

function BirdsAnimalsGameCtrl:Close()
    self.super.Close(self);
end

---添加UI事件
function BirdsAnimalsGameCtrl:AddUIEvent()
	self.uiEventListener:AddClick(self.view.btn_close,function()
		self:Close()
	end)
	self.uiEventListener:AddClick(self.view.btn_help,function()
		CtrlManager.SingleShow(CtrlNames.BirdsAnimalsRule)
	end)
	self.uiEventListener:AddClick(self.view.btn_setting,function()
		look("打开设置界面")
	end)

	self.uiEventListener:AddClick(self.view.btn_trend,function()
		CtrlManager.SingleShow(CtrlNames.BirdsAnimalsTrend)
	end)

	self.uiEventListener:AddClick(self.view.btn_1,function()
		--测试
		self:Test()

	end)
	---压注按钮
	for i=1,#self.view.chipInfos do
		self.uiEventListener:AddClick(self.view.chipInfos[i].button,function()
			if BirdsAnimalsConfig.allow then
				self.view:ChangeDiZhu(i)
				look("btn 抵住数值".. BirdsAnimalsConfig.dizhuNumArr[BirdsAnimalsConfig.dizhuIndex])
				---测试数据生成 龙虎和 对应前三个币
			end
		end)
	end
	---下注区域点击
	for i=1,self.view.areasTrs.childCount do
		self.uiEventListener:AddClick(self.view.areasTrs:GetChild(i-1),function(obj)
			self:OnClickCenterYaZhuSide(i)
		end)
	end

	self.uiEventListener:AddClick(self.view.btn_players,function(obj)
		CtrlManager.SingleShow(CtrlNames.BirdsAnimalsPlayers,{})
	end)
	self.uiEventListener:AddClick(self.view.btn_muen,function()
		self.view:SettingFade()
	end)
	self.uiEventListener:AddClick(self.view.btn_touch,function()
		self.view:SettingFade()
	end)
	self.uiEventListener:AddClick(self.view.btn_repeat,function()
		if #BirdsAnimalsConfig.lastXiaZhuInfo>0 and BirdsAnimalsConfig.isRepeat == false then
			BirdsAnimalsConfig.isRepeat=true
			for i=1,#BirdsAnimalsConfig.lastXiaZhuInfo do
				if BirdsAnimalsConfig.allow == false or BirdsAnimalsConfig.currStatus ~= 1 or BirdsAnimalsConfig.dizhuNumArr[BirdsAnimalsConfig.lastXiaZhuInfo[i].index]> BirdsAnimalsConfig.goldRealNum then
					break
				end
				self:XiaZhu(BirdsAnimalsConfig.lastXiaZhuInfo[i])
				self.view:PayXiaZhuCoinFly(BirdsAnimalsConfig.lastXiaZhuInfo[i].side)
			end
			self.view.btn_repeat.interactable = false
		end
	end)
end

---移除UI事件
function BirdsAnimalsGameCtrl:RemoveEvent()
	self.super.RemoveEvent(self);
end

--region UI事件方法
function BirdsAnimalsGameCtrl:OnClickCenterYaZhuSide(side)
	look("点击了区域：",side)
	if side then
		local data = {side=side,index=BirdsAnimalsConfig.dizhuIndex}
		self:XiaZhu(data)
		self.view:PayXiaZhuCoinFly(side)
	end

	self.view:UpdateDiZhuBtnState()
	self.view:UpdateSelfGoldCount()
end

function BirdsAnimalsGameCtrl:XiaZhu(data)
	BirdsAnimalsConfig.selfDiZhuNums[data.side] = BirdsAnimalsConfig.selfDiZhuNums[data.side] + BirdsAnimalsConfig.dizhuNumArr[data.index]
	BirdsAnimalsConfig.totalDiZhuNums[data.side] = BirdsAnimalsConfig.totalDiZhuNums[data.side] + BirdsAnimalsConfig.dizhuNumArr[data.index]
	BirdsAnimalsConfig.goldRealNum = BirdsAnimalsConfig.goldRealNum - BirdsAnimalsConfig.dizhuNumArr[data.index]
	table.insert(BirdsAnimalsConfig.selfXiaZhuInfo,data)
	self.view:UpdateXiaZhuLabel()
end

---模拟测试游戏流程
---下注时间0秒开始，开奖时间15秒
---开奖开始的前2,秒，转轴上所有的图标都会闪光
---开奖开始的第5秒开始转轴速度逐渐变慢
---开奖开始的第7秒转轴停止，开奖动画播放
---开奖开始的第10秒开始筹码飞向赢奖玩家
function BirdsAnimalsGameCtrl:Test()
	self.view:InitUI()

	BirdsAnimalsConfig.allow=true
	BirdsAnimalsConfig.currStatus=1
	BirdsAnimalsConfig.selfXiaZhuInfo = {}
	--BirdsAnimalsConfig.isRepeat = false
	self.view:UpdateDiZhuBtnState()
	self.view:SetRepeatState(BirdsAnimalsConfig.isRepeat)
	--复投功能
	self.view.btn_repeat.interactable = #BirdsAnimalsConfig.lastXiaZhuInfo>0

	--准备
	self.view:StartEffect(function()

		--下注
		local times= Tools.RandomInt(3,5)
		TimerManager.StartTimer(self, function
		()
			self.view:ChangeDiZhu(Tools.RandomInt(1,5))
			self:OnClickCenterYaZhuSide(Tools.RandomInt(1,12))
		end, 1, 3, true)
		--其他玩家下注消息
		TimerManager.StartTimer(self, function
		()
			GlobalEvent.Notify(BirdsAnimalsConfig.EventBinner.XIAZHU,{})
		end, 0.2, times, true)
		--下注结束结算
		TimerManager.StartTimer(self, function
		()
			local logo_id=Tools.RandomInt(1,10)
			local logo_index=BirdsAnimalsConfig.LOGO_IDX[logo_id][Tools.RandomInt(1,#BirdsAnimalsConfig.LOGO_IDX[logo_id])]
			self.view:PlayResultAnimation({win_logo={logo_index=logo_index,logo_id=logo_id},last_logo={logo_index=4,logo_id=4}})

			---复投功能
			if BirdsAnimalsConfig.isRepeat then
				BirdsAnimalsConfig.lastXiaZhuInfo={}
			else
				BirdsAnimalsConfig.lastXiaZhuInfo = BirdsAnimalsConfig.selfXiaZhuInfo
			end
			BirdsAnimalsConfig.selfXiaZhuInfo = {}
		end, BIRDS_ANIMALS_GAME_TIME+2.5, 0, true)

	end)
end
--endregion


---销毁UI
function BirdsAnimalsGameCtrl:RealCloseDestroy()
	self.super.RealCloseDestroy(self);
end

return BirdsAnimalsGameCtrl