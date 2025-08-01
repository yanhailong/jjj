---
---Create by Administrator
---DateTime: 2025-07-30 10:29:58
---
---@class SicBoMainCtrl:BaseCtrl
local SicBoMainCtrl = Class("SicBoMainCtrl", BaseCtrl)

---构造函数
function SicBoMainCtrl:ctor(ctrlName, param)
    self.layer = 2;
    self.abName = "SingleGames/SicBo/prefabs/SicBoMain";
    self.prefabName = "SicBoMain"
    self.super.ctor(self, ctrlName, param);
    ---@type SicBoMainView
    self.view = self.view
    ---@type SicBoMainModel
    self.model = self.model
end

---初始化
function SicBoMainCtrl:CtrlInit(args)
    self.super.CtrlInit(self, args);
    self:InitData()
end

---初始化数据
function SicBoMainCtrl:InitData()
    self.config = require "SingleGames/SicBo/SicBoConfig"
    self.sounds = require "SingleGames/SicBo/SicBoSounds"
    self.config:Init()
    self:InitGame()
end

function SicBoMainCtrl:InitGame()
    self.BetArea = {}
    self.PlayerInfo = {}
    local BetArea = require "SingleGames/SicBo/SicBoCustom/BetArea"
    local PlayerInfo = require "SingleGames/SicBo/SicBoCustom/PlayerInfo"
    local Chip = require "SingleGames/SicBo/SicBoCustom/ChipManager"
    for i = 1, self.view.obj_Palyers.transform.childCount do
        print("xxxx" .. self.view.obj_Palyers.transform.childCount)
        self.PlayerInfo[i] = PlayerInfo.New(self.view.obj_Palyers.transform:Find("palyer" .. i), i, self)
        self.PlayerInfo[i]:Enter({ 11, 11 })
        coroutine.start(function()
            coroutine.yield(CS.UnityEngine.WaitForSeconds(5))
            self.PlayerInfo[i]:Settlement(Tools.RandomInt(-1000, 1000))
        end)
    end

    for i = 1, self.view.obj_SelectArea.transform.childCount - 1 do
        self.BetArea[i] = BetArea.New(self.view.obj_SelectArea.transform:Find(tostring(i)), i, self)
        self.BetArea[i]:ShowBetNumber(self.config)
    end
    self.SelectAreaMask = self.view.obj_SelectArea.transform:GetComponent(typeof(CS.UnityEngine.CanvasGroup))
    self.SelectAreaMask.interactable = true --开始下注
    self.ChipManager = Chip.New(self.view.obj_ChipPool, self.config.ChipPrefab, self.config.ChipIcon)
    self:StartGame()
end

function SicBoMainCtrl:StartGame()
    self:CreatBetChip()
    self.model:ReqEnterRoom()
    self:TestAnimation()
end

