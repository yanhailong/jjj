---
---Create by Administrator
---DateTime: 2025-06-30 15:05:04
---
---@class CarLogoGameView:BaseView
local CarLogoGameView=Class("CarLogoGameView",BaseView)
local CarLogoItem=require("SingleGames/CarLogo/View/Item/CarLogoItem")
local CarLogoHistoryItem=require("SingleGames/CarLogo/View/Item/CarLogoHistoryItem")
local CarLogoAreaItem=require("SingleGames/CarLogo/View/Item/CarLogoAreaItem")
local CarLogoConfig=require("SingleGames/CarLogo/CarLogoConfig")
local CarLogoHelper=require("SingleGames/CarLogo/CarLogoHelper")
local CarLogoPlayCoinView=require("SingleGames/CarLogo/View/CarLogoPlayCoinView")
local PlayerItem = require("SingleGames/DragonTigerFight/View/Item/PlayerItem")

local DOTween = CS.DG.Tweening.DOTween
local Ease = CS.DG.Tweening.Ease
DOTween:SetTweensCapacity(1000, 250);
---初始化panel
function CarLogoGameView:InitView()
	---@type CarLogoGameCtrl
    self.ctrl=self.ctrl
	self:InitComponents()
end

---获取组件
function CarLogoGameView:InitComponents()
    self.btn_1=ComponentUtilGet.Button(self.transform,"content/top/btn_1");
    self.btn_trend=ComponentUtilGet.Button(self.transform,"content/top/history/btn_trend");
    self.btn_recharge=ComponentUtilGet.Button(self.transform,"content/top/btn_recharge");
    self.btn_players=ComponentUtilGet.Button(self.transform,"content/bottom/btn_players");
    self.btn_repeat=ComponentUtilGet.Button(self.transform,"content/bottom/btn_repeat")
    self.tmp_playerNum=ComponentUtilGet.TextMeshProUGUI(self.transform,"content/bottom/btn_players/tmp_playerNum");
    self.img_light=ComponentUtilGet.Image(self.transform,"content/center/result/Car/img_light");
    self.img_car=ComponentUtilGet.Image(self.transform,"content/center/result/Car/img_car");
    self.img_icon=ComponentUtilGet.Image(self.transform,"content/center/result/Car/img_icon");
    self.tmp_time=ComponentUtilGet.TextMeshProUGUI(self.transform,"content/center/timer/timer/tmp_time");
    self.muenRect=ComponentUtilGet.RectTransform(self.transform,"content/setting/mask/muen")
    self.btn_touch=ComponentUtilGet.Button(self.transform,"content/setting/btn_touch");
    self.btn_muen=ComponentUtilGet.Button(self.transform,"content/setting/btn_muen");
    self.btn_setting=ComponentUtilGet.Button(self.transform,"content/setting/mask/muen/btn_setting");
    self.btn_help=ComponentUtilGet.Button(self.transform,"content/setting/mask/muen/btn_help");
    self.btn_close=ComponentUtilGet.Button(self.transform,"content/setting/mask/muen/btn_close");

    self.tmp_totalPlayerNum=ComponentUtilGet.TextMeshProUGUI(self.btn_players.transform,"tmp_playerNum")
    ---提示信息
    self.tipsTrs = ComponentUtilGet.Transform(self.transform,"content/center/tips")
    self.tipsTimeEnd = ComponentUtilGet.GameObject(self.tipsTrs,"tips_time_end")
    self.tipsStartXiaZhu = ComponentUtilGet.GameObject(self.tipsTrs,"tips_start_xiazhu")
    self.tipsCenterTxt = ComponentUtilGet.TextMeshProUGUI(self.tipsTrs,"tips_center/tips_center_txt")
    self.colockStateTimeTrs = ComponentUtilGet.Transform(self.tipsTrs,"tips_center/colock_state_time")
    self.colockStateLeftText=ComponentUtilGet.TextMeshProUGUI(self.colockStateTimeTrs,"text") --倒计时
    self.colockStateTimeNum=ComponentUtilGet.TextMeshProUGUI(self.colockStateTimeTrs,"time") --倒计时
    self.three=ComponentUtilGet.Transform(self.tipsTrs,"three")

    --- 汽车灯
    self.carLights = {}
    self.carRoot = ComponentUtilGet.Transform(self.transform,"back/car")
    self.carPos = ComponentUtilGet.Transform(self.transform,"back/node")
    for i = 1, self.carRoot.childCount do
        table.insert(self.carLights, ComponentUtilGet.Image(self.carRoot:GetChild(i - 1),"Light"))
    end
    
    self.resultTrs=ComponentUtilGet.Transform(self.transform,"content/center/result");
    self.resultCar=ComponentUtilGet.GameObject(self.resultTrs,"Car")
    ---下注区域
    self.areasTrs=ComponentUtilGet.Transform(self.transform,"content/center/areas")
    ---@type CarLogoAreaItem[]
    self.areaViews = {};
    for i = 1, self.areasTrs.childCount do
        self.areaViews[i] = CarLogoAreaItem.New(self.areasTrs:GetChild(i-1));
    end
    ---车标 跑马灯
    self.logosTrs=ComponentUtilGet.Transform(self.transform,"content/center/logos")
    ---@type CarLogoItem[]
    self.logoViews = {};
    for i = 1, self.logosTrs.childCount do
        self.logoViews[i] = CarLogoItem.New(self.logosTrs:GetChild(i-1))
    end
    
    ---历史信息
    self.historyObj=ComponentUtilGet.GameObject(self.transform,"content/top/history")
    ---@type CarLogoHistoryItem
    self.history=CarLogoHistoryItem.New(self.historyObj)
    ---下注底注按钮
    self.chipInfos={}
    for i = 1, 5 do
        local chipItem={}
        chipItem.obj=ComponentUtilGet.Button(self.transform,"content/bottom/dizhu/"..i)
        chipItem.rectTrans=ComponentUtilGet.RectTransform(self.transform,"content/bottom/dizhu/"..i)
        chipItem.button=ComponentUtilGet.Button(chipItem.rectTrans)
        chipItem.effects=ComponentUtilGet.GameObject(chipItem.rectTrans,"checkd")
        chipItem.effects:SetActive(false)
        self.chipInfos[i]=chipItem
    end
    ---玩家
    self.selfPlayerRoot  = ComponentUtilGet.GameObject(self.transform,"content/bottom/selfPlayerRoot")
    self.selfPlayer = PlayerItem.New(self.selfPlayerRoot)
    ---底注节点prefab
    self.dizhuNode = ComponentUtilGet.GameObject(self.transform,"content/bottom/nodes")
