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
    self.btn_repeat=ComponentUtilGet.Button(self.transform,"content/bottom/btn_repeat")
    self.img_car=ComponentUtilGet.Image(self.transform,"content/center/result/Car/img_car");
    self.img_icon=ComponentUtilGet.Image(self.transform,"content/center/result/Car/img_icon");

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

    self.tipsEnterWait=ComponentUtilGet.Transform(self.tipsTrs,"tips_enter_wait")
    self.tipsEnterWaitTime=ComponentUtilGet.Text(self.tipsEnterWait,"naozhong/time")

    self.resultTrs=ComponentUtilGet.Transform(self.transform,"content/center/result");
    self.resultCar=ComponentUtilGet.GameObject(self.resultTrs,"Car")
    self.resultCarObj=ComponentUtilGet.Transform(self.resultTrs,"Car/carObj")
    self.resultLogoObj=ComponentUtilGet.Transform(self.resultTrs,"Car/logoObj")
    ---下注区域
    self.areasTrs=ComponentUtilGet.Transform(self.transform,"content/center/areas")
    ---@type CarLogoAreaItem[]
    self.areaViews = {};
    self.xiazhuStarAreas = {}
    for i = 1, self.areasTrs.childCount do
        self.areaViews[i] = CarLogoAreaItem.New(self.areasTrs:GetChild(i-1));
        table.insert(self.xiazhuStarAreas,self.areaViews[i].noteRoot)
    end
    ---车标 跑马灯
    self.logosTrs=ComponentUtilGet.Transform(self.transform,"content/center/logos")
    local logoItem=ComponentUtilGet.Transform(self.transform,"content/center/logositem/1")
    ---@type CarLogoItem[]
    self.logoViews = {};
    for i = 1, self.logosTrs.childCount do
        local parent = self.logosTrs:GetChild(i-1)
        self.logoViews[i] = CarLogoItem.New(Tools.Instance(logoItem,parent),self)
    end
    
    ---历史信息
    self.historyObj=ComponentUtilGet.GameObject(self.transform,"content/top/history")
    ---@type CarLogoHistoryItem
    self.history=CarLogoHistoryItem.New(self.historyObj)
    
end

---清空组件
function CarLogoGameView:ClearComponents()
    self.btn_trend=nil;
    self.btn_repeat=nil
    self.img_car=nil;
    self.img_icon=nil;
    self.tmp_time=nil;
end

---初始化View数据
function CarLogoGameView:InitPanelData(args)
    self.selectIndex=args
    self:InitMarquee()
    self:InitLogos()
end

function CarLogoGameView:InitUI()
    CarLogoSounds.PlaySoundMusic()
    ---续押
    self:SetRepeatState(false)
    ---初始筹码数值
    self.ctrl.commCtrl:InitChouMa(self.model.betPointList)
    
    --请下注提示
    self.resultTrs.gameObject:SetActive(true);
    self.tipsTimeEnd:SetActive(false)
    self.tipsStartXiaZhu:SetActive(false)
    self.tipsEnterWait.gameObject:SetActive(false)
    self:InitXiaZhuLabel()
end

---初始化车标
function CarLogoGameView:InitLogos()
    for logo_id, pos in pairs(config.LOGO_IDX) do
        for i, index in ipairs(pos) do
            self.logoViews[index]:ShowLogo(logo_id);
        end
    end
end

---闪灯
function CarLogoGameView:FlashLight()
    local time  = 0.3
    for i=1,#self.logoViews do
        self.logoViews[i]:FlashLight(time,3)
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

------start Logo Marquee-----
function CarLogoGameView:InitMarquee()
    self.marqueeCallFunc = nil
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
        local lastIndex = from + Mathf.FloorToInt(self.curve:Evaluate(deltaTime / time) * (to - from))
        local newIndex = lastIndex
        local runIndex = 0

        CorManager.StartCor(self.ctrl,function()
            while deltaTime<time and lastIndex<to do
                deltaTime = Time.realtimeSinceStartup - startTime;
                newIndex = from + Mathf.FloorToInt(self.curve:Evaluate(deltaTime / time) * (to - from))
                for i = lastIndex + 1, newIndex do
                    lastIndex = i;

                    local index = i% config.LOGO_MAX
                    if index<=0 then
                        index = index + config.LOGO_MAX
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
        end)
    end
end
------end Logo Marquee-----

function CarLogoGameView:LogoFlyToHistory(index)
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
function CarLogoGameView:PlayRuningAnimtion(result, leftTime, callFunc)
    if leftTime>1 then
        CarLogoSounds.PlaySoundEffic(config.AUDIO_KEY.Running)
        self.marqueeCallFunc = callFunc
        self:IntMove(self.model.lastIndex, result.rewardAreaIdx,leftTime,6)
    else
        self:LogoShowLinght(result.rewardAreaIdx)
        if callFunc then  callFunc() end
    end
    self.model.lastIndex = result.rewardAreaIdx
