---
---Create by Administrator
---DateTime: 2025-07-02 18:28:37
---
---@class BirdsAnimalsGameView:BaseView
local BirdsAnimalsGameView=Class("BirdsAnimalsGameView",BaseView)
local BirdsAnimalsItem=require("SingleGames/BirdsAnimals/View/Item/BirdsAnimalsItem")
local BirdsAnimalsHistoryItem=require("SingleGames/BirdsAnimals/View/Item/BirdsAnimalsHistoryItem")
local BirdsAnimalsAreaItem=require("SingleGames/BirdsAnimals/View/Item/BirdsAnimalsAreaItem")
local config =require("SingleGames/BirdsAnimals/BirdsAnimalsConfig")
local BirdsAnimalsHelper=require("SingleGames/BirdsAnimals/BirdsAnimalsHelper")
local ChouMaFlyUtil=require("Logic/Common/ChouMaFlyUtil")
local BirdsAnimalsPlayerItem = require("SingleGames/BirdsAnimals/View/Item/BirdsAnimalsPlayerItem")
local BirdsAnimalsSounds = require("SingleGames/BirdsAnimals/BirdsAnimalsSounds")
local DOTween = CS.DG.Tweening.DOTween
local Ease = CS.DG.Tweening.Ease
DOTween:SetTweensCapacity(1000, 250);
---初始化panel
function BirdsAnimalsGameView:InitView()
	---@type BirdsAnimalsGameCtrl
    self.ctrl=self.ctrl
    self.bettingTime = 0
	self:InitComponents()
end

