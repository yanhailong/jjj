---
---Create by Administrator
---DateTime: 2025-07-02 18:28:37
---
---@class BirdsAnimalsGameView:BaseView
local BirdsAnimalsGameView=Class("BirdsAnimalsGameView",BaseView)
local BirdsAnimalsItem=require("SingleGames/BirdsAnimals/View/Item/BirdsAnimalsItem")
local BirdsAnimalsHistoryItem=require("SingleGames/BirdsAnimals/View/Item/BirdsAnimalsHistoryItem")
local BirdsAnimalsAreaItem=require("SingleGames/BirdsAnimals/View/Item/BirdsAnimalsAreaItem")
local BirdsAnimalsConfig=require("SingleGames/BirdsAnimals/BirdsAnimalsConfig")
local BirdsAnimalsHelper=require("SingleGames/BirdsAnimals/BirdsAnimalsHelper")
local BirdsAnimalsPlayCoinView=require("SingleGames/BirdsAnimals/View/BirdsAnimalsPlayCoinView")
local PlayerItem = require("SingleGames/DragonTigerFight/View/Item/PlayerItem")

local DOTween = CS.DG.Tweening.DOTween
local Ease = CS.DG.Tweening.Ease
DOTween:SetTweensCapacity(1000, 250);
---初始化panel
function BirdsAnimalsGameView:InitView()
	---@type BirdsAnimalsGameCtrl
    self.ctrl=self.ctrl
	self:InitComponents()
end

---获取组件
function BirdsAnimalsGameView:InitComponents()
    self.btn_trend=ComponentUtilGet.Button(self.transform,"content/top/history/btn_trend");
    self.btn_recharge=ComponentUtilGet.Button(self.transform,"content/top/btn_recharge");
    self.btn_1=ComponentUtilGet.Button(self.transform,"content/top/btn_1");
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
    self.txt_mybets=ComponentUtilGet.Text(self.transform,"content/center/tips/tips_center/mybets/txt_mybets");
    self.tmp_totalnote=ComponentUtilGet.TextMeshProUGUI(self.transform,"content/center/tips/tips_center/totalnote/tmp_totalnote");
    self.tmp_automatic=ComponentUtilGet.TextMeshProUGUI(self.transform,"content/center/tips/tips_center/automatic/tmp_automatic");

    self.bottomtips=ComponentUtilGet.Transform(self.transform,"content/center/bottomtips");
    self.img_watch=ComponentUtilGet.Image(self.transform,"content/center/bottomtips/img_watch");
    self.img_netganm=ComponentUtilGet.Image(self.transform,"content/center/bottomtips/img_netganm");
    self.img_tips1=ComponentUtilGet.Image(self.transform,"content/center/bottomtips/img_tips1");
    
    self.tipsTrs = ComponentUtilGet.Transform(self.transform,"content/center/tips")

    self.tipsTimeTrs = ComponentUtilGet.Transform(self.tipsTrs,"tips_time_center")
    self.tipsTimeEnd = ComponentUtilGet.GameObject(self.tipsTimeTrs,"tips_time_end")
    self.tipsStartXiaZhu = ComponentUtilGet.GameObject(self.tipsTimeTrs,"tips_start_xiazhu")
    
    self.tipsPassedTrs = ComponentUtilGet.Transform(self.tipsTrs,"tips_passed")
    self.tipsTimePassed = ComponentUtilGet.TextMeshProUGUI(self.tipsPassedTrs,"tips_time_passed")

    self.three=ComponentUtilGet.Transform(self.tipsTrs,"three")
    ---结果
    self.resultTrs=ComponentUtilGet.Transform(self.transform,"content/center/result");
    self.resultAnimal=ComponentUtilGet.GameObject(self.resultTrs,"Animal")
    self.img_name=ComponentUtilGet.Image(self.transform,"content/center/result/Animal/img_name");
    self.img_icon=ComponentUtilGet.Image(self.transform,"content/center/result/Animal/img_icon");
    self.img_rate=ComponentUtilGet.Text(self.transform,"content/center/result/Animal/img_rate");
    ---下注区域
    self.areasTrs=ComponentUtilGet.Transform(self.transform,"content/center/areas")
    ---@type BirdsAnimalsAreaItem[]
    self.areaViews = {};
    for i = 1, self.areasTrs.childCount do
        self.areaViews[i] = BirdsAnimalsAreaItem.New(self.areasTrs:GetChild(i-1),i);
    end
    ---车标 跑马灯
    self.logosTrs=ComponentUtilGet.Transform(self.transform,"content/center/logos")
    ---@type BirdsAnimalsItem[]
    self.logoViews = {};
    for i = 1, self.logosTrs.childCount do
        self.logoViews[i] = BirdsAnimalsItem.New(self.logosTrs:GetChild(i-1))
    end

    ---历史信息
    self.historyObj=ComponentUtilGet.GameObject(self.transform,"content/top/history")
    ---@type BirdsAnimalsHistoryItem
    self.history=BirdsAnimalsHistoryItem.New(self.historyObj)
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
function BirdsAnimalsGameView:ClearComponents()
    self.btn_trend=nil;
    self.btn_recharge=nil;
    self.btn_1=nil;
    self.btn_players=nil;
    self.tmp_totalPlayerNum=nil;
    self.btn_repeat=nil;
    self.txt_mybets=nil;
    self.tmp_totalnote=nil;
    self.tmp_automatic=nil;
    self.img_watch=nil;
    self.img_netganm=nil;
    self.img_tips1=nil;
    self.img_name=nil;
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
    self:InitUI()
