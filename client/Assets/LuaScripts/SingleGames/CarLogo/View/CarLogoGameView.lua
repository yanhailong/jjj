---
---Create by Administrator
---DateTime: 2025-06-30 15:05:04
---
---@class CarLogoGameView:BaseView
local CarLogoGameView=Class("CarLogoGameView",BaseView)
local CarLogoItem=require("SingleGames/CarLogo/View/Item/CarLogoItem")
local CarLogoHistoryItem=require("SingleGames/CarLogo/View/Item/CarLogoHistoryItem")
local CarLogoAreaItem=require("SingleGames/CarLogo/View/Item/CarLogoAreaItem")
local config =require("SingleGames/CarLogo/CarLogoConfig")
local CarLogoHelper=require("SingleGames/CarLogo/CarLogoHelper")
local ChouMaFlyUtil=require("Logic/Common/ChouMaFlyUtil")
local CarLogoPlayerItem = require("SingleGames/CarLogo/View/Item/CarLogoPlayerItem")
local CarLogoSounds =  require("SingleGames/CarLogo/CarLogoSounds")

local DOTween = CS.DG.Tweening.DOTween
local Ease = CS.DG.Tweening.Ease
DOTween:SetTweensCapacity(1000, 250);
---初始化panel
function CarLogoGameView:InitView()
	---@type CarLogoGameCtrl
    self.ctrl=self.ctrl
    self.bettingTime = 0
	self:InitComponents()
end

---获取组件
function CarLogoGameView:InitComponents()
    self.btn_trend=ComponentUtilGet.Button(self.transform,"content/top/history/btn_trend");
    self.btn_recharge=ComponentUtilGet.Button(self.transform,"content/top/btn_recharge");
    self.btn_players=ComponentUtilGet.Button(self.transform,"content/bottom/btn_players");
    self.btn_repeat=ComponentUtilGet.Button(self.transform,"content/bottom/btn_repeat")
    self.tmp_playerNum=ComponentUtilGet.TextMeshProUGUI(self.transform,"content/bottom/btn_players/tmp_playerNum");
    self.img_car=ComponentUtilGet.Image(self.transform,"content/center/result/Car/img_car");
    self.img_icon=ComponentUtilGet.Image(self.transform,"content/center/result/Car/img_icon");
    self.muenRect=ComponentUtilGet.RectTransform(self.transform,"content/setting/mask/muen")
    self.btn_touch=ComponentUtilGet.Button(self.transform,"content/setting/btn_touch");
    self.btn_muen=ComponentUtilGet.Button(self.transform,"content/setting/btn_muen");
    self.btn_setting=ComponentUtilGet.Button(self.transform,"content/setting/mask/muen/btn_setting");
    self.btn_help=ComponentUtilGet.Button(self.transform,"content/setting/mask/muen/btn_help");
    self.btn_close=ComponentUtilGet.Button(self.transform,"content/setting/mask/muen/btn_close");

    self.tmp_totalPlayerNum=ComponentUtilGet.Text(self.btn_players.transform,"tmp_playerNum")
    ---提示信息
    self.tipsTrs = ComponentUtilGet.Transform(self.transform,"content/center/tips")

    self.tipsTimeEnd = ComponentUtilGet.GameObject(self.tipsTrs,"effect_CarLogo_EndOfBetting")
    self.tipsTimeEndSp=ComponentUtilGet.SkeletonGraphic(self.tipsTimeEnd.transform,"SkeletonGraphic (kaishijieshuxiazhu)")
    self.tipsStartXiaZhu = ComponentUtilGet.GameObject(self.tipsTrs,"effect_CarLogo_StartBetting")
    self.tipsStartXiaZhuSp=ComponentUtilGet.SkeletonGraphic(self.tipsStartXiaZhu.transform,"SkeletonGraphic (kaishijieshuxiazhu)")

    self.colockStateTimeTrs = ComponentUtilGet.Transform(self.transform,"content/center/timer")
    self.colockStateLeftText1=ComponentUtilGet.GameObject(self.colockStateTimeTrs,"tips1") --倒计时
    self.colockStateLeftText2=ComponentUtilGet.GameObject(self.colockStateTimeTrs,"tips2") --倒计时
    self.colockStateTimeNum=ComponentUtilGet.Text(self.colockStateTimeTrs,"tmp_time") --倒计时
    self.daojishiParticles =ComponentUtilGet.GameObject(self.tipsTrs,"eff_daojishi/eff_daojishi"):GetComponent("ParticleSystem")

    self.resultTrs=ComponentUtilGet.Transform(self.transform,"content/center/result");
    self.resultCar=ComponentUtilGet.GameObject(self.resultTrs,"Car")
    self.resultCarObj=ComponentUtilGet.Transform(self.resultTrs,"Car/carObj")
    self.resultLogoObj=ComponentUtilGet.Transform(self.resultTrs,"Car/logoObj")
    ---下注区域
    self.areasTrs=ComponentUtilGet.Transform(self.transform,"content/center/areas")
    ---@type CarLogoAreaItem[]
    self.areaViews = {};
    for i = 1, self.areasTrs.childCount do
        self.areaViews[i] = CarLogoAreaItem.New(self.areasTrs:GetChild(i-1));
    end
    ---车标 跑马灯
    self.logosTrs=ComponentUtilGet.Transform(self.transform,"content/center/logos")
    local logoItem=ComponentUtilGet.Transform(self.transform,"content/center/logositem/1")
    ---@type CarLogoItem[]
    self.logoViews = {};
    for i = 1, self.logosTrs.childCount do
        local parent = self.logosTrs:GetChild(i-1)
        self.logoViews[i] = CarLogoItem.New(Tools.Instance(logoItem,parent))
    end
    
    ---历史信息
    self.historyObj=ComponentUtilGet.GameObject(self.transform,"content/top/history")
    ---@type CarLogoHistoryItem
    self.history=CarLogoHistoryItem.New(self.historyObj)

    self.dizhu=ComponentUtilGet.Transform(self.transform,"content/bottom/chouma/Viewport/Content");
    self.btn_prev = ComponentUtilGet.Button(self.transform, "content/bottom/chouma/prev");
    self.btn_next = ComponentUtilGet.Button(self.transform, "content/bottom/chouma/next");
    self.img_prev = ComponentUtilGet.Image(self.btn_prev.transform,"img");
    self.img_next = ComponentUtilGet.Image(self.btn_next.transform,"img");
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
    ---玩家
    self.selfPlayerRoot  = ComponentUtilGet.GameObject(self.transform,"content/bottom/SelfHead")
    self.selfPlayer = CarLogoPlayerItem.New(self.selfPlayerRoot)
    ---底注节点prefab
    self.dizhuNode = ComponentUtilGet.GameObject(self.transform,"content/bottom/nodes")