---获取组件
function BirdsAnimalsGameView:InitComponents()
    self.btn_trend=ComponentUtilGet.Button(self.transform,"content/center/history/btn_trend");
    self.btn_recharge=ComponentUtilGet.Button(self.transform,"content/top/btn_recharge");
    self.btn_players=ComponentUtilGet.Button(self.transform,"content/bottom/btn_players");
    self.btn_repeat=ComponentUtilGet.Button(self.transform,"content/bottom/btn_repeat");
    self.muenRect=ComponentUtilGet.RectTransform(self.transform,"content/setting/mask/muen")
    self.btn_touch=ComponentUtilGet.Button(self.transform,"content/setting/btn_touch");
    self.btn_muen=ComponentUtilGet.Button(self.transform,"content/setting/btn_muen");
    self.btn_setting=ComponentUtilGet.Button(self.transform,"content/setting/mask/muen/btn_setting");
    self.btn_help=ComponentUtilGet.Button(self.transform,"content/setting/mask/muen/btn_help");
    self.btn_close=ComponentUtilGet.Button(self.transform,"content/setting/mask/muen/btn_close");

    self.tmp_totalPlayerNum=ComponentUtilGet.Text(self.btn_players.transform,"tmp_total_player_num")
    ---提示信息
    self.txt_mybets=ComponentUtilGet.Text(self.transform,"content/tips/tips_center/mybets/txt_mybets");
    self.tmp_totalnote=ComponentUtilGet.TextMeshProUGUI(self.transform,"content/tips/tips_center/totalnote/tmp_totalnote");
    self.tmp_automatic=ComponentUtilGet.TextMeshProUGUI(self.transform,"content/tips/tips_center/automatic/tmp_automatic");
    
    self.tipsTrs = ComponentUtilGet.Transform(self.transform,"content/tips")
    
    self.tipsTimeEnd = ComponentUtilGet.GameObject(self.tipsTrs,"eff_BirdsAnimals_EndOfBetting")
    self.tipsTimeEndSp=ComponentUtilGet.SkeletonGraphic(self.tipsTimeEnd.transform,"SkeletonGraphic (kaishijieshuxiazhu)")
    self.tipsStartXiaZhu = ComponentUtilGet.GameObject(self.tipsTrs,"eff_BirdsAnimals_StartBetting")
    self.tipsStartXiaZhuSp=ComponentUtilGet.SkeletonGraphic(self.tipsStartXiaZhu.transform,"SkeletonGraphic (kaishijieshuxiazhu)")

    self.daojishiParticles =ComponentUtilGet.GameObject(self.tipsTrs,"eff_daojishi/eff_daojishi"):GetComponent("ParticleSystem")
    self.tipsEnterWait=ComponentUtilGet.Transform(self.tipsTrs,"tips_enter_wait")
    self.tipsEnterWaitTime=ComponentUtilGet.Text(self.tipsEnterWait,"naozhong/time")

    ---结果
    self.resultTrs=ComponentUtilGet.Transform(self.transform,"content/result");
    self.resultAnimal=ComponentUtilGet.GameObject(self.resultTrs,"Animal")
    self.resultSp=ComponentUtilGet.SkeletonGraphic(self.resultTrs,"Animal/eff_BirdsAnimals_tanchuang/SkeletonGraphic (gongxihuode )")
    self.txt_name=ComponentUtilGet.Text(self.transform,"content/result/Animal/txt_name");
    self.img_icon_bg=ComponentUtilGet.Transform(self.transform,"content/result/Animal/img_icon_bg");
    self.img_icon=ComponentUtilGet.Image(self.transform,"content/result/Animal/img_icon_bg/img_icon");
    self.img_rate=ComponentUtilGet.Text(self.transform,"content/result/Animal/img_rate");
    ---下注区域
    self.areasTrs=ComponentUtilGet.Transform(self.transform,"content/areas")
    local areaItem=self.areasTrs:GetChild(0)
    ---@type BirdsAnimalsAreaItem[]
    self.areaViews = {};
    self.areaViews[1] = BirdsAnimalsAreaItem.New(areaItem,1);
    for i = 2, 12 do
        local areaObj = Tools.Instance(areaItem.gameObject,self.areasTrs)
        self.areaViews[i] = BirdsAnimalsAreaItem.New(areaObj.transform,i);
    end
    ---车标 跑马灯
    self.logosTrs=ComponentUtilGet.Transform(self.transform,"content/center/logos")
    local logoItem=self.logosTrs:GetChild(0)
    ---@type BirdsAnimalsItem[]
    self.logoViews = {BirdsAnimalsItem.New(logoItem,self)};
    local logoV3 = logoItem.localPosition;-- (-937,525.5)
    local v2x, v2y = 187, 218
    local logoV3x, logoV3y, logoV3z = logoV3.x, logoV3.y, logoV3.z
    for i = 2, 28 do
        local logoObj = Tools.Instance(logoItem.gameObject)
        logoObj.transform:SetParent(self.logosTrs,false)
        local newX, newY, newZ
        if i < 12 then
            newX = logoV3x + v2x * (i - 1)
            newY = logoV3y
            newZ = logoV3z
        elseif i < 16 then
            newX = logoV3x + v2x * 10
            newY = logoV3y - v2y * (i - 11)
            newZ = logoV3z
        elseif i < 26 then
            newX = logoV3x + v2x * (25 - i)
            newY = logoV3y - v2y * 4
            newZ = logoV3z
        else
            newX = logoV3x
            newY = logoV3y - v2y * (29 - i)
            newZ = logoV3z
        end
        logoObj.transform.localPosition = Vector3(newX, newY, newZ)
        self.logoViews[i] = BirdsAnimalsItem.New(logoObj.transform,self)
    end

    ---历史信息
    self.historyObj=ComponentUtilGet.GameObject(self.transform,"content/center/history")
    ---@type BirdsAnimalsHistoryItem
    self.history=BirdsAnimalsHistoryItem.New(self.historyObj)

    self.dizhu = ComponentUtilGet.Transform(self.transform,"content/bottom/chouma/Viewport/Content");
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
    self.selfPlayer = BirdsAnimalsPlayerItem.New(self.selfPlayerRoot)
    ---底注节点prefab
    self.dizhuNode = ComponentUtilGet.GameObject(self.transform,"content/bottom/nodes")
end

---清空组件
function BirdsAnimalsGameView:ClearComponents()
    self.btn_trend=nil;
    self.btn_recharge=nil;
    self.btn_players=nil;
    self.tmp_totalPlayerNum=nil;
    self.btn_repeat=nil;
    self.txt_mybets=nil;
    self.tmp_totalnote=nil;
    self.tmp_automatic=nil;
    self.txt_name=nil;
    self.img_icon=nil;
    self.img_rate=nil;
    self.btn_touch=nil;
    self.btn_muen=nil;
    self.btn_setting=nil;
    self.btn_help=nil;
    self.btn_close=nil;
end

---初始化View数据
function BirdsAnimalsGameView:InitPanelData(args)
    self:InitMarquee()
    self:InitLogos()
    self:FlashLight()
    --播放背景音乐
    BirdsAnimalsSounds.PlaySoundMusic()
end

function BirdsAnimalsGameView:InitChouMa()
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

