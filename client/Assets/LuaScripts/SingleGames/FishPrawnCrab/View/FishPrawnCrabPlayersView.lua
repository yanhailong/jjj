---
---Create by Administrator
---DateTime: 2025-07-18 17:14:55
---
---@class FishPrawnCrabPlayersView:BaseView
local FishPrawnCrabPlayersView=Class("FishPrawnCrabPlayersView",BaseView)
local FishPrawnCrabPlayerRankItem=require("SingleGames/FishPrawnCrab/View/Item/FishPrawnCrabPlayerRankItem")

---初始化panel
function FishPrawnCrabPlayersView:InitView()
	---@type FishPrawnCrabPlayersCtrl
    self.ctrl=self.ctrl
	self:InitComponents()
end

---获取组件
function FishPrawnCrabPlayersView:InitComponents()
    self.img_title=ComponentUtilGet.Image(self.transform,"content/BackGround/img_title");
    self.btn_close=ComponentUtilGet.Button(self.transform,"content/BackGround/btn_close");
    self.scrollContent=ComponentUtilGet.Transform(self.transform,"content/ScrollView/Viewport/Content");
    self.rankPrefab=ComponentUtilGet.GameObject(self.transform,"content/ScrollView/Viewport/item/PlayerRankItem")
end

---清空组件
function FishPrawnCrabPlayersView:ClearComponents()
    self.img_title=nil;
    self.btn_close=nil;
    self.scrollContent=nil;
    self.rankPrefab=nil;
end

function FishPrawnCrabPlayersView:UpdateData(rankData)
    for i=1,#rankData do
        local itemObj = self.pool:Spawn(nil,self.rankPrefab)
        itemObj.transform:SetParent(self.scrollContent,false)
        itemObj:SetActive(true)
        local rankItem = FishPrawnCrabPlayerRankItem.New(itemObj)
        rankItem:UpdateUI(rankData[i])
    end
end

---初始化View数据
function FishPrawnCrabPlayersView:InitPanelData(args)
    self.pool=ObjectPoolUtil.New(self.name)
    self.rankPrefab:SetActive(false)
end

---关闭界面
function FishPrawnCrabPlayersView:Close()
    self.pool:DestroyAll()
    self.super.Close(self);
end

return FishPrawnCrabPlayersView

