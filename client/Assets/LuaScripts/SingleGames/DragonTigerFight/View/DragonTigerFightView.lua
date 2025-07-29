---
---Create by Administrator
---DateTime: 2025-06-21 15:09:13
---
---@class DragonTigerFightView:BaseView
local DragonTigerFightView=Class("DragonTigerFightView",BaseView)
local config=require("SingleGames/DragonTigerFight/DragonTigerFightConfig")
local RoadView = require("SingleGames/DragonTigerFight/View/RoadView")
local CardItem = require("SingleGames/DragonTigerFight/View/Item/CardItem")
local DragonTigerFightSounds = require("SingleGames/DragonTigerFight/DragonTigerFightSounds")

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

    self.xiazhuArea = ComponentUtilGet.Transform(self.transform,"content/center/XiaZhu")
    self.longClickArea = ComponentUtilGet.Transform(self.transform,"content/clickRect/longClick")
    self.huClickArea = ComponentUtilGet.Transform(self.transform,"content/clickRect/huClick")
    self.heClickArea = ComponentUtilGet.Transform(self.transform,"content/clickRect/heClick")
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
    
    self.huWo=ComponentUtilGet.GameObject(self.tipsTrs,"eff_DragonTigerFight_hu_won/eff_DragonTigerFight_hu_won"):GetComponent("ParticleSystem")
    self.longWo=ComponentUtilGet.GameObject(self.tipsTrs,"eff_DragonTigerFight_long_won/eff_DragonTigerFight_long_won"):GetComponent("ParticleSystem")
    ---路单信息
    ---@type RoadView
    self.roadView=RoadView.New(ComponentUtilGet.GameObject(self.transform,"Background/RoadView"))

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
    self.btn_repeat=nil;
    self.longClickArea=nil;
    self.huClickArea=nil;
    self.heClickArea=nil;
    self.xiazhuNumLabels = nil;
    self.xiazhuSelfNumsLabels=nil;
    self.xiazhuStarAreas=nil;
end


---设置续投按钮是否可以点击 当前局已经手动投注或者上局未投注不能点 其他可点
function DragonTigerFightView:SetRepeatState(isOn)
    if isOn then
        self.btn_repeat.interactable = true;
    else
        self.btn_repeat.interactable = false;
    end
end

---初始界面
function DragonTigerFightView:InitUI()
    DragonTigerFightSounds.PlaySoundMusic()
    ---续押
    self:SetRepeatState(false)
    
    ---初始筹码数值
    self.ctrl.commCtrl:InitChouMa(self.model.betPointList)
    
    ---路单数据
    self.RoadHistoryRecord = nil
    
    self.startTrs.gameObject:SetActive(false)
    self.resultTrs.gameObject:SetActive(false)
    self.resultBgTrs.gameObject:SetActive(false)
    
    self.colockStateTimeTrs.gameObject:SetActive(false)
    self.tipsCenterTxt.gameObject:SetActive(false)
    self.tipsWaitopenTxt.gameObject:SetActive(false)
    self.tipsStartXiaZhu:SetActive(false)
    self.tipsTimeEnd:SetActive(false)
    self.tipsTimeThree:SetActive(false)
    self.resultWinTrs.gameObject:SetActive(false)
    self.colockNumTrs.gameObject:SetActive(false)
    self.tipsEnterWait.gameObject:SetActive(false)
    self.resultCard1:Hiden()
    self.resultCard2:Hiden()
    self.roadView.gameObject:SetActive(true)
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
        self.ctrl.commCtrl:PlayCompeleCoinFLy(result.playerSettleInfos)
        --- 更新获奖玩家金币
        self.ctrl.commCtrl:UpdatePlayers(result.playerInfos)
        self.ctrl.commCtrl:UpdatePlayerNum(self.model.playersNum)
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
    self.ctrl.commCtrl:UpdatePlayers(model.players)
    self.ctrl.commCtrl:UpdatePlayerNum(model.playersNum)
    self.ctrl.commCtrl:UpdateSelf()
    
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
            self.ctrl.commCtrl:ShowAreaChouMa(value)
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


-- 切换状态
function DragonTigerFightView:OnGameStatus(status)
    logError("OnGameStatus:"..status)
    -- status: 1准备阶段，2押分阶段，3亮牌阶段，4结算阶段
    self.model.status = status
    config.lessSeconds = Mathf.Round(config.StageTime[status]/1000)
    config.allow= status==2

    -- 结算阶段 特殊处理
    if status == 4 then
        self.ctrl.commCtrl:UpdateDiZhuBtnState()
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
        self.model:ResetConfig()
        self.ctrl.commCtrl:UpdateDiZhuBtnState()
        self:SetRepeatState(false)
        self:StartEffect()
    elseif status == 2 then -- 押分阶段
        self.ctrl.commCtrl:UpdateDiZhuBtnState()
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
                self.tipsTimeThree:SetActive(true)
                self.ctrl.commCtrl:PlayDaoJiShiEffect()
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
        self.ctrl.commCtrl:UpdateDiZhuBtnState()
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
    TimerManager.StopAllTimer(self)
    DragonTigerFightSounds.StopSoundMusic()
    self.super.Close(self);
end

return DragonTigerFightView