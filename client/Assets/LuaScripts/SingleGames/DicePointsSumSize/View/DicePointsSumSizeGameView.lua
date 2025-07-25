---
---Create by Administrator
---DateTime: 2025-07-22 10:18:39
---
---@class DicePointsSumSizeGameView:BaseView
local DicePointsSumSizeGameView=Class("DicePointsSumSizeGameView",BaseView)

local DicePointsSumSizeConfig = require("SingleGames/DicePointsSumSize/DicePointsSumSizeConfig")
local DicePointsSumSizePlayerItem = require("SingleGames/DicePointsSumSize/View/Item/DicePointsSumSizePlayerItem")

---初始化panel
function DicePointsSumSizeGameView:InitView()
	---@type DicePointsSumSizeGameCtrl
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
function DicePointsSumSizeGameView:InitComponents()
    self.btn_1=ComponentUtilGet.Button(self.transform,"content/top/btn_1");
    self.btn_recharge=ComponentUtilGet.Button(self.transform,"content/top/btn_recharge");
    self.trans_bet_btns=ComponentUtilGet.Transform(self.transform,"content/center/bet/trans_bet_btns");
    self.btn_repeat=ComponentUtilGet.Button(self.transform,"content/bottom/btn_repeat");
    self.btn_AllOther=ComponentUtilGet.Button(self.transform,"content/bottom/btn_AllOther");
    self.tmp_AllOtherNumber=ComponentUtilGet.TextMeshProUGUI(self.transform,"content/bottom/btn_AllOther/tmp_AllOtherNumber");
    self.chipListView=ComponentUtilGet.ScrollRect(self.transform,"content/bottom/ChipScrollView");
    self.obj_ChipContent=ComponentUtilGet.GameObject(self.transform,"content/bottom/ChipScrollView/Viewport/obj_ChipContent");
    self.obj_chipItem=ComponentUtilGet.GameObject(self.transform,"content/bottom/obj_chipItem");
    self.btn_Chipleft=ComponentUtilGet.Button(self.transform,"content/bottom/Image/btn_Chipleft");
    self.btn_ChipRight=ComponentUtilGet.Button(self.transform,"content/bottom/Image (1)/btn_ChipRight");
    self.obj_PlayerRoot=ComponentUtilGet.GameObject(self.transform,"content/obj_PlayerRoot");
    self.btn_touch=ComponentUtilGet.Button(self.transform,"content/setting/btn_touch");
    self.btn_muen=ComponentUtilGet.Button(self.transform,"content/setting/btn_muen");
    self.trans_menu_panel=ComponentUtilGet.Transform(self.transform,"content/setting/mask/trans_menu_panel");
    self.btn_setting=ComponentUtilGet.Button(self.transform,"content/setting/mask/trans_menu_panel/btn_setting");
    self.btn_help=ComponentUtilGet.Button(self.transform,"content/setting/mask/trans_menu_panel/btn_help");
    self.btn_close=ComponentUtilGet.Button(self.transform,"content/setting/mask/trans_menu_panel/btn_close");
    self.obj_Countdown=ComponentUtilGet.GameObject(self.transform,"content/tips/obj_Countdown");
    self.txt_Countdown=ComponentUtilGet.Text(self.transform,"content/tips/obj_Countdown/txt_Countdown");
end

---清空组件
function DicePointsSumSizeGameView:ClearComponents()
    self.selfPlayer:OnDestroy()
    for i = 1, #self.AllOtherPlayerHeads do
        self.AllOtherPlayerHeads[i]:OnDestroy()
    end
    
    self.btn_1=nil;
    self.btn_recharge=nil;
    self.trans_bet_btns=nil;
    self.btn_repeat=nil;
    self.btn_AllOther=nil;
    self.tmp_AllOtherNumber=nil;
    self.obj_ChipContent=nil;
    self.obj_chipItem=nil;
    self.obj_chipItem_bottom=nil;
    self.btn_Chipleft=nil;
    self.btn_ChipRight=nil;
    self.obj_PlayerRoot=nil;
    self.btn_touch=nil;
    self.btn_muen=nil;
    self.trans_menu_panel=nil;
    self.btn_setting=nil;
    self.btn_help=nil;
    self.btn_close=nil;
    self.obj_Countdown=nil;
    self.txt_Countdown=nil;
end

---下注底注按钮
function DicePointsSumSizeGameView:InitChipInfos()
    self.chipInfos={}
    --for i = 1, #DicePointsSumSizeConfig.betValuesArr do
    --    local chipItem={}
    --    chipItem.obj=ComponentUtilGet.Button(self.obj_ChipContent.transform,"content/bottom/stakes/"..i)
    --    chipItem.rectTrans=ComponentUtilGet.RectTransform(self.obj_ChipContent.transform,"content/bottom/stakes/"..i)
    --    chipItem.button=ComponentUtilGet.Button(chipItem.rectTrans)
    --    chipItem.effects=ComponentUtilGet.GameObject(chipItem.rectTrans,"checkd")
    --    chipItem.effects:SetActive(false)
    --    self.chipInfos[i]=chipItem
    --end