end

function BirdsAnimalsGameView:InitUI()
    ---续押
    self.btn_repeat.interactable = false;
    self.tmp_totalPlayerNum.text="0"
    --请下注提示
    self.tipsStartXiaZhu:SetActive(false)
    self.tipsTimeEnd:SetActive(false)
    self.three.gameObject:SetActive(false)
    self.tipsPassedTrs.gameObject:SetActive(false)
    self.tipsTimeTrs.gameObject:SetActive(false)
    self.bottomtips.gameObject:SetActive(false)
    
    BirdsAnimalsConfig.allow=false

    self:InitXiaZhuLabel()
end

---初始化图标
function BirdsAnimalsGameView:InitLogos()
    for logo_id, indexs in ipairs(BirdsAnimalsConfig.LOGO_IDX) do
        for i, index in ipairs(indexs) do
            self.logoViews[index]:ShowLogo(logo_id);
        end
    end
end
---闪灯
function BirdsAnimalsGameView:FlashLight()
    local time  = 0.2
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
    if self.marqueeCor then
        coroutine.stop(self.marqueeCor)
        self.marqueeCor = nil
    end

    self.curve = CS.UnityEngine.AnimationCurve()
    for i=1,#BirdsAnimalsConfig.CURVE_KEYS do
        self.curve:AddKey(BirdsAnimalsConfig.CURVE_KEYS[i][1], BirdsAnimalsConfig.CURVE_KEYS[i][2])
    end
end

function BirdsAnimalsGameView:IntMove(from, to, leftTime, time)
    time = time or 6
    if leftTime > 0 then
        leftTime =  leftTime > time and time or leftTime
        to = to + BirdsAnimalsConfig.LOGO_MAX * 3

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

                    local index = i%BirdsAnimalsConfig.LOGO_MAX
                    if index<=0 then
                        index = index + BirdsAnimalsConfig.LOGO_MAX
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
    self.history:PlayMoveAni()
    self.logoViews[index]:FlyLogoHistory(self.resultTrs,self.history:GetPoint())

end

--隐藏所有Logo的选中效果
function BirdsAnimalsGameView:UnChooseAllLogos()
    for i, v in ipairs(self.logoViews) do
        v:ShowChoose(false);
    end
end

--播放奔跑动画
--result {win_logo:{logo_index,logo_id},last_logo:{logo_index,logo_id}}
function BirdsAnimalsGameView:PlayRuningAnimtion(result, isPlay, callFunc)
    table.insert(self.ctrl.model.historyList,result.win_logo)
    if isPlay then
        self.marqueeCallFunc = callFunc
        self:IntMove(result.last_logo.logo_index, result.win_logo.logo_index,6,6)
    else
        self.LogoShowLinght(result.win_logo.logo_index)
        --self.history:UpdateBirdsAnimals()
        if callFunc then  callFunc() end
    end
