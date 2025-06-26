---
---Create by Administrator
---DateTime: 2025-06-21 15:09:13
---
---@class DragonTigerFightView:BaseView
local DragonTigerFightView=Class("DragonTigerFightView",BaseView)
local config=require("SingleGames/DragonTigerFight/DragonTigerFightConfig")
local coinFlyAnim = require("SingleGames/DragonTigerFight/View/PlayCoin")
local PlayerItem = require("SingleGames/DragonTigerFight/View/Item/PlayerItem")
local ClockStateItem = require("SingleGames/DragonTigerFight/View/Item/ClockState")
local RoadView = require("SingleGames/DragonTigerFight/View/RoadView")
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
    self.btn_1=ComponentUtilGet.Button(self.transform,"content/top/btn_1");
    self.btn_repeat=ComponentUtilGet.Button(self.transform,"content/buttom/btn_repeat");
    self.btn_players=ComponentUtilGet.Button(self.transform,"content/buttom/btn_players");
    self.dizhu=ComponentUtilGet.Transform(self.transform,"content/buttom/dizhu");
    self.xiazhuArea = ComponentUtilGet.Transform(self.transform,"content/center/XiaZhu")
    self.longClickArea = ComponentUtilGet.Transform(self.transform,"content/clickRect/longClick")
    self.huClickArea = ComponentUtilGet.Transform(self.transform,"content/clickRect/huClick")
    self.heClickArea = ComponentUtilGet.Transform(self.transform,"content/clickRect/heClick")
    self.selfPlayerRoot  = ComponentUtilGet.GameObject(self.transform,"content/buttom/selfPlayerRoot")
    ---下注数量
    ---@type  TMPro.TextMeshProUGUI[]
    self.xiazhuNumLabels = {}
    self.xiazhuNumLabels[1] = ComponentUtilGet.TextMeshProUGUI(self.xiazhuArea,"Center/Long/title/num")
    self.xiazhuNumLabels[2] = ComponentUtilGet.TextMeshProUGUI(self.xiazhuArea,"Center/Hu/title/num")
    self.xiazhuNumLabels[3] = ComponentUtilGet.TextMeshProUGUI(self.xiazhuArea,"Center/He/title/num")
    ---下注金币落点
    self.xiazhuStarAreas = {}
    self.xiazhuStarAreas[1] = ComponentUtilGet.RectTransform(self.longClickArea,"Star")
    self.xiazhuStarAreas[2] = ComponentUtilGet.RectTransform(self.huClickArea,"Star")
    self.xiazhuStarAreas[3] = ComponentUtilGet.RectTransform(self.heClickArea,"Star")
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
        chipItem.button=ComponentUtilGet.Button(chipItem.rectTrans)
        chipItem.effects=ComponentUtilGet.GameObject(chipItem.rectTrans,"checkd")
        chipItem.effects:SetActive(false)
        self.chipInfos[i]=chipItem
    end
    ---底注节点
    self.dizhuNode = ComponentUtilGet.GameObject(self.transform,"content/buttom/nodes")
    look("看下这个表",self.chipInfos)
    ---其他玩家信息 left right
    ---@type PlayerItem[]
    self.AllOtherPlayerHeads = {}
    local leftPath = "content/LeftRoot/playerRoot"
    for i = 1, 3 do
        self.AllOtherPlayerHeads[#self.AllOtherPlayerHeads + 1] = PlayerItem.New(ComponentUtilGet.GameObject(self.transform,leftPath..i))
    end
    local rightPath = "content/RightRoot/playerRoot"
    for i = 1, 3 do
        self.AllOtherPlayerHeads[#self.AllOtherPlayerHeads + 1] = PlayerItem.New(ComponentUtilGet.GameObject(self.transform,rightPath..i))
    end
    self.selfPlayer = PlayerItem.New(self.selfPlayerRoot)
    ---时钟状态提示
    self.clockStateTips = ComponentUtilGet.GameObject(self.transform,"content/center/XiaZhu/clockStateTips")
    ClockStateItem.New(self.clockStateTips)
    self.centerTips = ComponentUtilGet.GameObject(self.transform,"content/center/XiaZhu/centerTips")
    self.timeStartObj = ComponentUtilGet.GameObject(self.centerTips.transform,"timeStart")
    self.timeStart = ComponentUtilGet.TextMeshProUGUI(self.timeStartObj.transform,"Timer/LeftTime")
    self.timeStartBg = ComponentUtilGet.GameObject(self.timeStartObj.transform,"Timer/Bg")
    self.timeStartLockAnim = ComponentUtilGet.GameObject(self.timeStartObj.transform,"Timer/LockAnim")
    self.startXiaZhuTips = ComponentUtilGet.GameObject(self.centerTips.transform,"startXiaZhuTips")
    self.endXiaZhuTips = ComponentUtilGet.GameObject(self.centerTips.transform,"endXiaZhuTips")
    ---路单信息
    ---@type RoadView
    self.roadView=RoadView.New(ComponentUtilGet.GameObject(self.transform,"Background/RoadView"))
    
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
    self.chipInfos[config.dizhuIndex].effects:SetActive(false)
    ---@type UnityEngine.RectTransform
    local rect = self.chipInfos[index].rectTrans
    --rect:DOScale(1.4,0.1)
    rect:DOLocalMoveY(13.0,0.1)
    self.chipInfos[index].effects:SetActive(true)

end

---启用/禁用下注按钮
function DragonTigerFightView:InteractableDiZhu(enbale)
    for i=1,#self.chipInfos do
        self.chipInfos[i].button.interactable = enbale
    end
end

---本玩家下注动画
function DragonTigerFightView:PayXiaZhuCoinFly(index)
    coinFlyAnim:AnimateCoin(self.dizhuNode,config.dizhuIndex,self.selfPlayer.transform.position,self.xiazhuStarAreas[index])
    look("下注动画"..index)
    self.xiazhuSelfNumsLabels[index].transform.parent.gameObject:SetActive(true)
    self.xiazhuNumLabels[index].transform.parent.gameObject:SetActive(true)
    self.xiazhuSelfNumsLabels[index].text = config.selfDiZhuNums[index]
    self.xiazhuNumLabels[index].text = config.totalDiZhuNums[index]
end
---通过id找到玩家
function DragonTigerFightView:FindPlayerByID(id)
    for i=1,#self.AllOtherPlayerHeads do
        if self.AllOtherPlayerHeads[i].id==id then
            return self.AllOtherPlayerHeads[i]
        end
    end
    return nil
end
---其他玩家下注动画
function DragonTigerFightView:PayOtherXiaZhuCoinFly(data)
    for i=1,#self.ctrl.model.players do
        ---其他Top玩家下注动画
        if data.id == self.ctrl.model.players[i].id then
            local playerItem = self:FindPlayerByID(data.id)
            if playerItem ~= nil then
                coinFlyAnim:AnimateCoin(self.dizhuNode,data.dizhuType,playerItem.transform.position,self.xiazhuStarAreas[data.areaType])
            end
            break
        end

        if i>=6 then
            coinFlyAnim:AnimateCoin(self.dizhuNode,data.dizhuType,self.btn_players.transform.position,self.xiazhuStarAreas[data.areaType])
            break
        end
    end
end

---金币回收动画
function DragonTigerFightView:PlayCompeleCoinFLy(datas,players,cards)
    local result = 0
    if cards[1]>cards[2] then
        result = 1
    elseif cards[1] == cards[2] then
        result = 3
    else
        result = 2
    end

    ---测试
    local ratios = {0.3,0.2,0.5}
    local targetPos = {}
    targetPos[1] = self.selfPlayerRoot.transform.position
    targetPos[2] = self.btn_players.transform.position
    targetPos[3] = self.AllOtherPlayerHeads[Tools.RandomInt(1,6)].transform.position
    coinFlyAnim:DestroyCoin(targetPos,ratios)
end



---初始界面
function DragonTigerFightView:InitUI()
    for i=1,3 do
        self.xiazhuSelfNumsLabels[i].transform.parent.gameObject:SetActive(false)
        self.xiazhuNumLabels[i].transform.parent.gameObject:SetActive(false)
    end
    ---续押
    self.btn_repeat.interactable = false;
    ---其他玩家信息
    for i=1,#self.AllOtherPlayerHeads do
        self.AllOtherPlayerHeads[i]:updateGoldCount(i)
    end
    
    ---路单数据
    self.RoadHistoryRecord = nil
end
---初始化View数据
function DragonTigerFightView:InitPanelData(args)
	
end

---其他玩家信息更新
function DragonTigerFightView:UpdatePlayers(players)
    if players ~=nil and #players>0 then
        ---玩家排序
        table.sort(players, function(a, b)
            return a.coin < b.coin
        end)

        for i=1,#players do
            self.AllOtherPlayerHeads[i]:UpdatePlayer(players[i])
            if i>=#self.AllOtherPlayerHeads then
                break
            end
        end
    end
end

---更新路信息
function DragonTigerFightView:UpdateRoleView(data)
    self.RoadHistoryRecord = data
    self.roadView:UpdatePanelInfo(self.RoadHistoryRecord, true)
end

---关闭界面
function DragonTigerFightView:Close()   
    self.super.Close(self);
end

return DragonTigerFightView

