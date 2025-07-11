---
---Create by Administrator
---DateTime: 2025-07-11 09:39:31
---
---@class FishPrawnCrabGameCtrl:BaseCtrl
local FishPrawnCrabGameCtrl=Class("FishPrawnCrabGameCtrl",BaseCtrl)

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
		self.view.obj_Menu.transform:DOLocalMoveY(483,0.5):SetEase(Ease.InBack)
		self.view.btn_touch.gameObject:SetActive(false)
	else
		self.view.obj_Menu.transform:DOLocalMoveY(0,0.5):SetEase(Ease.OutBack)
		self.view.btn_touch.gameObject:SetActive(true)
	end

end

function FishPrawnCrabGameCtrl:Close()
    self.super.Close(self);
end

---添加UI事件
function FishPrawnCrabGameCtrl:AddUIEvent()
	self.uiEventListener:AddClick(self.view.btn_Menu,function()
		self:RefreshMenuShow()
	end)

	self.uiEventListener:AddClick(self.view.btn_touch,function()
		self:RefreshMenuShow()
	end)
	self.uiEventListener:AddClick(self.view.btn_help,function()
		--CtrlManager.SingleShow(CtrlNames)
	end)
	self.uiEventListener:AddClick(self.view.btn_close,function()
		logError("点击FishPrawnCrabGameCtrl Close")
		self:Close();
	end)
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