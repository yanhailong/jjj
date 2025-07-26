---
---Create by Administrator
---DateTime: 2025-06-30 16:37:31
---
---@class UICommonSelectionCtrl:BaseCtrl
local UICommonSelectionCtrl=Class("UICommonSelectionCtrl",BaseCtrl)
---@class UICommonSelectionItem 
local UICommonSelectionItem=require("PlatformHall/UICommonSelection/Ctrl/UICommonSelectionItem")

---构造函数
function UICommonSelectionCtrl:ctor(ctrlName,param)
    self.layer=2;
    self.abName="PlatformHall/UICommonSelection/UICommonSelection";
    self.prefabName="UICommonSelection"
    self.super.ctor(self,ctrlName,param);
	---@type UICommonSelectionView
	self.view = self.view
	---@type UICommonSelectionModel
	self.model = self.model
end

---初始化
function UICommonSelectionCtrl:CtrlInit(args)
	self.super.CtrlInit(self,args);
	---@type SubGame
	self.subGame=args.subGame
	look("self.subGame",self.subGame)
	self:InitData()
end

---初始化数据
function UICommonSelectionCtrl:InitData()
	self.objselects={}
	for i = 1, 3 do
		local go =ComponentUtilGet.GameObject(self.view.transform,"content/obj/select"..i)
		local item=UICommonSelectionItem.New(go,self)
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





function UICommonSelectionCtrl:Close()
    self.super.Close(self);
end

---添加UI事件
function UICommonSelectionCtrl:AddUIEvent()
	self.uiEventListener:AddClick(self.view.btn_close, function
	()
		self:Close()
	end)
	
end


---返回大厅
function UICommonSelectionCtrl:OnClickReturn(_)
	local ctrl=CtrlManager.GetCtrl(CtrlNames.UIHallGames);
	if ctrl then
		self:Close();
	else
		GameCenter.CloseCurGame(true);
	end
end

---移除UI事件
function UICommonSelectionCtrl:RemoveEvent()
	self.super.RemoveEvent(self);
end

function UICommonSelectionCtrl:OnClickItem(index)
	self.subGame:SendEnterRoom(index);
end


---销毁UI
function UICommonSelectionCtrl:RealCloseDestroy()
	self.super.RealCloseDestroy(self);
end

return UICommonSelectionCtrl