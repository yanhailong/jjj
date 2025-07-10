---
---Create by Administrator
---DateTime: 2025-06-21 15:09:13
---
---@class DragonTigerFightCtrl:BaseCtrl
local DragonTigerFightCtrl=Class("DragonTigerFightCtrl",BaseCtrl)
---@type DragonTigerFightConfig
local config=require("SingleGames/DragonTigerFight/DragonTigerFightConfig")

---构造函数
function DragonTigerFightCtrl:ctor(ctrlName,param)
    self.layer=2;
    self.abName="SingleGames/DragonTigerFight/prefabs/DragonTigerFight";
    self.prefabName="DragonTigerFight"
    self.super.ctor(self,ctrlName,param);
	---@type DragonTigerFightView
	self.view = self.view
	---@type DragonTigerFightModel
	self.model = self.model
end

---初始化
function DragonTigerFightCtrl:CtrlInit(args)
	self.super.CtrlInit(self,args);
	self:InitData()
	self:InitChipINof()
end

---初始化数据
function DragonTigerFightCtrl:InitData()

end


function DragonTigerFightCtrl:Close()
    self.super.Close(self);
end


---添加UI事件
function DragonTigerFightCtrl:AddUIEvent()
	--ObjectPoolUtil:SpawnPrefab()
	self.uiEventListener:AddClick(self.view.btn_close,function()
		self:Close()
	end)
	self.uiEventListener:AddClick(self.view.btn_help,function()
		CtrlManager.SingleShow(CtrlNames.DragonTigerFightRule)
	end)
	self.uiEventListener:AddClick(self.view.btn_setting,function()
		look("打开设置界面")
	end)
	---压注按钮
	for i=1,#self.view.chipInfos do
		self.uiEventListener:AddClick(self.view.chipInfos[i].obj,function()
			if config.allow then
				self.view:ChangeDiZhu(i)
				look("btn 抵住数值"..config.dizhuNumArr[config.dizhuIndex])
				---测试数据生成 龙虎和 对应前三个币
				GlobalEvent.Notify("UPDATE_HIS_ITEMS",i)
			end
		end)
	end
	---下注区域
	self.uiEventListener:AddClick(self.view.longClickArea,function(obj)
		self:OnClickCenterYaZhuSide(obj)
	end)
	self.uiEventListener:AddClick(self.view.huClickArea,function(obj)
		self:OnClickCenterYaZhuSide(obj)
	end)
	self.uiEventListener:AddClick(self.view.heClickArea,function(obj)
		self:OnClickCenterYaZhuSide(obj)
	end)

	self.uiEventListener:AddClick(self.view.btn_1,function(obj)
		---测试
		--GlobalEvent.Notify("UPDATE_PLAYER",{})
		--TimerManager.StartTimer(self, function
		--()
		--	GlobalEvent.Notify("XIAZHU",{})
		--end, 0.2, 30, true)
		self:TestAreaCoin()
	end)
	self.uiEventListener:AddClick(self.view.btn_players,function(obj)
		CtrlManager.SingleShow(CtrlNames.DragonTigerFightPlayerRank)
		---测试
		GlobalEvent.Notify("XIAZHU_END",{})
	end)
	self.uiEventListener:AddClick(self.view.btn_2,function()
		self:Test()
	end)
	self.uiEventListener:AddClick(self.view.btn_muen,function()
		self.view:SettingFade()
	end)
	self.uiEventListener:AddClick(self.view.btn_touch,function()
		self.view:SettingFade()
	end)
	self.uiEventListener:AddClick(self.view.btn_repeat,function()
		if #config.lastXiaZhuInfo>0 and config.isRepeat == false then
			config.isRepeat=true
			for i=1,#config.lastXiaZhuInfo do
				if config.allow == false or config.currStatus ~= 1 or config.dizhuNumArr[config.lastXiaZhuInfo[i].index]>config.goldRealNum then
					break
				end
				self:XiaZhu(config.lastXiaZhuInfo[i])
				self.view:PayXiaZhuCoinFly(config.lastXiaZhuInfo[i].side)
			end
			self.view.btn_repeat.interactable = false
		end
	end)

end

