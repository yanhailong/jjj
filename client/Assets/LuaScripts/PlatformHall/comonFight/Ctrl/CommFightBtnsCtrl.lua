---
---Create by Administrator
---DateTime: 2025-07-28 14:41:11
---
---@class CommFightBtnsCtrl:BaseCtrl
local CommFightBtnsCtrl=Class("CommFightBtnsCtrl",BaseCtrl)
local PlayerItem=require("PlatformHall/comonFight/Ctrl/CommFightPlayerItem")
local ChouMaFlyUtil=require("Logic/Common/ChouMaFlyUtil")

local dizhuImgAtlas = "Common/GameArtsCommon/GameFight/alats/main"

local DOTween = CS.DG.Tweening.DOTween
local Ease = CS.DG.Tweening.Ease

---构造函数
function CommFightBtnsCtrl:ctor(ctrlName,param)
    self.layer=2;
    self.abName="Common/UICommon/prefabs/CommFightBtns";
    self.prefabName="CommFightBtns"
    self.super.ctor(self,ctrlName,param);
	---@type CommFightBtnsView
	self.view = self.view
	---@type CommFightBtnsModel
	self.model = self.model
end

---初始化
function CommFightBtnsCtrl:CtrlInit(args)
	self.super.CtrlInit(self,args);
	self.subGameCtr = args
	self:InitData()
end

---初始化数据
function CommFightBtnsCtrl:InitData()
	---当前选中的底注
	self.dizhuIndex=0
	---当前是否可以下注
	self.allow=false
end

---获取到服务器betPointList时更新筹码数值
---@param haveOtherPlayer是否显示其他玩家
---@param betPointList筹码数值
---@param btn_players用户获取坐标
function CommFightBtnsCtrl:BindData(config,haveOtherPlayer,betPointList,btn_players,xiaZhuAreas)
	self.config = config
	self.betPointList = betPointList
	self.btn_players = btn_players
	self.haveOtherPlayer = haveOtherPlayer
	self.xiaZhuAreas = xiaZhuAreas
	
	self:InitChouMa()
end


function CommFightBtnsCtrl:Close()
    self.super.Close(self);
end

function CommFightBtnsCtrl:GetDizhuIndex()
	return self.dizhuIndex
end
function CommFightBtnsCtrl:GetSelfPlayer()
	return self.selfPlayer
end
function CommFightBtnsCtrl:GetOtherPlayer(index)
	return self.AllOtherPlayerHeads[index]
end
---通过id找到TOP6玩家
function CommFightBtnsCtrl:FindPlayerByID(playerId)
	for i=1,#self.AllOtherPlayerHeads do
		if self.AllOtherPlayerHeads[i].id== playerId then
			return self.AllOtherPlayerHeads[i]
		end
	end
	return nil
end

