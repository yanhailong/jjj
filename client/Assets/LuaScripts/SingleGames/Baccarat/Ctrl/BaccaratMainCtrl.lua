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
	self:RefreshSelectModel();
end

function BaccaratMainCtrl:RefreshSelectModel()
	for i = 1, 4 do
		local obj = self.objPools:SpawnPrefab(nil,config.ABNames.prefabsItem,"BaccaratItem",self.view.obj_Content.transform)
		obj:SetActive(true)
		obj.transform.localScale =  Vector3.one
		---@type BaccaratItemScripts
		local item = BaccaratItemScripts.New(obj,self)
		item:RefreshDataShow();--等服务器那边传数据过来
	end
end

function BaccaratMainCtrl:Close()
    self.super.Close(self);
end

---添加UI事件
function BaccaratMainCtrl:AddUIEvent()
    self.uiEventListener:AddClick(self.view.btn_close,function()
		self:Close()
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
end

return BaccaratMainCtrl