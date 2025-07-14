---
---Create by Administrator
---DateTime: 2025-07-11 09:39:31
---
---@class FishPrawnCrabGameCtrl:BaseCtrl
local FishPrawnCrabGameCtrl=Class("FishPrawnCrabGameCtrl",BaseCtrl)
local FishPrawnCrabGameConfig = require("SingleGames/FishPrawnCrab/FishPrawnCrabGameConfig")
local Ease = CS.DG.Tweening.Ease

---构造函数
function FishPrawnCrabGameCtrl:ctor(ctrlName,param)
    self.layer=2;
    self.abName="SingleGames/FishPrawnCrab/prefabs/FishPrawnCrabGamePanel";
    self.prefabName="FishPrawnCrabGamePanel"
    self.super.ctor(self,ctrlName,param);
	---@type FishPrawnCrabGameView
	self.view = self.view
	---@type FishPrawnCrabGameModel
	self.model = self.model
end

---初始化
function FishPrawnCrabGameCtrl:CtrlInit(args)
	self.super.CtrlInit(self,args);
	self:InitData()
end

---初始化数据
function FishPrawnCrabGameCtrl:InitData()
	
end

---刷新菜单显示隐藏
function FishPrawnCrabGameCtrl:RefreshMenuShow()
	if self.view.btn_touch.gameObject.activeSelf then
		self.view.trans_menu_panel:DOLocalMoveY(self.view.trans_menu_panel.sizeDelta.y+100,0.5):SetEase(Ease.InBack)
		self.view.btn_touch.gameObject:SetActive(false)
	else
		self.view.trans_menu_panel:DOLocalMoveY(0,0.5):SetEase(Ease.OutBack)
		self.view.btn_touch.gameObject:SetActive(true)
	end

end

function FishPrawnCrabGameCtrl:Close()
    self.super.Close(self);
end

---添加UI事件
function FishPrawnCrabGameCtrl:AddUIEvent()
	self.uiEventListener:AddClick(self.view.btn_muen,function()
		self:RefreshMenuShow()
	end)
	self.uiEventListener:AddClick(self.view.btn_touch,function()
		self:RefreshMenuShow()
	end)
	self.uiEventListener:AddClick(self.view.btn_help,function()
		--CtrlManager.SingleShow(CtrlNames)
	end)
	self.uiEventListener:AddClick(self.view.btn_close,function()
		self:Close();
	end)
	self.uiEventListener:AddClick(self.view.btn_setting,function()
		look("打开设置界面")
	end)

	self.uiEventListener:AddClick(self.view.btn_players,function(obj)
		--CtrlManager.SingleShow(CtrlNames)
	end)

	---压注按钮
	for i=1,#self.view.chipInfos do
		self.uiEventListener:AddClick(self.view.chipInfos[i].obj,function()
			if FishPrawnCrabGameConfig.allowBet then
				self.view:ChangeAnte(i)
				--look("btn 抵住数值"..FishPrawnCrabGameConfig.dizhuNumArr[FishPrawnCrabGameConfig.anteIndex])
				---测试数据生成 龙虎和 对应前三个币
				--GlobalEvent.Notify("UPDATE_HIS_ITEMS",i)
			end
		end)
	end
end

---移除UI事件
function FishPrawnCrabGameCtrl:RemoveEvent()
	self.super.RemoveEvent(self);
end

--region UI事件方法

--endregion


---销毁UI
function FishPrawnCrabGameCtrl:RealCloseDestroy()
	self.super.RealCloseDestroy(self);
end

return FishPrawnCrabGameCtrl