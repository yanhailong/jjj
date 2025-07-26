---
---Create by Administrator
---DateTime: 2025-06-21 15:09:13
---
---@class DragonTigerFightView:BaseView
local DragonTigerFightView=Class("DragonTigerFightView",BaseView)
local config=require("SingleGames/DragonTigerFight/DragonTigerFightConfig")
local ChouMaFlyUtil=require("Logic/Common/ChouMaFlyUtil")
local PlayerItem = require("SingleGames/DragonTigerFight/View/Item/PlayerItem")
local RoadView = require("SingleGames/DragonTigerFight/View/RoadView")
local CardItem = require("SingleGames/DragonTigerFight/View/Item/CardItem")
local DragonTigerFightSounds = require("SingleGames/DragonTigerFight/DragonTigerFightSounds")

local DOTween = CS.DG.Tweening.DOTween
local Ease = CS.DG.Tweening.Ease

---初始化panel
function DragonTigerFightView:InitView()
	---@type DragonTigerFightCtrl
    self.ctrl=self.ctrl
    self.bettingTime = 0
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
    self.xiazhuSelfNumsLabels = {}
    self.xiazhuSelfNumsLabels[1] = ComponentUtilGet.TextMeshProUGUI(self.longClickArea,"yazhuNum/num")
    self.xiazhuSelfNumsLabels[2] = ComponentUtilGet.TextMeshProUGUI(self.huClickArea,"yazhuNum/num")
    self.xiazhuSelfNumsLabels[3] = ComponentUtilGet.TextMeshProUGUI(self.heClickArea,"yazhuNum/num")

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
    self.tipsTimeEnd = ComponentUtilGet.GameObject(self.tipsTrs,"eff_DragonTigerFight_EndOfBetting")
    self.tipsTimeEndSp=ComponentUtilGet.SkeletonGraphic(self.tipsTimeEnd.transform,"SkeletonGraphic (kaishijieshuxiazhu)")
    self.tipsStartXiaZhu = ComponentUtilGet.GameObject(self.tipsTrs,"eff_DragonTigerFight_StartBetting")
    self.tipsStartXiaZhuSp=ComponentUtilGet.SkeletonGraphic(self.tipsStartXiaZhu.transform,"SkeletonGraphic (kaishijieshuxiazhu)")
    
    self.tipsTimeThree = ComponentUtilGet.GameObject(self.tipsTrs,"tips_time_three")
    -- 结算中
    self.tipsCenterTxt = ComponentUtilGet.Transform(self.tipsTrs,"tips_center/tips_center_txt")
    self.tipsWaitopenTxt = ComponentUtilGet.Transform(self.tipsTrs,"tips_center/tips_waitopen_txt") 
    self.colockStateTimeTrs = ComponentUtilGet.Transform(self.tipsTrs,"tips_center/colock_state_time")
    self.colockStateTimeNum=ComponentUtilGet.Text(self.colockStateTimeTrs,"time") --倒计时
    self.colockNumTrs=ComponentUtilGet.Transform(self.tipsTrs,"tips_center/colock_num")
    self.colockNumTime=ComponentUtilGet.Text(self.colockNumTrs,"time")
    self.tipsEnterWait=ComponentUtilGet.Transform(self.tipsTrs,"tips_enter_wait")
    self.tipsEnterWaitTime=ComponentUtilGet.Text(self.tipsEnterWait,"naozhong/time")
    
    self.daojishiParticles =ComponentUtilGet.GameObject(self.tipsTrs,"eff_daojishi/eff_daojishi"):GetComponent("ParticleSystem")
    self.huWo=ComponentUtilGet.GameObject(self.tipsTrs,"eff_DragonTigerFight_hu_won/eff_DragonTigerFight_hu_won"):GetComponent("ParticleSystem")
    self.longWo=ComponentUtilGet.GameObject(self.tipsTrs,"eff_DragonTigerFight_long_won/eff_DragonTigerFight_long_won"):GetComponent("ParticleSystem")
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
    self.resultBgTrs=ComponentUtilGet.Transform(self.transform,"Background/resoult")
    self.resultWinTrs=ComponentUtilGet.Transform(self.resultTrs,"win")
    ---@type CardItem
    self.resultCard1=CardItem.New(ComponentUtilGet.GameObject(self.resultTrs,"card/left"))
    ---@type CardItem
    self.resultCard2=CardItem.New(ComponentUtilGet.GameObject(self.resultTrs,"card/right"))
    self.ctr_dot_p1=ComponentUtilGet.Transform(self.effectsTrs,"dot/p1")
    self.ctr_dot_p2=ComponentUtilGet.Transform(self.effectsTrs,"dot/p2")

    self.startTrs=ComponentUtilGet.Transform(self.effectsTrs,"eff_DragonTigerFight_VS")
    self.startSp=ComponentUtilGet.SkeletonGraphic(self.startTrs,"SkeletonGraphic (vs)")