end

function BirdsAnimalsGameView:PlayCarEffectView(logo_id,callFunc)
    self.resultAnimal:SetActive(true)
    self.img_rate.text = "X"..BirdsAnimalsConfig.ODDS[logo_id]
    self.img_icon.sprite=BirdsAnimalsHelper.LoadLogoSprite(logo_id)
    self.img_name.sprite=BirdsAnimalsHelper.LoadNameTxtSprite(logo_id)
    self.img_name:SetNativeSize()
    self.img_icon:SetNativeSize()
    
    self.img_icon.transform.localScale=Vector3.Zero()
    self.img_icon.transform:DOScale(Vector3(1,1,1),0.2):SetEase(Ease.OutBack):OnComplete(function()
        TimerManager.StartTimer(self,function()
            --关闭
            self.resultAnimal:SetActive(false)
            if callFunc then callFunc() end
        end,2)

    end)

end


--播放结算动画
function BirdsAnimalsGameView:PlayResultAnimation(result)
    --播放奔跑动画
    self:PlayRuningAnimtion(result, true,function()
        -- 播放车子特效
        self:PlayCarEffectView(result.win_logo.logo_id,function()
            -- 播放赢的区域闪动
            local index = BirdsAnimalsHelper.FindIndexById(result.win_logo.logo_id)
            self.areaViews[index]:ShowWinFlashAnim(function()
                ---回收
                GlobalEvent.Notify(BirdsAnimalsConfig.EventBinner.XIAZHU_END,{})
                
            end)

            --飞鸟和走兽区域
            if BirdsAnimalsHelper.IsFeiQinType(result.win_logo.logo_id) then
                self.areaViews[3]:ShowWinFlashAnim()
            elseif BirdsAnimalsHelper.IsZouShouType(result.win_logo.logo_id) then
                self.areaViews[4]:ShowWinFlashAnim()
            end
            
            -- 播放筹码飞动效果
            --self.PlayCollectNoteAnim(result)
            --self.ShowResultCurrencyChange(result)
        end)
        
        TimerManager.StartTimer(self,function()
            self:LogoFlyToHistory(result.win_logo.logo_index)
        end,0.4)
    end)

end
---切换当前选中的底注
function BirdsAnimalsGameView:ChangeDiZhu(index)
    -- 参数验证
    if not index or index < 1 or index > #self.chipInfos then
        return
    end

    -- 如果点击的是当前已选中的按钮，不做任何操作
    if index == BirdsAnimalsConfig.dizhuIndex and self.chipInfos[index].effects.activeSelf then
        return
    end

    local oldIndex = BirdsAnimalsConfig.dizhuIndex
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
    BirdsAnimalsConfig.dizhuIndex = index
end

function BirdsAnimalsGameView:InitXiaZhuLabel()
    for i=1,#self.areaViews do
        self.areaViews[i]:UpdateTotal(0)
        self.areaViews[i]:UpdateSelf(0)
    end
end

function BirdsAnimalsGameView:UpdateXiaZhuLabel()
    for i=1,#self.areaViews do
        self.areaViews[i]:UpdateTotal(BirdsAnimalsConfig.totalDiZhuNums[i])
        self.areaViews[i]:UpdateSelf(BirdsAnimalsConfig.selfDiZhuNums[i])
    end
end

function BirdsAnimalsGameView:UpdateDiZhuBtnState()
    for i=1,#self.chipInfos do
        self.chipInfos[i].button.interactable = BirdsAnimalsConfig.allow and BirdsAnimalsConfig.dizhuNumArr[i]<=BirdsAnimalsConfig.goldRealNum
    end
end
---更新自己信息
function BirdsAnimalsGameView:UpdateSelf(player)
    self.selfPlayer:UpdatePlayer(player)
end
function BirdsAnimalsGameView:UpdateSelfGoldCount()
    self.selfPlayer:UpdateGoldCount(BirdsAnimalsConfig.goldRealNum)