end

---提示信息
function DicePointsSumSizeGameView:InitTips()
    self.tipsTrs = ComponentUtilGet.Transform(self.transform,"content/tips")
    self.tipsStopBetting = ComponentUtilGet.GameObject(self.tipsTrs,"tips_stop_betting")
    self.tipsStartToBet = ComponentUtilGet.GameObject(self.tipsTrs,"tips_start_to_bet")
    self.tipsGameStart = ComponentUtilGet.GameObject(self.tipsTrs, "game_start")

    self.colockStateTimeTrs = ComponentUtilGet.Transform(self.tipsTrs,"tips_center")
    self.colockStateTimePrepare = ComponentUtilGet.GameObject(self.colockStateTimeTrs,"colock_state_prepare") --准备倒计时Root
    self.colockStateTimeNumPrepare = ComponentUtilGet.Text(self.colockStateTimeTrs,"colock_state_prepare/time") --准备倒计时
    self.colockStateTimeBet = ComponentUtilGet.GameObject(self.colockStateTimeTrs,"colock_state_bet") --下注倒计时Root
    self.colockStateTimeNumBet = ComponentUtilGet.Text(self.colockStateTimeTrs,"colock_state_bet/time") --下注倒计时
    self.colockStateTimeSettlement = ComponentUtilGet.GameObject(self.colockStateTimeTrs,"colock_state_settlement") --结算倒计时Root
    self.colockStateTimeNumSettlement = ComponentUtilGet.Text(self.colockStateTimeTrs,"colock_state_settlement/time") --结算倒计时
    self.colockNumTrs = ComponentUtilGet.Transform(self.tipsTrs,"tips_center/count_down")
    self.colockNumTime = ComponentUtilGet.Text(self.colockNumTrs,"time")
end