end

---清空组件
function CarLogoGameView:ClearComponents()
    self.btn_trend=nil;
    self.btn_recharge=nil;
    self.btn_players=nil;
    self.tmp_playerNum=nil;
    self.img_car=nil;
    self.img_icon=nil;
    self.tmp_time=nil;
    self.btn_touch=nil;
    self.btn_muen=nil;
    self.btn_setting=nil;
    self.btn_help=nil;
    self.btn_close=nil;
    self.chipInfos={}
end

---初始化View数据
function CarLogoGameView:InitPanelData(args)
    self.selectIndex=args
    self:InitMarquee()
    self:InitLogos()
end

function CarLogoGameView:InitChouMa()
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


function CarLogoGameView:InitUI()
    CarLogoSounds.PlaySoundMusic()
    ---续押
    self:SetRepeatState(false)
    self:InitChouMa()

    --请下注提示
    self.tmp_totalPlayerNum.text="0"
    self.daojishiParticles.gameObject:SetActive(false)
    self.resultTrs.gameObject:SetActive(true);
    self.tipsTimeEnd:SetActive(false)
    self.tipsStartXiaZhu:SetActive(false)
    self:InitXiaZhuLabel()
    UpdateManager.AddUpdate(self,self.UpdateBetting)
    GameObject.Destroy(ComponentUtilGet.HorizontalLayoutGroup(self.dizhu))
end

function CarLogoGameView:DizhuPrev(isNext)
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

---初始化车标
function CarLogoGameView:InitLogos()
    for logo_id, indexs in ipairs(config.LOGO_IDX) do
        for i, index in ipairs(indexs) do
            self.logoViews[index]:ShowLogo(logo_id);
        end
    end
end

---闪灯
function CarLogoGameView:FlashLight()
    local time  = 0.3
    for i=1,#self.logoViews do
        self.logoViews[i]:FlashLight(time,2)
    end
end

function CarLogoGameView:EnterLight()
    local time  = 0.2
    for i=1,#self.logoViews do
        self.logoViews[i]:FlashLight(time,4)
    end
end

function CarLogoGameView:LogoShowLinght(index)
    for i, view in ipairs(self.logoViews) do
        view:ShowChoose(true,i ~= index)
    end
end

