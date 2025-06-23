---
---Create by Administrator
---DateTime: 2025-06-21 15:09:13
---
---@class DragonTigerFightView:BaseView
local DragonTigerFightView=Class("DragonTigerFightView",BaseView)
local config=require("SingleGames/DragonTigerFight/DragonTigerFightConfig")
local coinFlyAnim = require("SingleGames/DragonTigerFight/View/CoinFlyAnimation")

---初始化panel
function DragonTigerFightView:InitView()
	---@type DragonTigerFightCtrl
    self.ctrl=self.ctrl
	self:InitComponents()
    self:InitUI()
end

---获取组件
function DragonTigerFightView:InitComponents()
    self.btn_close=ComponentUtilGet.Button(self.transform,"content/top/btn_close");
    self.btn_repeat=ComponentUtilGet.Button(self.transform,"content/buttom/btn_repeat");
    self.btn_players=ComponentUtilGet.Button(self.transform,"content/buttom/btn_players");
    self.dizhu=ComponentUtilGet.Transform(self.transform,"content/buttom/dizhu");
    self.xiazhuArea = ComponentUtilGet.Transform(self.transform,"content/center/XiaZhu")
    self.longClickArea = ComponentUtilGet.Transform(self.xiazhuArea,"longClick")
    self.huClickArea = ComponentUtilGet.Transform(self.xiazhuArea,"huClick")
    self.heClickArea = ComponentUtilGet.Transform(self.xiazhuArea,"heClick")
    ---下注数量
    ---@type  TMPro.TextMeshProUGUI[]
    self.xiazhuNumLabels = {}
    self.xiazhuNumLabels[1] = ComponentUtilGet.TextMeshProUGUI(self.xiazhuArea,"Center/Long/title/num")
    self.xiazhuNumLabels[2] = ComponentUtilGet.TextMeshProUGUI(self.xiazhuArea,"Center/Hu/title/num")
    self.xiazhuNumLabels[3] = ComponentUtilGet.TextMeshProUGUI(self.xiazhuArea,"Center/He/title/num")
    ---下注金币落点
    self.xiazhuStarAreas = {}
    self.xiazhuStarAreas[1] = ComponentUtilGet.RectTransform(self.xiazhuArea,"Center/Long/Star")
    self.xiazhuStarAreas[2] = ComponentUtilGet.RectTransform(self.xiazhuArea,"Center/Hu/Star")
    self.xiazhuStarAreas[3] = ComponentUtilGet.RectTransform(self.xiazhuArea,"Center/He/Star")
    ---个人下注数量
    ---@type  TMPro.TextMeshProUGUI[]
    self.xiazhuSelfNumsLabels = {}
    self.xiazhuSelfNumsLabels[1] = ComponentUtilGet.TextMeshProUGUI(self.longClickArea,"yazhuNum/num")
    self.xiazhuSelfNumsLabels[2] = ComponentUtilGet.TextMeshProUGUI(self.huClickArea,"yazhuNum/num")
    self.xiazhuSelfNumsLabels[3] = ComponentUtilGet.TextMeshProUGUI(self.heClickArea,"yazhuNum/num")
    ---下注底注按钮
    self.chipInfos={}
    for i = 1, 5 do
        local chipItem={}
        chipItem.obj=ComponentUtilGet.Button(self.transform,"content/buttom/dizhu/"..i)
        chipItem.rectTrans=ComponentUtilGet.RectTransform(self.transform,"content/buttom/dizhu/"..i)
        self.chipInfos[i]=chipItem
    end
    ---底注节点
    self.dizhuNode = ComponentUtilGet.GameObject(self.transform,"content/buttom/nodes")
    look("看下这个表",self.chipInfos)

end

---清空组件
function DragonTigerFightView:ClearComponents()
    self.btn_close=nil;
    self.btn_repeat=nil;
    self.btn_players=nil;
    self.img_1=nil;
    self.img_10=nil;
    self.img_50=nil;
    self.img_100=nil;
    self.img_500=nil;
    self.dizhu=nil;
    self.chipInfos=nil;
    self.longClickArea=nil;
    self.huClickArea=nil;
    self.heClickArea=nil;
    self.xiazhuNumLabels = nil;
    self.xiazhuSelfNumsLabels=nil;
    self.xiazhuStarAreas=nil;
    
end

---切换当前选中的底注
function DragonTigerFightView:ChangeDiZhu(index)
    self.chipInfos[config.dizhuIndex].rectTrans:DOScale(1,0.1)
    self.chipInfos[config.dizhuIndex].rectTrans:DOLocalMoveY(0,0.1)
    ---@type UnityEngine.RectTransform
    local rect = self.chipInfos[index].rectTrans
    rect:DOScale(1.4,0.1)
    rect:DOLocalMoveY(15.0,0.1)
    
end

---下注动画
function DragonTigerFightView:PayXiaZhuCoinFly(index)
    coinFlyAnim:AnimateCoin(self.dizhuNode,config.dizhuIndex,self.btn_players.transform.position,self.xiazhuStarAreas[index])
    self.xiazhuSelfNumsLabels[index].GameObject.transform.parent.gameObject:SetActive(true)
    self.xiazhuNumLabels[index].GameObject.transform.parent.gameObject:SetActive(true)
    self.xiazhuSelfNumsLabels[index].SetText(config.selfDiZhuNums[config.dizhuIndex])
    self.xiazhuNumLabels[index].SetText(config.totalDiZhuNums[config.dizhuIndex])
end

---初始界面
function DragonTigerFightView:InitUI()
    for i=1,3 do
        self.xiazhuSelfNumsLabels[i].gameObject.transform.parent.gameObject:SetActive(false)
        self.xiazhuNumLabels[i].gameObject.transform.parent.gameObject:SetActive(false)
    end
end
---初始化View数据
function DragonTigerFightView:InitPanelData(args)
	
end

---关闭界面
function DragonTigerFightView:Close()   
    self.super.Close(self);
end

return DragonTigerFightView

