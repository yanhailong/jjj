--
--time:{time}
--{paramdesc} 
--@desc 
--
---@class BirdsAnimalsPlayerRankItem
local BirdsAnimalsPlayerRankItem=Class("BirdsAnimalsPlayerRankItem")

function BirdsAnimalsPlayerRankItem:ctor(go)
    self.gameObject = go
    self.transform=self.gameObject.transform
    self.rankIcon = ComponentUtilGet.Image(self.transform,"img_rank")
    self.rankText = ComponentUtilGet.Text(self.transform,"txt_rank")
    self.headIcon = ComponentUtilGet.Image(self.transform,"player/head/icon")
    self.vipTxt = ComponentUtilGet.TextMeshProUGUI(self.transform,"player/vip")
    self.nameTxt = ComponentUtilGet.TextMeshProUGUI(self.transform,"info/tmp_name")
    self.coinNum = ComponentUtilGet.TextMeshProUGUI(self.transform,"info/coin/tmp_coin")
    self.gameNum = ComponentUtilGet.Text(self.transform,"info/tmp_game")
    self.xiazhuNum = ComponentUtilGet.TextMeshProUGUI(self.transform,"info/tmp_xiazhu")
    self.sucNum = ComponentUtilGet.TextMeshProUGUI(self.transform,"info/tmp_sucnum")
end

---
---更新玩家排名信息
function BirdsAnimalsPlayerRankItem:UpdateUI(data)
    self.sucNum.text = data.succeed or 0
    self.xiazhuNum.text = data.xiazhu or 0
    self.gameNum.text = data.game or 0
    self.coinNum.text = data.coin or 0
    self.nameTxt.text = data.name or ""
    
end

return BirdsAnimalsPlayerRankItem