end

---清空组件
function DragonTigerFightView:ClearComponents()
    self.btn_close=nil;
    self.btn_repeat=nil;
    self.btn_players=nil;
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
        self.chipInfos[i].button.interactable = config.allow and self.model.betPointList[i]<=PlayerManager:GetPlayerInfo().goldNum
    end
    if self.chipInfos[config.dizhuIndex] then self.chipInfos[config.dizhuIndex].effects:SetActive(config.allow) end
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
            self.model.betPointList[config.dizhuIndex])
    --下注音效
    DragonTigerFightSounds.PlaySoundEffic(config.AUDIO_KEY.ADD_CHIP)
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
    local areaTotal = self.model.AreaChipTotals
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
    DragonTigerFightSounds.OtherFlyBet()
end


---金币回收动画
function DragonTigerFightView:PlayCompeleCoinFLy(results)
    --数据处理 winCurrency
    local targetPos = {}
    local winCurrency = {0,0}
    local totalCurrency = 0
    targetPos[1] = self.selfPlayerRoot.transform.position
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
    DragonTigerFightSounds.PlaySoundEffic(config.AUDIO_KEY.END_COIN_FLY)
end

function DragonTigerFightView:InitChouMa()
    ---底注数值
    for i=1,#self.chipInfos do
        if self.model.betPointList[i] then
            self.chipInfos[i].obj:SetActive(true)
            self.chipInfos[i].image.sprite = resMgr:LoadSprite(config.dizhuImgAtlas,"yx_ph_cm_"..i)
            self.chipInfos[i].num.text = StringUtil.CheckDiZhu(self.model.betPointList[i])

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
    DragonTigerFightSounds.PlaySoundMusic()
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
    self.tipsWaitopenTxt.gameObject:SetActive(false)
    self.tipsStartXiaZhu:SetActive(false)
    self.tipsTimeEnd:SetActive(false)
    self.tipsTimeThree:SetActive(false)
    self.daojishiParticles.gameObject:SetActive(false)
    self.resultWinTrs.gameObject:SetActive(false)
    self.colockNumTrs.gameObject:SetActive(false)
    self.tipsEnterWait.gameObject:SetActive(false)
    self.resultCard1:Hiden()
    self.resultCard2:Hiden()
    self.roadView.gameObject:SetActive(true)
    self:InitXiaZhuLabel()
    UpdateManager.AddUpdate(self,self.UpdateBetting)
    GameObject.Destroy(ComponentUtilGet.HorizontalLayoutGroup(self.dizhu))
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

function DragonTigerFightView:ResultStageTimer(stage)
    if self.resultTimer then
        TimerManager.StopTimer(self,self.resultTimer)
        self.resultTimer = nil
    end
    self.resultTimer = TimerManager.StartTimer(self,function() 
        self:ResultStage(stage)
        if stage<#config.ResultStageTime then
            self:ResultStageTimer(stage+1)
        end
    end,config.ResultStageTime[stage],0,false)
end

