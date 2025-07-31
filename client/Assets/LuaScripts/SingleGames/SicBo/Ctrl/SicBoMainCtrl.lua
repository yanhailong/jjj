---
---Create by Administrator
---DateTime: 2025-07-30 10:29:58
---
---@class SicBoMainCtrl:BaseCtrl
local SicBoMainCtrl = Class("SicBoMainCtrl", BaseCtrl)
local GameState = {
    START_GAME = 0,                --游戏开始
    BET = 1,                       --下注
    PLAY_CART = 2,                 --出牌
    DISS_MISS = 3,                 --解散房间
    WAIT_READY = 4,                --等待开始
    GAME_ROUND_OVER_SETTLEMENT = 5 --游戏一个回合结束进行结算
}
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
    self:StartGame()
end

function SicBoMainCtrl:StartGame()
    self.sounds.PlayBackgroudSound()
    self.BetArea = {}
    local BetArea = require "SingleGames/SicBo/SicBoCustom/BetArea"
    local Chip = require "SingleGames/SicBo/SicBoCustom/ChipManager"
    self.SelectAreaMask = self.view.obj_SelectArea.transform:GetComponent(typeof(CS.UnityEngine.CanvasGroup))
    self.SelectAreaMask.interactable = true
    for i = 1, self.view.obj_SelectArea.transform.childCount - 1 do
        self.BetArea[i] = BetArea.New(self.view.obj_SelectArea.transform:Find(i), i, self)
        self.BetArea[i]:ShowBetNumber(self.config)
    end
    self.ChipManager = Chip.New(self.view.obj_ChipPool, self.config.ChipPrefab, self.config.ChipIcon)
    coroutine.start(function()
        self.view.obj_DiceBox_Big:SetActive(true)
        while true do
            coroutine.yield(CS.UnityEngine.WaitForSeconds(1))
            --coroutine.yield(self.view.obj_DiceBox_Big.transform:DOShakePosition(10, 100, 500,0,false,false):WaitForCompletion());
            --coroutine.yield(self.view.obj_DiceBox_Big.transform:DOPunchPosition(Vector3(0, 200, 0), 2, 20, 0.9)
            --:WaitForCompletion())
        end
        coroutine.yield(CS.UnityEngine.WaitForSeconds(10))
        self:Dealer()
        coroutine.yield(CS.UnityEngine.WaitForSeconds(10))
        self:Settlement()
    end
    )
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
    local chip = self.ChipManager:PlayerBet(self.view.obj_palyerSelf, BetArea:GetPos(),
        number * 100)
    BetArea:AddChip(number * 100, chip, self.view.obj_palyerSelf, true)
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

function SicBoMainCtrl:Settlement()
    for i, v in ipairs(self.BetArea) do
        v:Settlement()
    end
    self.sounds.PlaySettlement()
end

--进入游戏
function SicBoMainCtrl:Enter()
    if GameState.START_GAME == 0 then
    end
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