--[[message NotifyDiceTreasureTableInfo {
    enum E_MsgID {def = 0; msgID = 102529;};
    int32 code = 1;  //状态码

repeated DiceTreasureHistoryBean settlementHistory = 8;  //结算历史，首次进入时发送，下注区域id列表
]]
--进入游戏
function SicBoMainCtrl:EnterGame(data)
    self.sounds.PlayBackgroudSound()
    --data.tableCountDownTime   --时钟倒计时，时间戳
    self.ChangeState(data.gamePhase, data.settlementInfo)
    for i, v in ipairs(data.betPointList) do
        log("创建下注筹码" .. tostring(v))
    end
    self:CreateHistory(data.settlementHistory)

    log("房间玩家" .. data.totalPlayerNum)
end

function SicBoMainCtrl:TestAnimation()
    coroutine.start(function()
        self.view.obj_DiceBox_Big:SetActive(true)
        while true do
            coroutine.yield(CS.UnityEngine.WaitForSeconds(1))
            --coroutine.yield(--self.view.obj_DiceBox_Big.transform:DOShakePosition(10, 100, 500, 0, false, false)
            --:WaitForCompletion());
            --coroutine.yield(self.view.obj_DiceBox_Big.transform:DOPunchPosition(Vector3(0, 200, 0), 2, 20, 0.9)
            --:WaitForCompletion())
            local shakeDuration = 0.2
            local shakeHeight = 2
            local originalPosition = self.view.obj_DiceBox_Big.transform.position
            local shakeSequence = DOTween.Sequence()
            for i = 0, 12 do
                if i % 2 == 0 then
                    shakeSequence:Append(self.view.obj_DiceBox_Big.transform:DOMoveY(
                        originalPosition.y + shakeHeight,
                        shakeDuration / 2
                    ):SetEase(CS.DG.Tweening.Ease.InOutQuad));
                else
                    shakeSequence:Append(self.view.obj_DiceBox_Big.transform:DOMoveY(
                        originalPosition.y,
                        shakeDuration / 2
                    ):SetEase(CS.DG.Tweening.Ease.InOutQuad));
                end
            end
            shakeSequence:AppendInterval(0.3)
            shakeSequence:Append(self.view.obj_DiceBox_Big.transform:DOMoveY(
                originalPosition.y,
                0.05
            ):SetEase(CS.DG.Tweening.Ease.InOutQuad));
            shakeSequence:Append(self.view.obj_DiceBox_Big.transform:DOShakePosition(0.1, 2, 50, 0, false, false))
            --shakeSequence:Append(self.view.obj_DiceBox_Big.transform:DOShakePosition(
            --0.5, Vector3(0.05, 0.02, 0.05), 5, 90));
            coroutine.yield(shakeSequence:WaitForCompletion())
        end
        coroutine.yield(CS.UnityEngine.WaitForSeconds(10))
        self:Dealer()
        coroutine.yield(CS.UnityEngine.WaitForSeconds(10))
        self:Settlement()
    end
    )
end

local SlectEffect = nil;
function SicBoMainCtrl:CreatBetChip()
    for i, v in ipairs(self.model.betPointList) do
        local go = CS.UnityEngine.GameObject.Instantiate(self.view.obj_BetButtonPrefab, self.view.obj_Content.transform)
        go.transform:GetComponent(typeof(CS.UnityEngine.UI.Image)).sprite = self.config.ChipIcon[v / 100]
        go.transform:Find("betMoneyText"):GetComponent(typeof(CS.UnityEngine.UI.Text)).text = v
        local SlectEffect1 = go.transform:Find("SlectEffect").gameObject
        self.uiEventListener:AddClick(go:GetComponent(typeof(CS.UnityEngine.UI.Button)), function()
            log("选择的下注筹码" .. i)
            self.model.CurrentSelectBetChip = i
            if SlectEffect ~= nil then
                SlectEffect:SetActive(false)
                SlectEffect = SlectEffect1
                SlectEffect:SetActive(true)
            else
                SlectEffect = SlectEffect1
                SlectEffect:SetActive(true)
            end
        end)
        if i == 1 then
            SlectEffect = SlectEffect1
            SlectEffect:SetActive(true)
        end
        go:SetActive(true)
    end


    --self.view.obj_disabe_Left
    --self.view.obj_enable_Left

    --self.view.obj_disabe_Right
    --self.view.obj_enable_Right=
    local pageContainer=self.view.obj_Content.transform:GetComponent(typeof(CS.UnityEngine.RectTransform));    --拖这个横向容器  RectTransform
    local leftButton;       --Button
    local rightButton;      --Button
    --ButtonsList/obj_Content --算出页数
    local totalPages = 2;   -- 总页数
    local pageWidth = 1095; -- 每页宽度（根据分辨率设置）
    local tweenTime = 0.3;  -- 动画时间

    local currentPage = 0;
    local moveTween;  --Tween

    local MoveToPage = function(pageIndex)
        local targetX = -pageWidth * pageIndex;
        if moveTween then
            --moveTween.Kill(); --// 防止并发Tween
        end

        moveTween = pageContainer:DOAnchorPosX(targetX, tweenTime):SetEase(CS.DG.Tweening.Ease.OutCubic);
        --leftButton.interactable = currentPage > 0;
        --rightButton.interactable = currentPage < totalPages - 1;
    end
 self.uiEventListener:AddClick(self.view.btn_BetButtonMove_Left, function()
        if (currentPage >= totalPages - 1) then return end;
        currentPage = currentPage + 1;
        MoveToPage(currentPage);
    end);
    self.uiEventListener:AddClick( self.view.btn_BetButtonMove_Right, function()
        if (currentPage <= 0) then return end;
        currentPage = currentPage - 1;
        MoveToPage(currentPage);
    end);
    --leftButton.interactable = currentPage > 0;
    --rightButton.interactable = currentPage < totalPages - 1;]]
end

--[[//响应,msgID=0x20089
 message NotifyPhaseChangInfo {
 enum E_MsgID {def = 0; msgID = 131209;};
 int32 code = 1;  //状态码
 EGamePhase gamePhase = 2;  //当前阶段
 int64 endTime = 3;  //结束时间戳
 }]]
function SicBoMainCtrl.ChangeState(gameState, endTime, settlementInfo)
    if self.config.GameState.START_GAME == gameState then                          --游戏开始
        log("游戏开始")
    elseif self.config.GameState.BET == gameState then                             --下注阶段
        log("下注阶段")
    elseif self.config.GameState.PLAY_CART == gameState then                       --出牌
        log("下注阶段")
    elseif self.config.GameState.DISS_MISS == gameState then                       --解散房间
        log("解散房间")
    elseif self.config.GameState.WAIT_READY == gameState then                      --等待开始
        log("等待开始")
    elseif self.config.GameState.GAME_ROUND_OVER_SETTLEMENT == data.gamePhase then --游戏一个回合结束进行结算
        log("结算")
        if settlementInfo then
            self:Settlement(data)
        end
    end