function DragonTigerFightView:ResultStage(stage)
    local result = self.model.Result

    if stage == 1 then --发牌
        --等待开牌
        local p1 = self.ctr_dot_p1.position
        local p2 = self.ctr_dot_p2.position
        self.resultCard1:Approach(p2,p1)
        self.resultCard2:Approach(Vector3(-p2.x,p2.y),Vector3(-p1.x,p1.y))
    elseif stage == 2 then --正在結算
        self.tipsCenterTxt.gameObject:SetActive(true)
        DragonTigerFightSounds.PlaySoundEffic(config.AUDIO_KEY.DEAL)
    elseif stage == 3 then--开牌
        self.tipsTimeEnd:SetActive(false)
        self.resultCard1:ShowFront()
        DragonTigerFightSounds.PlaySoundEffic(config.AUDIO_KEY.FLIP_CARD)
    elseif stage == 4 then--开牌
        self.resultCard2:ShowFront()
        DragonTigerFightSounds.PlaySoundEffic(config.AUDIO_KEY.FLIP_CARD)
    elseif stage == 5 then
        if result.winState == DRAGON_TIGER_FIGHT_WIN_SIDE.LONG  then
            self.resultWinTrs:GetChild(0).gameObject:SetActive(true)
            --结果动画
            self.longWo.gameObject:SetActive(true)
            if self.longWo.isStopped then
                self.longWo:Play()
            end
            DragonTigerFightSounds.PlaySoundWin(result.winState,true)
        elseif result.winState == DRAGON_TIGER_FIGHT_WIN_SIDE.HU then
            self.resultWinTrs:GetChild(1).gameObject:SetActive(true)
            --结果动画
            self.huWo.gameObject:SetActive(true)
            if self.huWo.isStopped then
                self.huWo:Play()
            end
            DragonTigerFightSounds.PlaySoundWin(result.winState,true)
        else
            self.resultWinTrs:GetChild(2).gameObject:SetActive(true)
        end
        DragonTigerFightSounds.PlaySoundWin(result.winState)
        
    elseif stage==6 then
        self.huWo.gameObject:SetActive(false)
        self.longWo.gameObject:SetActive(false)
        self.resultWinTrs.gameObject:SetActive(false)
        ---金币回收动画
        self:PlayCompeleCoinFLy(result.playerSettleInfos)
        --- 更新获奖玩家金币
        self:UpdatePlayers(result.playerInfos)
        ---更新状态
        self:OnGameStatus(4)
    elseif stage==7 then
        self.resultCard1:Hiden()
        self.resultCard2:Hiden()
        self.tipsCenterTxt.gameObject:SetActive(false)
        --等待开局
        self.tipsWaitopenTxt.gameObject:SetActive(true)
    elseif stage==8 then
        self.resultTrs.gameObject:SetActive(false)
        self.resultBgTrs.gameObject:SetActive(false)
        self.roadView.gameObject:SetActive(true)
        -- 更新路信息
        self:UpdateRoleView(self.model.history)
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
    self.roadView.gameObject:SetActive(false)
    --下注结束
    self.tipsTimeEnd:SetActive(true)
    Tools.PlayerSpineAniByName(self.tipsTimeEndSp,"jieshuxiazhu",false)
    DragonTigerFightSounds.PlaySoundEffic(config.AUDIO_KEY.BET_END)
    
    self:ResultStageTimer(1)
end

---开始动画播放 2s
function DragonTigerFightView:StartEffect()
    self.startTrs.gameObject:SetActive(true)
    Tools.PlayerSpineAniByName(self.startSp,"action",false)
    DragonTigerFightSounds.PlaySoundEffic(config.AUDIO_KEY.BET_READY)
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

    self.tmp_totalPlayerNum.text = self.model.playersNum
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
            local side = value.betIdx<config.gameID and value.betIdx or value.betIdx-config.gameID*100
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
    -- 在亮牌和结算阶段进来，就从亮牌开始播，直至下一局开始
    -- 如果播不完就立即结束动画，可以直接中断，需要回收金币表现奖励那些可以都不播，直接消失
    local lessTime = Tools.CacStageLessTime(model.status,ServerTimeSync:GetTimeStamp(),model.endTime,config.StageTime)
    look("当前阶段剩余时间（毫秒）："..lessTime)
    if lessTime<=0 then
        --进行下一阶段
        if model.status<4 then self:OnGameStatus(model.status+1) end
    else--更新当前阶段
        self:OnGameStatus(model.status)
    end
    
    -- 提示 等待本对局结束
    if model.Result or (lessTime<=0 and model.status==2) then--有结果 或者 发消息的时候还没结束但是收到消息已结束
        local lessSeconds = Mathf.Round((model.endTime - ServerTimeSync:GetTimeStamp())/1000)
        if lessSeconds>1 then--时间太少不展示
            self.tipsEnterWait.gameObject:SetActive(true)
            self.tipsEnterWaitTime.text = tostring(lessSeconds)
            TimerManager.StartTimer(self,function()
                lessSeconds = lessSeconds - 1
                self.tipsEnterWaitTime.text = tostring(lessSeconds)
                logError("tipsEnterWait:"..lessSeconds)
                if lessSeconds<=0 then
                    self.tipsEnterWait.gameObject:SetActive(false)
                end
            end,1, lessSeconds,false)
        end
    end
end


