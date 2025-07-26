---
---Create by Administrator
---DateTime: 2025-07-23 15:35:06
---
---@class USDollarExpressMapMainCtrl:BaseCtrl
local USDollarExpressMapMainCtrl=Class("USDollarExpressMapMainCtrl",BaseCtrl)
---@type USDollarExpressConfig
local config=require"SingleGames/USDollarExpress/USDollarExpressConfig"
---构造函数
function USDollarExpressMapMainCtrl:ctor(ctrlName,param)
    self.layer=2;
    self.abName="SingleGames/USDollarExpress/prefabs/USDollarExpressMapMain";
    self.prefabName="USDollarExpressMapMain"
    self.super.ctor(self,ctrlName,param);
	---@type USDollarExpressMapMainView
	self.view = self.view
	---@type USDollarExpressMapMainModel
	self.model = self.model
end

---初始化
function USDollarExpressMapMainCtrl:CtrlInit(args)
	self.super.CtrlInit(self,args);
	self:InitData()
	SoundManager:ChangeBg(config.ABNames.audios.."bgm_pick")
	SoundManager:PlayClip(config.ABNames.audios.."pick_vo")
	self.USDollarExpresszhuanchang=ComponentUtilGet.GameObject(self.view.transform,"USDollarExpresszhuanchang")
	self.USDollarExpresszhuanchang:SetActive(true)
	SoundManager:PlayClip(config.ABNames.audios.."trans_pick")
	self.canvasGroup=ComponentUtilGet.CanvasGroup(self.view.transform,"USDollarExpresszhuanchang")
	self.objspine=ComponentUtilGet.GameObject(self.USDollarExpresszhuanchang.transform,"eff_zhuanchang/SkeletonGraphic (guochang)")

	self.choosableAreas=args
	local index=Tools.RandomInt(1,#self.choosableAreas)
	self.curSelectIndex=self.choosableAreas[index]
	look("投资小游戏区域数据",self.choosableAreas)
	for i = 1, #self.choosableAreas do
		local id=self.choosableAreas[i]
		self.view.maps[id].obj:SetActive(true)
	end
	CorManager.StartCor(self, function
	()
		coroutine.wait(1.5)
		self.objspine:SetActive(false)
		self.canvasGroup:DOFade(0,1).onComplete= function()
			self.USDollarExpresszhuanchang:SetActive(false)
			self.canvasGroup.alpha=1
			self.objspine:SetActive(true)

			self:MapAutoSelect()
		end
	end)

	
end

function USDollarExpressMapMainCtrl:InitAreas()
	
end


---初始化数据
function USDollarExpressMapMainCtrl:InitData()
	
end

function USDollarExpressMapMainCtrl:Close()
    self.super.Close(self);
	CorManager.StopAll(self)
end

---添加UI事件
function USDollarExpressMapMainCtrl:AddUIEvent()
	--self.isClick = false
	--for i = 1, 8 do
	--	self.uiEventListener:AddClick(self.view.maps[i].obj, function
	--	()
	--		if self.isClick==true then
	--			return
	--		end
	--		self.isClick=true
	--		self:MapAutoSelect()
	--	end)
	--end

end

function USDollarExpressMapMainCtrl:MapAutoSelect()
	CorManager.StartCor(self, function
	()
		coroutine.wait(1)
		self.view.maps[self.curSelectIndex].objSelect:SetActive(true)
		coroutine.wait(1.5)
		CtrlManager.SingleShow(CtrlNames.USDollarExpressMapSelect,self.curSelectIndex)
	end)
end


---移除UI事件
function USDollarExpressMapMainCtrl:RemoveEvent()
	self.super.RemoveEvent(self);
end

---区域全解锁返回
function USDollarExpressMapMainCtrl:allAreaUnLock()
	logError("所有区域都解锁触发黄金列车2")
	SoundManager:PlayClip(config.ABNames.audios.."trans_superfree")
	config.allAreaUnLock=false
	for i = 1, 8 do
		Tools.SetActive(self.view.maps[i].obj,false)
	end
	---走二选一后的逻辑
	local ctrl=CtrlManager.GetCtrl(CtrlNames.USDollarExpressMain)
	config.gameTypeState=2
	ctrl.model.status=2
	ctrl:EndSmallGame()
	self:Close()
end


---销毁UI
function USDollarExpressMapMainCtrl:RealCloseDestroy()
	self.super.RealCloseDestroy(self);
	CorManager.StopAll(self)
end

return USDollarExpressMapMainCtrl