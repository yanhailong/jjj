---
---Create by Administrator
---DateTime: 2025-07-14 18:34:27
---
---@class FishPrawnCrabGameView:BaseView
local FishPrawnCrabGameView=Class("FishPrawnCrabGameView",BaseView)
local FishPrawnCrabConfig = require("SingleGames/FishPrawnCrab/FishPrawnCrabConfig")
local FishPrawnCrabPlayerItem = require("SingleGames/FishPrawnCrab/View/Item/FishPrawnCrabPlayerItem")
local DOTween = CS.DG.Tweening.DOTween
local Ease = CS.DG.Tweening.Ease

---初始化panel
function FishPrawnCrabGameView:InitView()
	---@type FishPrawnCrabGameCtrl
    self.ctrl=self.ctrl
	self:InitComponents()

    ---下注底注按钮
    self:InitChipInfos()
    ---提示信息
    self:InitTips()
    ---结果信息
    self:InitGameResult()
    ---所有玩家
    self:InitPalyers()
    ---下注区域
    self:InitBetArea()
    --游戏记录
    self:InitGameRecords()
end

---获取组件
function FishPrawnCrabGameView:InitComponents()
    self.btn_1=ComponentUtilGet.Button(self.transform,"content/top/btn_1");
    self.btn_recharge=ComponentUtilGet.Button(self.transform,"content/top/btn_recharge");
    self.btn_repeat=ComponentUtilGet.Button(self.transform,"content/bottom/btn_repeat");
    self.btn_players=ComponentUtilGet.Button(self.transform,"content/bottom/btn_players");
    self.tmp_total_player_num=ComponentUtilGet.Text(self.transform,"content/bottom/btn_players/tmp_total_player_num");
    self.obj_PlayerRoot=ComponentUtilGet.GameObject(self.transform,"content/obj_PlayerRoot");
    self.btn_touch=ComponentUtilGet.Button(self.transform,"content/setting/btn_touch");
    self.btn_muen=ComponentUtilGet.Button(self.transform,"content/setting/btn_muen");
    self.trans_menu_panel=ComponentUtilGet.Transform(self.transform,"content/setting/mask/trans_menu_panel");
    self.btn_setting=ComponentUtilGet.Button(self.transform,"content/setting/mask/trans_menu_panel/btn_setting");
    self.btn_help=ComponentUtilGet.Button(self.transform,"content/setting/mask/trans_menu_panel/btn_help");
    self.btn_close=ComponentUtilGet.Button(self.transform,"content/setting/mask/trans_menu_panel/btn_close");

    ---荷官
    self.btn_dealer = ComponentUtilGet.Button(self.transform,"content/Dealer")
end

---下注底注按钮
function FishPrawnCrabGameView:InitChipInfos()
    self.chipInfos={}
    for i = 1, #FishPrawnCrabConfig.betValuesArr do
        local chipItem={}
        chipItem.obj=ComponentUtilGet.Button(self.transform,"content/bottom/stakes/"..i)
        chipItem.rectTrans=ComponentUtilGet.RectTransform(self.transform,"content/bottom/stakes/"..i)
        chipItem.button=ComponentUtilGet.Button(chipItem.rectTrans)
        chipItem.effects=ComponentUtilGet.GameObject(chipItem.rectTrans,"checkd")
        chipItem.effects:SetActive(false)
        self.chipInfos[i]=chipItem
    end
end

---提示信息
function FishPrawnCrabGameView:InitTips()
    self.tipsTrs = ComponentUtilGet.Transform(self.transform,"content/tips")
    self.tipsStopBetting = ComponentUtilGet.GameObject(self.tipsTrs,"tips_stop_betting")
    self.tipsStartToBet = ComponentUtilGet.GameObject(self.tipsTrs,"tips_start_to_bet")
    self.tipsTimeThree = ComponentUtilGet.GameObject(self.tipsTrs,"tips_time_three")

    self.colockStateTimeTrs = ComponentUtilGet.Transform(self.tipsTrs,"tips_center/colock_state_time")
    self.colockStateTimeNum = ComponentUtilGet.Text(self.colockStateTimeTrs,"time") --倒计时
    self.colockStateTimePrepare = ComponentUtilGet.GameObject(self.colockStateTimeTrs,"prepare") --准备倒计时文字
    self.colockStateTimeBet = ComponentUtilGet.GameObject(self.colockStateTimeTrs,"bet") --下注倒计时文字
    self.colockStateTimeSettlement = ComponentUtilGet.GameObject(self.colockStateTimeTrs,"settlement") --结算倒计时文字
    self.colockNumTrs = ComponentUtilGet.Transform(self.tipsTrs,"tips_center/count_down")
    self.colockNumTime = ComponentUtilGet.Text(self.colockNumTrs,"time")

    self.three = ComponentUtilGet.Transform(self.tipsTrs,"three")
