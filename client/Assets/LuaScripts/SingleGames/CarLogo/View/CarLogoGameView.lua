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
local ChouMaFlyUtil=require("Logic/Common/ChouMaFlyUtil")
local CarLogoPlayerItem = require("SingleGames/CarLogo/View/Item/CarLogoPlayerItem")

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

    self.tmp_totalPlayerNum=ComponentUtilGet.TextMeshProUGUI(self.btn_players.transform,"tmp_playerNum")
    ---提示信息
    self.tipsTrs = ComponentUtilGet.Transform(self.transform,"content/center/tips")
    self.tipsTimeEnd = ComponentUtilGet.GameObject(self.tipsTrs,"tips_time_end")
    self.tipsStartXiaZhu = ComponentUtilGet.GameObject(self.tipsTrs,"tips_start_xiazhu")
    self.colockStateTimeTrs = ComponentUtilGet.Transform(self.transform,"content/center/timer")
    self.colockStateLeftText1=ComponentUtilGet.GameObject(self.colockStateTimeTrs,"tips1") --倒计时
    self.colockStateLeftText2=ComponentUtilGet.GameObject(self.colockStateTimeTrs,"tips2") --倒计时
    self.colockStateTimeNum=ComponentUtilGet.Text(self.colockStateTimeTrs,"tmp_time") --倒计时
    self.three=ComponentUtilGet.Transform(self.tipsTrs,"three")

    --- 汽车灯
    --self.carLights = {}
    --self.carRoot = ComponentUtilGet.Transform(self.transform,"back/car")
    --self.carPos = ComponentUtilGet.Transform(self.transform,"back/node")
    --for i = 1, self.carRoot.childCount do
    --    table.insert(self.carLights, ComponentUtilGet.Image(self.carRoot:GetChild(i - 1),"Light"))
    --end
    
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
    self:InitMarquee()
    self:InitLogos()
    self:EnterLight()
    self:InitUI()
end

function CarLogoGameView:InitChouMa()
    ---底注数值
    for i=1,#self.chipInfos do
        if self.ctrl.model.config.betList[i] then
            self.chipInfos[i].obj:SetActive(true)
            self.chipInfos[i].image.sprite = resMgr:LoadSprite(CarLogoConfig.dizhuImgAtlas,CarLogoConfig.dizhuColor[i])
            self.chipInfos[i].num.text = StringUtil.CheckDiZhu(self.ctrl.model.config.betList[i])

            local img = ComponentUtilGet.Image(self.dizhuNode.transform,"img")
            local num = ComponentUtilGet.Text(self.dizhuNode.transform,"num")
            img.sprite = resMgr:LoadSprite(CarLogoConfig.dizhuImgAtlas,CarLogoConfig.dizhuColor[i])
            num.text = self.chipInfos[i].num.text
        else
            self.chipInfos[i].obj:SetActive(false)
        end
    end
end

function CarLogoGameView:InitUI()
    self:InitChouMa()
    ---续押
    self.btn_repeat.interactable = false;
    self.tmp_totalPlayerNum.text="0"
    --请下注提示
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
            self.img_prev.sprite = resMgr:LoadSprite(CarLogoConfig.dizhuImgAtlas,"d_ph_jiantou1")
            self.img_next.sprite = resMgr:LoadSprite(CarLogoConfig.dizhuImgAtlas,"d_ph_jiantou2")
            self.img_prev.transform.localScale = Vector3.one
            self.img_next.transform.localScale = Vector3.one
            self.dizhupos = false
        end
    else if not self.dizhupos then
        self.dizhu:DOLocalMoveX(self.dizhu.localPosition.x-412,1):SetEase(Ease.OutBack)
        self.img_prev.sprite = resMgr:LoadSprite(CarLogoConfig.dizhuImgAtlas,"d_ph_jiantou2")
        self.img_next.sprite = resMgr:LoadSprite(CarLogoConfig.dizhuImgAtlas,"d_ph_jiantou1")
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
    for i=1,#CarLogoConfig.CURVE_KEYS do 
        self.curve:AddKey(CarLogoConfig.CURVE_KEYS[i][1], CarLogoConfig.CURVE_KEYS[i][2])
    end
end

