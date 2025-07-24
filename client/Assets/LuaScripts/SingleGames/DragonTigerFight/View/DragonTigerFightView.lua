---
---Create by Administrator
---DateTime: 2025-06-21 15:09:13
---
---@class DragonTigerFightView:BaseView
local DragonTigerFightView=Class("DragonTigerFightView",BaseView)
local config=require("SingleGames/DragonTigerFight/DragonTigerFightConfig")
local ChouMaFlyUtil=require("Logic/Common/ChouMaFlyUtil")
local PlayerItem = require("SingleGames/DragonTigerFight/View/Item/PlayerItem")
local ClockStateItem = require("SingleGames/DragonTigerFight/View/Item/ClockState")
local RoadView = require("SingleGames/DragonTigerFight/View/RoadView")
local CardItem = require("SingleGames/DragonTigerFight/View/Item/CardItem")
local DOTween = CS.DG.Tweening.DOTween
local Ease = CS.DG.Tweening.Ease

---初始化panel
function DragonTigerFightView:InitView()
	---@type DragonTigerFightCtrl
    self.ctrl=self.ctrl
	self:InitComponents()
end

---获取组件
function DragonTigerFightView:InitComponents()
    self.btn_repeat=ComponentUtilGet.Button(self.transform,"content/bottom/btn_repeat");
    self.btn_players=ComponentUtilGet.Button(self.transform,"content/bottom/btn_players");
    self.tmp_totalPlayerNum=ComponentUtilGet.Text(self.btn_players.transform,"tmp_total_player_num")
    self.dizhu=ComponentUtilGet.Transform(self.transform,"content/bottom/chouma/Viewport/Content");
    self.btn_prev = ComponentUtilGet.Button(self.transform, "content/bottom/chouma/prev");
    self.btn_next = ComponentUtilGet.Button(self.transform, "content/bottom/chouma/next");
    self.img_prev = ComponentUtilGet.Image(self.btn_prev.transform,"img");
    self.img_next = ComponentUtilGet.Image(self.btn_next.transform,"img");
    self.xiazhuArea = ComponentUtilGet.Transform(self.transform,"content/center/XiaZhu")
    self.longClickArea = ComponentUtilGet.Transform(self.transform,"content/clickRect/longClick")
    self.huClickArea = ComponentUtilGet.Transform(self.transform,"content/clickRect/huClick")
    self.heClickArea = ComponentUtilGet.Transform(self.transform,"content/clickRect/heClick")
    self.selfPlayerRoot  = ComponentUtilGet.Transform(self.transform,"content/bottom/SelfHead")
    ---下注数量
    ---@type  TMPro.TextMeshProUGUI[]
    self.xiazhuNumLabels = {}
    self.xiazhuNumLabels[1] = ComponentUtilGet.TextMeshProUGUI(self.xiazhuArea,"Center/Long/title/num")
    self.xiazhuNumLabels[2] = ComponentUtilGet.TextMeshProUGUI(self.xiazhuArea,"Center/Hu/title/num")
    self.xiazhuNumLabels[3] = ComponentUtilGet.TextMeshProUGUI(self.xiazhuArea,"Center/He/title/num")
    ---下注金币落点
    self.xiazhuStarAreas = {}
    self.xiazhuStarAreas[1] = ComponentUtilGet.RectTransform(self.longClickArea,"Star")
    self.xiazhuStarAreas[2] = ComponentUtilGet.RectTransform(self.huClickArea,"Star")
    self.xiazhuStarAreas[3] = ComponentUtilGet.RectTransform(self.heClickArea,"Star")
    ---个人下注数量
    ---@type  TMPro.TextMeshProUGUI[]
    self.xiazhuSelfNumsLabels = {}
    self.xiazhuSelfNumsLabels[1] = ComponentUtilGet.TextMeshProUGUI(self.longClickArea,"yazhuNum/num")
    self.xiazhuSelfNumsLabels[2] = ComponentUtilGet.TextMeshProUGUI(self.huClickArea,"yazhuNum/num")
    self.xiazhuSelfNumsLabels[3] = ComponentUtilGet.TextMeshProUGUI(self.heClickArea,"yazhuNum/num")
    
    self.debugTxt = ComponentUtilGet.TextMeshProUGUI(self.transform,"content/top/debug/txt")
    self.debugTime = ComponentUtilGet.TextMeshProUGUI(self.transform,"content/top/debug/time")
    
    ---下注底注按钮
    self.chipInfos={}
    local ChouMaItem = ComponentUtilGet.GameObject(self.dizhu,"ChouMaItem")
    for i=1,6 do
        local chouma = GameObject.Instantiate(ChouMaItem);
        chouma.transform:SetParent(self.dizhu,false);
    end
    for i = 1, 7 do
        local chipItem={}
        chipItem.obj=self.dizhu:GetChild(i-1).gameObject
        chipItem.rectTrans=self.dizhu:GetChild(i-1)
        chipItem.button=ComponentUtilGet.Button(chipItem.rectTrans)
        chipItem.image=ComponentUtilGet.Image(chipItem.rectTrans)
        chipItem.num=ComponentUtilGet.Text(chipItem.rectTrans,"number")
        chipItem.effects=ComponentUtilGet.GameObject(chipItem.rectTrans,"checkd")
        chipItem.effects:SetActive(false)
        self.chipInfos[i]=chipItem
    end
    ---底注节点
    self.dizhuNode = ComponentUtilGet.GameObject(self.transform,"content/bottom/nodes")
    ---其他玩家信息 left right
    ---@type PlayerItem[]
    self.AllOtherPlayerHeads = {}
    local otherPlayerTrs = ComponentUtilGet.Transform(self.transform,"content/obj_PlayerRoot")
    for i = 1, 6 do
        self.AllOtherPlayerHeads[#self.AllOtherPlayerHeads + 1] = PlayerItem.New(otherPlayerTrs:GetChild(i-1))
    end
    self.selfPlayer = PlayerItem.New(self.selfPlayerRoot)
    ---提示信息
    self.tipsTrs = ComponentUtilGet.Transform(self.transform,"content/tips")
    self.tipsTimeEnd = ComponentUtilGet.GameObject(self.tipsTrs,"tips_time_end")
    self.tipsStartXiaZhu = ComponentUtilGet.GameObject(self.tipsTrs,"tips_start_xiazhu")
    self.tipsTimeThree = ComponentUtilGet.GameObject(self.tipsTrs,"tips_time_three")
    -- 结算中
    self.tipsCenterTxt = ComponentUtilGet.Transform(self.tipsTrs,"tips_center/tips_center_txt")
    self.colockStateTimeTrs = ComponentUtilGet.Transform(self.tipsTrs,"tips_center/colock_state_time")
    self.colockStateTimeNum=ComponentUtilGet.Text(self.colockStateTimeTrs,"time") --倒计时
    self.colockNumTrs=ComponentUtilGet.Transform(self.tipsTrs,"tips_center/colock_num")
    self.colockNumTime=ComponentUtilGet.Text(self.colockNumTrs,"time")
    
    self.daojishiParticles =ComponentUtilGet.GameObject(self.tipsTrs,"eff_daojishi/eff_daojishi"):GetComponent("ParticleSystem")
    
    ---路单信息
    ---@type RoadView
    self.roadView=RoadView.New(ComponentUtilGet.GameObject(self.transform,"Background/RoadView"))
    ---设置按钮
    self.muenRect=ComponentUtilGet.RectTransform(self.transform,"content/setting/mask/muen")
    self.btn_setting=ComponentUtilGet.Button(self.muenRect,"btn_setting")
    self.btn_help=ComponentUtilGet.Button(self.muenRect,"btn_help")
    self.btn_close=ComponentUtilGet.Button(self.muenRect,"btn_close")
    self.btn_muen=ComponentUtilGet.Button(self.transform,"content/setting/btn_muen")
    self.btn_touch=ComponentUtilGet.Button(self.transform,"content/setting/btn_touch")
    ---结果信息
    self.effectsTrs=ComponentUtilGet.Transform(self.transform,"content/effects")
    self.resultTrs=ComponentUtilGet.Transform(self.effectsTrs,"resoult")
    self.resultBgTrs=ComponentUtilGet.Transform(self.transform,"Background/resoult/bg")
    self.resultWinTrs=ComponentUtilGet.Transform(self.resultTrs,"win")
    ---@type CardItem
    self.resultCard1=CardItem.New(ComponentUtilGet.GameObject(self.resultTrs,"card/left"))
    ---@type CardItem
    self.resultCard2=CardItem.New(ComponentUtilGet.GameObject(self.resultTrs,"card/right"))
    self.ctr_dot_p1=ComponentUtilGet.Transform(self.effectsTrs,"dot/p1")
    self.ctr_dot_p2=ComponentUtilGet.Transform(self.effectsTrs,"dot/p2")

    self.startTrs=ComponentUtilGet.Transform(self.effectsTrs,"start")
    self.startLeftTrs=ComponentUtilGet.Transform(self.startTrs,"left")
    self.startRightTrs=ComponentUtilGet.Transform(self.startTrs,"right")
    self.startVsTrs=ComponentUtilGet.Transform(self.startTrs,"vs")
    self.startVsImg=ComponentUtilGet.Image(self.startVsTrs)

end

---清空组件
function DragonTigerFightView:ClearComponents()
    self.btn_close=nil;
    self.btn_repeat=nil;
    self.btn_players=nil;
    self.img_1=nil;
    self.img_10=nil;
    self.img_50=nil;
    self.img_100=nil;
    self.img_500=nil;
    self.dizhu=nil;
    self.chipInfos=nil;
    self.longClickArea=nil;
    self.huClickArea=nil;
    self.heClickArea=nil;
    self.xiazhuNumLabels = nil;
    self.xiazhuSelfNumsLabels=nil;
    self.xiazhuStarAreas=nil;
    self.tmp_totalPlayerNum=nil
end

function DragonTigerFightView:DizhuPrev(isNext)
    if isNext==false then
        if self.dizhupos then
            self.dizhu:DOLocalMoveX(self.dizhu.localPosition.x+412,1):SetEase(Ease.OutBack)
            self.img_prev.sprite = resMgr:LoadSprite(config.dizhuImgAtlas,"d_ph_jiantou1")
            self.img_next.sprite = resMgr:LoadSprite(config.dizhuImgAtlas,"d_ph_jiantou2")
            self.img_prev.transform.localScale = Vector3.one
            self.img_next.transform.localScale = Vector3.one
            self.dizhupos = false
        end
    else if not self.dizhupos then
        self.dizhu:DOLocalMoveX(self.dizhu.localPosition.x-412,1):SetEase(Ease.OutBack)
        self.img_prev.sprite = resMgr:LoadSprite(config.dizhuImgAtlas,"d_ph_jiantou2")
        self.img_next.sprite = resMgr:LoadSprite(config.dizhuImgAtlas,"d_ph_jiantou1")
        self.img_prev.transform.localScale = Vector3(-1,1,1)
        self.img_next.transform.localScale = Vector3(-1,1,1)
        self.dizhupos = true
        end
    end
end

---切换当前选中的底注
function DragonTigerFightView:ChangeDiZhu(index)
    -- 参数验证
    if not index or index < 1 or index > #self.chipInfos then
        return
    end
    
    -- 如果点击的是当前已选中的按钮，不做任何操作
    if index == config.dizhuIndex and self.chipInfos[index].effects.activeSelf then
        return
    end
    
    local oldIndex = config.dizhuIndex
    local oldChip = self.chipInfos[oldIndex]
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
    config.dizhuIndex = index
end

---启用/禁用下注按钮
function DragonTigerFightView:UpdateDiZhuBtnState()
    for i=1,#self.chipInfos do
        self.chipInfos[i].button.interactable = config.allow and self.ctrl.model.betPointList[i]<=PlayerManager:GetPlayerInfo().goldNum
    end
end

---设置续投按钮是否可以点击 当前局已经手动投注或者上局未投注不能点 其他可点
function DragonTigerFightView:SetRepeatState(isOn)
    if isOn then
        self.btn_repeat.interactable = true;
    else
        self.btn_repeat.interactable = false;
    end
end

---本玩家下注动画
function DragonTigerFightView:PayXiaZhuCoinFly(side)
    ChouMaFlyUtil:AnimateCoin(self.dizhuNode,config.dizhuIndex,self.selfPlayer.transform.position,self.xiazhuStarAreas[side],
            self.ctrl.model.betPointList[config.dizhuIndex])
end
---通过id找到TOP6玩家
function DragonTigerFightView:FindPlayerByID(id)
    for i=1,#self.AllOtherPlayerHeads do
        if self.AllOtherPlayerHeads[i].id==id then
            return self.AllOtherPlayerHeads[i]
        end
    end
    return nil
end
---其他玩家下注动画
function DragonTigerFightView:PayOtherXiaZhuCoinFly(data)
    -- 更新总押注金额
    config.totalDiZhuNums[data.side] = data.betIdxTotal
    -- 自己下注
    local selfId = PlayerManager:GetPlayerInfo().playerId
    if selfId==data.playerId then
        config.selfDiZhuNums[data.side] = config.selfDiZhuNums[data.side] + data.betValue
        PlayerManager:GetPlayerInfo().goldNum = data.currency or 0; -- 更新金币
        table.insert(config.selfXiaZhuInfo,data)
        self:PayXiaZhuCoinFly(data.side)
        self:UpdateXiaZhuLabel()
        self:UpdateSelfGoldCount()
        return
    end
    -- 其他玩家下注
    local areaTotal = self.ctrl.model.AreaChipTotals
    self:UpdateXiaZhuLabel()
    local playerItem = self:FindPlayerByID(data.playerId)
    if playerItem ~= nil then
        playerItem:UpdateGoldCount(data.currency or 0) --更新数值
    end
    if areaTotal[data.side] >= config.AreaChouMaLimit[data.side] then
        return
    end
    if playerItem ~= nil then
        ChouMaFlyUtil:AnimateCoin(self.dizhuNode,data.index,playerItem.transform.position,self.xiazhuStarAreas[data.side],
                data.betValue)
    else
        ChouMaFlyUtil:AnimateCoin(self.dizhuNode,data.index,self.btn_players.transform.position,self.xiazhuStarAreas[data.side],
                data.betValue)
    end
    areaTotal[data.side] = areaTotal[data.side] + 1
end


---金币回收动画
function DragonTigerFightView:PlayCompeleCoinFLy(results)
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
        local playerItem = self:FindPlayerByID(player.playerId)
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

function DragonTigerFightView:InitChouMa()
    ---底注数值
    for i=1,#self.chipInfos do
        if self.ctrl.model.betPointList[i] then
            self.chipInfos[i].obj:SetActive(true)
            self.chipInfos[i].image.sprite = resMgr:LoadSprite(config.dizhuImgAtlas,"yx_ph_cm_"..i)
            self.chipInfos[i].num.text = StringUtil.CheckDiZhu(self.ctrl.model.betPointList[i])

            local img = ComponentUtilGet.Image(self.dizhuNode.transform,"img")
            local num = ComponentUtilGet.Text(self.dizhuNode.transform,"num")
            img.sprite = resMgr:LoadSprite(config.dizhuImgAtlas,"yx_ph_cm_"..i)
            num.text = self.chipInfos[i].num.text
        else
            self.chipInfos[i].obj:SetActive(false)
        end
    end
    --默认选中第一个
    self:ChangeDiZhu(1)
end

---初始界面
function DragonTigerFightView:InitUI()
    ---续押
    self:SetRepeatState(false)
    ---其他玩家信息
    for i=1,#self.AllOtherPlayerHeads do
        self.AllOtherPlayerHeads[i]:UpdatePlayer(nil)
    end
    self:InitChouMa()
    ---路单数据
    self.RoadHistoryRecord = nil
    
    self.startTrs.gameObject:SetActive(false)
    self.resultTrs.gameObject:SetActive(false)
    self.resultBgTrs.gameObject:SetActive(false)
    
    self.tmp_totalPlayerNum.text="0"
    self.colockStateTimeTrs.gameObject:SetActive(false)
    self.tipsCenterTxt.gameObject:SetActive(false)
    self.tipsStartXiaZhu:SetActive(false)
    self.tipsTimeEnd:SetActive(false)
    self.tipsTimeThree:SetActive(false)
    self.daojishiParticles.gameObject:SetActive(false)
    self:InitXiaZhuLabel()
    
end
---初始化View数据
function DragonTigerFightView:InitPanelData(args)
	
end

function DragonTigerFightView:InitXiaZhuLabel()
    for index=1,3 do
        self.xiazhuSelfNumsLabels[index].transform.parent.gameObject:SetActive(false)
    end
    self.xiazhuNumLabels[1].text = "0" --LocalManager.GetStrById(200101014)
    self.xiazhuNumLabels[2].text = "0" --LocalManager.GetStrById(200101014)
    self.xiazhuNumLabels[3].text = "0" --LocalManager.GetStrById(200101015)
end

function DragonTigerFightView:UpdateXiaZhuLabel()
    for index=1,3 do
        self.xiazhuNumLabels[index].text = config.totalDiZhuNums[index]
        if config.selfDiZhuNums[index]>0 then
            self.xiazhuSelfNumsLabels[index].transform.parent.gameObject:SetActive(true)
            self.xiazhuSelfNumsLabels[index].text = config.selfDiZhuNums[index]
        end
    end
end
---流程 当前牌局状态,1=等待押注,2=押注冻结，等待开牌,3=本局结束
---当前状态剩余秒数

---设置菜单显示隐藏
function DragonTigerFightView:SettingFade()
    if self.settingShow then
        self.settingShow = false
        self.muenRect:DOLocalMoveY(self.muenRect.sizeDelta.y+100,0.5):SetEase(Ease.InBack)
        self.btn_touch.gameObject:SetActive(false)
    else
        self.settingShow = true
        self.muenRect:DOLocalMoveY(0,0.5):SetEase(Ease.OutBack)
        self.btn_touch.gameObject:SetActive(true)
    end
    
end

---显示牌面结果和播放动画
function DragonTigerFightView:ResultEffect(result)
    local cards = {result.loongCard,result.tigerCard}
    for i=1,3 do
        self.resultWinTrs:GetChild(i-1).gameObject:SetActive(false)
    end
    self.resultWinTrs.gameObject:SetActive(true)
    self.resultTrs.gameObject:SetActive(true)
    self.resultBgTrs.gameObject:SetActive(true)
    self.resultCard1:LoadCard(cards[1])
    self.resultCard2:LoadCard(cards[2])
    local p1 = self.ctr_dot_p1.position
    local p2 = self.ctr_dot_p2.position
    
    --下注结束
    self.tipsTimeEnd:SetActive(true)
    
    --等待开牌
    self.resultCard1:Approach(p2,p1)
    self.resultCard2:Approach(Vector3(-p2.x,p2.y),Vector3(-p1.x,p1.y))
    --TimerManager.StopAllTimer(self)
    TimerManager.StartTimer(self, function
    ()
        --正在結算
        self.tipsCenterTxt.gameObject:SetActive(true)
    end, 1, 0, true)
    TimerManager.StartTimer(self, function
    ()
        self.tipsTimeEnd:SetActive(false)
        --开牌
        self.resultCard1:ShowFront()
    end, 2, 0, true)
    TimerManager.StartTimer(self, function
    ()
        self.resultCard2:ShowFront()
    end, 3, 0, true)
    --结果
    TimerManager.StartTimer(self, function
    ()
        if result.winState == DRAGON_TIGER_FIGHT_WIN_SIDE.LONG  then
            self.resultWinTrs:GetChild(0).gameObject:SetActive(true)
        elseif result.winState == DRAGON_TIGER_FIGHT_WIN_SIDE.HU then
            self.resultWinTrs:GetChild(1).gameObject:SetActive(true)
        else
            self.resultWinTrs:GetChild(2).gameObject:SetActive(true)
        end
        --结果动画
        
    end, 4, 0, true)
    
    TimerManager.StartTimer(self, function
    ()
        self.resultWinTrs.gameObject:SetActive(false)
    end,6, 0, true)
    TimerManager.StartTimer(self, function
    ()
        self.resultCard1:Hiden()
        self.resultCard2:Hiden()
        --等待开局提示
        self.tipsCenterTxt.gameObject:SetActive(false)
        --self.tipsCenterTxt.text = LocalManager.GetStrById(200101004)
        
    end,7, 0, true)
    TimerManager.StartTimer(self, function
    ()
        self.resultTrs.gameObject:SetActive(false)
        self.resultBgTrs.gameObject:SetActive(false)
        -- 更新路信息
        self:UpdateRoleView(self.ctrl.model.history)
    end,8, 0, true)
    
end

---开始动画播放
function DragonTigerFightView:StartEffect()
    self.startTrs.gameObject:SetActive(true)
    
    self.startLeftTrs.localPosition = Vector3(-3000,self.startLeftTrs.localPosition.y,0)
    self.startRightTrs.localPosition = Vector3(3000,self.startRightTrs.localPosition.y,0)
    self.startVsTrs.localScale=Vector3(20,20,1)
    local sequence = DOTween.Sequence()
    sequence:Insert(0,self.startLeftTrs:DOLocalMoveX(-540, 0.8):SetEase(Ease.InOutBounce))
    sequence:Insert(0,self.startRightTrs:DOLocalMoveX(540, 0.8):SetEase(Ease.InOutBounce))
    sequence:Append(self.startVsTrs:DOScale(Vector3(0.5,0.5,1),0.4))
    sequence:Join(self.startVsImg:DOFade(1,0.3))
    sequence:Append(self.startVsTrs:DOScale(Vector3(1,1,1),0.2))
    sequence:AppendInterval(1.2)
    sequence:Append(self.startLeftTrs:DOLocalMoveX(-3000, 0.6))
    sequence:Join(self.startRightTrs:DOLocalMoveX(3000, 0.6))
    sequence:Join(self.startVsImg:DOFade(0, 0.6))
    
    sequence:OnComplete(function()
        sequence:Kill(false)
        self.startTrs.gameObject:SetActive(false)
        --开始下注提示
        self.tipsStartXiaZhu:SetActive(true)
        self:UpdateXiaZhuLabel()
        TimerManager.StartTimer(self,function()
            self.tipsStartXiaZhu:SetActive(false)
        end,1.5,0,false)
    end)
    sequence:Play()
    
end

---倒计时3秒
function DragonTigerFightView:PlayDaoJiShiEffect()

    self.daojishiParticles.gameObject:SetActive(true)
    self.tipsTimeThree:SetActive(true)
    if self.daojishiParticles.isStopped  then
        self.daojishiParticles:Play();
    end
end

---更新自己信息
function DragonTigerFightView:UpdateSelf(player)
    self.selfPlayer:UpdatePlayer(player)
end
function DragonTigerFightView:UpdateSelfGoldCount()
    self.selfPlayer:UpdateGoldCount(PlayerManager:GetPlayerInfo().goldNum)
end
---其他玩家信息更新
function DragonTigerFightView:UpdatePlayers(players)
    if players ~= nil and #players > 0 then
        -- 只取前6名
        local total = Mathf.Max(6,#players)
        local index = 1
        for i = 1, total do
            if players[i] and players[i].playerId == PlayerManager:GetPlayerInfo().playerId then
                self:UpdateSelf(players[i])
                goto continue
            end
            if index >= 6 then
                goto continue
            end
            if players[i] then
                self.AllOtherPlayerHeads[index]:UpdatePlayer(players[i])
            else
                self.AllOtherPlayerHeads[index]:UpdatePlayer(nil)
            end
            index = index + 1
            ::continue::
        end
    end
    --更新房间玩家总数
    self.tmp_totalPlayerNum.text = self.ctrl.model.playersNum
end

---更新路信息
function DragonTigerFightView:UpdateRoleView(data)
    self.RoadHistoryRecord = {}
    for i=1,#data do
        table.insert(self.RoadHistoryRecord,{seri_id=i,win_side=data[i]})
    end
    self.roadView:UpdatePanelInfo(self.RoadHistoryRecord, true)
end

-- 更新房间信息
function DragonTigerFightView:UpdateRoomInfo(model)
    Debug.Log("更新房间信息")
    -- 1. 初始化UI状态
    self:InitUI()
    
    -- 2.更新玩家
    self:UpdatePlayers(model.players)
    self:UpdateSelf(PlayerManager:GetPlayerInfo())
    
    -- 3. 刷新路信息
    self:UpdateRoleView(model.history)

    -- 4. 刷新押注池信息
    if model.sideBetInfos then
        for k,value in pairs(model.sideBetInfos) do
            local side = value.betIdx-config.gameID*100
            -- 更新总押注金额
            config.totalDiZhuNums[side] = value.betIdxTotal
            -- 更新玩家区域押注金额
            config.selfDiZhuNums[side] = value.betValue
            -- 更新区域筹码显示
            self:ShowAreaChouMa(value)
        end
        self:UpdateXiaZhuLabel()
    end

    -- 5. 刷新当前游戏状态和倒计时
    local lessTime = Tools.CacStageLessTime(model.status,ServerTimeSync:GetTimeStamp(),model.endTime,config.StageTime)
    look("当前阶段剩余时间（毫秒）："..lessTime)
    if lessTime<=0 then
        if model.status<4 then
            --进行下一阶段
            self:OnGameStatus(model.status+1)
            --else本轮游戏已结束 等待重新开始 
        end
    elseif model.status==3 then
        -- 当前阶段还未结束
        self:OnGameStatus(model.status,Mathf.Round(lessTime/1000))
    end
    
end


-- 直接显示区域筹码 SideBetInfo
function DragonTigerFightView:ShowAreaChouMa(sideInfo)
    if not sideInfo.betGoldList then return end
    local areaTotal = self.ctrl.model.AreaChipTotals
    local side = sideInfo.betIdx-config.gameID*100
    for ix=1,#sideInfo.betGoldList do
        local value = sideInfo.BetInfos[ix]
        local index = self.ctrl.model:FindBetIndex(value)
        if areaTotal[side] < config.AreaChouMaLimit[side] then
            areaTotal[side]=areaTotal[side]+1
            ChouMaFlyUtil:CreatCoinInArea(self.dizhuNode,index,self.xiazhuStarAreas[side],value)
        end
    end
end

function DragonTigerFightView:NextStage(time)
    if self.nextTimer then
        TimerManager.StopTimer(self,self.nextTimer)
        self.nextTimer = nil
    end

    if time<=0 then
        self:OnGameStatus(self.ctrl.model.status+1)
        return
    end
    
    self.nextTimer = TimerManager.StartTimer(self, function()
        self:OnGameStatus(self.ctrl.model.status+1)
        self.nextTimer = nil
    end,time,0,false)
end

-- 切换状态
function DragonTigerFightView:OnGameStatus(status,time)
    logError("OnGameStatus:"..status.." time:"..(time or ""))
    -- status: 1准备阶段，2押分阶段，3亮牌阶段，4结算阶段
    self.ctrl.model.status = status
    config.lessSeconds = time or Mathf.Round(config.StageTime[status]/1000)
    config.allow= status==2
    
    -- 隐藏所有阶段相关UI
    self.tipsStartXiaZhu:SetActive(false)
    self.tipsTimeEnd:SetActive(false)
    self.tipsTimeThree:SetActive(false)
    self.colockStateTimeTrs.gameObject:SetActive(false)
    self.resultTrs.gameObject:SetActive(false)
    self.resultBgTrs.gameObject:SetActive(false)
    self.resultWinTrs.gameObject:SetActive(false)
    self.tipsCenterTxt.gameObject:SetActive(false)
    self.daojishiParticles.gameObject:SetActive(false)

    if self.statusTimer then
        TimerManager.StopTimer(self,self.statusTimer)
        self.statusTimer = nil
    end
    --self.debugTxt.text = "status："..status..config.allow
    --self.debugTime.text = os.date("%Y-%m-%d %H:%M:%S", ServerTimeSync:GetTimeStamp()/1000) 
    if status == 1 then -- 准备阶段
        self.ctrl.model:ResetConfig()
        self:UpdateDiZhuBtnState()
        self:SetRepeatState(false)
        self:StartEffect()
    elseif status == 2 then -- 押分阶段
        self:UpdateDiZhuBtnState()
        self:SetRepeatState(#config.lastXiaZhuInfo > 0 and not config.isRepeat)
        
        self.colockStateTimeTrs.gameObject:SetActive(true)
        self.colockStateTimeNum.text = tostring(config.lessSeconds)
        -- 启动倒计时
        self.statusTimer = TimerManager.StartTimer(self, function()
            config.lessSeconds = config.lessSeconds - 1
            self.colockStateTimeNum.text = tostring(config.lessSeconds)
            if config.lessSeconds == 3 then
                self.colockStateTimeTrs.gameObject:SetActive(false)
                self:PlayDaoJiShiEffect()
            end
            if config.lessSeconds <= 0 then
                TimerManager.StopTimer(self,self.statusTimer)
                self.statusTimer = nil
            end
        end, 1, config.lessSeconds, true)
    elseif status == 3 then -- 亮牌阶段
        self:UpdateDiZhuBtnState()
        self:SetRepeatState(false)
        self.tipsTimeEnd:SetActive(true)
        self.tipsCenterTxt.gameObject:SetActive(true)
        self.resultTrs.gameObject:SetActive(true)
        self.resultBgTrs.gameObject:SetActive(true)
    elseif status == 4 then -- 结算阶段
        self:UpdateDiZhuBtnState()
        self:RepeatInit()
        self:InitXiaZhuLabel()
    end

    if status==3 then
        local nextTime = Mathf.Round(config.StageTime[status+1]/1000)
        if time and nextTime>0 then
            nextTime = nextTime - config.StageTime[status] + time --时间差补偿
        end
        self:NextStage(nextTime)
    end
end

---复投功能
function DragonTigerFightView:RepeatInit()
    logError("复投功能 RepeatInit")
    if config.isRepeat then
        config.lastXiaZhuInfo={}
    else
        config.lastXiaZhuInfo = config.selfXiaZhuInfo
    end
    config.selfXiaZhuInfo = {}
    config.isRepeat = false
    
    self:SetRepeatState(false)
end

---关闭界面
function DragonTigerFightView:Close()
    ChouMaFlyUtil:Destroy()
    TimerManager.StopAllTimer(self)
    self.super.Close(self);
end

return DragonTigerFightView