end
---本玩家下注动画
function BirdsAnimalsGameView:PayXiaZhuCoinFly(side)
    BirdsAnimalsPlayCoinView:AnimateCoin(self.dizhuNode,BirdsAnimalsConfig.dizhuIndex,self.selfPlayer.transform.position,self.areaViews[side].noteRoot)
end
---其他玩家下注动画
function BirdsAnimalsGameView:PayOtherXiaZhuCoinFly(data)
    self:UpdateXiaZhuLabel()
    BirdsAnimalsPlayCoinView:AnimateCoin(self.dizhuNode,data.dizhuType,self.btn_players.transform.position,self.areaViews[data.areaType].noteRoot)
end

---显示房间已出的底注 不要动画
function BirdsAnimalsGameView:RefresAreaCoin()
    if BirdsAnimalsConfig.allXiaZhuData and #BirdsAnimalsConfig.allXiaZhuData>0 then
        for i=1,#BirdsAnimalsConfig.allXiaZhuData do
            BirdsAnimalsPlayCoinView:CreatCoinInArea(self.dizhuNode,BirdsAnimalsConfig.allXiaZhuData[i].dizhuType,self.areaViews[BirdsAnimalsConfig.allXiaZhuData[i].areaType].noteRoot)
        end
    end
end

---金币回收动画
function BirdsAnimalsGameView:PlayCompeleCoinFLy(datas,players,cards)

    ---测试
    local ratios = {0.3,0.7}
    local targetPos = {}
    targetPos[1] = self.selfPlayerRoot.transform.position
    targetPos[2] = self.btn_players.transform.position
    BirdsAnimalsPlayCoinView:DestroyCoin(targetPos,ratios)
    --奖励数值
    self.selfPlayer:ShowResultCount(Tools.RandomInt(-100,1000))
end

function BirdsAnimalsGameView:StartEffect(callFunc)
    --点亮灯圈
    self:UnChooseAllLogos()
    
    --开始下注提示
    self.tipsTimeTrs.gameObject:SetActive(true)
    self.tipsStartXiaZhu:SetActive(true)
    self:UpdateXiaZhuLabel()
    TimerManager.StartTimer(self,function()
        self.tipsStartXiaZhu:SetActive(false)
        self.tipsTimeTrs.gameObject:SetActive(false)
    end,1.5,0,false)

    --倒计时
    BirdsAnimalsConfig.lessSeconds = BIRDS_ANIMALS_GAME_TIME
    self.txt_mybets.text = BirdsAnimalsConfig.lessSeconds
    TimerManager.StartTimer(self, function
    ()
        BirdsAnimalsConfig.lessSeconds = BirdsAnimalsConfig.lessSeconds - 1
        self.txt_mybets.text = BirdsAnimalsConfig.lessSeconds
        --倒计时3s
        if BirdsAnimalsConfig.lessSeconds==3 then
            self:PlayDaoJiShiEffect()
        end
    end, 1, BIRDS_ANIMALS_GAME_TIME, true,function()
        BirdsAnimalsConfig.allow=false
        self:UpdateDiZhuBtnState()
        self:SetRepeatState(false)
        --闪灯
        self:FlashLight()
        
        --下注结束提示
        self.tipsTimeTrs.gameObject:SetActive(true)
        self.tipsTimeEnd:SetActive(true)
        TimerManager.StartTimer(self,function()
            self.tipsTimeEnd:SetActive(false)
            self.tipsTimeTrs.gameObject:SetActive(false)
        end,1.5,0,false)

        --结算倒计时
        BirdsAnimalsConfig.lessSeconds = BIRDS_ANIMALS_GAME_TIME+3
        self.txt_mybets.text = BirdsAnimalsConfig.lessSeconds
        TimerManager.StartTimer(self, function
        ()
            BirdsAnimalsConfig.lessSeconds = BirdsAnimalsConfig.lessSeconds - 1
            self.txt_mybets.text = BirdsAnimalsConfig.lessSeconds
        end, 1, BIRDS_ANIMALS_GAME_TIME+3, true,function()
            --结算完成
        end)

    end)

    if callFunc then callFunc() end
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
function BirdsAnimalsGameView:Close()   
    self.super.Close(self);
end

return BirdsAnimalsGameView