function BirdsAnimalsGameView:InitUI()
    BirdsAnimalsSounds.PlaySoundMusic()
    ---续押
    self:SetRepeatState(false)
    self:InitChouMa()
    
    --请下注提示
    self.tmp_totalPlayerNum.text="0"
    self.tipsStartXiaZhu:SetActive(false)
    self.tipsTimeEnd:SetActive(false)
    self.daojishiParticles.gameObject:SetActive(false)
    self.resultTrs.gameObject:SetActive(true);
    self.tipsEnterWait.gameObject:SetActive(false)
    self:InitXiaZhuLabel()
    UpdateManager.AddUpdate(self,self.UpdateBetting)
    GameObject.Destroy(ComponentUtilGet.HorizontalLayoutGroup(self.dizhu))
end

function BirdsAnimalsGameView:DizhuPrev(isNext)
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


---初始化图标
function BirdsAnimalsGameView:InitLogos()
    for logo_id, pos in pairs(config.LOGO_IDX) do
        for i, index in ipairs(pos) do
            self.logoViews[index]:ShowLogo(logo_id);
        end
    end
end
---闪灯
function BirdsAnimalsGameView:FlashLight()
    local time  = 0.3
    for i=1,#self.logoViews do
        self.logoViews[i]:FlashLight(time,3,0.2)
    end
end


function BirdsAnimalsGameView:LogoShowLinght(index)
    for i, view in ipairs(self.logoViews) do
        view:ShowChoose(true,i ~= index)
    end
end

------start Logo Marquee-----
function BirdsAnimalsGameView:InitMarquee()
    self.marqueeCallFunc = nil
    self.curve = CS.UnityEngine.AnimationCurve()
    for i=1,#config.CURVE_KEYS do
        self.curve:AddKey(config.CURVE_KEYS[i][1], config.CURVE_KEYS[i][2])
    end
end

function BirdsAnimalsGameView:IntMove(from, to, leftTime, time)
    time = time or 6
    if leftTime > 0 then
        leftTime =  leftTime > time and time or leftTime
        to = to + config.ANIMAL_MAX * 3

        local startTime = Time.realtimeSinceStartup - (time - leftTime);
        local deltaTime = Time.realtimeSinceStartup - startTime;
        local lastIndex = from + Mathf.FloorToInt(self.curve:Evaluate(deltaTime / time) * (to - from))
        local newIndex = lastIndex
        local runIndex = 0
        CorManager.StartCor(self.ctrl,function()
            while deltaTime<time and lastIndex<to do
                deltaTime = Time.realtimeSinceStartup - startTime;
                newIndex = from + Mathf.FloorToInt(self.curve:Evaluate(deltaTime / time) * (to - from))
                for i = lastIndex + 1, newIndex do
                    lastIndex = i;

                    local index = i% config.ANIMAL_MAX
                    if index==0 then
                        index = config.ANIMAL_MAX
                    end
                    
                    if runIndex~=index then
                        self.logoViews[index]:ShowChoose(true)
                        if runIndex>0 then
                            self.logoViews[runIndex]:ShowChoose(true, true)
                        end
                        runIndex = index
                    end
                end
                coroutine.yield(CS.UnityEngine.WaitForEndOfFrame())
            end
            
            if self.marqueeCallFunc then
                self.marqueeCallFunc()
                self.marqueeCallFunc = nil
            end
            --转轴停止的音效
            BirdsAnimalsSounds.PlaySoundEffic(config.AUDIO_KEY.End)
        end)
    end
end
------end Logo Marquee-----

---设置菜单显示隐藏
function BirdsAnimalsGameView:SettingFade()
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
function BirdsAnimalsGameView:LogoFlyToHistory(index)
    self.history:PlayMoveAni(self.model.history)
    self.logoViews[index]:FlyLogoHistory(self.resultTrs,self.history:GetPoint())

end

--隐藏所有Logo的选中效果
function BirdsAnimalsGameView:UnChooseAllLogos()
    for i, v in ipairs(self.logoViews) do
        v:ShowChoose(false);
    end
end

--播放奔跑动画
function BirdsAnimalsGameView:PlayRuningAnimtion(result, leftTime, callFunc)
    if leftTime>1 then
        --慢速旋转
        BirdsAnimalsSounds.PlaySoundEffic(config.AUDIO_KEY.XuanZhuan)
        --转轴旋转
        BirdsAnimalsSounds.PlaySoundEffic(config.AUDIO_KEY.Running)
        self.marqueeCallFunc = callFunc
        self:IntMove(self.model.lastIndex, result.rewardAreaIdx,leftTime,6)
    else
        self:LogoShowLinght(result.rewardAreaIdx)
        if callFunc then  callFunc() end
    end
    self.model.lastIndex = result.rewardAreaIdx
