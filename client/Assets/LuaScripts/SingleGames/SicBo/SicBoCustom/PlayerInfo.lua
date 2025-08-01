local PlayerInfo = {}
PlayerInfo.__index = PlayerInfo

function PlayerInfo.New(transform, index, sicBoMainCtrl)
    local self = setmetatable({}, PlayerInfo)
    self.transform = transform
    self.index = index
    self.sicBoMainCtrl = sicBoMainCtrl
    self.gold = 0
    self:Init()
    return self
end

--初始化
function PlayerInfo:Init()
    self.HeadImage = self.transform:Find("Head/HeadImage"):GetComponent(typeof(CS.UnityEngine.UI.Image))
    self.PlayerName = self.transform:Find("PlayerName_Text"):GetComponent(typeof(CS.UnityEngine.UI.Text))
    self.GoldText = self.transform:Find("Gold/GoldText"):GetComponent(typeof(CS.UnityEngine.UI.Text))
    self.MoveWinTextTrs = self.transform:Find("MoveWinText")
    self.MoveWinTextPos = self.MoveWinTextTrs.localPosition
    self.MoveWinText = self.MoveWinTextTrs:GetComponent(typeof(CS.UnityEngine.UI.Text))
    self.MoveLoseTextTrs = self.transform:Find("MoveLoseText")
    self.MoveLoseTextPos = self.MoveLoseTextTrs.localPosition
    self.MoveLoseText = self.MoveLoseTextTrs:GetComponent(typeof(CS.UnityEngine.UI.Text))
end

function PlayerInfo:Settlement(Number)
    self.gold = self.gold + Number
    if Number >= 0 then
        self.MoveWinText.text = "+" .. tostring(Number)
        self.MoveWinTextTrs.gameObject:SetActive(true)
        self.MoveWinTextTrs:DOLocalMoveY(self.MoveWinTextPos.y + 100, 2):SetEase(CS.DG.Tweening.Ease.Linear)
            :OnComplete(function()
                self.MoveWinTextTrs.gameObject:SetActive(false)
                self.MoveWinTextTrs.localPosition = self.MoveWinTextPos
                self.GoldText.text = tostring(self.gold)
            end
            )
    else
        self.MoveLoseText.text = tostring(Number)
        self.MoveLoseTextTrs.gameObject:SetActive(true)
        self.MoveLoseTextTrs:DOLocalMoveY(self.MoveLoseTextPos.y + 100, 2):SetEase(CS.DG.Tweening.Ease.Linear)
            :OnComplete(function()
                self.MoveLoseTextTrs.gameObject:SetActive(false)
                self.MoveLoseTextTrs.localPosition = self.MoveLoseTextPos
                self.GoldText.text = tostring(self.gold)
            end
            )
    end
end

--玩家下注,
function PlayerInfo:PlayerBet(BetAmount, BetArea)
    local chip = self.sicBoMainCtrl.ChipManager:PlayerBet(self.transform, BetArea:GetPos(), BetAmount * 100)
    BetArea:AddChip(BetAmount * 100, chip)
end

--玩家坐下
function PlayerInfo:Enter(playerData)
    --self.HeadImage.sprite =
    self.PlayerName.text = "ccccc"
    self.GoldText.text = 1000
end

--玩家离开
function PlayerInfo:Leav()
    self.gold = 0
    self.PlayerName.text = ""
    self.GoldText.text = ""
end

--游戏关闭
function PlayerInfo:Close()
    self.MoveLoseTextTrs:DOKill()
    self.MoveWinTextTrs:DOKill()
end

return PlayerInfo
