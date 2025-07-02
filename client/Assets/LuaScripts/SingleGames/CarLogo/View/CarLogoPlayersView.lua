---
---Create by Administrator
---DateTime: 2025-07-02 08:53:42
---
---@class CarLogoPlayersView:BaseView
local CarLogoPlayersView=Class("CarLogoPlayersView",BaseView)
local PlayerRankItem=require("SingleGames/DragonTigerFight/View/Item/PlayerRankItem")
---初始化panel
function CarLogoPlayersView:InitView()
	---@type CarLogoPlayersCtrl
    self.ctrl=self.ctrl
	self:InitComponents()
end

---获取组件
function CarLogoPlayersView:InitComponents()
    self.img_title=ComponentUtilGet.Image(self.transform,"content/BackGround/img_title");
    self.btn_close=ComponentUtilGet.Button(self.transform,"content/BackGround/btn_close");
    self.scrollContent=ComponentUtilGet.Transform(self.transform,"content/ScrollView/Viewport/Content");
    self.rankPrefab=ComponentUtilGet.GameObject(self.transform,"content/ScrollView/Viewport/item/PlayerRankItem")
end

---清空组件
function CarLogoPlayersView:ClearComponents()
    self.img_title=nil;
    self.btn_close=nil;
    self.scrollContent=nil;
    self.rankPrefab=nil;
end

---初始化View数据
function CarLogoPlayersView:InitPanelData(args)
    ---@type ObjectPoolUtil
    self.pool=ObjectPoolUtil.New(self.name)
end

function CarLogoPlayersView:UpdateData(rankData)
    for i=1,#rankData do
        local itemObj = self.pool:Spawn(nil,self.rankPrefab)
        itemObj.transform:SetParent(self.scrollContent,false)
        itemObj:SetActive(true)
        local rankItem = PlayerRankItem.New(itemObj)
        rankItem:UpdateUI(rankData[i])
    end
end


---关闭界面
function CarLogoPlayersView:Close()
    self.pool:DestroyAll()
    self.super.Close(self);
end

return CarLogoPlayersView