end

function BirdsAnimalsGameView:PlayCarEffectView(logo_id,callFunc)
    self.resultAnimal:SetActive(true)
    self.img_rate.text = "X".. config.ODDS[logo_id]
    self.img_icon.sprite=BirdsAnimalsHelper.LoadLogoSprite(logo_id)
    self.txt_name.text=BirdsAnimalsHelper.LoadNameLanguage(logo_id)
    self.img_icon:SetNativeSize()
    
    self.img_icon_bg.localScale=Vector3.Zero()
    self.img_icon_bg:DOScale(Vector3(1,1,1),0.3):SetEase(Ease.OutBack)
    Tools.PlayerSpineAniByName(self.resultSp,"action",false)
    CorManager.StartCor(self.ctrl, function
    ()
        coroutine.wait(0.3)
        BirdsAnimalsSounds.PlaySoundAnimal(logo_id)
        coroutine.wait(2)
        self.resultAnimal:SetActive(false)
        if callFunc then callFunc() end
    end)
end

function BirdsAnimalsGameView:ResultStageTimer(stage)
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

function BirdsAnimalsGameView:ResultStage(stage)
    local result = self.model.Result

end

--播放结算动画
function BirdsAnimalsGameView:ResultEffect(result)
    local LogoId = config.FindIndexByLogoId(result.rewardAreaIdx)
    --播放奔跑动画
    local leftTime = Mathf.Round((self.model.endTime - ServerTimeSync:GetTimeStamp())/1000)-7
    CorManager.StartCor(self.ctrl,function()
        --闪灯
        self:FlashLight()
        coroutine.yield(CS.UnityEngine.WaitForSeconds(1.5))

        self:PlayRuningAnimtion(result, leftTime,function()
            -- 显示结果
            self:PlayCarEffectView(LogoId,function()
                -- 播放赢的区域闪动
                local index = BirdsAnimalsHelper.FindIndexById(LogoId)
                self.areaViews[index]:ShowWinFlashAnim()

                --飞鸟和走兽区域闪动
                if BirdsAnimalsHelper.IsFeiQinType(LogoId) then
                    self.areaViews[3]:ShowWinFlashAnim()
                elseif BirdsAnimalsHelper.IsZouShouType(LogoId) then
                    self.areaViews[4]:ShowWinFlashAnim()
                end

                --金币回收动画
                self:PlayCompeleCoinFLy()
            end)

            -- 播放筹码飞动效果
            TimerManager.StartTimer(self,function()
                self:LogoFlyToHistory(result.rewardAreaIdx)
            end,0.4)
        end)

    end)
    
end
---切换当前选中的底注
function BirdsAnimalsGameView:ChangeDiZhu(index)
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

function BirdsAnimalsGameView:InitXiaZhuLabel()
    for i=1,#self.areaViews do
        self.areaViews[i]:UpdateTotal(0)
        self.areaViews[i]:UpdateSelf(0)
    end
    self.tmp_totalnote.text =0;
    self.tmp_automatic.text = 0;
end

function BirdsAnimalsGameView:UpdateXiaZhuLabel()
    for i=1,#self.areaViews do
        self.areaViews[i]:UpdateTotal(config.totalDiZhuNums[i])
        self.areaViews[i]:UpdateSelf(config.selfDiZhuNums[i])
    end
    self.tmp_totalnote.text = ArrayUtil.Sum(config.totalDiZhuNums);
    self.tmp_automatic.text = ArrayUtil.Sum(config.selfDiZhuNums);
end

function BirdsAnimalsGameView:UpdateDiZhuBtnState()
    for i=1,#self.chipInfos do
        self.chipInfos[i].button.interactable = config.allow and self.model.betPointList[i]<=PlayerManager:GetPlayerInfo().goldNum
    end
    if self.chipInfos[config.dizhuIndex] then self.chipInfos[config.dizhuIndex].effects:SetActive(config.allow) end
end
---更新自己信息
function BirdsAnimalsGameView:UpdateSelf(player)
    self.selfPlayer:UpdatePlayer(player)
end
function BirdsAnimalsGameView:UpdateSelfGoldCount()
    self.selfPlayer:UpdateGoldCount(PlayerManager:GetPlayerInfo().goldNum)
