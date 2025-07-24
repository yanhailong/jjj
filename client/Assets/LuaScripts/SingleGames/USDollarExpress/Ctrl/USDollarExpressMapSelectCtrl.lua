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
	self.view:SetTopState(1)
	self.view.txt_leftNum.text=3
	self.selectMapItem=self.view.allMaps[self.areaIndex]
	self.selectMapItem.obj:SetActive(true)
	local count=self.selectMapItem.obj.transform.childCount
	for i = 1, count do
		self.uiEventListener:AddClick(self.selectMapItem.cItem[i].obj, function
		()
			if table.contains(self.selectMapIds,self.selectMapItem.cItem[i])==true then
				logError("已经包含了")
				return
			end
			self.view.txt_leftNum.text=3-1
			local count= table.getCount(self.selectMapIds)
			if count<3 then
				table.insert(self.selectMapIds,self.selectMapItem.cItem[i])
				self.view.redCirle[count+1].transform.position=self.selectMapItem.cItem[i].obj.transform.position
				self.view.redCirle[count+1]:SetActive(true)
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
	self.view:SetTopState(2)
	self.alleffects={}
	self.dollars=0
	self.dollarValues={}
	CorManager.StartCor(self, function
	()
		self.view.obj_zhang:SetActive(true)
		coroutine.wait(1)
		local goldList=msg.goldList
		local totalWin=0
		for i = 1, #goldList do
			if goldList[i]>0 then
				---@type UnityEngine.GameObject
				self.alleffects[i]= self.objPools:SpawnPrefab(nil, config.ABNames.iconEffect,"Eff_Chess_glod", self.view.efects)
				self.alleffects[i].transform.position=self.selectMapIds[i].obj.transform.position
				local txt_dollars=ComponentUtilGet.Text(self.alleffects[i].transform,"txt_dollers")
				txt_dollars.text=goldList[i]
				totalWin=totalWin+goldList[i]
				self.dollarValues[i]=goldList[i]
				txt_dollars.gameObject:SetActive(false)
				local sp=ComponentUtilGet.SkeletonGraphic(self.alleffects[i].transform,"Spine_Chess")
				Tools.PlayerSpineAniByName(sp,"keepup",false)
				coroutine.wait(1)
				txt_dollars.gameObject:SetActive(true)
				coroutine.wait(1)
			else
				logError("这个区域没有中奖")
			end

		end
		logError("所有表现执行完毕！")

		local allWinTrainInfo=msg.allWinTrainInfo
		self.allAreaUnLock=msg.allAreaUnLock--是否全部解锁区域
		config.allAreaUnLock=self.allAreaUnLock
		if allWinTrainInfo and allWinTrainInfo.type==15 then
			logError("进入黄金列车")
			self.view:SetTopState(3)
			local pos=self.view.txt_repeatWin.transform.position
			coroutine.wait(0.5)
			for i = 1, 3 do
				self:DollarsFlyTo(pos,i)
				coroutine.wait(0.5)
			end
			coroutine.wait(1)
			local args={}
			if self.allAreaUnLock==true then
				args.enterType=102--投资小游戏进入2
			else
				args.enterType=101--投资小游戏进入1
			end

			args.trainInfoList={[1]=allWinTrainInfo}
			CtrlManager.SingleShow(CtrlNames.USDollarExpressCar,args):AddAsyncOpenCallback(function
			()
				self:Close()
				if self.allAreaUnLock==false then
					self:CloseMapMain()
				end
			end)

		else
			self.view:SetWinText(totalWin)
			coroutine.wait(5)
			self:winShowBack()
		end
	end)

end


function USDollarExpressMapSelectCtrl:RefreshRepeatWin(value)
	self.dollars=self.dollars+ value
	self.view.txt_repeatWin.text=self.dollars
end


function USDollarExpressMapSelectCtrl:DollarsFlyTo(pos,index)
	local txt_dollars=ComponentUtilGet.Text(self.alleffects[index].transform,"txt_dollers")
	txt_dollars.gameObject:SetActive(false)
	---@type  UnityEngine.GameObject
	local dollar= self.objPools:SpawnPrefab(nil, "SingleGames/USDollarExpress/prefabs/txt_dollers","txt_dollers", self.view.efects)
	dollar.transform.position=self.transform.position
	ComponentUtilGet.Text(dollar.transform).text=txt_dollars.text
	ComponentUtilGet.GameObject(dollar.transform,"effect_jinzhuan_trail"):SetActive(true)
	---@type DG.Tweening.Tween
	self.twDollars= dollar.transform:DOMove(pos,0.5)
	self.twDollars.onComplete= function
	()
		self.objPools:UnSpawnPrefab(dollar)
		self:RefreshRepeatWin(self.dollarValues[index])
		CorManager.StartCor(self, function
		()
			---@type  UnityEngine.GameObject
			local effect_jinzhuan_trail_bd= self.objPools:SpawnPrefab(nil, "SingleGames/USDollarExpress/effects/prefab/effect_jinzhuan_trail_bd","effect_jinzhuan_trail_bd", self.view.efects)
			effect_jinzhuan_trail_bd.transform.position=pos
			coroutine.wait(1.3)
			self.objPools:UnSpawnPrefab(effect_jinzhuan_trail_bd)
		end)
	end
end

function USDollarExpressMapSelectCtrl:Close()
    self.super.Close(self);
	CorManager.StopAll(self)
end

function USDollarExpressMapSelectCtrl:CloseMapMain()
	local ctrl=CtrlManager.GetCtrl(CtrlNames.USDollarExpressMapMain)
	if ctrl then
		ctrl:Close()
	end
end

function USDollarExpressMapSelectCtrl:NoticeEndGame()
	local ctrl1=CtrlManager.GetCtrl(CtrlNames.USDollarExpressMain)
	ctrl1:EndSmallGame()
end

---添加UI事件
function USDollarExpressMapSelectCtrl:AddUIEvent()
	self.uiEventListener:AddClick(self.view.btn_collect, function
	()
		self:winShowBack()
	end)
end

function USDollarExpressMapSelectCtrl:winShowBack()
	self:Close()
	if self.allAreaUnLock==true then
		local ctrl=CtrlManager.GetCtrl(CtrlNames.USDollarExpressMapMain)
		if ctrl then
			ctrl:allAreaUnLock()
		end
	else
		self:CloseMapMain()
		self:NoticeEndGame()
	end
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