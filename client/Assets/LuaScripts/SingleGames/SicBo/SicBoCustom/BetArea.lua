local BetArea = {}
BetArea.__index = BetArea

function BetArea.New(gameObject, index, sicBoMainCtrl)
    local self = setmetatable({}, BetArea)
    self.gameObject = gameObject
    self.transform = gameObject.transform
    self.index = index
    self.sicBoMainCtrl = sicBoMainCtrl
    self.totalNumer = 0
    self.selfNumer = 0
    self.chips = {}
    self.plays = {}
    self:Init()
    return self
end

function BetArea:Init()
    self.light = self.transform:Find("Light")
    --self.Image=self.transform:GetComponent(typeof(CS.UnityEngine.UI.Image))
    --self.Image.alphaHitTestMinimumThreshold = 0.9
    self.BetArea_Button = self.transform:GetComponent(typeof(CS.UnityEngine.UI.Button))
    self.totaleBetAmount = self.transform:Find("TotaleBetAmount")
    self.totaleBetAmount_txt = self.totaleBetAmount:GetComponent(typeof(CS.UnityEngine.UI.Text))
    self.SelfBetAmount = self.transform:Find("SelfBetAmount")
    self.SelfBetAmount_txt = self.transform:Find("SelfBetAmount/SelfBetAmount_text"):GetComponent(typeof(CS.UnityEngine
        .UI.Text))
    self.sicBoMainCtrl.uiEventListener:AddClick(self.BetArea_Button, function()
        self.sicBoMainCtrl:SelfBet(self.index, self)
    end);
    self.AreaSize = self.transform:GetComponent(typeof(CS.UnityEngine.RectTransform)).sizeDelta
    self.localPosition = self.transform.localPosition
end

--展示高亮
function BetArea:ShowBetNumber()
    --self.light.gameObject:SetActive(true)
    self.totaleBetAmount_txt.text = tostring(self.totalNumer)
    self.SelfBetAmount_txt.text = tostring(self.selfNumer)
    --self.totaleBetAmount.gameObject:SetActive(true)
    --self.SelfBetAmount.gameObject:SetActive(true)
end

function BetArea:AddChip(number, go, player, isCount)
    log("玩家下注金额:" .. tostring(number))
    if isCount then
        self.totalNumer = self.totalNumer + number
        self.selfNumer = self.selfNumer + number
        self.totaleBetAmount_txt.text = tostring(self.totalNumer)
        self.SelfBetAmount_txt.text = tostring(self.selfNumer)
        self.totaleBetAmount.gameObject:SetActive(true)
        self.SelfBetAmount.gameObject:SetActive(true)
    end
    table.insert(self.chips, go)
    table.insert(self.plays, player)
end

--结算
function BetArea:Settlement()
    --local xx = #self.chips / #WinPlayers
    for i, v in ipairs(self.chips) do
        self.sicBoMainCtrl.ChipManager:MoveTargetPos(v, self.plays[1])
    end
    self.totaleBetAmount.gameObject:SetActive(false)
    self.SelfBetAmount.gameObject:SetActive(false)
end

function BetArea:GetPos()
    local offsetX = 120
    if self.index == 28 or self.index == 29 then
        offsetX = 170
    end
    local size = self.AreaSize - Vector2(offsetX, 120)
    local pos = self.localPosition + Vector3(CS.UnityEngine.Random.Range(-size.x / 2, size.x / 2),
        CS.UnityEngine.Random.Range(-size.y / 2, size.y / 2), 0)
    return self.transform:TransformVector(pos)
end

return BetArea
