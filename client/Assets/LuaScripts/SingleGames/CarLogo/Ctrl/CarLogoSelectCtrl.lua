---
---Create by Administrator
---DateTime: 2025-07-22 17:17:10
---
---@class CarLogoSelectCtrl:BaseCtrl
local CarLogoSelectCtrl=Class("CarLogoSelectCtrl",BaseCtrl)
local CarLogoSelectionItem=require("SingleGames/CarLogo/View/Item/CarLogoSelectionItem")

---构造函数
function CarLogoSelectCtrl:ctor(ctrlName,param)
    self.layer=2;
    self.abName="SingleGames/CarLogo/prefabs/CarLogoSelectPanel";
    self.prefabName="CarLogoSelectPanel"
    self.super.ctor(self,ctrlName,param);
	---@type CarLogoSelectView
	self.view = self.view
	---@type CarLogoSelectModel
	self.model = self.model
end

---初始化
function CarLogoSelectCtrl:CtrlInit(args)
	self.super.CtrlInit(self,args);
	---@type SubGame
	self.subGame=args.subGame
	self:InitData()
end

---初始化数据
function CarLogoSelectCtrl:InitData()
	self.view.GoldNumber.text = PlayerManager:GetPlayerInfo().goldNum
	self.objselects={}
	local group = ComponentUtilGet.Transform(self.view.transform,"content/center")
	for i = 1, 3 do
		local trs = group:GetChild(i-1)
		local item=CarLogoSelectionItem.New(trs,self)
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

function CarLogoSelectCtrl:Close()
	self.super.Close(self);
end

---添加UI事件
function CarLogoSelectCtrl:AddUIEvent()
	self.uiEventListener:AddClick(self.view.btn_close, function
	()
		self:OnClickReturn()
	end)
	self.uiEventListener:AddClick(self.view.btn_coinAdd,function() 
		
	end)
end


---返回大厅
function CarLogoSelectCtrl:OnClickReturn()
	local ctrl=CtrlManager.GetCtrl(CtrlNames.UIHallGames);
	if ctrl then
		self:Close();
	else
		GameCenter.CloseCurGame(true);
	end
end

---移除UI事件
function CarLogoSelectCtrl:RemoveEvent()
	self.super.RemoveEvent(self);
end

function CarLogoSelectCtrl:OnClickItem(index)
	self.subGame:SendEnterRoom(index);
end


---销毁UI
function CarLogoSelectCtrl:RealCloseDestroy()
	self.super.RealCloseDestroy(self);
end

return CarLogoSelectCtrl