end

---清空组件
function CarLogoGameView:ClearComponents()
    self.btn_trend=nil;
    self.btn_recharge=nil;
    self.btn_players=nil;
    self.tmp_playerNum=nil;
    self.img_light=nil;
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
    self:InitMarquee()
    self:InitLogos()
    self:EnterLight()
    self:InitUI()
end

function CarLogoGameView:InitUI()
    ---续押
    self.btn_repeat.interactable = false;
    self.tmp_totalPlayerNum.text="0"
    --请下注提示
    self.colockStateLeftText.text = LocalManager.GetStrById(200400008)
    self.colockStateTimeTrs.gameObject:SetActive(false)
    self.tipsStartXiaZhu:SetActive(false)
    self.tipsTimeEnd:SetActive(false)
    self.three.gameObject:SetActive(false)
    
    CarLogoConfig.allow=false
    
    self:InitXiaZhuLabel()
end

---初始化车标
function CarLogoGameView:InitLogos()
    for logo_id, indexs in ipairs(CarLogoConfig.LOGO_IDX) do
        for i, index in ipairs(indexs) do
            self.logoViews[index]:ShowLogo(logo_id);
        end
    end
end
---闪灯
function CarLogoGameView:FlashLight()
    local time  = 0.2
    for i=1,#self.logoViews do
        self.logoViews[i]:FlashLight(time,2)
    end
    for i=1,#self.carLights do
        Tools.DOFade_Repeat(self.carLights[i],time,2)
    end
end

function CarLogoGameView:EnterLight()
    local time  = 0.2
    for i = 1, self.carRoot.childCount do
        self.carRoot:GetChild(i-1):DOMove(self.carPos:GetChild(i-1).position,0.8)
    end
    for i=1,#self.logoViews do
        self.logoViews[i]:FlashLight(time,4)
    end
    for i=1,#self.carLights do
        Tools.DOFade_Repeat(self.carLights[i],time,4)
    end
end

function CarLogoGameView:LogoShowLinght(index)
    for i, view in ipairs(self.logoViews) do
        view:ShowChoose(true,i ~= index)
    end
end

