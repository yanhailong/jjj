--
--time:{time}
--{paramdesc} 
--@desc 
--
---@class DicePointsSumSizePlayerItem
local DicePointsSumSizePlayerItem=Class("DicePointsSumSizePlayerItem")
local DOTween = CS.DG.Tweening.DOTween
local Ease = CS.DG.Tweening.Ease
local Vector3 = CS.UnityEngine.Vector3

function DicePointsSumSizePlayerItem:ctor(go)
    self.gameObject = go
    self.transform = self.gameObject.transform
    self.headKuang = ComponentUtilGet.Image(self.transform,"HeadPic")
    self.headIcon = ComponentUtilGet.Image(self.transform,"HeadPic/Head")
    self.goldCount = ComponentUtilGet.TextMeshProUGUI(self.transform,"Money/GoldNumber")
    self.nicknameTxt = ComponentUtilGet.TextMeshProUGUI(self.transform, "PlayerName")
    self.resultNum = ComponentUtilGet.TextMeshProUGUI(self.transform,"result")
    self.resultNum.gameObject:SetActive(false)
    self.chipInfo = {{}, {}, {}, {}, {}, {}}
end

---
---更新玩家金币数量
---@param num number
function DicePointsSumSizePlayerItem:UpdateGoldCount(num)
    self.goldCount.text = num
end

function DicePointsSumSizePlayerItem:ShowResultCount(num)
    local symbol = ""
    if num>0 then
        symbol = "+"
    end
    local x = -100
    if self.transform.position.x<0 then
        x = 200
    end
    self.resultNum.gameObject:SetActive(true)
    self.resultNum.text = symbol..num
    self.resultNum.transform.localPosition = Vector3(x,0,0)
    self.resultNum.alpha = 1
    local sequence = DOTween.Sequence()
    sequence:Append(self.resultNum.transform:DOLocalMoveY(60,1))
    sequence:Insert(0.6,self.resultNum:DOFade(1,0.4))
    sequence:OnComplete(function()
        sequence:Kill(false)
        self.resultNum.gameObject:SetActive(false)
    end)
    sequence:Play()
end


function DicePointsSumSizePlayerItem:UpdatePlayer(player)
    self.player = player
    if player ~= nil then
        self.goldCount.text = player.coin
        self.nicknameTxt.text = player.nickname
        self.id = player.id
    else
        self.id = nil
    end
end

function DicePointsSumSizePlayerItem:SetActive(active)
    if self.gameObject ~= nil then
        self.gameObject:SetActive(active)
    end
end

function DicePointsSumSizePlayerItem:ResetBetData()
    self.chipInfo = {{}, {}, {}, {}, {}, {}}
end

function DicePointsSumSizePlayerItem:AddChip(area, chipObj)
    if area > 0 and area <= #self.chipInfo and chipObj ~= nil then
        table.insert(self.chipInfo[area], chipObj)
    end
end

return DicePointsSumSizePlayerItem