end
function BirdsAnimalsGameView:UpdatePlayerTotal()
    self.tmp_totalPlayerNum.text = self.model.playersNum
end
---本玩家下注动画
function BirdsAnimalsGameView:PayXiaZhuCoinFly(side)
    ChouMaFlyUtil:AnimateCoin(self.dizhuNode,config.dizhuIndex,self.selfPlayer.transform.position,self.areaViews[side].noteRoot,
            self.model.betPointList[config.dizhuIndex])
    --下注音效
    BirdsAnimalsSounds.PlaySoundEffic(config.AUDIO_KEY.Bet)
end
---其他玩家下注动画
function BirdsAnimalsGameView:PayOtherXiaZhuCoinFly(data)
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
    --下注音效
    BirdsAnimalsSounds.PlaySoundEffic(config.AUDIO_KEY.Bet)
end

---金币回收动画
function BirdsAnimalsGameView:PlayCompeleCoinFLy()
    local results = self.model.Result.playerChangedGolds
    if not results then return end
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
            BirdsAnimalsSounds.PlaySoundEffic(config.AUDIO_KEY.WinBet)
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

function BirdsAnimalsGameView:StartEffect()
    --点亮灯圈
    self:UnChooseAllLogos()
    
    --开始下注提示
    BirdsAnimalsSounds.PlaySoundEffic(config.AUDIO_KEY.KaiShiXiaZhu)
    self.tipsStartXiaZhu:SetActive(true)
    Tools.PlayerSpineAniByName(self.tipsStartXiaZhuSp,"kaishixiazhu",false)
    
end

function BirdsAnimalsGameView:EndEffect()
    --下注结束提示
    BirdsAnimalsSounds.PlaySoundEffic(config.AUDIO_KEY.StopXiaZhu)
    self.tipsTimeEnd:SetActive(true)
    Tools.PlayerSpineAniByName(self.tipsTimeEndSp,"jieshuxiazhu",false)
    -- 停止下注吹哨
    TimerManager.StartTimer(self,function()
        BirdsAnimalsSounds.PlaySoundEffic(config.AUDIO_KEY.StopXiaZhuEnd)
    end,1.1,0,false)
end

---设置续投按钮是否可以点击 当前局已经手动投注或者上局未投注不能点 其他可点
function BirdsAnimalsGameView:SetRepeatState(isOn)
    if isOn then
        self.btn_repeat.interactable = true;
    else
        self.btn_repeat.interactable = false;
    end
end
------------tips-------------
---倒计时3秒
function BirdsAnimalsGameView:PlayDaoJiShiEffect()
    self.daojishiParticles.gameObject:SetActive(true)
    if self.daojishiParticles.isStopped  then
        self.daojishiParticles:Play();
    end
end

-- 更新房间信息
function BirdsAnimalsGameView:UpdateRoomInfo(model)
    -- 1. 初始化UI状态
    self:InitUI()

    -- 2. 刷新玩家信息
    ------------------
    self:UpdatePlayerTotal()
    self:UpdateSelf(PlayerManager:GetPlayerInfo())
    ------------------
    
    -- 3. 刷新历史信息
    self.history:UpdateBirdsAnimals(model.history)
    
    -- 4. 刷新押注池信息
    if model.sideBetInfos then
        for k,value in pairs(model.sideBetInfos) do
            local side = value.betIdx<config.gameID and value.betIdx or value.betIdx-config.gameID*100
            -- 更新总押注金额
            config.totalDiZhuNums[side] = value.betIdxTotal
            -- 更新玩家区域押注金额
            config.selfDiZhuNums[side] = 0
            -- 更新区域筹码显示
            self:ShowAreaChouMa(value)
        end
        self:UpdateXiaZhuLabel()
    end

    -- 5. 刷新当前游戏状态和倒计时
    local lessTime = model.endTime - ServerTimeSync:GetTimeStamp()
    look("当前阶段剩余时间（毫秒）："..lessTime)
    if lessTime<=0 then
        --进行下一阶段
        if model.status<4 then self:OnGameStatus(model.status+1) end
    else--更新当前阶段
        self:OnGameStatus(model.status,Mathf.Round(lessTime/1000))
    end

    -- 提示 等待本对局结束
    if model.Result or (lessTime<=0 and model.status>=2) then--有结果 或者 发消息的时候还没结束但是收到消息已结束
        local lessSeconds = Mathf.Round(lessTime/1000)
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
function BirdsAnimalsGameView:ShowAreaChouMa(sideInfo)
    if not sideInfo.betGoldList then return end
    local areaTotal = self.model.AreaChipTotals
    local side = sideInfo.betIdx<config.gameID and sideInfo.betIdx or sideInfo.betIdx-config.gameID*100
    for i=1,#sideInfo.betGoldList do
        local value = sideInfo.betGoldList[i]
        local index = self.model:FindBetIndex(value)
        if areaTotal[side] < config.AreaChouMaLimit[side] then
            areaTotal[side]=areaTotal[side]+1
            ChouMaFlyUtil:CreatCoinInArea(self.dizhuNode,index,self.areaViews[side].noteRoot,value)
        end
    end
