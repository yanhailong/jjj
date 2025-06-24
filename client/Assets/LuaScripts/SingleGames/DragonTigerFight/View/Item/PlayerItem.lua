--
--time:{time}
--{paramdesc} 
--@desc 
--
---@class PlayerItem
local PlayerItem=Class("PlayerItem")

function PlayerItem:ctor(go)
    self.gameObject = go
    self.transform=self.gameObject.transform
    self.headIcon = ComponentUtilGet.Image(self.transform,"Image")
    self.goldCount = ComponentUtilGet.TextMeshProUGUI(self.transform,"GoldRoot/Count")
end

---
---更新玩家金币数量
---@param num int
function PlayerItem:updateGoldCount(num)
    self.goldCount.text = num
end

function PlayerItem:UpdatePlayer(player)
    self.goldCount.text = player.coin
    self.player = player
    self.id = player.id
end

return PlayerItem