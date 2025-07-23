---
---Create by Administrator
---DateTime: 2025-07-23 16:48:20
---
---@class USDollarExpressMapSelectCtrl:BaseCtrl
local USDollarExpressMapSelectCtrl=Class("USDollarExpressMapSelectCtrl",BaseCtrl)
---@type USDollarExpressConfig
local config=require"SingleGames/USDollarExpress/USDollarExpressConfig"
---构造函数
function USDollarExpressMapSelectCtrl:ctor(ctrlName,param)
    self.layer=2;
    self.abName="SingleGames/USDollarExpress/prefabs/USDollarExpressMapSelect";
    self.prefabName="USDollarExpressMapSelect"
    self.super.ctor(self,ctrlName,param);
	---@type USDollarExpressMapSelectView
	self.view = self.view
	---@type USDollarExpressMapSelectModel
	self.model = self.model
end

---初始化
function USDollarExpressMapSelectCtrl:CtrlInit(args)
	self.super.CtrlInit(self,args);
	---@type ObjectPoolUtil
	self.objPools=ObjectPoolUtil.New()
	self:InitData()
	self.areaIndex=args
	self:InitMaps()
end

---初始化数据
function USDollarExpressMapSelectCtrl:InitData()
	self.selectMapItem={}
	self.selectMapIds={}
end

function USDollarExpressMapSelectCtrl:InitMaps()

	self.selectMapItem=self.view.allMaps[self.areaIndex]
	self.selectMapItem.obj:SetActive(true)
	local count=self.selectMapItem.obj.transform.childCount
	for i = 1, count do
		self.uiEventListener:AddClick(self.selectMapItem.cItem[i].obj, function
		()
			local count= table.getCount(self.selectMapIds)
			if count<3 then
				self.view.redCirle[count+1].transform.position=self.selectMapItem.cItem[i].obj.transform.position
				self.view.redCirle[count+1]:SetActive(true)
				table.insert(self.selectMapIds,i)
				self.selectMapItem.cItem[i].light:SetActive(true)
				if table.getCount(self.selectMapIds)==3 then
					self.view.redCirle[count+1].transform.position=self.selectMapItem.cItem[i].obj.transform.position
					self.view.redCirle[table.getCount(self.selectMapIds)]:SetActive(true)
					logError("3个已经选择完成！，向服务器发送数据---》")
					self.model:ReqInvestArea(self.areaIndex)
				end
			end
		end)
	end
end

function USDollarExpressMapSelectCtrl:ResInvestArea(msg)
	look("收到选择投资区消息",msg)
	CorManager.StartCor(self, function
	()
		self.view.obj_zhang:SetActive(true)
		coroutine.wait(1)
		local goldList=msg.goldList
		for i = 1, #goldList do
			---@type UnityEngine.GameObject
			self.iconEffect= self.objPools:SpawnPrefab(nil, config.ABNames.iconEffect,"Eff_Chess_glod", self.view.transform)
			self.iconEffect.transform.position=self.transform.position
			local txt_dollars=ComponentUtilGet.Text(self.iconEffect.transform,"txt_dollers")
			txt_dollars.text=goldList[i]
			txt_dollars.gameObject:SetActive(false)
			local sp=ComponentUtilGet.SkeletonGraphic(self.iconEffect.transform,"Spine_Chess")
			Tools.PlayerSpineAniByName(sp,"keepup",true)
			coroutine.wait(1)
			txt_dollars.gameObject:SetActive(true)
			coroutine.wait(0.5)
		end
		
		local allWinTrainInfo=msg.allWinTrainInfo
		if #allWinTrainInfo>0 then
			logError("进入黄金列车")
			coroutine.wait(1)
			CtrlManager.SingleShow(CtrlNames.USDollarExpressCar,allWinTrainInfo)
		end
		
	end)

end


function USDollarExpressMapSelectCtrl:Close()
    self.super.Close(self);
end

---添加UI事件
function USDollarExpressMapSelectCtrl:AddUIEvent()

end

---移除UI事件
function USDollarExpressMapSelectCtrl:RemoveEvent()
	self.super.RemoveEvent(self);
end

--region UI事件方法

--endregion


---销毁UI
function USDollarExpressMapSelectCtrl:RealCloseDestroy()
	self.super.RealCloseDestroy(self);
	self.objPools:DestroyAll()
end

return USDollarExpressMapSelectCtrl