function CarLogoGameView:DizhuPrev(isNext)
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

------start Logo Marquee-----
function CarLogoGameView:InitMarquee()
    self.marqueeCallFunc = nil
    if self.marqueeCor then
        coroutine.stop(self.marqueeCor)
        self.marqueeCor = nil
    end
    
    self.curve = CS.UnityEngine.AnimationCurve()
    for i=1,#config.CURVE_KEYS do 
        self.curve:AddKey(config.CURVE_KEYS[i][1], config.CURVE_KEYS[i][2])
    end
end

function CarLogoGameView:IntMove(from, to, leftTime, time)
    time = time or 6
    if leftTime > 0 then
        leftTime =  leftTime > time and time or leftTime
        to = to + config.LOGO_MAX * 3
        
        local startTime = Time.realtimeSinceStartup - (time - leftTime);
        local deltaTime = Time.realtimeSinceStartup - startTime;
        local lastIndex = from + Mathf.FloorToInt(self.curve:Evaluate(deltaTime / time) * (to - from)) - 1
        local newIndex = lastIndex
        local runIndex = 0
        
        self.marqueeCor=coroutine.start( function()
            while deltaTime<time and lastIndex<to do
                deltaTime = Time.realtimeSinceStartup - startTime;
                newIndex = from + Mathf.FloorToInt(self.curve:Evaluate(deltaTime / time) * (to - from))
                for i = lastIndex + 1, newIndex do
                    lastIndex = i;

                    local index = i% config.LOGO_MAX
                    if index<=0 then
                        index = index + config.LOGO_MAX
                    end

                    self.logoViews[index]:ShowChoose(true)
                    if runIndex>0 then
                        self.logoViews[runIndex]:ShowChoose(true, true)
                    end
                    runIndex = index
                end
                coroutine.yield(CS.UnityEngine.WaitForEndOfFrame())
            end
            coroutine.stop(self.marqueeCor)
            self.marqueeCor = nil
            
            if self.marqueeCallFunc then
                self.marqueeCallFunc()
                self.marqueeCallFunc = nil
            end
        end)
    end
end
------end Logo Marquee-----

---设置菜单显示隐藏
function CarLogoGameView:SettingFade()
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

---
function CarLogoGameView:LogoFlyToHistory(index)
    look(index)
    self.history:PlayMoveAni(self.model.history)
    self.logoViews[index]:FlyLogoHistory(self.resultTrs,self.history:GetPoint())

end

--隐藏所有Logo的选中效果
function CarLogoGameView:UnChooseAllLogos()
    for i, v in ipairs(self.logoViews) do
        v:ShowChoose(false);
    end
end

--播放奔跑动画
function CarLogoGameView:PlayRuningAnimtion(result, isPlay, callFunc)
    if isPlay then
        CarLogoSounds.PlaySoundEffic(config.AUDIO_KEY.Running)
        self.marqueeCallFunc = callFunc
        self:IntMove(self.model.lastIndex, result.rewardAreaIdx,6,6)
    else
        self.LogoShowLinght(result.rewardAreaIdx)
        --self.history:UpdateBirdsAnimals(self.model.history)
        if callFunc then  callFunc() end
    end
end

function CarLogoGameView:PlayCarEffectView(logo_id,callFunc)
    self.resultCar:SetActive(true)
    self.areasTrs.gameObject:SetActive(false)
    self.img_icon.sprite=CarLogoHelper.LoadLogoSprite(logo_id)
    self.img_car.sprite=CarLogoHelper.LoadLogoResultSprite(logo_id)
    local carEff = CarLogoHelper.LoadLogoResultCar(logo_id)
    local logoEff = CarLogoHelper.LoadLogoResultLogo(logo_id)
    logoEff.transform:SetParent(self.resultLogoObj)
    
    self.img_car.transform.localScale=Vector3.Zero()
    self.img_car.transform:DOScale(Vector3(1,1,1),0.3):SetEase(Ease.InBack):OnComplete(function()
        carEff.transform:SetParent(self.resultCarObj)
    end)
    
    TimerManager.StartTimer(self,function()
        self.resultCar:SetActive(false)
        self.areasTrs.gameObject:SetActive(true)
        GameObject.Destroy(carEff)
        GameObject.Destroy(logoEff)
        
        if callFunc then callFunc() end
    end,1.2)
end

function CarLogoGameView:ResultStageTimer(stage)
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

function CarLogoGameView:ResultStage(stage)
    local result = self.model.Result
    