end

--单独飞筹码处理 防止频繁UI更新卡住
function BirdsAnimalsGameView:UpdateBetting()
    if  not config.allow or Time.realtimeSinceStartup - self.bettingTime < 0.1 then return end
    self.bettingTime = Time.realtimeSinceStartup

    for playerId, msg in pairs(self.model.bettingDataMap) do
        if not msg.handled then
            for _, value in ipairs(msg.betTableInfoList) do
                local bet = {
                    side = value.betIdx<config.gameID and value.betIdx or value.betIdx-config.gameID*100,
                    index = self.model:FindBetIndex(value.betValue),
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
function BirdsAnimalsGameView:OnGameStatus(status,seconds)
    -- status: 1准备阶段，2押分阶段，3亮牌阶段，4结算阶段
    self.model.status = status
    config.lessSeconds = seconds or Mathf.Round(config.StageTime[status]/1000)
    config.allow= status==2

    -- 隐藏所有阶段相关UI
    self.tipsTimeEnd:SetActive(false)
    self.resultAnimal:SetActive(false)
    self.daojishiParticles.gameObject:SetActive(false)
    self.tipsEnterWait.gameObject:SetActive(false)
    
    if self.statusTimer then
        TimerManager.StopTimer(self,self.statusTimer)
        self.statusTimer = nil
    end
    if self.resultTimer then
        TimerManager.StopTimer(self,self.resultTimer)
        self.resultTimer = nil
    end
    
    if status == 1 then -- 准备阶段
        self.model:ResetConfig()
        self:UpdateDiZhuBtnState()
        self:SetRepeatState(false)
        self:StartEffect()
        self:InitXiaZhuLabel()
    elseif status == 2 then -- 押分阶段
        self:UpdateDiZhuBtnState()
        self:SetRepeatState(#config.lastXiaZhuInfo > 0 and not config.isRepeat)
        
        self.txt_mybets.text = tostring(config.lessSeconds)
        -- 启动倒计时
        self.statusTimer = TimerManager.StartTimer(self, function()
            config.lessSeconds = config.lessSeconds - 1
            self.txt_mybets.text = tostring(config.lessSeconds)
            if config.lessSeconds == 3 then
                self:PlayDaoJiShiEffect()
            end
            if config.lessSeconds <= 0 then
                TimerManager.StopTimer(self,self.statusTimer)
                self.statusTimer = nil
            end
            if config.lessSeconds<=3 then
                BirdsAnimalsSounds.PlaySoundEffic(config.AUDIO_KEY.DaoJiShi)
            end
        end, 1, config.lessSeconds, true)
    elseif status == 3 then -- 亮牌阶段
        self:UpdateDiZhuBtnState()
        self:SetRepeatState(false)
        self:EndEffect()
        --结算倒计时
        self.txt_mybets.text = config.lessSeconds
        self.statusTimer = TimerManager.StartTimer(self, function
        ()
            config.lessSeconds = config.lessSeconds - 1
            self.txt_mybets.text = config.lessSeconds
            if config.lessSeconds <= 0 then
                TimerManager.StopTimer(self,self.statusTimer)
                self.statusTimer = nil
            end
        end, 1, config.lessSeconds,true)
	elseif status == 4 then
        self:UpdateDiZhuBtnState()
        self:RepeatInit()
        self:InitXiaZhuLabel()
    end
end

---复投功能
function BirdsAnimalsGameView:RepeatInit()
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
function BirdsAnimalsGameView:Close()
    ChouMaFlyUtil:Destroy()
    TimerManager.StopAllTimer(self)
    UpdateManager.ReMoveAll(self)
    BirdsAnimalsSounds.StopSoundMusic()
    self.super.Close(self);
end

return BirdsAnimalsGameView