---测试显示区域底注
function DragonTigerFightCtrl:TestAreaCoin()
	for i=1,30 do
		local data  = {id=Tools.RandomInt(1,30),dizhuType=Tools.RandomInt(1,5),areaType=Tools.RandomInt(1,3)}
		config.allXiaZhuData[#config.allXiaZhuData+1] = data
		config.totalDiZhuNums[data.areaType] = config.totalDiZhuNums[data.areaType]+config.dizhuNumArr[data.dizhuType]
	end
	self.view:RefresAreaCoin()
end
---模拟测试游戏流程
function DragonTigerFightCtrl:Test()
	self.view:InitUI()
	
	local areas = {self.view.longClickArea,self.view.huClickArea,self.view.heClickArea}
	--进房间更新玩家信息
	GlobalEvent.Notify("UPDATE_PLAYER",{})
	
	config.allow=true
	config.currStatus=1
	config.selfXiaZhuInfo = {}
	--config.isRepeat = false
	self.view:UpdateDiZhuBtnState()
	self.view:SetRepeatState(config.isRepeat)
	--复投功能
	self.view.btn_repeat.interactable = #config.lastXiaZhuInfo>0
	
	--准备
	self.view:StartEffect(function()
		
		--下注
		local times= Tools.RandomInt(3,10)
		TimerManager.StartTimer(self, function
		()
			self.view:ChangeDiZhu(Tools.RandomInt(1,3))
			self:OnClickCenterYaZhuSide(areas[Tools.RandomInt(1,3)])
		end, 0.2, times, true)
		--其他玩家下注消息
		TimerManager.StartTimer(self, function
		()
			GlobalEvent.Notify("XIAZHU",{})
		end, 0.1, times*2, true)
		--下注结束结算
		TimerManager.StartTimer(self, function
		()
			self.view:ResultEffect({
				Tools.RandomInt(0,3)*13+Tools.RandomInt(1,13),
				Tools.RandomInt(0,3)*13+Tools.RandomInt(1,13)
			},function()
				--显示路信息
				GlobalEvent.Notify("UPDATE_HIS_ITEMS")

				self:Test()
			end)
			
			TimerManager.StartTimer(self, function
			()
				---回收
				GlobalEvent.Notify("XIAZHU_END",{})	
			end,6,0,false)

			---复投功能
			if config.isRepeat then
				config.lastXiaZhuInfo={}
			else
				config.lastXiaZhuInfo = config.selfXiaZhuInfo
			end
			config.selfXiaZhuInfo = {}
		end, DRAGON_TIGER_FIGHT_GAME_TIME+0.5, 0, true)
		
	end)
end

---中心下注区域
function DragonTigerFightCtrl:OnClickCenterYaZhuSide(obj)
	look("点击了下注节点：",obj)
	if config.allow == false or config.currStatus ~= 1 or config.dizhuNumArr[config.dizhuIndex]>config.goldRealNum then
		return
	end
	local side = 0
	if obj.name == self.view.longClickArea.name then
		look("下注了龙:",config.dizhuNumArr[config.dizhuIndex])
		side = 1
	end
	if obj.name == self.view.huClickArea.name then
		look("下注了虎:",config.dizhuNumArr[config.dizhuIndex])
		side = 2
	end
	if obj.name == self.view.heClickArea.name then
		look("下注了和:",config.dizhuNumArr[config.dizhuIndex])
		side = 3
	end

	if side then
		local data = {side=side,index=config.dizhuIndex}
		self:XiaZhu(data)
		self.view:PayXiaZhuCoinFly(side)
	end
	
	self.view:UpdateDiZhuBtnState()
	self.view:UpdateSelfGoldCount()
end

function DragonTigerFightCtrl:XiaZhu(data)
	config.selfDiZhuNums[data.side] = config.selfDiZhuNums[data.side] + config.dizhuNumArr[data.index]
	config.totalDiZhuNums[data.side] = config.totalDiZhuNums[data.side] + config.dizhuNumArr[data.index]
	config.goldRealNum = config.goldRealNum - config.dizhuNumArr[data.index]
	table.insert(config.selfXiaZhuInfo,data)
	self.view:UpdateXiaZhuLabel()
end
---
function DragonTigerFightCtrl:InitChipINof()
	
end


---移除UI事件
function DragonTigerFightCtrl:RemoveEvent()
	self.super.RemoveEvent(self);
end

--region UI事件方法

--endregion


---销毁UI
function DragonTigerFightCtrl:RealCloseDestroy()
	self.super.RealCloseDestroy(self);
end

return DragonTigerFightCtrl