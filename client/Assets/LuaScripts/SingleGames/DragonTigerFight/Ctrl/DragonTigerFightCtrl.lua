---
---Create by Administrator
---DateTime: 2025-06-21 15:09:13
---
---@class DragonTigerFightCtrl:BaseCtrl
local DragonTigerFightCtrl=Class("DragonTigerFightCtrl",BaseCtrl)
---@type DragonTigerFightConfig
local config=require("SingleGames/DragonTigerFight/DragonTigerFightConfig")
require("SingleGames/DragonTigerFight/PokerConfig")

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
				config.dizhuIndex = i
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
		GlobalEvent.Notify("UPDATE_PLAYER",{})
		TimerManager.StartTimer(self, function
		()
			GlobalEvent.Notify("XIAZHU",{})
		end, 0.2, 30, true)
	end)
	self.uiEventListener:AddClick(self.view.btn_players,function(obj)
		CtrlManager.SingleShow(CtrlNames.DragonTigerFightPlayerRank)
		---测试
		GlobalEvent.Notify("XIAZHU_END",{})
	end)
	self.uiEventListener:AddClick(self.view.btn_2,function()
		self.view:ResultEffect({
			{Tools.RandomInt(1,4),Tools.RandomInt(1,13)},
			{Tools.RandomInt(1,4),Tools.RandomInt(1,13)}
		})
	end)
	self.uiEventListener:AddClick(self.view.btn_muen,function()
		self.view:SettingFade()
	end)
	self.uiEventListener:AddClick(self.view.btn_touch,function()
		self.view:SettingFade()
	end)
	
end

---中心下注区域
function DragonTigerFightCtrl:OnClickCenterYaZhuSide(obj)
	look("点击了下注节点：",obj)

	if obj.name == self.view.longClickArea.name then
		look("下注了龙:",config.dizhuNumArr[config.dizhuIndex])
		self:XiaZhu(1)
		self.view:PayXiaZhuCoinFly(1)
	end
	if obj.name == self.view.huClickArea.name then
		look("下注了虎:",config.dizhuNumArr[config.dizhuIndex])
		self:XiaZhu(2)
		self.view:PayXiaZhuCoinFly(2)
	end
	if obj.name == self.view.heClickArea.name then
		look("下注了和:",config.dizhuNumArr[config.dizhuIndex])
		self:XiaZhu(3)
		self.view:PayXiaZhuCoinFly(3)
	end
end

function DragonTigerFightCtrl:XiaZhu(index)
	config.selfDiZhuNums[index] = config.selfDiZhuNums[index] + config.dizhuNumArr[config.dizhuIndex]
	config.totalDiZhuNums[index] = config.totalDiZhuNums[index] + config.dizhuNumArr[config.dizhuIndex]
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