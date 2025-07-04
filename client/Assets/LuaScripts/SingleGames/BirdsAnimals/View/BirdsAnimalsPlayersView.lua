---
---Create by Administrator
---DateTime: 2025-07-03 09:54:21
---
---@class BirdsAnimalsPlayersView:BaseView
local BirdsAnimalsPlayersView=Class("BirdsAnimalsPlayersView",BaseView)
local BirdsAnimalsPlayerRankItem=require("SingleGames/BirdsAnimals/View/Item/BirdsAnimalsPlayerRankItem")
---初始化panel
function BirdsAnimalsPlayersView:InitView()
	---@type BirdsAnimalsPlayersCtrl
    self.ctrl=self.ctrl
	self:InitComponents()
end

---获取组件
function BirdsAnimalsPlayersView:InitComponents()
    self.img_title=ComponentUtilGet.Image(self.transform,"content/BackGround/img_title");
    self.btn_close=ComponentUtilGet.Button(self.transform,"content/BackGround/btn_close");
    self.scrollContent=ComponentUtilGet.Transform(self.transform,"content/ScrollView/Viewport/Content");
    self.rankPrefab=ComponentUtilGet.GameObject(self.transform,"content/ScrollView/Viewport/item/PlayerRankItem")
end

---清空组件
function BirdsAnimalsPlayersView:ClearComponents()
    self.img_title=nil;
    self.btn_close=nil;
    self.scrollContent=nil;
    self.rankPrefab=nil;
end

function BirdsAnimalsPlayersView:UpdateData(rankData)
    for i=1,#rankData do
        local itemObj = self.pool:Spawn(nil,self.rankPrefab)
        itemObj.transform:SetParent(self.scrollContent,false)
        itemObj:SetActive(true)
        local rankItem = BirdsAnimalsPlayerRankItem.New(itemObj)
        rankItem:UpdateUI(rankData[i])
    end
end

---初始化View数据
function BirdsAnimalsPlayersView:InitPanelData(args)
    self.pool=ObjectPoolUtil.New(self.name)
end

---关闭界面
function BirdsAnimalsPlayersView:Close()
    self.pool:DestroyAll()
    self.super.Close(self);
end

return BirdsAnimalsPlayersView