function CommFightBtnsCtrl:InitUI()
	---下注底注按钮
	self.chipInfos={}
	local ChouMaItem = ComponentUtilGet.GameObject(self.view.dizhu,"ChouMaItem")
	for i=1,6 do
		local chouma = GameObject.Instantiate(ChouMaItem);
		chouma.transform:SetParent(self.view.dizhu,false);
	end
	for i = 1, 7 do
		local chipItem={}
		chipItem.obj=self.view.dizhu:GetChild(i-1).gameObject
		chipItem.rectTrans=ComponentUtilGet.Transform(self.view.dizhu:GetChild(i-1),"Button")
		chipItem.button=ComponentUtilGet.Button(chipItem.rectTrans)
		chipItem.image=ComponentUtilGet.Image(chipItem.rectTrans)
		chipItem.num=ComponentUtilGet.Text(chipItem.rectTrans,"number")
		chipItem.effects=ComponentUtilGet.GameObject(chipItem.rectTrans,"checkd")
		chipItem.effects:SetActive(false)
		self.chipInfos[i]=chipItem
	end
	---其他玩家信息 left right
	---@type PlayerItem[]
	self.AllOtherPlayerHeads = {}
	local otherPlayerTrs = ComponentUtilGet.Transform(self.view.transform,"content/players")
	for i = 1, 6 do
		self.AllOtherPlayerHeads[#self.AllOtherPlayerHeads + 1] = PlayerItem.New(otherPlayerTrs:GetChild(i-1))
	end
	self.selfPlayer = PlayerItem.New(self.view.selfPlayerRoot)
end

function CommFightBtnsCtrl:InitChouMa()
	---底注数值
	for i=1,#self.chipInfos do
		if self.betPointList[i] then
			self.chipInfos[i].obj:SetActive(true)
			self.chipInfos[i].image.sprite = resMgr:LoadSprite(dizhuImgAtlas,"yx_ph_cm_"..i)
			self.chipInfos[i].num.text = StringUtil.FormatNumber(self.betPointList[i])

			local img = ComponentUtilGet.Image(self.view.dizhuNode.transform,"img")
			local num = ComponentUtilGet.Text(self.view.dizhuNode.transform,"num")
			img.sprite = resMgr:LoadSprite(dizhuImgAtlas,"yx_ph_cm_"..i)
			num.text = self.chipInfos[i].num.text
		else
			self.chipInfos[i].obj:SetActive(false)
		end
	end
	--默认选中第一个
	self:ChangeSelectDiZhu(1)
end
---设置菜单显示隐藏
function CommFightBtnsCtrl:SettingFade()
	if self.settingShow then
		self.settingShow = false
		self.view.muenRect:DOLocalMoveY(self.view.muenRect.sizeDelta.y+100,0.5):SetEase(Ease.InBack)
		self.view.btn_touch.gameObject:SetActive(false)
	else
		self.settingShow = true
		self.view.muenRect:DOLocalMoveY(0,0.5):SetEase(Ease.OutBack)
		self.view.btn_touch.gameObject:SetActive(true)
	end

end

function CommFightBtnsCtrl:OnClickDiZhuNav(isNext)
	local target = isNext and 1 or 0
	self.view.dizhuScrollRect:DOHorizontalNormalizedPos(target,1):SetEase(Ease.OutBack)
end

function CommFightBtnsCtrl:OnChangeDiZhuNav(isRight)
	if isRight then
		self.view.img_prev.sprite = resMgr:LoadSprite(dizhuImgAtlas,"d_ph_jiantou2")
		self.view.img_next.sprite = resMgr:LoadSprite(dizhuImgAtlas,"d_ph_jiantou1")
		self.view.img_prev.transform.localScale = Vector3(-1,1,1)
		self.view.img_next.transform.localScale = Vector3(-1,1,1)
	else
		self.view.img_prev.sprite = resMgr:LoadSprite(dizhuImgAtlas,"d_ph_jiantou1")
		self.view.img_next.sprite = resMgr:LoadSprite(dizhuImgAtlas,"d_ph_jiantou2")
		self.view.img_prev.transform.localScale = Vector3.one
		self.view.img_next.transform.localScale = Vector3.one
	end
end

---切换当前选中的底注
function CommFightBtnsCtrl:ChangeSelectDiZhu(index)
	-- 参数验证
	if not index or index < 1 or index > #self.chipInfos then
		return
	end

	-- 如果点击的是当前已选中的按钮，不做任何操作
	if index == self.dizhuIndex and self.chipInfos[index].effects.activeSelf then
		return
	end

	local oldChip = self.chipInfos[self.dizhuIndex]
	local newChip = self.chipInfos[index]

	-- 停止之前按钮的所有动画
	if oldChip and oldChip.rectTrans then
		oldChip.rectTrans:DOKill() -- 停止所有DOTween动画
	end

	-- 停止新按钮的所有动画
	if newChip and newChip.rectTrans then
		newChip.rectTrans:DOKill() -- 停止所有DOTween动画
	end

	-- 重置旧按钮状态
	if oldChip then
		oldChip.rectTrans:DOScale(1, 0.1):SetEase(Ease.OutQuad)
		oldChip.rectTrans:DOLocalMoveY(0, 0.1):SetEase(Ease.OutQuad)
		oldChip.effects:SetActive(false)
	end

	-- 设置新按钮状态
	if newChip then
		-- 先设置缩放动画
		newChip.rectTrans:DOScale(1.1, 0.15):SetEase(Ease.OutBack)
		-- 再设置位置动画
		newChip.rectTrans:DOLocalMoveY(13.0, 0.15):SetEase(Ease.OutQuad)
		newChip.effects:SetActive(true)
	end

	-- 更新配置中的当前选中索引
	self.dizhuIndex = index
end

---启用/禁用下注按钮
function CommFightBtnsCtrl:UpdateDiZhuBtnState()
	for i=1,#self.chipInfos do
		self.chipInfos[i].button.interactable = self.allow and self.betPointList[i]<=PlayerManager:GetPlayerInfo().goldNum
	end
	if self.chipInfos[self.dizhuIndex] then self.chipInfos[self.dizhuIndex].effects:SetActive(self.allow) end
end

---更新自己信息
function CommFightBtnsCtrl:UpdateSelf(player)
	self.selfPlayer:UpdatePlayer(player)
end
function CommFightBtnsCtrl:UpdateSelfGoldCount()
	self.selfPlayer:UpdateGoldCount(PlayerManager:GetPlayerInfo().goldNum)
end
function CommFightBtnsCtrl:UpdatePlayerNum(playersNum)
	self.tmp_totalPlayerNum.text = tostring(playersNum)
end
---其他玩家信息更新
function CommFightBtnsCtrl:UpdatePlayers(players)
	local idx = 1
	local selfId = PlayerManager:GetPlayerInfo().playerId

	-- 先把有数据的头像更新
	if players then
		for _, player in ipairs(players) do
			if player.playerId == selfId then
				self:UpdateSelf(player)
			else
				if idx <= 6 then
					self.AllOtherPlayerHeads[idx]:UpdatePlayer(player)
					idx = idx + 1
				end
			end
		end
	end

	-- 剩下的头像没有数据，才隐藏
	for i = idx, 6 do
		self.AllOtherPlayerHeads[i]:UpdatePlayer(nil)
	end

end

---本玩家下注动画
---@param targetTrans下注区域
function CommFightBtnsCtrl:PaySelfXiaZhuCoinFly(side)
	ChouMaFlyUtil:AnimateCoin(self.dizhuNode,self.dizhuIndex,self.selfPlayer.transform.position,self.xiaZhuAreas[side], self.betPointList[self.dizhuIndex])
end

---其他玩家下注动画
---@param data服务器返回的结果
---@param config子游戏的配置
---@param areas下注区域集合
function CommFightBtnsCtrl:PayOtherXiaZhuCoinFly(data)
	local config = self.config
	local areas = self.xiaZhuAreas
	-- 更新总押注金额
	config.totalDiZhuNums[data.side] = data.betIdxTotal
	-- 自己下注
	local selfId = PlayerManager:GetPlayerInfo().playerId
	if selfId==data.playerId then
		config.selfDiZhuNums[data.side] = config.selfDiZhuNums[data.side] + data.betValue
		PlayerManager:GetPlayerInfo().goldNum = data.currency or 0; -- 更新金币
		table.insert(config.selfXiaZhuInfo,data)
		self:PaySelfXiaZhuCoinFly(data.side)
		self:UpdateSelfGoldCount()
		return
	end
	-- 其他玩家下注
	local areaTotal = config.AreaChipTotals
	local playerItem = self.haveOtherPlayer and self:FindPlayerByID(data.playerId) or nil
	if playerItem ~= nil then
		playerItem:UpdateGoldCount(data.currency or 0) --更新数值
	end
	if areaTotal[data.side] >= config.AreaChouMaLimit[data.side] then
		return
	end
	if playerItem ~= nil then
		ChouMaFlyUtil:AnimateCoin(self.dizhuNode,data.index,playerItem.transform.position,areas[data.side],data.betValue)
	else
		ChouMaFlyUtil:AnimateCoin(self.dizhuNode,data.index,self.btn_players.transform.position,areas[data.side],data.betValue)
	end
	areaTotal[data.side] = areaTotal[data.side] + 1
end


---金币回收动画
function CommFightBtnsCtrl:PlayCompeleCoinFLy(results)
	--数据处理 winCurrency
	local targetPos = {}
	local winCurrency = {0,0}
	local totalCurrency = 0
	targetPos[1] = self.selfPlayerRoot.position
	targetPos[2] = self.btn_players.transform.position
	for i=1,#results do
		local player = results[i]
		--跳过没有赢钱的玩家
		if player.playerWinGold == 0 then goto continue end
		local playerItem = self.haveOtherPlayer and self:FindPlayerByID(player.playerId) or nil
		totalCurrency = totalCurrency + player.playerWinGold
		if player.playerId == PlayerManager:GetPlayerInfo().playerId then
			winCurrency[1] = player.playerWinGold
			self.selfPlayer:ShowResultCount( player.playerWinGold)
			PlayerManager:GetPlayerInfo().goldNum = PlayerManager:GetPlayerInfo().goldNum + player.playerWinGold;
			self:UpdateSelfGoldCount() -- 更新金币
		elseif  playerItem ~= nil then
			targetPos[#targetPos+1] = playerItem.transform.position
			winCurrency[#winCurrency+1] =  player.playerWinGold
			playerItem:ShowResultCount(player.playerWinGold)
		else
			winCurrency[2] = winCurrency[2] + player.playerWinGold
		end
		::continue::
	end
	--按比例回收
	local ratios = {}
	for i=1,#winCurrency do
		table.insert(ratios,winCurrency[i]/totalCurrency)
	end
	if totalCurrency==0 then
		ratios = {0,1}
	end
	ChouMaFlyUtil:DestroyCoin(targetPos,ratios)
end

--单独飞筹码处理 防止频繁UI更新卡住
function CommFightBtnsCtrl:UpdateBetting()
	if  not self.allow or not self.config or Time.realtimeSinceStartup - self.bettingTime < 0.1 then return end
	self.bettingTime = Time.realtimeSinceStartup

	for playerId, msg in pairs(self.bettingDataMap) do
		if not msg.handled then
			for _, value in ipairs(msg.betTableInfoList) do
				local bet = {
					side = value.betIdx<self.config.gameID and value.betIdx or value.betIdx-self.config.gameID*100,
					index = self:FindBetIndex(value.betValue),
					currency = msg.playerCurGold,
					playerId = msg.playerId,
					betValue = value.betValue,
					betIdxTotal = value.betIdxTotal,--区域总的押注数量
				}
				self:PayOtherXiaZhuCoinFly(bet)
			end
			msg.handled = true
		end
	end
end

---倒计时3秒
function CommFightBtnsCtrl:PlayDaoJiShiEffect()
	self.view.daojishiObj:SetActive(true)
	local daojishiParticles = self.view.daojishiObj:GetComponent("ParticleSystem")
	if daojishiParticles.isStopped  then
		daojishiParticles:Play();
	end
end

function CommFightBtnsCtrl:FindBetIndex(value)
	for i=1,#self.betPointList do
		if self.betPointList[i]==value then
			return i
		end
	end
	return nil
end
--获取房间玩家信息
function CommFightBtnsCtrl:ReqRoomPlayers()
	WebNetworkManager.SendMsg(pb_comonFight.ReqTablePlayerInfo)
end
---添加UI事件
function CommFightBtnsCtrl:AddUIEvent()
	self:AddFunctionButtons()
	self:AddBetButtons()
	self:AddDiZhuScrollRect()
	UpdateManager.AddUpdate(self,self.UpdateBetting)
end

function CommFightBtnsCtrl:AddFunctionButtons()
	self.uiEventListener:AddClick(self.view.btn_close, function() self.subGameCtr:Close() end)
	self.uiEventListener:AddClick(self.view.btn_muen,function() self:SettingFade()  end)
	self.uiEventListener:AddClick(self.view.btn_touch,function() self:SettingFade()  end)
	self.uiEventListener:AddClick(self.view.btn_help, function() if self.subGameCtr.OnClickHelp then self.subGameCtr:OnClickHelp() end end)
	self.uiEventListener:AddClick(self.view.btn_setting, function() look("打开设置界面") end)
	self.uiEventListener:AddClick(self.view.btn_players, function() self:ReqRoomPlayers() end)
	self.uiEventListener:AddClick(self.view.btn_prev,function()  self:OnClickDiZhuNav(false) end)
	self.uiEventListener:AddClick(self.view.btn_next,function()  self:OnClickDiZhuNav(true) end)
end
function CommFightBtnsCtrl:AddBetButtons()
	for i, chipInfo in ipairs(self.chipInfos) do
		self.uiEventListener:AddClick(chipInfo.button.gameObject, function()
			if self.config and self.config.allow then
				self:ChangeSelectDiZhu(i)
				look("btn 抵住数值" .. self.dizhuIndex)
			end
		end)
	end
end
function CommFightBtnsCtrl:AddDiZhuScrollRect()
	self.uiEventListener:AddScrollRect(self.view.dizhuScrollRect.gameObject,function(pos)
		if Mathf.Abs(pos.x - 1) < 0.01 then --判断是否滑动到最右
			self:OnChangeDiZhuNav(true)
		elseif Mathf.Abs(pos.x) < 0.01 then-- 判断是否滑动到最左
			self:OnChangeDiZhuNav(false)
		end
	end)
end
---移除UI事件
function CommFightBtnsCtrl:RemoveEvent()
	self.super.RemoveEvent(self);
	UpdateManager.ReMoveAll(self)
end

--region UI事件方法

--endregion


---销毁UI
function CommFightBtnsCtrl:RealCloseDestroy()
	self.super.RealCloseDestroy(self);
end

return CommFightBtnsCtrl