end

function SicBoMainCtrl:UpdatePlayerInfo(playerId, playerInfo)
    --- //牌桌玩家信息
    --[[message TablePlayerInfo {
    int64 playerId = 1;  //玩家ID
    string playerName = 2;  //玩家名
    string local = 3;  //玩家地址
    int32 vipLevel = 4;  //VIP等级
    int64 goldNum = 5;  //玩家当前金币
    int64 totalBet = 6;  //近20局下注金币总数
    int32 winCount = 7;  //近20局赢的总局数
    }]]
end

function SicBoMainCtrl:CreateHistory(data)
    for i, v in ipairs(data) do
        -- //骰宝历史记录bean
        --message DiceTreasureHistoryBean {
        -- repeated int32 betIdxId = 1;  //下注区域ID
        --repeated int32 diceList = 2;  //骰子开奖结果列表，骰子点数：1-6
        -- }
    end
end

function SicBoMainCtrl:PlayerBet(playerId, playerCurGold, betTableInfoList)
    for i, v in ipairs(betTableInfoList) do --玩家押注信息列表
        --v.betIdx    --下标,筹码
        --v.playerBetTotal  --玩家总押注
        --v.betIdxTotal   --区域下标的总的押注数量
        --v.betValue  --玩家此次下注的金币数量

        for k, l in ipairs(v.betGoldList) do --v.betGoldList = 5;  --区域押注金币列表

        end
    end
end

function SicBoMainCtrl:RollDice()
    self.view.obj_DiceBox_Big:SetActive(true)
    self.view.obj_DiceBox_Big.transform:DOPunchPosition(Vector3(0, 400, 0), 2, 6, 0.7)
end

--其它玩家下注
function SicBoMainCtrl:OtherPlayerBet(palyerId, AreaIndex, number)
    local chip = self.ChipManager:PlayerBet(self.view.obj_palyerSelf, self.BetArea[number]:GetPos(),
        number * 100)
    self.BetArea[AreaIndex]:AddChip(number * 100, chip)
end

--玩家自己下注
function SicBoMainCtrl:SelfBet(AreaIndex, BetArea)
    log("玩家自己开始下注——区域" .. tostring(AreaIndex))
    log("xxxx" .. tostring(BetArea.gameObject.name))
    local number = math.floor(CS.UnityEngine.Random.Range(1, 7))
    local offset = Vector3(CS.UnityEngine.Random.Range(-0.3, 0.3), CS.UnityEngine.Random.Range(-0.3, 0.3),
        CS.UnityEngine.Random.Range(-0.5, 0.5))
    local number = self.model:GetBetChip()
    local chip = self.ChipManager:PlayerBet(self.view.obj_palyerSelf, BetArea:GetPos(),
        number)
    BetArea:AddChip(number, chip, self.view.obj_palyerSelf, true)
    self.sounds.PlayBetSoundEffic()
end

--庄家赔钱
function SicBoMainCtrl:Dealer()
    for i = 1, 100 do
        local offset = Vector3(CS.UnityEngine.Random.Range(-0.3, 0.3), CS.UnityEngine.Random.Range(-0.3, 0.3),
            CS.UnityEngine.Random.Range(-0.5, 0.5))
        local number = math.floor(CS.UnityEngine.Random.Range(1, 30))
        local sl = math.floor(CS.UnityEngine.Random.Range(1, 7))
        local chip = self.ChipManager:PlayerBet(self.view.obj_croupier,
            self.BetArea[number]:GetPos(),
            sl * 100)
        self.BetArea[number]:AddChip(sl * 100, chip, self.view.obj_croupier, false)
    end
end

function SicBoMainCtrl:Settlement(data)
    --data.settlementInfo   --//结算信息，当阶段为结算时发送 --]]
    -- //骰宝历史记录bean
    --message DiceTreasureHistoryBean {
    -- repeated int32 betIdxId = 1;  //下注区域ID
    --repeated int32 diceList = 2;  //骰子开奖结果列表，骰子点数：1-6
    -- }
    for i, v in ipairs(self.BetArea) do
        v:Settlement()
    end
    self.sounds.PlaySettlement()
end

function SicBoMainCtrl:Close()
    self.super.Close(self);
end

---添加UI事件
function SicBoMainCtrl:AddUIEvent()

end

---移除UI事件
function SicBoMainCtrl:RemoveEvent()
    self.super.RemoveEvent(self);
end

--region UI事件方法

--endregion


---销毁UI
function SicBoMainCtrl:RealCloseDestroy()
    self.super.RealCloseDestroy(self);
end

return SicBoMainCtrl