---所有玩家
function DicePointsSumSizeGameView:InitPalyers()
    self.AllOtherPlayerHeads = {}
    local otherPlayerTrs = ComponentUtilGet.Transform(self.transform,"content/obj_PlayerRoot")
    for i = 1, 6 do
        self.AllOtherPlayerHeads[#self.AllOtherPlayerHeads + 1] = DicePointsSumSizePlayerItem.New(otherPlayerTrs:GetChild(i-1).gameObject)
    end

    self.selfPlayerRoot  = ComponentUtilGet.GameObject(self.transform,"content/bottom/SelfHead")
    ---@type DicePointsSumSizePlayerItem
    self.selfPlayer = DicePointsSumSizePlayerItem.New(self.selfPlayerRoot)
end

---下注区域
function DicePointsSumSizeGameView:InitBetArea()
    self.betAreaRoot = ComponentUtilGet.Transform(self.transform,"content/center/bet")
    self.clickAreaRoot = ComponentUtilGet.Transform(self.transform,"content/center/bet/trans_bet_btns")

    ---下注金币落点
    ---@type  TMPro.TextMeshProUGUI[]
    self.betAreas = {}
    ---个人下注数量
    ---@type  TMPro.TextMeshProUGUI[]
    self.betSelfNumLabels = {}
    ---所有人总下注数量
    ---@type  TMPro.TextMeshProUGUI[]
    self.betTotalNumLabels = {}

    ---押中高亮
    self.winHighLights = {}
    for i=1,DicePointsSumSizeConfig.DiceSumType.TypeCount do
        local trs = ComponentUtilGet.Transform(self.betAreaRoot,"area" .. i)
        self.winHighLights[i] = ComponentUtilGet.Image(trs,"win_highlight")
        self.betAreas[i] = ComponentUtilGet.Transform(trs,"chips")
        self.betSelfNumLabels[i] = ComponentUtilGet.TextMeshProUGUI(trs,"selfBet/num")
        self.betTotalNumLabels[i] = ComponentUtilGet.TextMeshProUGUI(trs,"totalBet/num")
    end
end

---结果信息
function DicePointsSumSizeGameView:InitGameResult()
    -- 大骰子结果
    local bigDiceResultTrans = ComponentUtilGet.Transform(self.transform, "content/result/big")
    self.bigDiceResultObj = bigDiceResultTrans.gameObject
    self.bigDiceBase = ComponentUtilGet.GameObject(bigDiceResultTrans, "base")
    self.bigDiceLid = ComponentUtilGet.GameObject(bigDiceResultTrans, "lid")
    self.bigDiceImages = {}
    for i = 1, DicePointsSumSizeConfig.diceCount do
        self.bigDiceImages[i] = ComponentUtilGet.Image(bigDiceResultTrans, "dices/dice" .. i)
    end
    self.bigDiceResultOriginalPos = bigDiceResultTrans.position
    self.bigDiceResultOriginalScale = bigDiceResultTrans.localScale
    self.bigDiceLidImage = ComponentUtilGet.Image(bigDiceResultTrans, "lid")

    -- 小骰子结果
    local smallDiceResultTrans = ComponentUtilGet.Transform(self.transform, "content/result/small")
    self.smallDiceResultObj = smallDiceResultTrans.gameObject
    self.smallDiceBase = ComponentUtilGet.GameObject(smallDiceResultTrans, "base")
    self.smallDiceLid = ComponentUtilGet.GameObject(smallDiceResultTrans, "lid")
    self.smallDiceImages = {}
    for i = 1, DicePointsSumSizeConfig.diceCount do
        self.smallDiceImages[i] = ComponentUtilGet.Image(smallDiceResultTrans, "dices/dice" .. i)
    end
    self.smallDiceResultOriginalPos = smallDiceResultTrans.position
    self.smallDiceResultOriginalScale = smallDiceResultTrans.localScale
    self.shakePos = ComponentUtilGet.Transform(self.transform, "content/result/shake_pos").position
end

--游戏记录
function DicePointsSumSizeGameView:InitGameRecords()
    local recordRootTrans = ComponentUtilGet.Transform(self.transform, "content/records")
    self.recordsRootObj = recordRootTrans.gameObject
    self.recordUIDatas = {}
    for i = 1, DicePointsSumSizeConfig.showRecordCount do
        local perRecordData = {}
        perRecordData.rootObj = ComponentUtilGet.GameObject(recordRootTrans, "record_grid/record" .. i)
        perRecordData.resultTypeImage = ComponentUtilGet.Image(perRecordData.rootObj.transform, "result_type")
        perRecordData.dicePointSumText = ComponentUtilGet.TextMeshProUGUI(perRecordData.rootObj.transform, "dice_point_sum")
        local diceImages = {}
        for diceIndex = 1, DicePointsSumSizeConfig.diceCount do
            diceImages[diceIndex] = ComponentUtilGet.Image(perRecordData.rootObj.transform, "dice" .. diceIndex)
        end
        perRecordData.diceImages = diceImages

        self.recordUIDatas[i] = perRecordData
    end
end

---初始化View数据
function DicePointsSumSizeGameView:InitPanelData(args)
    self.btn_repeat.interactable = false

    ---其他玩家信息
    for i = 1, #self.AllOtherPlayerHeads do
        self.AllOtherPlayerHeads[i]:SetActive(false)
    end

    for i = 1, #self.winHighLights do
        self.winHighLights[i].gameObject:SetActive(false)
    end

    self.recordsRootObj:SetActive(true)
    for i = 1, DicePointsSumSizeConfig.showRecordCount do
        local perRecordData = self.recordUIDatas[i]
        perRecordData.rootObj:SetActive(false)
    end
    
    self.bigDiceResultObj:SetActive(false)
    self.smallDiceResultObj:SetActive(false)

    for i = 1, DicePointsSumSizeConfig.DiceSumType.TypeCount do
        self.betTotalNumLabels[i].text = "0"
        self.betSelfNumLabels[i].text = "0"
    end

    self.obj_Countdown:SetActive(false)
end

---关闭界面
function DicePointsSumSizeGameView:Close()   
    self.super.Close(self);
end

---更新自己信息
function DicePointsSumSizeGameView:UpdateSelf(player)
    self.selfPlayer:UpdatePlayer(player)
end

function DicePointsSumSizeGameView:UpdateSelfGoldCount()
    self.selfPlayer:UpdateGoldCount(self.ctrl.goldRealNum)
end

---启用/禁用下注按钮
function DicePointsSumSizeGameView:UpdateBetBtnStatus()
    for i = 1, #self.chipInfos do
        self.chipInfos[i].button.interactable = self.ctrl.allowBet and DicePointsSumSizeConfig.betValuesArr[i] <= self.ctrl.goldRealNum
    end
end

---更新区域自己下注数据，index有效，更新指定区域；无效则更新所有区域。
function DicePointsSumSizeGameView:UpdateSelfBetAreaInfo(index)
    if index ~= nil and index > 0 and index <= #self.betSelfNumLabels then
        self.betSelfNumLabels[index].text = tostring(self.ctrl.selfBets[index])
    else
        for tmpIndex = 1, #self.betSelfNumLabels do
            self.betSelfNumLabels[tmpIndex].text = tostring(self.ctrl.selfBets[tmpIndex])
        end
    end
end

---更新区域总下注数据，index有效，更新指定区域；无效则更新所有区域。
function DicePointsSumSizeGameView:UpdateTotalBetAreaInfo(index)
    if index ~= nil and index > 0 and index <= #self.betSelfNumLabels then
        self.betTotalNumLabels[index].text = tostring(self.ctrl.totalBets[index])
    else
        for tmpIndex = 1, #self.betTotalNumLabels do
            self.betTotalNumLabels[tmpIndex].text = tostring(self.ctrl.totalBets[tmpIndex])
        end
    end
end

---其他玩家信息更新
function DicePointsSumSizeGameView:UpdatePlayers(players)
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

function DicePointsSumSizeGameView:FindPlayer(playerid)
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

return DicePointsSumSizeGameView