end

---所有玩家
function FishPrawnCrabGameView:InitPalyers()
    self.AllOtherPlayerHeads = {}
    local otherPlayerTrs = ComponentUtilGet.Transform(self.transform,"content/obj_PlayerRoot")
    for i = 1, 6 do
        self.AllOtherPlayerHeads[#self.AllOtherPlayerHeads + 1] = FishPrawnCrabPlayerItem.New(otherPlayerTrs:GetChild(i-1).gameObject)
    end
    
    self.selfPlayerRoot  = ComponentUtilGet.GameObject(self.transform,"content/bottom/SelfHead")
    self.selfPlayer = FishPrawnCrabPlayerItem.New(self.selfPlayerRoot)
end

---下注区域
function FishPrawnCrabGameView:InitBetArea()
    self.betAreaRoot = ComponentUtilGet.Transform(self.transform,"content/center/bet")
    self.clickRect = ComponentUtilGet.Transform(self.transform,"content/clickRect")
    
    ---下注金币落点
    ---@type  TMPro.TextMeshProUGUI[]
    self.betAreas = {}
    ---个人下注数量
    ---@type  TMPro.TextMeshProUGUI[]
    self.betSelfNumLabels = {}
    ---所有人总下注数量
    ---@type  TMPro.TextMeshProUGUI[]
    self.betTotalNumLabels = {}
    for i=1,self.clickRect.childCount do
        self.betAreas[i] = ComponentUtilGet.Transform(self.clickRect:GetChild(i-1),"chips")
        self.betSelfNumLabels[i] = ComponentUtilGet.TextMeshProUGUI(self.clickRect:GetChild(i-1),"selfBet/num")
        self.betTotalNumLabels[i] = ComponentUtilGet.TextMeshProUGUI(self.clickRect:GetChild(i-1),"totalBet/num")
    end

    ---押中高亮
    self.winHighLights = {}
    for i=1,self.betAreaRoot.childCount do
        local trs = self.betAreaRoot:GetChild(i-1)
        self.winHighLights[i] = ComponentUtilGet.Image(trs,"bg")
    end
end

---结果信息
function FishPrawnCrabGameView:InitGameResult()
    self.dicePlate = ComponentUtilGet.GameObject(self.transform, "content/result/plate")
    self.diceBowl = ComponentUtilGet.GameObject(self.transform, "content/result/bowl")
    self.diceImages = {}
    self.diceTexts = {}
    for i = 1, FishPrawnCrabConfig.diceCount do
        self.diceImages[i] = ComponentUtilGet.Image(self.transform, "content/result/dices/dice" .. i)
        self.diceTexts[i] = ComponentUtilGet.TextMeshProUGUI(self.transform, "content/result/dices/dice" .. i .."/Text (TMP)")
    end
end

--游戏记录
function FishPrawnCrabGameView:InitGameRecords()
    local recordRootTrans = ComponentUtilGet.Transform(self.transform, "content/records")
    self.recordsRootObj = recordRootTrans.gameObject
    self.latestRecordIconObj = ComponentUtilGet.GameObject(recordRootTrans, "latest_image")
    self.recordUIDatas = {}
    for i = 1, FishPrawnCrabConfig.showRecordCount do
        local perRecordData = {}
        perRecordData.rootObj = ComponentUtilGet.GameObject(recordRootTrans, "record_grid/record" .. i)
        local diceImages = {}
        local diceTexts = {}
        for diceIndex = 1, FishPrawnCrabConfig.diceCount do
            diceImages[diceIndex] = ComponentUtilGet.Image(perRecordData.rootObj.transform, "dice" .. diceIndex)
            diceTexts[diceIndex] = ComponentUtilGet.TextMeshProUGUI(diceImages[diceIndex].transform:GetChild(0))
        end
        perRecordData.diceImages = diceImages
        perRecordData.diceTexts = diceTexts
        
        self.recordUIDatas[i] = perRecordData
    end
end

---清空组件
function FishPrawnCrabGameView:ClearComponents()
    self.btn_1=nil;
    self.btn_recharge=nil;
    self.btn_repeat=nil;
    self.btn_players=nil;
    self.tmp_total_player_num=nil;
    self.img_1=nil;
    self.img_2=nil;
    self.img_3=nil;
    self.img_4=nil;
    self.img_5=nil;
    self.obj_PlayerRoot=nil;
    self.btn_touch=nil;
    self.btn_muen=nil;
    self.trans_menu_panel=nil;
    self.btn_setting=nil;
    self.btn_help=nil;
    self.btn_close=nil;
end

---初始化View数据
function FishPrawnCrabGameView:InitPanelData(args)
    self.btn_repeat.interactable = false

    ---其他玩家信息
    for i = 1, #self.AllOtherPlayerHeads do
        self.AllOtherPlayerHeads[i]:SetActive(false)
    end

    for i = 1, #self.winHighLights do
        self.winHighLights[i].gameObject:SetActive(false)
    end
    
    self.recordsRootObj:SetActive(false)
    self.latestRecordIconObj:SetActive(false)
end

---关闭界面
function FishPrawnCrabGameView:Close()   
    self.super.Close(self);
end

---切换当前选中的底注
function FishPrawnCrabGameView:ChangeAnte(index)
    -- 参数验证
    if not index or index < 1 or index > #self.chipInfos then
        return
    end

    -- 如果点击的是当前已选中的按钮，不做任何操作
    if index == self.ctrl.betIndex and self.chipInfos[index].effects.activeSelf then
        return
    end

    local oldIndex = self.ctrl.betIndex
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
    self.ctrl.betIndex = index
end

---倒计时3秒
function FishPrawnCrabGameView:PlayDaoJiShiEffect()
    for i = 0, 1 do
        self.three:GetChild(i).gameObject:SetActive(false)
    end
    self.three.gameObject:SetActive(true)
    self.tipsTimeThree:SetActive(true)

    self.three:GetChild(2).gameObject:SetActive(true)
    for i = 1, 3 do
        TimerManager.StartTimer(self,function()
            if i == 3 then
                self.three.gameObject:SetActive(false)
                self.tipsTimeThree:SetActive(false)
                return
            end
            self.three:GetChild(3-i).gameObject:SetActive(false)
            self.three:GetChild(2-i).gameObject:SetActive(true)
        end, i,0,false)
    end
end

---更新自己信息
function FishPrawnCrabGameView:UpdateSelf(player)
    self.selfPlayer:UpdatePlayer(player)
end

function FishPrawnCrabGameView:UpdateSelfGoldCount()
    self.selfPlayer:UpdateGoldCount(self.ctrl.goldRealNum)
end

---启用/禁用下注按钮
function FishPrawnCrabGameView:UpdateBetBtnStatus()
    for i = 1, #self.chipInfos do
        self.chipInfos[i].button.interactable = self.ctrl.allowBet and FishPrawnCrabConfig.betValuesArr[i] <= self.ctrl.goldRealNum
    end
end

---更新区域下注数据，index有效，更新指定区域；无效则更新所有区域。
function FishPrawnCrabGameView:UpdateBetAreaInfo(index)
    if index ~= nil and index > 0 and index <= #self.betSelfNumLabels then
        self.betSelfNumLabels[index].text = tostring(self.ctrl.selfBets[index])
        self.betTotalNumLabels[index].text = tostring(self.ctrl.totalBets[index])
    else
        for tmpIndex = 1, #self.betSelfNumLabels do
            self.betSelfNumLabels[tmpIndex].text = tostring(self.ctrl.selfBets[tmpIndex])
            self.betTotalNumLabels[tmpIndex].text = tostring(self.ctrl.totalBets[tmpIndex])
        end
    end
end

---其他玩家信息更新
function FishPrawnCrabGameView:UpdatePlayers(players)
    if players ~=nil and #players>0 then
        ---玩家排序
        table.sort(players, function(a, b)
            return a.coin > b.coin
        end)

        for i=1,#self.AllOtherPlayerHeads do
            if i <= #players then
                self.AllOtherPlayerHeads[i]:UpdatePlayer(players[i])
                self.AllOtherPlayerHeads[i]:SetActive(true)
            else
                self.AllOtherPlayerHeads[i]:SetActive(false)
                self.AllOtherPlayerHeads[i]:UpdatePlayer(nil)
            end
        end
    end
end

function FishPrawnCrabGameView:FindPlayer(playerid)
    local target = nil
    if self.selfPlayer.id == playerid then
        target = self.selfPlayer
    else
        for i = 1, #self.AllOtherPlayerHeads do
            if self.AllOtherPlayerHeads[i].id == playerid then
                target = self.AllOtherPlayerHeads[i]
            end
        end
    end
    
    return target
end

return FishPrawnCrabGameView

