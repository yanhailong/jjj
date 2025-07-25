---@class BaccaratPlayerItem
local BaccaratPlayerItem = Class("BaccaratPlayerItem")

function BaccaratPlayerItem:ctor(obj,ctrl)
    ---@type UnityEngine.GameObject
    self.gameObject = obj
    ---@type UnityEngine.Transform
    self.transform = obj.transform
    self.HeadPic = ComponentUtilGet.Image(self.transform,"HeadPic")
    self.Head = ComponentUtilGet.Image(self.transform,"HeadPic/Head")
    self.Head.gameObject:SetActive(false)--目前没有图像先隐藏
    self.PlayerName = ComponentUtilGet.TextMeshProUGUI(self.transform,"PlayerName")
    self.GoldNumber = ComponentUtilGet.TextMeshProUGUI(self.transform,"Money/GoldNumber")
    ---@type BaccaratGameCtrl
    self.ctrl=ctrl
end
---刷新玩家信息显示
function BaccaratPlayerItem:RefreshPlayerInfoShow(info)
    self.info = info;
    self.PlayerName.text = info.playerName;
    self.GoldNumber.text = info.goldNum;
end
---获取当前玩家的id
function BaccaratPlayerItem:GetPlayerId()
    if(self.gameObject.activeSelf) then
        return self.info.playerId;
    end
    return 0;
end
---修改玩家金币数量显示
function BaccaratPlayerItem:ChangeGoldNum(goldNum)
    self.GoldNumber.text = goldNum;
end

return BaccaratPlayerItem