end

function CarLogoGameView:PlayCarEffectView(logo_id,callFunc)
    self.resultCar:SetActive(true)
    self.areasTrs.gameObject:SetActive(false)
    self.img_icon.sprite=CarLogoHelper.LoadLogoSprite(logo_id)
    self.img_car.sprite=CarLogoHelper.LoadLogoResultSprite(logo_id)
    self.img_car:SetNativeSize()
    local carEff = self.ctrl.objPools:SpawnPrefab(nil, config.effectPath,"effect_CarLogo_Car_"..config.LOGO_IMAGES[logo_id], self.resultCarObj)
    
    self.img_car.transform.localScale=Vector3.Zero()
    self.img_car.transform:DOScale(Vector3(1,1,1),0.3):SetEase(Ease.InBack)
    CorManager.StartCor(self.ctrl, function
    ()
        coroutine.wait(0.3)
        local logoEff = self.ctrl.objPools:SpawnPrefab(nil, config.effectPath,"effect_CarLogo_Car_"..config.LOGO_IMAGES[logo_id].."_logo", self.resultLogoObj)
        CarLogoSounds.PlaySoundAnimal(logo_id)
        coroutine.wait(2.4)
        self.resultCar:SetActive(false)
        self.areasTrs.gameObject:SetActive(true)
        self.ctrl.objPools:UnSpawnPrefab(carEff)
        self.ctrl.objPools:UnSpawnPrefab(logoEff)
        if callFunc then callFunc() end
    end)
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
    --播放奔跑动画 结果3s 回收2s 动画5s 奔跑6s
    local leftTime = Mathf.Round((self.model.endTime - ServerTimeSync:GetTimeStamp())/1000)-5
    self:PlayRuningAnimtion(result, leftTime,function()
        -- 显示结果
        self:PlayCarEffectView(LogoId,function()
            -- 播放赢的区域闪动
            local index = CarLogoHelper.FindIndexById(LogoId)
            self.areaViews[index]:ShowWinFlashAnim()
            --金币回收动画
            self.ctrl.commCtrl:PlayCompeleCoinFLy(self.model.Result.playerChangedGolds)
        end)

        -- 播放筹码飞动效果
        TimerManager.StartTimer(self,function()
            self:LogoFlyToHistory(result.rewardAreaIdx)
        end,0.4)
    end)
    
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

function CarLogoGameView:StartEffect()
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
    end,1.1,0,false)
end

function CarLogoGameView:EndEffect()
    --闪灯
    --self:FlashLight()

    --下注结束提示
    CarLogoSounds.PlaySoundEffic(config.AUDIO_KEY.StopXiaZhu)
    self.tipsTimeEnd:SetActive(true)
    Tools.PlayerSpineAniByName(self.tipsTimeEndSp,"jieshuxiazhu",false)
    TimerManager.StartTimer(self,function()
        CarLogoSounds.PlaySoundEffic(config.AUDIO_KEY.StopXiaZhuEnd)
    end,1.1,0,false)

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

-- 更新房间信息
function CarLogoGameView:UpdateRoomInfo(model)
    -- 1. 初始化UI状态
    self:InitUI()

    -- 2. 刷新玩家信息
    ------------------
    self.ctrl.commCtrl:UpdatePlayerNum(model.playersNum)
    self.ctrl.commCtrl:UpdateSelf()
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
function CarLogoGameView:OnGameStatus(status,seconds)
    -- status: 1准备阶段，2押分阶段，3亮牌阶段，4结算阶段
    self.model.status = status
    config.lessSeconds = seconds or Mathf.Round(config.StageTime[status]/1000)
    config.allow= status==2
    
    -- 隐藏所有阶段相关UI
    self.tipsTimeEnd:SetActive(false)
    self.resultCar:SetActive(false)
    self.tipsEnterWait.gameObject:SetActive(false)
    self.colockStateLeftText1:SetActive(false)
    self.colockStateLeftText2:SetActive(false)
    
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
        self.colockStateLeftText1:SetActive(true)
        self.colockStateTimeNum.text = tostring(config.lessSeconds)
        -- 启动倒计时
        self.statusTimer = TimerManager.StartTimer(self, function()
            config.lessSeconds = config.lessSeconds - 1
            self.colockStateTimeNum.text = tostring(config.lessSeconds)
            if config.lessSeconds == 3 then
                self.ctrl.commCtrl:PlayDaoJiShiEffect()
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
        self.ctrl.commCtrl:UpdateDiZhuBtnState()
        self:SetRepeatState(false)
        self:EndEffect()
        --结算倒计时
        self.colockStateLeftText2:SetActive(true)
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
    elseif status == 4 then
        self.ctrl.commCtrl:UpdateDiZhuBtnState()
        self:RepeatInit()
        self:InitXiaZhuLabel()
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
    CarLogoSounds.StopSoundMusic()
    self.super.Close(self);
end

return CarLogoGameView

