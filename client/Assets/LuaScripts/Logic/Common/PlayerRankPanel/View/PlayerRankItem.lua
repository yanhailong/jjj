--
--time:{time}
--{paramdesc} 
--@desc 
--
---@class PlayerRankItem
local PlayerRankItem=Class("PlayerRankItem")

function PlayerRankItem:ctor(go)
    self.gameObject = go
    self.transform=self.gameObject.transform
    self.rankImg = ComponentUtilGet.Image(self.transform,"img_rank")
    self.rankTxt = ComponentUtilGet.Text(self.transform,"txt_rank") 
    self.headFrame = ComponentUtilGet.Image(self.transform,"info/player/Head/HeadFrame")
    self.headIcon = ComponentUtilGet.Image(self.transform,"info/player/Head/HeadPic")
    self.goldCount = ComponentUtilGet.TextMeshProUGUI(self.transform,"info/player/Money/GoldNumber")
    self.playerName = ComponentUtilGet.TextMeshProUGUI(self.transform,"info/player/PlayerName");
    self.gameNum = ComponentUtilGet.Text(self.transform,"info/tmp_game")
    self.xiazhuNum = ComponentUtilGet.TextMeshProUGUI(self.transform,"info/tmp_xiazhu")
    self.sucNum = ComponentUtilGet.TextMeshProUGUI(self.transform,"info/tmp_sucnum")
end

---
---更新玩家排名信息
function PlayerRankItem:UpdateUI(index,player)
    if index <4 then
        self.rankImg.sprite = resMgr:LoadSprite("Common/GameArtsCommon/GameFight/alats/player","yx_ph_list"..index)
    end
    self.rankImg.gameObject:SetActive(index<4)
    self.rankTxt.gameObject:SetActive(index>=4)
    self.goldCount.text = player.goldNum
    self.playerName.text = player.playerName or "Robot:"..index
    self.rankTxt.text = tostring(index)
    self.gameNum.text = LocalManager.GetStrById(15008)
    self.xiazhuNum.text =  LocalManager.GetStrById(15009)..": "..tostring(player.totalBet)
    self.sucNum.text = LocalManager.GetStrById(15010)..": "..tostring(player.winCount).." "..LocalManager.GetStrById(15011)
end

return PlayerRankItem