------start Logo Marquee-----
function CarLogoGameView:InitMarquee()
    self.marqueeTimer = nil
    self.marqueeIndex = 1
    self.marqueeRunning = false
    self.marqueeInterval = 0.2 -- 当前间隔
    self.marqueeMinInterval = 0.04 -- 最快
    self.marqueeMaxInterval = 0.08 -- 最慢
    self.marqueeStep = 0.02 -- 步长
    self.marqueeTarget = 1 -- 目标索引
    self.marqueeState = "acc" -- "acc"加速 "const"匀速 "dec"减速
    self.marqueeLoopCount = 0 -- 跑的圈数
    self.marqueeTotalLoop = 2 -- 跑几圈后开始减速
    self.decelerateSteps = 10 -- 期望减速步数
end

function CarLogoGameView.CalcStepsToTarget(currentIndex, targetIndex, total)
    return (targetIndex - currentIndex + total) % total
end

function CarLogoGameView:StartMarquee(marqueeIndex,targetIndex)
    self.marqueeRunning = true
    self.marqueeIndex = marqueeIndex
    self.marqueeTarget = targetIndex
    
    self.marqueeInterval = self.marqueeMaxInterval
    self.marqueeState = "acc"
    self.marqueeLoopCount = 0
    
    if self.marqueeTimer then
        TimerManager.StopTimer(self, self.marqueeTimer)
    end
    self.marqueeTimer = TimerManager.StartTimer(self, function() self:MarqueeStep() end, self.marqueeInterval, -1)
end

