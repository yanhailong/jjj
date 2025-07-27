--
--time:{time}
--{paramdesc} 
--@desc 
--
---@class BirdsAnimalsPlayerItem
local BirdsAnimalsPlayerItem=Class("BirdsAnimalsPlayerItem")
local DOTween = CS.DG.Tweening.DOTween
local Ease = CS.DG.Tweening.Ease
local Vector3 = CS.UnityEngine.Vector3

function BirdsAnimalsPlayerItem:ctor(go)
    self.gameObject = go
    self.transform=self.gameObject.transform
    self.headKuang = ComponentUtilGet.Image(self.transform,"HeadPic")
    self.headIcon = ComponentUtilGet.Image(self.transform,"HeadPic/Head")
    self.goldCount = ComponentUtilGet.TextMeshProUGUI(self.transform,"Money/GoldNumber")
    self.playerName = ComponentUtilGet.TextMeshProUGUI(self.transform,"PlayerName");
    self.resultNum = ComponentUtilGet.TextMeshProUGUI(self.transform,"result")
    self.resultNum.gameObject:SetActive(false)
end

---
---更新玩家金币数量
---@param num int
function BirdsAnimalsPlayerItem:UpdateGoldCount(num)
    self.goldCount.text = num
end

function BirdsAnimalsPlayerItem:ShowResultCount(num)
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


function BirdsAnimalsPlayerItem:UpdatePlayer(player)
    if player == nil then
        self.gameObject:SetActive(false)
    else
        self.gameObject:SetActive(true)
        self.goldCount.text = player.goldNum
        self.playerName.text = player.playerName
        self.player = player
        self.id = player.playerId
    end
end

return BirdsAnimalsPlayerItem