---
---Create by Administrator
---DateTime: 2025-06-21 10:15:12
---
---@class USDollarExpressSelectCtrl:BaseCtrl
local USDollarExpressSelectCtrl=Class("USDollarExpressSelectCtrl",BaseCtrl)

---构造函数
function USDollarExpressSelectCtrl:ctor(ctrlName,param)
    self.layer=2;
    self.abName="SingleGames/USDollarExpress/prefabs/USDollarExpressSelect";
    self.prefabName="USDollarExpressSelect"
    self.super.ctor(self,ctrlName,param);
	---@type USDollarExpressSelectView
	self.view = self.view
	---@type USDollarExpressSelectModel
	self.model = self.model
end

---初始化
function USDollarExpressSelectCtrl:CtrlInit(args)
	self.super.CtrlInit(self,args);
	self:InitData()
	self.wareHouseList=args.wareHouseList
	look("选择界面的数据",self.wareHouseList)
	
	
	WebNetEvent.AddListener(pb_PlatformHall.ResChooseWare,self.ResChooseWare,self)
	for i = 1, #self.wareHouseList do
		self.view.selectItems[i].obj:SetActive(true)
		self.view.selectItems[i].txt_name.text=self.wareHouseList[i].name
		self.view.selectItems[i].txt_value.text=self.wareHouseList[i].limitVipMin
		self.uiEventListener:AddClick(self.view.selectItems[i].obj,function ()
			WebNetworkManager.SendMsg(pb_PlatformHall.ReqChooseWare,{gameType=100100,wareId=i})
		end)
	end
	
end

---临时写的位置 后期整理结构
function USDollarExpressSelectCtrl:ResChooseWare(msg)
	look("选择场次进入游戏",msg)
end


---初始化数据
function USDollarExpressSelectCtrl:InitData()
	
end

function USDollarExpressSelectCtrl:Close()
    self.super.Close(self);
end

---添加UI事件
function USDollarExpressSelectCtrl:AddUIEvent()

end

---移除UI事件
function USDollarExpressSelectCtrl:RemoveEvent()
	self.super.RemoveEvent(self);
end

--region UI事件方法

--endregion


---销毁UI
function USDollarExpressSelectCtrl:RealCloseDestroy()
	self.super.RealCloseDestroy(self);
end

return USDollarExpressSelectCtrl