function CarLogoGameView:IntMove(from, to, leftTime, time)
    time = time or 6
    if leftTime > 0 then
        leftTime =  leftTime > time and time or leftTime
        to = to + CarLogoConfig.LOGO_MAX * 3
        
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

                    local index = i%CarLogoConfig.LOGO_MAX
                    if index<=0 then
                        index = index + CarLogoConfig.LOGO_MAX
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

        self:IntMove(result.last_carlogo.logo_index, result.win_carlogo.logo_index, 6, 6)
    else
        self.LogoShowLinght(result.win_carlogo.logo_index)
        --self.history:UpdateCarLogo()
        if callFunc then  callFunc() end
    end
end

function CarLogoGameView:PlayCarEffectView(logo_id,callFunc)
    self.resultCar:SetActive(true)
    self.areasTrs.gameObject:SetActive(false)
    self.img_icon.sprite=CarLogoHelper.LoadLogoSprite(logo_id)
    self.img_car.sprite=CarLogoHelper.LoadLogoResultSprite(logo_id)
    
    self.img_car.transform.localScale=Vector3.Zero()
    self.img_car.transform:DOScale(Vector3(1,1,1),0.3):SetEase(Ease.InBack)
    
    TimerManager.StartTimer(self,function()
        self.resultCar:SetActive(false)
        self.areasTrs.gameObject:SetActive(true)
      
        if callFunc then callFunc() end
    end,1.2)
end


--播放结算动画
function CarLogoGameView:PlayResultAnimation(result)
    --播放奔跑动画
    self:PlayRuningAnimtion(result, true,function()
        -- 播放车子特效
        self:PlayCarEffectView(result.win_carlogo.logo_id,function()
            
            self:LogoFlyToHistory(result.win_carlogo.logo_index)
        end)
        
        TimerManager.StartTimer(self,function()
            -- 播放赢的区域闪动
            --self.areaViews[result.win_carlogo.logo_id]:ShowWinFlashAnim()
            --回收
            --GlobalEvent.Notify(CarLogoConfig.EventBinner.XIAZHU_END,{})
            
        end,2)
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
    ChouMaFlyUtil:AnimateCoin(self.dizhuNode,CarLogoConfig.dizhuIndex,self.selfPlayer.transform.position,self.areaViews[side].noteRoot,
            self.ctrl.model.config.betList[CarLogoConfig.dizhuIndex])
end
---其他玩家下注动画
function CarLogoGameView:PayOtherXiaZhuCoinFly(data)
    self:UpdateXiaZhuLabel()
    ChouMaFlyUtil:AnimateCoin(self.dizhuNode,data.dizhuType,self.btn_players.transform.position,self.areaViews[data.areaType].noteRoot,
            self.ctrl.model.config.betList[data.dizhuType])
end

---显示房间已出的底注 不要动画
function CarLogoGameView:RefresAreaCoin()
    if CarLogoConfig.allXiaZhuData and #CarLogoConfig.allXiaZhuData>0 then
        for i=1,#CarLogoConfig.allXiaZhuData do
            ChouMaFlyUtil:CreatCoinInArea(self.dizhuNode,CarLogoConfig.allXiaZhuData[i].dizhuType,self.areaViews[CarLogoConfig.allXiaZhuData[i].areaType].noteRoot,
                    self.ctrl.model.config.betList[CarLogoConfig.allXiaZhuData[i].dizhuType])
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
    ChouMaFlyUtil:DestroyCoin(targetPos,ratios)
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
    self.colockStateLeftText1:SetActive(true)
    self.colockStateLeftText2:SetActive(false)
    self.colockStateTimeTrs.gameObject:SetActive(true)
    TimerManager.StartTimer(self, function
    ()
        CarLogoConfig.lessSeconds = CarLogoConfig.lessSeconds - 1
        self.colockStateTimeNum.text = CarLogoConfig.lessSeconds
        --倒计时3s
        if CarLogoConfig.lessSeconds==3 then
            self:PlayDaoJiShiEffect()
        end
    end, 1, CAR_LOGO_GAME_TIME+1, true,function()
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
        self.colockStateTimeNum.text = CarLogoConfig.lessSeconds
        self.colockStateLeftText1:SetActive(false)
        self.colockStateLeftText2:SetActive(true)
        TimerManager.StartTimer(self, function
        ()
            CarLogoConfig.lessSeconds = CarLogoConfig.lessSeconds - 1
            self.colockStateTimeNum.text = CarLogoConfig.lessSeconds
        end, 1, CAR_LOGO_GAME_TIME+3, true,function()
            --结算完成
            self.colockStateTimeTrs.gameObject:SetActive(false)
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