end
--播放结算动画
function CarLogoGameView:ResultEffect(result)
    local LogoId = config.FindIndexByLogoId(result.rewardAreaIdx)
    --播放奔跑动画
    self:PlayRuningAnimtion(result, true,function()
        -- 显示结果
        self:PlayCarEffectView(LogoId,function()
            -- 播放赢的区域闪动
            local index = CarLogoHelper.FindIndexById(LogoId)
            self.areaViews[index]:ShowWinFlashAnim()
            --金币回收动画
            self:PlayCompeleCoinFLy()
            --切换状态
            self:OnGameStatus(4)
        end)

        -- 播放筹码飞动效果
        TimerManager.StartTimer(self,function()
            self:LogoFlyToHistory(result.rewardAreaIdx)
        end,0.4)
    end)
    
end
---切换当前选中的底注
function CarLogoGameView:ChangeDiZhu(index)
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

function CarLogoGameView:InitXiaZhuLabel()
    for i=1,#self.areaViews do
        self.areaViews[i]:UpdateTotal(0)
        self.areaViews[i]:UpdateSelf(0)
    end
end

function CarLogoGameView:UpdateXiaZhuLabel()
    for i=1,#self.areaViews do
        self.areaViews[i]:UpdateTotal(config.totalDiZhuNums[i])
        self.areaViews[i]:UpdateSelf(config.selfDiZhuNums[i])
    end
end

function CarLogoGameView:UpdateDiZhuBtnState()
    for i=1,#self.chipInfos do
        self.chipInfos[i].button.interactable = config.allow and self.model.betPointList[i]<=PlayerManager:GetPlayerInfo().goldNum
    end
    if self.chipInfos[config.dizhuIndex] then self.chipInfos[config.dizhuIndex].effects:SetActive(config.allow) end
end
---更新自己信息
function CarLogoGameView:UpdateSelf(player)
    self.selfPlayer:UpdatePlayer(player)
end
function CarLogoGameView:UpdateSelfGoldCount()
    self.selfPlayer:UpdateGoldCount(PlayerManager:GetPlayerInfo().goldNum)
end
function CarLogoGameView:UpdatePlayerTotal()
    self.tmp_totalPlayerNum.text = self.model.playersNum
end
---本玩家下注动画
function CarLogoGameView:PayXiaZhuCoinFly(side)
    ChouMaFlyUtil:AnimateCoin(self.dizhuNode,config.dizhuIndex,self.selfPlayer.transform.position,self.areaViews[side].noteRoot,
            self.model.betPointList[config.dizhuIndex])
    --下注音效
    CarLogoSounds.PlaySoundEffic(config.AUDIO_KEY.Bet)
end
---其他玩家下注动画
function CarLogoGameView:PayOtherXiaZhuCoinFly(data)
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
    if areaTotal[data.side] >= config.AreaChouMaLimit[data.side] then
        return
    end
    ChouMaFlyUtil:AnimateCoin(self.dizhuNode,data.index,self.btn_players.transform.position,self.areaViews[data.side].noteRoot, data.betValue)
    areaTotal[data.side] = areaTotal[data.side] + 1
    CarLogoSounds.PlaySoundEffic(config.AUDIO_KEY.Bet)
end

---金币回收动画
function CarLogoGameView:PlayCompeleCoinFLy()
    local results = self.model.Result.playerChangedGolds
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
        totalCurrency = totalCurrency + player.playerWinGold
        if player.playerId == PlayerManager:GetPlayerInfo().playerId then
            winCurrency[1] = player.playerWinGold
            self.selfPlayer:ShowResultCount( player.playerWinGold)
            PlayerManager:GetPlayerInfo().goldNum = PlayerManager:GetPlayerInfo().goldNum + player.playerWinGold;
            self:UpdateSelfGoldCount() -- 更新金币
            -- 播放得奖音效
            CarLogoSounds.PlaySoundEffic(config.AUDIO_KEY.WinBet)
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

function CarLogoGameView:StartEffect(callFunc)
    --点亮灯圈
    self:UnChooseAllLogos()
    --闪灯
    self:FlashLight()

    --开始下注提示
    CarLogoSounds.PlaySoundEffic(config.AUDIO_KEY.KaiShiXiaZhu)
    self.tipsStartXiaZhu:SetActive(true)
    Tools.PlayerSpineAniByName(self.tipsStartXiaZhuSp,"kaishixiazhu",false)
    self:UpdateXiaZhuLabel()
    TimerManager.StartTimer(self,function()
        CarLogoSounds.PlaySoundEffic(config.AUDIO_KEY.KaiShiXiaZhuEnd)
    end,1.5,0,false)
