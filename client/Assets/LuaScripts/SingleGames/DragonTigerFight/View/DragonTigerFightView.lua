---
---Create by Administrator
---DateTime: 2025-06-21 15:09:13
---
---@class DragonTigerFightView:BaseView
local DragonTigerFightView=Class("DragonTigerFightView",BaseView)
local config=require("SingleGames/DragonTigerFight/DragonTigerFightConfig")
local coinFlyAnim = require("SingleGames/DragonTigerFight/View/PlayCoin")
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
    self:InitUI()
end

---获取组件
function DragonTigerFightView:InitComponents()
    self.btn_1=ComponentUtilGet.Button(self.transform,"content/top/btn_1");
    self.btn_2=ComponentUtilGet.Button(self.transform,"content/top/btn_2")
    self.btn_repeat=ComponentUtilGet.Button(self.transform,"content/buttom/btn_repeat");
    self.btn_players=ComponentUtilGet.Button(self.transform,"content/buttom/btn_players");
    self.tmp_totalPlayerNum=ComponentUtilGet.Text(self.btn_players.transform,"tmp_total_player_num")
    self.dizhu=ComponentUtilGet.Transform(self.transform,"content/buttom/dizhu");
    self.xiazhuArea = ComponentUtilGet.Transform(self.transform,"content/center/XiaZhu")
    self.longClickArea = ComponentUtilGet.Transform(self.transform,"content/clickRect/longClick")
    self.huClickArea = ComponentUtilGet.Transform(self.transform,"content/clickRect/huClick")
    self.heClickArea = ComponentUtilGet.Transform(self.transform,"content/clickRect/heClick")
    self.selfPlayerRoot  = ComponentUtilGet.GameObject(self.transform,"content/buttom/SelfHead")
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
 
    ---下注底注按钮
    self.chipInfos={}
    for i = 1, 5 do
        local chipItem={}
        chipItem.obj=ComponentUtilGet.Button(self.transform,"content/buttom/dizhu/"..i)
        chipItem.rectTrans=ComponentUtilGet.RectTransform(self.transform,"content/buttom/dizhu/"..i)
        chipItem.button=ComponentUtilGet.Button(chipItem.rectTrans)
        chipItem.effects=ComponentUtilGet.GameObject(chipItem.rectTrans,"checkd")
        chipItem.effects:SetActive(false)
        self.chipInfos[i]=chipItem
    end
    ---底注节点
    self.dizhuNode = ComponentUtilGet.GameObject(self.transform,"content/buttom/nodes")
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
    
    self.tipsCenterTxt = ComponentUtilGet.Transform(self.tipsTrs,"tips_center/tips_center_txt")
    self.colockStateTimeTrs = ComponentUtilGet.Transform(self.tipsTrs,"tips_center/colock_state_time")
    self.colockStateTimeNum=ComponentUtilGet.Text(self.colockStateTimeTrs,"time") --倒计时
    self.colockNumTrs=ComponentUtilGet.Transform(self.tipsTrs,"tips_center/colock_num")
    self.colockNumTime=ComponentUtilGet.Text(self.colockNumTrs,"time")
    
    self.three=ComponentUtilGet.Transform(self.tipsTrs,"three")
    
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
    self.xiazhuLight=nil;
end

---进入房间 对当前房间阶段数据进行初始
function DragonTigerFightView:EnterRoom()
    ---下注阶段 需要先初始历史筹码和下注信息
    ---下注完成等待结果阶段 历史筹码和下注信息 正在结算动画
    ---完成结算等待开局 
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
        self.chipInfos[i].button.interactable = config.allow and config.dizhuNumArr[i]<=config.goldRealNum
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
    coinFlyAnim:AnimateCoin(self.dizhuNode,config.dizhuIndex,self.selfPlayer.transform.position,self.xiazhuStarAreas[side])
end
---通过id找到玩家
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
    self:UpdateXiaZhuLabel()
    
    for i=1,#self.ctrl.model.players do
        ---其他Top玩家下注动画
        if data.id == self.ctrl.model.players[i].id then
            local playerItem = self:FindPlayerByID(data.id)
            if playerItem ~= nil then
                coinFlyAnim:AnimateCoin(self.dizhuNode,data.dizhuType,playerItem.transform.position,self.xiazhuStarAreas[data.areaType])
            end
            break
        end

        if i>=6 then
            coinFlyAnim:AnimateCoin(self.dizhuNode,data.dizhuType,self.btn_players.transform.position,self.xiazhuStarAreas[data.areaType])
            break
        end
    end
end

---显示房间已出的底注 不要动画
function DragonTigerFightView:RefresAreaCoin()
    if config.allXiaZhuData and #config.allXiaZhuData>0 then
        for i=1,#config.allXiaZhuData do
            coinFlyAnim:CreatCoinInArea(self.dizhuNode,config.allXiaZhuData[i].dizhuType,self.xiazhuStarAreas[config.allXiaZhuData[i].areaType])
        end
    end
end