function CarLogoGameView:MarqueeStep()
    if not self.marqueeRunning then return end

    self:LogoShowLinght(self.marqueeIndex)
    self.marqueeIndex = self.marqueeIndex + 1
    if self.marqueeIndex > #self.logoViews then
        self.marqueeIndex = 1
        self.marqueeLoopCount = self.marqueeLoopCount + 1
    end
    
    -- 状态切换
    if self.marqueeState == "acc" then
        self.marqueeInterval = self.marqueeInterval - self.marqueeStep
        if self.marqueeInterval <= self.marqueeMinInterval then
            self.marqueeInterval = self.marqueeMinInterval
            self.marqueeState = "const"
        end
    elseif self.marqueeState == "const" then
        -- 判断是否需要减速
        local stepsToTarget = self.CalcStepsToTarget(self.marqueeIndex-1, self.marqueeTarget, #self.logoViews)
        if self.marqueeLoopCount >= self.marqueeTotalLoop and stepsToTarget == self.decelerateSteps then
            self.marqueeState = "dec"
        end
    elseif self.marqueeState == "dec" then
        self.marqueeInterval = self.marqueeInterval + self.marqueeStep
        -- 判断是否到目标且足够慢
        if self.marqueeInterval >= self.marqueeMaxInterval and self.marqueeIndex-1 == self.marqueeTarget then
            self:StopMarquee()
            return
        end
    end

    -- 重新设置定时器间隔
    TimerManager.StopTimer(self, self.marqueeTimer)
    self.marqueeTimer = TimerManager.StartTimer(self, function() self:MarqueeStep() end, self.marqueeInterval, 0)
end

function CarLogoGameView:StopMarquee()
    self.marqueeRunning = false
    if self.marqueeTimer then
        TimerManager.StopTimer(self, self.marqueeTimer)
        self.marqueeTimer = nil
    end
    self:LogoShowLinght(self.marqueeTarget)

    if self.marqueeCallFunc then
        self.marqueeCallFunc()
        self.marqueeCallFunc = nil
    end
    --self.history:UpdateCarLogo()
end
------end Logo Marquee-----

---设置菜单显示隐藏
function CarLogoGameView:SettingFade()
    if self.settingShow then
        self.settingShow = false
        self.muenRect:DOLocalMoveY(self.muenRect.sizeDelta.y+30,0.5):SetEase(Ease.InBack)
        self.btn_touch.gameObject:SetActive(false)
    else
        self.settingShow = true
        self.muenRect:DOLocalMoveY(0,0.5):SetEase(Ease.OutBack)
        self.btn_touch.gameObject:SetActive(true)
    end

end

---
function CarLogoGameView:LogoFlyToHistory(index)
    self.history:PlayMoveAni()
    self.logoViews[index]:FlyLogoHistory(self.resultTrs,self.history:GetPoint())

end

--隐藏所有Logo的选中效果
function CarLogoGameView:UnChooseAllLogos()
    for i, v in ipairs(self.logoViews) do
        v:ShowChoose(false);
    end
end

--播放奔跑动画
--result {win_carlogo:{logo_index,logo_id},last_carlogo:{logo_index,logo_id}}
function CarLogoGameView:PlayRuningAnimtion(result, isPlay, callFunc)
    table.insert(self.ctrl.model.historyList,result.win_carlogo)
    if isPlay then
        self.marqueeCallFunc = callFunc
        self:StartMarquee(result.last_carlogo.logo_index, result.win_carlogo.logo_index)
    else
        self.LogoShowLinght(result.win_carlogo.logo_index)
        --self.history:UpdateCarLogo()
        if callFunc then  callFunc() end
    end
end

function CarLogoGameView:PlayCarEffectView(logo_id,callFunc)
    self.resultCar:SetActive(true)
    self.img_light.sprite=CarLogoHelper.LoadLogoResultSprite(logo_id,2)
    self.img_icon.sprite=CarLogoHelper.LoadLogoResultSprite(logo_id,3)
    
    local mat = self.img_car.material

    -- 1. 替换图片
    local tex = CarLogoHelper.LoadLogoResultTexture2D(logo_id)
    mat:SetTexture("_MainTex", tex)
    mat:SetFloat("_Progress", 0)
    
    
    self.img_icon.transform.localScale=Vector3.Zero()
    self.img_light.transform.localScale=Vector3.Zero()
    self.img_icon.transform:DOScale(Vector3(1,1,1),0.3):SetEase(Ease.InBack):OnComplete(function()
        self.img_light.transform:DOScale(Vector3(1,1,1),0.3):SetEase(Ease.InBack):OnComplete(function()

            -- 2. 动画显示
            local progress = 0
            local speed = 1.5
            self.playCarEffectTimer = TimerManager.StartTimer(self,function()
                progress = progress + speed * 0.02
                mat:SetFloat("_Progress", math.min(progress-0.5, 1))
                if progress >= 3.2 then
                    TimerManager.StopTimer(self,self.playCarEffectTimer)

                    self.resultCar:SetActive(false)
                    if callFunc then callFunc() end
                end
            end,0.02,-1,false)
            
        end)
    end)
    
end


--播放结算动画
function CarLogoGameView:PlayResultAnimation(result)
    --播放奔跑动画
    self:PlayRuningAnimtion(result, true,function()
        -- 播放车子特效
        self:PlayCarEffectView(result.win_carlogo.logo_id,function()

            -- 播放赢的区域闪动
            self.areaViews[result.win_carlogo.logo_id]:ShowWinFlashAnim(function()

            end)

            -- 播放筹码飞动效果
            --self.PlayCollectNoteAnim(result)
            --self.ShowResultCurrencyChange(result)
            
        end)
        
        TimerManager.StartTimer(self,function()
            self:LogoFlyToHistory(result.win_carlogo.logo_index)
        end,1.2)
    end)
    
end
---切换当前选中的底注
function CarLogoGameView:ChangeDiZhu(index)
    -- 参数验证
    if not index or index < 1 or index > #self.chipInfos then
        return
    end

    -- 如果点击的是当前已选中的按钮，不做任何操作
    if index == CarLogoConfig.dizhuIndex and self.chipInfos[index].effects.activeSelf then
        return
    end

    local oldIndex = CarLogoConfig.dizhuIndex
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
    CarLogoConfig.dizhuIndex = index
end

function CarLogoGameView:InitXiaZhuLabel()
    for i=1,#self.areaViews do
        self.areaViews[i]:UpdateTotal(0)
        self.areaViews[i]:UpdateSelf(0)
    end
end

function CarLogoGameView:UpdateXiaZhuLabel()
    for i=1,#self.areaViews do
        self.areaViews[i]:UpdateTotal(CarLogoConfig.totalDiZhuNums[i])
        self.areaViews[i]:UpdateSelf(CarLogoConfig.selfDiZhuNums[i])
    end
end

function CarLogoGameView:UpdateDiZhuBtnState()
    for i=1,#self.chipInfos do
        self.chipInfos[i].button.interactable = CarLogoConfig.allow and CarLogoConfig.dizhuNumArr[i]<=CarLogoConfig.goldRealNum
    end
end
---更新自己信息
function CarLogoGameView:UpdateSelf(player)
    self.selfPlayer:UpdatePlayer(player)
end
function CarLogoGameView:UpdateSelfGoldCount()
    self.selfPlayer:UpdateGoldCount(CarLogoConfig.goldRealNum)
end
---本玩家下注动画
function CarLogoGameView:PayXiaZhuCoinFly(side)
    CarLogoPlayCoinView:AnimateCoin(self.dizhuNode,CarLogoConfig.dizhuIndex,self.selfPlayer.transform.position,self.areaViews[side].noteRoot)
end
---其他玩家下注动画
function CarLogoGameView:PayOtherXiaZhuCoinFly(data)
    self:UpdateXiaZhuLabel()
    CarLogoPlayCoinView:AnimateCoin(self.dizhuNode,data.dizhuType,self.btn_players.transform.position,self.areaViews[data.areaType].noteRoot)
end

---显示房间已出的底注 不要动画
function CarLogoGameView:RefresAreaCoin()
    if CarLogoConfig.allXiaZhuData and #CarLogoConfig.allXiaZhuData>0 then
        for i=1,#CarLogoConfig.allXiaZhuData do
            CarLogoPlayCoinView:CreatCoinInArea(self.dizhuNode,CarLogoConfig.allXiaZhuData[i].dizhuType,self.areaViews[CarLogoConfig.allXiaZhuData[i].areaType].noteRoot)
        end
    end
end

---金币回收动画
function CarLogoGameView:PlayCompeleCoinFLy(datas,players,cards)

    ---测试
    local ratios = {0.3,0.7}
    local targetPos = {}
    targetPos[1] = self.selfPlayerRoot.transform.position
    targetPos[2] = self.btn_players.transform.position
    CarLogoPlayCoinView:DestroyCoin(targetPos,ratios)
    --奖励数值
    self.selfPlayer:ShowResultCount(Tools.RandomInt(-100,1000))
end

function CarLogoGameView:StartEffect(callFunc)
    --开始下注提示
    self.tipsStartXiaZhu:SetActive(true)
    self:UpdateXiaZhuLabel()
    TimerManager.StartTimer(self,function()
        self.tipsStartXiaZhu:SetActive(false)
    end,1.5,0,false)
    --点亮灯圈
    self:UnChooseAllLogos()
    --闪灯
    self:FlashLight()
    
    --倒计时
    CarLogoConfig.lessSeconds = CAR_LOGO_GAME_TIME
    self.colockStateTimeNum.text = CarLogoConfig.lessSeconds
    self.colockStateLeftText.text = LocalManager.GetStrById(200400008)
    self.colockStateTimeTrs.gameObject:SetActive(true)
    TimerManager.StartTimer(self, function
    ()
        CarLogoConfig.lessSeconds = CarLogoConfig.lessSeconds - 1
        self.colockStateTimeNum.text = CarLogoConfig.lessSeconds
        --倒计时3s
        if CarLogoConfig.lessSeconds==3 then
            self:PlayDaoJiShiEffect()
        end
    end, 1, CAR_LOGO_GAME_TIME, true,function()
        CarLogoConfig.allow=false
        self:UpdateDiZhuBtnState()
        self:SetRepeatState(false)
        
        --下注结束提示
        self.tipsTimeEnd:SetActive(true)
        TimerManager.StartTimer(self,function()
            self.tipsTimeEnd:SetActive(false)
        end,1.5,0,false)
        
        --结算倒计时
        CarLogoConfig.lessSeconds = CAR_LOGO_GAME_TIME+3
        self.colockStateLeftText.text = LocalManager.GetStrById(200500003)
        self.colockStateTimeNum.text = CarLogoConfig.lessSeconds
        TimerManager.StartTimer(self, function
        ()
            CarLogoConfig.lessSeconds = CarLogoConfig.lessSeconds - 1
            self.colockStateTimeNum.text = CarLogoConfig.lessSeconds
        end, 1, CAR_LOGO_GAME_TIME+3, true,function()
            --结算完成
        end)
        
    end)

    if callFunc then callFunc() end
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
    for i=0,1 do
        self.three:GetChild(i).gameObject:SetActive(false)
    end
    self.three.gameObject:SetActive(true)

    self.three:GetChild(2).gameObject:SetActive(true)
    for i=1,3 do
        TimerManager.StartTimer(self,function()
            if i==3 then
                self.three.gameObject:SetActive(false)
                return
            end
            self.three:GetChild(3-i).gameObject:SetActive(false)
            self.three:GetChild(2-i).gameObject:SetActive(true)
        end,i,0,false)
    end
end


---关闭界面
function CarLogoGameView:Close()   
    self.super.Close(self);
end

return CarLogoGameView