end

function CarLogoGameView:EndEffect()
    --闪灯
    self:FlashLight()

    --下注结束提示
    CarLogoSounds.PlaySoundEffic(config.AUDIO_KEY.StopXiaZhu)
    self.tipsTimeEnd:SetActive(true)
    Tools.PlayerSpineAniByName(self.tipsTimeEndSp,"jieshuxiazhu",false)
    TimerManager.StartTimer(self,function()
        CarLogoSounds.PlaySoundEffic(config.AUDIO_KEY.StopXiaZhuEnd)
    end,1.5,0,false)

end
---设置续投按钮是否可以点击 当前局已经手动投注或者上局未投注不能点 其他可点
function CarLogoGameView:SetRepeatState(isOn)
    if isOn then
        self.btn_repeat.interactable = true;
    else
        self.btn_repeat.interactable = false;
    end
end
------------tips-------------
---倒计时3秒
function CarLogoGameView:PlayDaoJiShiEffect()
    self.daojishiParticles.gameObject:SetActive(true)
    if self.daojishiParticles.isStopped  then
        self.daojishiParticles:Play();
    end
end

-- 更新房间信息
function CarLogoGameView:UpdateRoomInfo(model)
    -- 1. 初始化UI状态
    self:InitUI()

    -- 2. 刷新玩家信息
    ------------------
    self:UpdatePlayerTotal()
    self:UpdateSelf(PlayerManager:GetPlayerInfo())
    ------------------

    -- 3. 刷新历史信息
    self.history:UpdateCarLogo(model.history)

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
function CarLogoGameView:ShowAreaChouMa(sideInfo)
    if not sideInfo.betGoldList then return end
    local areaTotal = self.model.AreaChipTotals
    local side = sideInfo.betIdx<config.gameID and sideInfo.betIdx or sideInfo.betIdx-config.gameID*100
    for ix=1,#sideInfo.betGoldList do
        local value = sideInfo.BetInfos[ix]
        local index = self.ctrl.model:FindBetIndex(value)
        if areaTotal[side] < config.AreaChouMaLimit[side] then
            areaTotal[side]=areaTotal[side]+1
            ChouMaFlyUtil:CreatCoinInArea(self.dizhuNode,index,self.areaViews[side].noteRoot,value)
        end
    end
end

--单独飞筹码处理 防止频繁UI更新卡住
function CarLogoGameView:UpdateBetting()
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
function CarLogoGameView:OnGameStatus(status)
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
    self.tipsTimeEnd:SetActive(false)
    self.resultCar:SetActive(false)
    self.daojishiParticles.gameObject:SetActive(false)

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
        self:InitXiaZhuLabel()
    elseif status == 2 then -- 押分阶段
        self:UpdateDiZhuBtnState()
        self:SetRepeatState(#config.lastXiaZhuInfo > 0 and not config.isRepeat)

        self.colockStateTimeNum.text = tostring(config.lessSeconds)
        -- 启动倒计时
        self.statusTimer = TimerManager.StartTimer(self, function()
            config.lessSeconds = config.lessSeconds - 1
            self.colockStateTimeNum.text = tostring(config.lessSeconds)
            if config.lessSeconds == 3 then
                self:PlayDaoJiShiEffect()
            end
            if config.lessSeconds <= 0 then
                TimerManager.StopTimer(self,self.statusTimer)
                self.statusTimer = nil
            end
            if config.lessSeconds <=3 then
                CarLogoSounds.PlaySoundEffic(config.AUDIO_KEY.DaoJiShi)
            end
        end, 1, config.lessSeconds, true)
    elseif status == 3 then -- 亮牌阶段
        self:UpdateDiZhuBtnState()
        self:SetRepeatState(false)
        self:EndEffect()
        --结算倒计时
        self.colockStateTimeNum.text = config.lessSeconds
        self.statusTimer = TimerManager.StartTimer(self, function
        ()
            config.lessSeconds = config.lessSeconds - 1
            self.colockStateTimeNum.text = config.lessSeconds
            if config.lessSeconds <= 0 then
                TimerManager.StopTimer(self,self.statusTimer)
                self.statusTimer = nil
            end
        end, 1, config.lessSeconds,true)
    end
end

---复投功能
function CarLogoGameView:RepeatInit()
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
function CarLogoGameView:Close()
    ChouMaFlyUtil:Destroy()
    TimerManager.StopAllTimer(self)
    UpdateManager.ReMoveAll(self)
    CarLogoSounds.StopSoundMusic()
    self.super.Close(self);
end

return CarLogoGameView

