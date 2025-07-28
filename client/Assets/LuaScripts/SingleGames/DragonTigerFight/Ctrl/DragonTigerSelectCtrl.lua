---
---Create by Administrator
---DateTime: 2025-07-28 09:55:32
---
---@class DragonTigerSelectCtrl:BaseCtrl
local DragonTigerSelectCtrl=Class("DragonTigerSelectCtrl",BaseCtrl)
local UICommonSelectionItem=require("SingleGames/DragonTigerFight/View/Item/SelectionItem")

---构造函数
function DragonTigerSelectCtrl:ctor(ctrlName,param)
    self.layer=2;
    self.abName="SingleGames/DragonTigerFight/prefabs/DragonTigerSelectPanel";
    self.prefabName="DragonTigerSelectPanel"
    self.super.ctor(self,ctrlName,param);
	---@type DragonTigerSelectView
	self.view = self.view
	---@type DragonTigerSelectModel
	self.model = self.model
end

---初始化
function DragonTigerSelectCtrl:CtrlInit(args)
	self.super.CtrlInit(self,args);
	---@type SubGame
	self.subGame=args.subGame
	self:InitData()
end

---初始化数据
function DragonTigerSelectCtrl:InitData()
	self.view.GoldNumber.text = PlayerManager:GetPlayerInfo().goldNum
	self.objselects={}
	local group = ComponentUtilGet.Transform(self.view.transform,"content/center")
	for i = 1, 3 do
		local trs = group:GetChild(i-1)
		local item=UICommonSelectionItem.New(trs,self)
		item:SetActive(false)
		self.objselects[i]=item
	end

	local wareHouseList=self.subGame.wareHouseList
	for i = 1, #wareHouseList do
		local item=self.objselects[i]
		if item then
			item:SetActive(true)
			item:InitData(wareHouseList[i])
			self.uiEventListener:AddClick(item.gameObject,function ()
				self:OnClickItem(wareHouseList[i].wareId);
			end);
		end
	end
end

function DragonTigerSelectCtrl:Close()
    self.super.Close(self);
end

---添加UI事件
function DragonTigerSelectCtrl:AddUIEvent()
	self.uiEventListener:AddClick(self.view.btn_close, function
	()
		self:OnClickReturn()
	end)
	self.uiEventListener:AddClick(self.view.btn_coinAdd,function()

	end)
end

---移除UI事件
function DragonTigerSelectCtrl:RemoveEvent()
	self.super.RemoveEvent(self);
end

--region UI事件方法
---返回大厅
function DragonTigerSelectCtrl:OnClickReturn()
	local ctrl=CtrlManager.GetCtrl(CtrlNames.UIHallGames);
	if ctrl then
		self:Close();
	else
		GameCenter.CloseCurGame(true);
	end
end

function DragonTigerSelectCtrl:OnClickItem(index)
	self.subGame:SendEnterRoom(index);
end

--endregion


---销毁UI
function DragonTigerSelectCtrl:RealCloseDestroy()
	self.super.RealCloseDestroy(self);
end

return DragonTigerSelectCtrl