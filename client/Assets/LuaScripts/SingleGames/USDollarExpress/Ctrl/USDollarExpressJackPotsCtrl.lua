---
---Create by Administrator
---DateTime: 2025-07-19 11:25:15
---
---@class USDollarExpressJackPotsCtrl:BaseCtrl
local USDollarExpressJackPotsCtrl=Class("USDollarExpressJackPotsCtrl",BaseCtrl)
---@type USDollarExpressConfig
local config=require"SingleGames/USDollarExpress/USDollarExpressConfig"
---构造函数
function USDollarExpressJackPotsCtrl:ctor(ctrlName,param)
    self.layer=2;
    self.abName="SingleGames/USDollarExpress/prefabs/USDollarExpressJackPots";
    self.prefabName="USDollarExpressJackPots"
    self.super.ctor(self,ctrlName,param);
	---@type USDollarExpressJackPotsView
	self.view = self.view
	---@type USDollarExpressJackPotsModel
	self.model = self.model
end

---初始化
function USDollarExpressJackPotsCtrl:CtrlInit(args)
	self.super.CtrlInit(self,args);
	self:InitData()
	local data=args
	self.poolId=data.poolId
	self.jackpotvalue=data.jackpotvalue
	self.func=args.func
	self:SetJackPotAwards(self.poolId)
	look("获取中的奖池数据，",data)
end

---初始化数据
function USDollarExpressJackPotsCtrl:InitData()
	self.numTween={}
	self.txtJackpots={}
	self.txtJackpots[config.jackpotIds.minori]=self.view.txt_minor
	self.txtJackpots[config.jackpotIds.major]=self.view.txt_mejor
	self.txtJackpots[config.jackpotIds.grand]=self.view.txt_grand
	self.txtJackpots[config.jackpotIds.minni]=self.view.txt_mini
end

function USDollarExpressJackPotsCtrl:Close()
    self.super.Close(self);
end

---添加UI事件
function USDollarExpressJackPotsCtrl:AddUIEvent()
	self.uiEventListener:AddClick(self.view.btn_mask, function
	()
		if self.func then
			self.func()
		end
		self:Close()
	end)
end

---移除UI事件
function USDollarExpressJackPotsCtrl:RemoveEvent()
	self.super.RemoveEvent(self);
end

--region UI事件方法

function USDollarExpressJackPotsCtrl:SetJackPotAwards(jackpotId)
	self:HideAll()
	if jackpotId==config.jackpotIds.grand then
		self.view.obj_eff_tc_grand_red.gameObject:SetActive(true)
		SoundManager:PlayClip(config.ABNames.audios.."Jackpot_Grand")
	end
	if jackpotId==config.jackpotIds.major then
		self.view.obj_eff_tc_mejor_violet.gameObject:SetActive(true)
		SoundManager:PlayClip(config.ABNames.audios.."Jackpot_Major")
	end
	if jackpotId==config.jackpotIds.minni then
		self.view.obj_eff_tc_mini_green.gameObject:SetActive(true)
		SoundManager:PlayClip(config.ABNames.audios.."Jackpot_Mini")
	end
	if jackpotId==config.jackpotIds.minori then
		self.view.obj_eff_tc_minor_blue.gameObject:SetActive(true)
		SoundManager:PlayClip(config.ABNames.audios.."Jackpot_Minor")
	end
	self:UpDateValueByIndex()
end

--endregion
function USDollarExpressJackPotsCtrl:HideAll()
	self.view.obj_eff_tc_grand_red.gameObject:SetActive(false)
	self.view.obj_eff_tc_mejor_violet.gameObject:SetActive(false)
	self.view.obj_eff_tc_mini_green.gameObject:SetActive(false)
	self.view.obj_eff_tc_minor_blue.gameObject:SetActive(false)
	self.view.obj_eff_tc_youwon_yellow.gameObject:SetActive(false)
end

---展示中奖池的数据展示----
function USDollarExpressJackPotsCtrl:UpDateValueByIndex()
	local form=self.jackpotvalue*0.3
	local to=self.jackpotvalue
	local time=2
	self.txtJackpots[self.poolId].text=form
	self.numTween[self.poolId]= Tools.NumJump(form,to,time, function
	(v)
		self.txtJackpots[self.poolId].text=math.floor(v)
	end, function
	()
		CorManager.StartCor(self, function
		()
			coroutine.wait(5)
			if self.func then
				self.func()
			end
			self:Close()
		end)
	end)
end


---销毁UI
function USDollarExpressJackPotsCtrl:RealCloseDestroy()
	self.super.RealCloseDestroy(self);
	for k,v in pairs(self.numTween) do
		if v then
			v:Kill()
		end
	end
	CorManager.StopAll(self)
end

return USDollarExpressJackPotsCtrl