---金币回收动画
function DragonTigerFightView:PlayCompeleCoinFLy(datas,players,cards)
    local result = 0
    if cards[1]>cards[2] then
        result = 1
    elseif cards[1] == cards[2] then
        result = 3
    else
        result = 2
    end

    ---测试
    local ratios = {0.3,0.2,0.5}
    local targetPos = {}
    local p = Tools.RandomInt(1,6)
    targetPos[1] = self.selfPlayerRoot.transform.position
    targetPos[2] = self.btn_players.transform.position
    targetPos[3] = self.AllOtherPlayerHeads[p].transform.position
    coinFlyAnim:DestroyCoin(targetPos,ratios)
    --奖励数值
    self.selfPlayer:ShowResultCount(Tools.RandomInt(-100,1000))
    self.AllOtherPlayerHeads[p]:ShowResultCount(Tools.RandomInt(-100,1000))
end



---初始界面
function DragonTigerFightView:InitUI()
    ---续押
    self.btn_repeat.interactable = false;
    ---其他玩家信息
    for i=1,#self.AllOtherPlayerHeads do
        self.AllOtherPlayerHeads[i]:UpdateGoldCount(i)
    end

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
    self.three.gameObject:SetActive(false)
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
---@param cards 龙虎牌型 牌型,牌值
function DragonTigerFightView:ResultEffect(cards,callFunc)
    config.allow=false
    config.currStatus=2
    self:UpdateDiZhuBtnState()
    
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
        config.currStatus = 3
        self.resultCard1:ShowFront()
    end, 2, 0, true)
    TimerManager.StartTimer(self, function
    ()
        self.resultCard2:ShowFront()
    end, 3, 0, true)
    --结果
    TimerManager.StartTimer(self, function
    ()
        local longCar = cards[1]%13
        local huCar = cards[2]%13
        if longCar>huCar then
            config.side = DRAGON_TIGER_FIGHT_WIN_SIDE.LONG
            self.resultWinTrs:GetChild(0).gameObject:SetActive(true)
        elseif longCar<huCar then
            config.side = DRAGON_TIGER_FIGHT_WIN_SIDE.HU
            self.resultWinTrs:GetChild(1).gameObject:SetActive(true)
        else
            config.side = DRAGON_TIGER_FIGHT_WIN_SIDE.HE
            self.resultWinTrs:GetChild(2).gameObject:SetActive(true)
        end
        --结果动画
        
    end, 4, 0, true)
    
    TimerManager.StartTimer(self, function
    ()
        self.resultWinTrs.gameObject:SetActive(false)
        self:InitXiaZhuLabel()
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

        if callFunc then
            callFunc()
        end
    end,8, 0, true)
    
end

---开始动画播放
function DragonTigerFightView:StartEffect(callFunc)
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
        self.tipsCenterTxt.gameObject:SetActive(false)
        --开始下注提示
        self.tipsStartXiaZhu:SetActive(true)
        self:UpdateXiaZhuLabel()
        TimerManager.StartTimer(self,function()
            self.tipsStartXiaZhu:SetActive(false)
        end,1.5,0,false)
        
        --倒计时
        config.lessSeconds = DRAGON_TIGER_FIGHT_GAME_TIME
        self.colockStateTimeNum.text = config.lessSeconds
        self.colockStateTimeTrs.gameObject:SetActive(true)
        TimerManager.StartTimer(self, function
        ()
            config.lessSeconds = config.lessSeconds - 1
            self.colockStateTimeNum.text = config.lessSeconds 
            --倒计时3s
            if config.lessSeconds==3 then
                self.colockStateTimeTrs.gameObject:SetActive(false)
                self:PlayDaoJiShiEffect()
            end
        end, 1, DRAGON_TIGER_FIGHT_GAME_TIME, true,function()
            self:SetRepeatState(false)
        end)
        
        if callFunc then callFunc() end
    end)
    sequence:Play()
    
end

---倒计时3秒
function DragonTigerFightView:PlayDaoJiShiEffect()
    for i=0,1 do
        self.three:GetChild(i).gameObject:SetActive(false)
    end
    self.three.gameObject:SetActive(true)
    self.tipsTimeThree:SetActive(true)
    
    self.three:GetChild(2).gameObject:SetActive(true)
    for i=1,3 do
        TimerManager.StartTimer(self,function()
            if i==3 then
                self.three.gameObject:SetActive(false)
                self.tipsTimeThree:SetActive(false)
                return
            end
            self.three:GetChild(3-i).gameObject:SetActive(false)
            self.three:GetChild(2-i).gameObject:SetActive(true)
        end,i,0,false)
    end
end

---更新自己信息
function DragonTigerFightView:UpdateSelf(player)
    self.selfPlayer:UpdatePlayer(player)
end
function DragonTigerFightView:UpdateSelfGoldCount()
    self.selfPlayer:UpdateGoldCount(config.goldRealNum)
end
---其他玩家信息更新
function DragonTigerFightView:UpdatePlayers(players)
    if players ~=nil and #players>0 then
        ---玩家排序
        table.sort(players, function(a, b)
            return a.coin < b.coin
        end)

        for i=1,#players do
            self.AllOtherPlayerHeads[i]:UpdatePlayer(players[i])
            if i>=#self.AllOtherPlayerHeads then
                break
            end
        end
    end
end

---更新路信息
function DragonTigerFightView:UpdateRoleView(data)
    self.RoadHistoryRecord = data
    self.roadView:UpdatePanelInfo(self.RoadHistoryRecord, true)
end

---关闭界面
function DragonTigerFightView:Close()
    coinFlyAnim:Destroy()
    self.super.Close(self);
end

return DragonTigerFightView

