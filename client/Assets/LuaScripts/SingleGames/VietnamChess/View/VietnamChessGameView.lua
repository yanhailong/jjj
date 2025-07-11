---
---Create by Administrator
---DateTime: 2025-07-10 15:51:08
---
---@class VietnamChessGameView:BaseView
local VietnamChessGameView=Class("VietnamChessGameView",BaseView)
local VietnamChessConfig=require("SingleGames/VietnamChess/VietnamChessConfig")
local VietnamChessPlayCoin = require("SingleGames/VietnamChess/View/Item/VietnamChessPlayCoin")
local VietnamChessPlayerItem = require("SingleGames/VietnamChess/View/Item/VietnamChessPlayerItem")
local VietnamChessRoadView = require("SingleGames/VietnamChess/View/Item/VietnamChessRoadView")
local DOTween = CS.DG.Tweening.DOTween
local Ease = CS.DG.Tweening.Ease

---初始化panel
function VietnamChessGameView:InitView()
	---@type VietnamChessGameCtrl
    self.ctrl=self.ctrl
	self:InitComponents()
end

---获取组件
function VietnamChessGameView:InitComponents()
    self.btn_nav=ComponentUtilGet.Button(self.transform,"content/RoadView/mask/node/btn_nav");
    self.btn_1=ComponentUtilGet.Button(self.transform,"content/top/btn_1");
    self.btn_recharge=ComponentUtilGet.Button(self.transform,"content/top/btn_recharge");
    self.btn_repeat=ComponentUtilGet.Button(self.transform,"content/buttom/btn_repeat");
    self.btn_players=ComponentUtilGet.Button(self.transform,"content/buttom/btn_players");
    self.tmp_totalPlayerNum=ComponentUtilGet.Text(self.transform,"content/buttom/btn_players/tmp_total_player_num");
    
    self.dizhu=ComponentUtilGet.Transform(self.transform,"content/buttom/dizhu");
    self.xiazhuArea = ComponentUtilGet.Transform(self.transform,"content/center/XiaZhu")
    self.clickRect = ComponentUtilGet.Transform(self.transform,"content/clickRect")
    self.selfPlayerRoot  = ComponentUtilGet.GameObject(self.transform,"content/buttom/SelfHead")
    ---下注数量
    ---@type  TMPro.TextMeshProUGUI[]
    self.xiazhuNumLabels = {}
    ---@type  TMPro.TextMeshProUGUI[]
    self.xiazhuRateLabels = {}
    self.xiazhuLights = {}
    for i=1,self.xiazhuArea.childCount do
        local trs = self.xiazhuArea:GetChild(i-1)
        self.xiazhuNumLabels[i] = ComponentUtilGet.TextMeshProUGUI(trs,"title/num")
        self.xiazhuRateLabels[i] = ComponentUtilGet.TextMeshProUGUI(trs,"rate")
        self.xiazhuLights[i] = ComponentUtilGet.Image(trs,"bg")
    end
    
    ---下注区域按钮

    ---下注金币落点
    ---@type  TMPro.TextMeshProUGUI[]
    self.xiazhuStarAreas = {}
    ---个人下注数量
    ---@type  TMPro.TextMeshProUGUI[]
    self.xiazhuSelfNumsLabels = {}
    for i=1,self.clickRect.childCount do
        self.xiazhuStarAreas[i] = ComponentUtilGet.Transform(self.clickRect:GetChild(i-1),"Star")
        self.xiazhuSelfNumsLabels[i] = ComponentUtilGet.TextMeshProUGUI(self.clickRect:GetChild(i-1),"yazhuNum/num")
    end
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
    ---其他玩家信息 left right
    ---@type VietnamChessPlayerItem[]
    self.AllOtherPlayerHeads = {}
    local otherPlayerTrs = ComponentUtilGet.Transform(self.transform,"content/obj_PlayerRoot")
    for i = 1, 6 do
        self.AllOtherPlayerHeads[#self.AllOtherPlayerHeads + 1] = VietnamChessPlayerItem.New(otherPlayerTrs:GetChild(i-1))
    end
    self.selfPlayer = VietnamChessPlayerItem.New(self.selfPlayerRoot)
    ---提示信息
    self.tipsTrs = ComponentUtilGet.Transform(self.transform,"content/tips")
    self.tipsTimeEnd = ComponentUtilGet.GameObject(self.tipsTrs,"tips_time_end")
    self.tipsStartXiaZhu = ComponentUtilGet.GameObject(self.tipsTrs,"tips_start_xiazhu")
    self.tipsTimeThree = ComponentUtilGet.GameObject(self.tipsTrs,"tips_time_three")

    self.tipsCenterTxt = ComponentUtilGet.Transform(self.tipsTrs,"tips_center/tips_center_txt")
    self.colockStateTimeTrs = ComponentUtilGet.Transform(self.tipsTrs,"tips_center/colock_state_time")
    self.colockStateTimeNum=ComponentUtilGet.Text(self.colockStateTimeTrs,"time") --倒计时
    self.colockStateTimeZunbei=ComponentUtilGet.GameObject(self.colockStateTimeTrs,"zunbei") --准备倒计时文字
    self.colockStateTimeXiaZhu=ComponentUtilGet.GameObject(self.colockStateTimeTrs,"xiazhu") --下注倒计时文字
    self.colockNumTrs=ComponentUtilGet.Transform(self.tipsTrs,"tips_center/colock_num")
    self.colockNumTime=ComponentUtilGet.Text(self.colockNumTrs,"time")

    self.three=ComponentUtilGet.Transform(self.tipsTrs,"three")

    ---路单信息
    self.navRect=ComponentUtilGet.RectTransform(self.transform,"content/RoadView/mask/node")
    ------@type VietnamChessRoadView
    self.RoadView=VietnamChessRoadView.New(self.navRect.gameObject)
    self.navBtnImg=ComponentUtilGet.Text(self.transform,"content/RoadView/mask/node/btn_nav/nav")
    self.navShow=true
    
    ---设置按钮
    self.muenRect=ComponentUtilGet.RectTransform(self.transform,"content/setting/mask/muen")
    self.btn_setting=ComponentUtilGet.Button(self.muenRect,"btn_setting")
    self.btn_help=ComponentUtilGet.Button(self.muenRect,"btn_help")
    self.btn_close=ComponentUtilGet.Button(self.muenRect,"btn_close")
    self.btn_muen=ComponentUtilGet.Button(self.transform,"content/setting/btn_muen")
    self.btn_touch=ComponentUtilGet.Button(self.transform,"content/setting/btn_touch")
    ---结果信息
    self.effectsTrs=ComponentUtilGet.Transform(self.transform,"content/effects")
    self.resultTrs=ComponentUtilGet.Transform(self.effectsTrs,"resoult")
    self.resultNode=ComponentUtilGet.Transform(self.resultTrs,"win")
    self.resultGaiZhi=ComponentUtilGet.Transform(self.resultTrs,"gaizhi")
end

---清空组件
function VietnamChessGameView:ClearComponents()
    self.btn_nav=nil;
    self.btn_1=nil;
    self.btn_recharge=nil;
    self.btn_repeat=nil;
    self.btn_players=nil;
    self.tmp_totalPlayerNum=nil;
    self.btn_touch=nil;
    self.btn_muen=nil;
    self.btn_setting=nil;
    self.btn_help=nil;
    self.btn_close=nil;
end

---初始化View数据
function VietnamChessGameView:InitPanelData(args)
	self:InitUI()
end


---切换当前选中的底注
function VietnamChessGameView:ChangeDiZhu(index)
    -- 参数验证
    if not index or index < 1 or index > #self.chipInfos then
        return
    end

    -- 如果点击的是当前已选中的按钮，不做任何操作
    if index == VietnamChessConfig.dizhuIndex and self.chipInfos[index].effects.activeSelf then
        return
    end

    local oldIndex = VietnamChessConfig.dizhuIndex
    local oldChip = self.chipInfos[oldIndex]
    local newChip = self.chipInfos[index]

    -- 停止之前按钮的所有动画
    if oldChip and oldChip.rectTrans then
        oldChip.rectTrans:DOKill() -- 停止所有DOTween动画
    end

    -- 停止新按钮的所有动画
    if newChip and newChip.rectTrans then
        newChip.rectTrans:DOKill() -- 停止所有DOTween动画
    end

    -- 重置旧按钮状态
    if oldChip then
        oldChip.rectTrans:DOScale(1, 0.1):SetEase(Ease.OutQuad)
        oldChip.rectTrans:DOLocalMoveY(0, 0.1):SetEase(Ease.OutQuad)
        oldChip.effects:SetActive(false)
    end

    -- 设置新按钮状态
    if newChip then
        -- 先设置缩放动画
        newChip.rectTrans:DOScale(1.1, 0.15):SetEase(Ease.OutBack)
        -- 再设置位置动画
        newChip.rectTrans:DOLocalMoveY(13.0, 0.15):SetEase(Ease.OutQuad)
        newChip.effects:SetActive(true)
    end

    -- 更新配置中的当前选中索引
    VietnamChessConfig.dizhuIndex = index
end

---启用/禁用下注按钮
function VietnamChessGameView:UpdateDiZhuBtnState()
    for i=1,#self.chipInfos do
        self.chipInfos[i].button.interactable = VietnamChessConfig.allow and VietnamChessConfig.dizhuNumArr[i]<=VietnamChessConfig.goldRealNum
    end
end

---设置续投按钮是否可以点击 当前局已经手动投注或者上局未投注不能点 其他可点
function VietnamChessGameView:SetRepeatState(isOn)
    if isOn then
        self.btn_repeat.interactable = true;
    else
        self.btn_repeat.interactable = false;
    end
end

---本玩家下注动画
function VietnamChessGameView:PayXiaZhuCoinFly(side)
    VietnamChessPlayCoin:AnimateCoin(self.dizhuNode,VietnamChessConfig.dizhuIndex,self.selfPlayer.transform.position,self.xiazhuStarAreas[side])
end
---通过id找到玩家
function VietnamChessGameView:FindPlayerByID(id)
    for i=1,#self.AllOtherPlayerHeads do
        if self.AllOtherPlayerHeads[i].id==id then
            return self.AllOtherPlayerHeads[i]
        end
    end
    return nil
end
---其他玩家下注动画
function VietnamChessGameView:PayOtherXiaZhuCoinFly(data)
    self:UpdateXiaZhuLabel()

    for i=1,#self.ctrl.model.players do
        ---其他Top玩家下注动画
        if data.id == self.ctrl.model.players[i].id then
            local playerItem = self:FindPlayerByID(data.id)
            if playerItem ~= nil then
                VietnamChessPlayCoin:AnimateCoin(self.dizhuNode,data.dizhuType,playerItem.transform.position,self.xiazhuStarAreas[data.areaType])
            end
            break
        end

        if i>=6 then
            VietnamChessPlayCoin:AnimateCoin(self.dizhuNode,data.dizhuType,self.btn_players.transform.position,self.xiazhuStarAreas[data.areaType])
            break
        end
    end
end

---显示房间已出的底注 不要动画
function VietnamChessGameView:RefresAreaCoin()
    if VietnamChessConfig.allXiaZhuData and #VietnamChessConfig.allXiaZhuData>0 then
        for i=1,#VietnamChessConfig.allXiaZhuData do
            VietnamChessPlayCoin:CreatCoinInArea(self.dizhuNode,VietnamChessConfig.allXiaZhuData[i].dizhuType,self.xiazhuStarAreas[VietnamChessConfig.allXiaZhuData[i].areaType])
        end
    end
end

---金币回收动画
function VietnamChessGameView:PlayCompeleCoinFLy(datas,players,cards)
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
    local p = Tools.RandomInt(1,6)
    targetPos[1] = self.selfPlayerRoot.transform.position
    targetPos[2] = self.btn_players.transform.position
    targetPos[3] = self.AllOtherPlayerHeads[p].transform.position
    VietnamChessPlayCoin:DestroyCoin(targetPos,ratios)
    --奖励数值
    self.selfPlayer:ShowResultCount(Tools.RandomInt(-100,1000))
    self.AllOtherPlayerHeads[p]:ShowResultCount(Tools.RandomInt(-100,1000))
end


---初始界面
function VietnamChessGameView:InitUI()
    ---续押
    self.btn_repeat.interactable = false;
    ---其他玩家信息
    for i=1,#self.AllOtherPlayerHeads do
        self.AllOtherPlayerHeads[i]:UpdateGoldCount(i)
    end
    
    for i=1,#self.xiazhuRateLabels do
        self.xiazhuLights[i].gameObject:SetActive(false)
        self.xiazhuRateLabels[i].text = "1:"..VietnamChessConfig.CHESS_ODS[i]
    end
    
    ---路单数据
    self.RoadHistoryRecord = nil
    self.tmp_totalPlayerNum.text="0"
    self.colockStateTimeTrs.gameObject:SetActive(false)
    self.tipsCenterTxt.gameObject:SetActive(false)
    self.tipsStartXiaZhu:SetActive(false)
    self.tipsTimeEnd:SetActive(false)
    self.tipsTimeThree:SetActive(false)
    self.three.gameObject:SetActive(false)
    self.resultGaiZhi.gameObject:SetActive(true)
    self:InitXiaZhuLabel()
end

function VietnamChessGameView:InitXiaZhuLabel()
    for i=1,#self.xiazhuRateLabels do
        self.xiazhuSelfNumsLabels[i].text = "0"
        self.xiazhuNumLabels[i].text = "0"
    end
end

function VietnamChessGameView:UpdateXiaZhuLabel()
    for index=1,6 do
        self.xiazhuNumLabels[index].text = VietnamChessConfig.totalDiZhuNums[index]
        if VietnamChessConfig.selfDiZhuNums[index]>0 then
            self.xiazhuSelfNumsLabels[index].text = VietnamChessConfig.selfDiZhuNums[index]
        end
    end
end
---流程 当前牌局状态,1=等待押注,2=押注冻结，等待开牌,3=本局结束
---当前状态剩余秒数

---设置菜单显示隐藏
function VietnamChessGameView:SettingFade()
    if self.settingShow then
        self.settingShow = false
        self.muenRect:DOLocalMoveY(self.muenRect.sizeDelta.y+100,0.5):SetEase(Ease.InBack)
        self.btn_touch.gameObject:SetActive(false)
    else
        self.settingShow = true
        self.muenRect:DOLocalMoveY(0,0.5):SetEase(Ease.OutBack)
        self.btn_touch.gameObject:SetActive(true)
    end

end

function VietnamChessGameView:NavRoleView()
    if self.navShow then
        self.navShow = false
        self.navRect:DOLocalMoveY(338,0.5):SetEase(Ease.InBack)
        self.navBtnImg.text = "V"
    else
        self.navShow = true
        self.navRect:DOLocalMoveY(0,0.5):SetEase(Ease.OutBack)
        self.navBtnImg.text = "^"
    end
end

function VietnamChessGameView:AreaLight()
    for i=1,#VietnamChessConfig.sideArea do
        local index = VietnamChessConfig.sideArea[i]
        self.xiazhuLights[index].gameObject:SetActive(true)
        Tools.DOFade_Repeat(self.xiazhuLights[index],0.2,3,0,function()
            self.xiazhuLights[index].gameObject:SetActive(false)
        end)
    end
end

function VietnamChessGameView:CacValue()
    local count = ArrayUtil.countByVale(VietnamChessConfig.sideColor,VietnamChessConfig.QICOLOR.WHITE)
    VietnamChessConfig.isouNum=count%2==0
    VietnamChessConfig.sideArea={}
    local index = ArrayUtil.indexOf(VietnamChessConfig.CHESS_TYPE,count)
    if index then
        for k,v in pairs(VietnamChessConfig.CHESS_ODS_GROUP) do
            if ArrayUtil.contains(v,index) then
                table.insert(VietnamChessConfig.sideArea,k)
            end
        end
    end
end

---显示牌面结果和播放动画
function VietnamChessGameView:ResultEffect()
    VietnamChessConfig.allow=false
    VietnamChessConfig.currStatus=2
    self:UpdateDiZhuBtnState()
    self:CacValue()
    
    --下注结束
    self.tipsTimeEnd:SetActive(true)

    --开牌
    self:UpdateQI(VietnamChessConfig.sideColor)
    self.resultGaiZhi:DOScale(0,0.5):OnComplete(function()
        self.resultGaiZhi.gameObject:SetActive(false)
    end)
    --等待开牌-飞-路信息
    TimerManager.StartTimer(self, function
    ()
        ---回收
        GlobalEvent.Notify("XIAZHU_END",{})
        ---区域
        self:AreaLight()
        
    end,2,0,false)

    TimerManager.StartTimer(self, function
    ()
        --显示路信息
        GlobalEvent.Notify("UPDATE_HIS_ITEMS")
    end,4,0,false)
    
end

---开始动画播放
function VietnamChessGameView:StartEffect(callFunc)
   
    --准备倒计时3s
    self.colockStateTimeZunbei:SetActive(true)
    self.colockStateTimeXiaZhu:SetActive(false)
    self.colockStateTimeTrs.gameObject:SetActive(true)
    VietnamChessConfig.lessSeconds = 3
    self.colockStateTimeNum.text = VietnamChessConfig.lessSeconds
    TimerManager.StartTimer(self,function()
        VietnamChessConfig.lessSeconds = VietnamChessConfig.lessSeconds - 1
        self.colockStateTimeNum.text = VietnamChessConfig.lessSeconds
    end,1,3,false)

    --开始下注提示
    TimerManager.StartTimer(self,function()
        --重置和初始UI信息
        self.resultGaiZhi.localScale = Vector3(1,1,1)
        self.resultGaiZhi.gameObject:SetActive(true)
        self:InitXiaZhuLabel()
        
        self.colockStateTimeZunbei:SetActive(false)
        self.colockStateTimeXiaZhu:SetActive(true)
        self.tipsStartXiaZhu:SetActive(true)
        self:UpdateXiaZhuLabel()
        TimerManager.StartTimer(self,function()
            self.tipsStartXiaZhu:SetActive(false)
        end,1.5,0,false)

        --倒计时
        VietnamChessConfig.lessSeconds = VIETNAM_CHESS_GAME_TIME
        self.colockStateTimeNum.text = VietnamChessConfig.lessSeconds
        self.colockStateTimeTrs.gameObject:SetActive(true)
        TimerManager.StartTimer(self, function
        ()
            VietnamChessConfig.lessSeconds = VietnamChessConfig.lessSeconds - 1
            self.colockStateTimeNum.text = VietnamChessConfig.lessSeconds
            --倒计时3s
            if VietnamChessConfig.lessSeconds==3 then
                self.colockStateTimeTrs.gameObject:SetActive(false)
                self:PlayDaoJiShiEffect()
            end
        end, 1, VIETNAM_CHESS_GAME_TIME, true,function()
            self:SetRepeatState(false)
        end)

        if callFunc then callFunc() end
    end,3,0,false)
 
end

---倒计时3秒
function VietnamChessGameView:PlayDaoJiShiEffect()
    for i=0,1 do
        self.three:GetChild(i).gameObject:SetActive(false)
    end
    self.three.gameObject:SetActive(true)
    self.tipsTimeThree:SetActive(true)

    self.three:GetChild(2).gameObject:SetActive(true)
    for i=1,3 do
        TimerManager.StartTimer(self,function()
            if i==3 then
                self.three.gameObject:SetActive(false)
                self.tipsTimeThree:SetActive(false)
                return
            end
            self.three:GetChild(3-i).gameObject:SetActive(false)
            self.three:GetChild(2-i).gameObject:SetActive(true)
        end,i,0,false)
    end
end

---更新自己信息
function VietnamChessGameView:UpdateSelf(player)
    self.selfPlayer:UpdatePlayer(player)
end
function VietnamChessGameView:UpdateSelfGoldCount()
    self.selfPlayer:UpdateGoldCount(VietnamChessConfig.goldRealNum)
end
---其他玩家信息更新
function VietnamChessGameView:UpdatePlayers(players)
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
function VietnamChessGameView:UpdateRoleView(data)
    self.RoadHistoryRecord = data
    self.RoadView:UpdatePanelInfo(self.RoadHistoryRecord, true)
end

---更新棋子
function VietnamChessGameView:UpdateQI(data)
    if not data or #data ~= 4 then
        return
    end
    --排序
    ArrayUtil.sort(data)
    for i=1,4 do
        if data[i] == VietnamChessConfig.QICOLOR.WHITE then
            self.resultNode:GetChild(i-1):GetChild(1).gameObject:SetActive(true)
        else
            self.resultNode:GetChild(i-1):GetChild(1).gameObject:SetActive(false)
        end
    end
end

---关闭界面
function VietnamChessGameView:Close()
    VietnamChessPlayCoin:Destroy()
    self.super.Close(self);
end

return VietnamChessGameView

