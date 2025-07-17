--
--time:{time}
--{paramdesc} 
--@desc 
--
---@class FishPrawnCrabPlayerItem
local FishPrawnCrabPlayerItem=Class("FishPrawnCrabPlayerItem")
local DOTween = CS.DG.Tweening.DOTween
local Ease = CS.DG.Tweening.Ease
local Vector3 = CS.UnityEngine.Vector3

function FishPrawnCrabPlayerItem:ctor(go)
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
function FishPrawnCrabPlayerItem:UpdateGoldCount(num)
    self.goldCount.text = num
end

function FishPrawnCrabPlayerItem:ShowResultCount(num)
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


function FishPrawnCrabPlayerItem:UpdatePlayer(player)
    self.player = player
    if player ~= nil then
        self.goldCount.text = player.coin
        self.nicknameTxt.text = player.nickname
        self.id = player.id
    else
        self.id = nil
    end
end

function FishPrawnCrabPlayerItem:SetActive(active)
    if self.gameObject ~= nil then
        self.gameObject:SetActive(active)
    end
end

function FishPrawnCrabPlayerItem:ResetBetData()
    self.chipInfo = {{}, {}, {}, {}, {}, {}}
end

function FishPrawnCrabPlayerItem:AddChip(area, chipObj)
    if area > 0 and area <= #self.chipInfo and chipObj ~= nil then
        table.insert(self.chipInfo[area], chipObj)
    end
end

return FishPrawnCrabPlayerItem