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
    self.btn_repeat=ComponentUtilGet.Button(self.transform,"content/bottom/btn_repeat");
    ---提示信息
    self.txt_mybets=ComponentUtilGet.Text(self.transform,"content/tips/tips_center/mybets/txt_mybets");
    self.tmp_totalnote=ComponentUtilGet.TextMeshProUGUI(self.transform,"content/tips/tips_center/totalnote/tmp_totalnote");
    self.tmp_automatic=ComponentUtilGet.TextMeshProUGUI(self.transform,"content/tips/tips_center/automatic/tmp_automatic");
    
    self.tipsTrs = ComponentUtilGet.Transform(self.transform,"content/tips")
    
    self.tipsTimeEnd = ComponentUtilGet.GameObject(self.tipsTrs,"eff_BirdsAnimals_EndOfBetting")
    self.tipsTimeEndSp=ComponentUtilGet.SkeletonGraphic(self.tipsTimeEnd.transform,"SkeletonGraphic (kaishijieshuxiazhu)")
    self.tipsStartXiaZhu = ComponentUtilGet.GameObject(self.tipsTrs,"eff_BirdsAnimals_StartBetting")
    self.tipsStartXiaZhuSp=ComponentUtilGet.SkeletonGraphic(self.tipsStartXiaZhu.transform,"SkeletonGraphic (kaishijieshuxiazhu)")
    
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
    self.xiazhuStarAreas = {self.areaViews[1].noteRoot}
    for i = 2, 12 do
        local areaObj = Tools.Instance(areaItem.gameObject,self.areasTrs)
        self.areaViews[i] = BirdsAnimalsAreaItem.New(areaObj.transform,i);
        table.insert(self.xiazhuStarAreas,self.areaViews[i].noteRoot)
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
    
end

---清空组件
function BirdsAnimalsGameView:ClearComponents()
    self.btn_trend=nil;
    self.btn_repeat=nil;
    self.txt_mybets=nil;
    self.tmp_totalnote=nil;
    self.tmp_automatic=nil;
    self.txt_name=nil;
    self.img_icon=nil;
    self.img_rate=nil;
end

---初始化View数据
function BirdsAnimalsGameView:InitPanelData(args)
    self:InitMarquee()
    self:InitLogos()
    self:FlashLight()
    --播放背景音乐
    BirdsAnimalsSounds.PlaySoundMusic()
end

function BirdsAnimalsGameView:InitUI()
    BirdsAnimalsSounds.PlaySoundMusic()
    ---续押
    self:SetRepeatState(false)
    ---初始筹码数值
    self.ctrl.commCtrl:InitChouMa(self.model.betPointList)
    
    --请下注提示
    self.tipsStartXiaZhu:SetActive(false)
    self.tipsTimeEnd:SetActive(false)
    self.resultTrs.gameObject:SetActive(true);
    self.tipsEnterWait.gameObject:SetActive(false)
    self:InitXiaZhuLabel()
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
                if index then --跳过通杀、通赔
                    self.areaViews[index]:ShowWinFlashAnim()
                end
                --飞鸟和走兽区域闪动
                if BirdsAnimalsHelper.IsFeiQinType(LogoId) then
                    self.areaViews[3]:ShowWinFlashAnim()
                elseif BirdsAnimalsHelper.IsZouShouType(LogoId) then
                    self.areaViews[4]:ShowWinFlashAnim()
                end

                ---金币回收动画
                self.ctrl.commCtrl:PlayCompeleCoinFLy(self.model.Result.playerChangedGolds)
            end)

            -- 播放筹码飞动效果
            TimerManager.StartTimer(self,function()
                self:LogoFlyToHistory(result.rewardAreaIdx)
            end,0.4)
        end)

    end)
    
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
-- 更新房间信息
function BirdsAnimalsGameView:UpdateRoomInfo(model)
    -- 1. 初始化UI状态
    self:InitUI()

    -- 2. 刷新玩家信息
    ------------------
    self.ctrl.commCtrl:UpdatePlayerNum(model.playersNum)
    self.ctrl.commCtrl:UpdateSelf()
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
            self.ctrl.commCtrl:ShowAreaChouMa(value)
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

-- 切换状态
function BirdsAnimalsGameView:OnGameStatus(status,seconds)
    -- status: 1准备阶段，2押分阶段，3亮牌阶段，4结算阶段
    self.model.status = status
    config.lessSeconds = seconds or Mathf.Round(config.StageTime[status]/1000)
    config.allow= status==2

    -- 隐藏所有阶段相关UI
    self.tipsTimeEnd:SetActive(false)
    self.resultAnimal:SetActive(false)
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
        self.ctrl.commCtrl:UpdateDiZhuBtnState()
        self:SetRepeatState(false)
        self:StartEffect()
        self:InitXiaZhuLabel()
    elseif status == 2 then -- 押分阶段
        self.ctrl.commCtrl:UpdateDiZhuBtnState()
        self:SetRepeatState(#config.lastXiaZhuInfo > 0 and not config.isRepeat)
        
        self.txt_mybets.text = tostring(config.lessSeconds)
        -- 启动倒计时
        self.statusTimer = TimerManager.StartTimer(self, function()
            config.lessSeconds = config.lessSeconds - 1
            self.txt_mybets.text = tostring(config.lessSeconds)
            if config.lessSeconds == 3 then
                self.ctrl.commCtrl:PlayDaoJiShiEffect()
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
        self.ctrl.commCtrl:UpdateDiZhuBtnState()
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
        self.ctrl.commCtrl:UpdateDiZhuBtnState()
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
    BirdsAnimalsSounds.StopSoundMusic()
    self.super.Close(self);
end

return BirdsAnimalsGameView