-- 直接显示区域筹码 SideBetInfo
function DragonTigerFightView:ShowAreaChouMa(sideInfo)
    if not sideInfo.betGoldList then return end
    local areaTotal = self.model.AreaChipTotals
    local side = sideInfo.betIdx<config.gameID and sideInfo.betIdx or sideInfo.betIdx-config.gameID*100
    for ix=1,#sideInfo.betGoldList do
        local value = sideInfo.BetInfos[ix]
        local index = self.ctrl.model:FindBetIndex(value)
        if areaTotal[side] < config.AreaChouMaLimit[side] then
            areaTotal[side]=areaTotal[side]+1
            ChouMaFlyUtil:CreatCoinInArea(self.dizhuNode,index,self.xiazhuStarAreas[side],value)
        end
    end
end

--单独飞筹码处理 防止频繁UI更新卡住
function DragonTigerFightView:UpdateBetting()
    if  not config.allow or Time.realtimeSinceStartup - self.bettingTime < 0.1 then return end
    self.bettingTime = Time.realtimeSinceStartup

    for playerId, msg in pairs(self.model.bettingDataMap) do
        if not msg.handled then
            for _, value in ipairs(msg.betTableInfoList) do
                local bet = {
                    side = value.betIdx<config.gameID and value.betIdx or value.betIdx-config.gameID*100,
                    index = self.ctrl.model:FindBetIndex(value.betValue),
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

-- 切换状态
function DragonTigerFightView:OnGameStatus(status)
    logError("OnGameStatus:"..status)
    -- status: 1准备阶段，2押分阶段，3亮牌阶段，4结算阶段
    self.model.status = status
    config.lessSeconds = Mathf.Round(config.StageTime[status]/1000)
    config.allow= status==2

    -- 结算阶段 特殊处理
    if status == 4 then
        self:UpdateDiZhuBtnState()
        self:RepeatInit()
        self:InitXiaZhuLabel()
        return
    end
    
    -- 隐藏所有阶段相关UI
    self.tipsStartXiaZhu:SetActive(false)
    self.tipsTimeEnd:SetActive(false)
    self.tipsTimeThree:SetActive(false)
    self.startTrs.gameObject:SetActive(true)
    self.colockStateTimeTrs.gameObject:SetActive(false)
    self.resultTrs.gameObject:SetActive(false)
    self.resultBgTrs.gameObject:SetActive(false)
    self.resultWinTrs.gameObject:SetActive(false)
    self.tipsCenterTxt.gameObject:SetActive(false)
    self.tipsWaitopenTxt.gameObject:SetActive(false)
    self.daojishiParticles.gameObject:SetActive(false)
    self.tipsEnterWait.gameObject:SetActive(false)
    self.colockNumTrs.gameObject:SetActive(false)
    self.roadView.gameObject:SetActive(true)
    self.huWo.gameObject:SetActive(false)
    self.longWo.gameObject:SetActive(false)
    self.resultCard1:Hiden()
    self.resultCard2:Hiden()
    
    if self.statusTimer then
        TimerManager.StopTimer(self,self.statusTimer)
        self.statusTimer = nil
    end
    if self.resultTimer then
        TimerManager.StopTimer(self,self.resultTimer)
        self.resultTimer = nil
    end

    if status == 1 then -- 准备阶段
        self.ctrl.model:ResetConfig()
        self:UpdateDiZhuBtnState()
        self:SetRepeatState(false)
        self:StartEffect()
    elseif status == 2 then -- 押分阶段
        self:UpdateDiZhuBtnState()
        self:SetRepeatState(#config.lastXiaZhuInfo > 0 and not config.isRepeat)
        --开始下注提示
        self.tipsStartXiaZhu:SetActive(true)
        Tools.PlayerSpineAniByName(self.tipsStartXiaZhuSp,"kaishixiazhu",false)
        DragonTigerFightSounds.PlaySoundEffic(config.AUDIO_KEY.BET_START)
        
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
                return
            end
            if config.lessSeconds<=3 then--倒计时音效
                DragonTigerFightSounds.PlaySoundEffic(config.AUDIO_KEY.DJS_NUM)
            end
            if config.lessSeconds == 11 then--关闭开始下注提示
                self.tipsStartXiaZhu:SetActive(false)
            end
        end, 1, config.lessSeconds, true)
    elseif status == 3 then -- 亮牌阶段
        self:UpdateDiZhuBtnState()
        self:SetRepeatState(false)
        self.resultTrs.gameObject:SetActive(true)
        self.resultBgTrs.gameObject:SetActive(true)
        DragonTigerFightSounds.PlaySoundEffic(config.AUDIO_KEY.DJS_END)
    end
end

---复投功能
function DragonTigerFightView:RepeatInit()
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
    UpdateManager.ReMoveAll(self)
    DragonTigerFightSounds.StopSoundMusic()
    self.super.Close(self);
end

return DragonTigerFightView