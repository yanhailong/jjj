---
---Create by Administrator
---DateTime: 2025-07-02 13:47:40
---
---@class USDollarExpressHelpCtrl:BaseCtrl
local USDollarExpressHelpCtrl=Class("USDollarExpressHelpCtrl",BaseCtrl)
local page=1
---构造函数
function USDollarExpressHelpCtrl:ctor(ctrlName,param)
    self.layer=2;
    self.abName="SingleGames/USDollarExpress/prefabs/USDollarExpressHelp";
    self.prefabName="USDollarExpressHelp"
    self.super.ctor(self,ctrlName,param);
	---@type USDollarExpressHelpView
	self.view = self.view
	---@type USDollarExpressHelpModel
	self.model = self.model
end

---初始化
function USDollarExpressHelpCtrl:CtrlInit(args)
	self.super.CtrlInit(self,args);
	self:InitData()
	page = 1;
	self:SetPage(page)
end

---初始化数据
function USDollarExpressHelpCtrl:InitData()
	
end

function USDollarExpressHelpCtrl:Close()
    self.super.Close(self);
end

---添加UI事件
function USDollarExpressHelpCtrl:AddUIEvent()
	self.uiEventListener:AddClick(self.view.btn_left, function(args)
		local lastPage = page
		page = page - 1
		self:SetPage(page, lastPage)
	end)
	self.uiEventListener:AddClick(self.view.btn_right, function(args)
		local lastPage = page
		page = page + 1
		self:SetPage(page, lastPage)
	end)
	
	self.uiEventListener:AddClick(self.view.btn_back, function
	()
		self:Close()
	end)
end

---移除UI事件
function USDollarExpressHelpCtrl:RemoveEvent()
	self.super.RemoveEvent(self);
end

--region UI事件方法 
function USDollarExpressHelpCtrl:SetPage(page, lastPage)
	self.view.peilvPage[page]:SetActive(true)
	if lastPage then
		self.view.peilvPage[lastPage]:SetActive(false)
	end
	if page == 1 then
		self.view:SetButtonState(false, true)
	elseif page == 8 then
		self.view:SetButtonState(true, false)
	else
		self.view:SetButtonState(true, true)
	end
end
--endregion


---销毁UI
function USDollarExpressHelpCtrl:RealCloseDestroy()
	self.super.RealCloseDestroy(self);
end

return USDollarExpressHelpCtrl