---
---Create by Administrator
---DateTime: 2025-07-08 17:28:05
---
---@class BaccaratMainCtrl:BaseCtrl
local BaccaratMainCtrl=Class("BaccaratMainCtrl",BaseCtrl)
---@type BaccaratConfig
local config=require("SingleGames/Baccarat/BaccaratConfig")
---@type BaccaratItemScripts
local BaccaratItemScripts = require("SingleGames/Baccarat/Ctrl/BaccaratItemScripts")
local Vector3 = CS.UnityEngine.Vector3
---每个路单Item的集合
local BaccaratItem = {};
---构造函数
function BaccaratMainCtrl:ctor(ctrlName,param)
    self.layer=2;
    self.abName="SingleGames/Baccarat/prefabs/BaccaratMain";
    self.prefabName="BaccaratMain"
    self.super.ctor(self,ctrlName,param);
	---@type BaccaratMainView
	self.view = self.view
	---@type BaccaratMainModel
	self.model = self.model
end

---初始化
function BaccaratMainCtrl:CtrlInit(args)
	self.super.CtrlInit(self,args);
	---@type ObjectPoolUtil
	self.objPools=ObjectPoolUtil.New()
	self:InitData()
end

---初始化数据
function BaccaratMainCtrl:InitData()
	self.model:ReqBaccaratTableSummaryList(1);
end

---拿到服务器数据初始化刷新界面显示
function BaccaratMainCtrl:InitSelectModel(data)
	for i, v in ipairs(data.tableSummaryList ) do
		local obj = self.objPools:SpawnPrefab(nil,config.ABNames.prefabsItem,"BaccaratItem",self.view.obj_Content.transform)
		obj:SetActive(true)
		obj.transform.localScale =  Vector3.one
		---@type BaccaratItemScripts
		local item = BaccaratItemScripts.New(obj,self)
		item:InitDataShow(i,v);
		local itemData = {}
		itemData.item = item;
		itemData.roomId = v.roomId;
		table.insert(BaccaratItem,itemData)
	end
end
---刷新单个显示
function BaccaratMainCtrl:RefreshSelectModel(data)
	for _, v in pairs(BaccaratItem) do
		if(v.roomId == data.tableSummary.baccaratBaseInfo.roomId) then
			---@type BaccaratItemScripts
			local item = v.item;
			item:RefreshDataShow(data.tableSummary)
		end
	end
end

function BaccaratMainCtrl:Close()
    self.super.Close(self);
end

---添加UI事件
function BaccaratMainCtrl:AddUIEvent()
    self.uiEventListener:AddClick(self.view.btn_close,function()
		self:Close()
		GameCenter.LeaveGame();
	end)
	
	self.uiEventListener:AddClick(self.view.btn_Help,function()
		CtrlManager.SingleShow(CtrlNames.BaccaratRule)
	end)
end

---移除UI事件
function BaccaratMainCtrl:RemoveEvent()
	self.super.RemoveEvent(self);
end

--region UI事件方法

--endregion


---销毁UI
function BaccaratMainCtrl:RealCloseDestroy()
	self.super.RealCloseDestroy(self);
	for _, v in pairs(BaccaratItem) do
		---@type BaccaratItemScripts
		local item =v.item;
		item:Destroy();
	end
	BaccaratItem = {}
	self.objPools:DestroyAll();
end

return BaccaratMainCtrl