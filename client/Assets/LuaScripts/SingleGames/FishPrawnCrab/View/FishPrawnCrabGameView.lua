---
---Create by Administrator
---DateTime: 2025-07-14 18:34:27
---
---@class FishPrawnCrabGameView:BaseView
local FishPrawnCrabGameView=Class("FishPrawnCrabGameView",BaseView)
local FishPrawnCrabGameConfig = require("SingleGames/FishPrawnCrab/FishPrawnCrabGameConfig")
local DOTween = CS.DG.Tweening.DOTween
local Ease = CS.DG.Tweening.Ease

---初始化panel
function FishPrawnCrabGameView:InitView()
	---@type FishPrawnCrabGameCtrl
    self.ctrl=self.ctrl
	self:InitComponents()
end

---获取组件
function FishPrawnCrabGameView:InitComponents()
    self.btn_1=ComponentUtilGet.Button(self.transform,"content/top/btn_1");
    self.btn_recharge=ComponentUtilGet.Button(self.transform,"content/top/btn_recharge");
    self.btn_repeat=ComponentUtilGet.Button(self.transform,"content/bottom/btn_repeat");
    self.btn_players=ComponentUtilGet.Button(self.transform,"content/bottom/btn_players");
    self.tmp_total_player_num=ComponentUtilGet.TextMeshProUGUI(self.transform,"content/bottom/btn_players/tmp_total_player_num");
    self.img_1=ComponentUtilGet.Image(self.transform,"content/bottom/nodes/img_1");
    self.img_2=ComponentUtilGet.Image(self.transform,"content/bottom/nodes/img_2");
    self.img_3=ComponentUtilGet.Image(self.transform,"content/bottom/nodes/img_3");
    self.img_4=ComponentUtilGet.Image(self.transform,"content/bottom/nodes/img_4");
    self.img_5=ComponentUtilGet.Image(self.transform,"content/bottom/nodes/img_5");
    self.obj_PlayerRoot=ComponentUtilGet.GameObject(self.transform,"content/obj_PlayerRoot");
    self.btn_touch=ComponentUtilGet.Button(self.transform,"content/setting/btn_touch");
    self.btn_muen=ComponentUtilGet.Button(self.transform,"content/setting/btn_muen");
    self.trans_menu_panel=ComponentUtilGet.Transform(self.transform,"content/setting/mask/trans_menu_panel");
    self.btn_setting=ComponentUtilGet.Button(self.transform,"content/setting/mask/trans_menu_panel/btn_setting");
    self.btn_help=ComponentUtilGet.Button(self.transform,"content/setting/mask/trans_menu_panel/btn_help");
    self.btn_close=ComponentUtilGet.Button(self.transform,"content/setting/mask/trans_menu_panel/btn_close");

    ---下注底注按钮
    self.chipInfos={}
    for i = 1, 5 do
        local chipItem={}
        chipItem.obj=ComponentUtilGet.Button(self.transform,"content/bottom/antes/"..i)
        chipItem.rectTrans=ComponentUtilGet.RectTransform(self.transform,"content/bottom/antes/"..i)
        chipItem.button=ComponentUtilGet.Button(chipItem.rectTrans)
        chipItem.effects=ComponentUtilGet.GameObject(chipItem.rectTrans,"checkd")
        chipItem.effects:SetActive(false)
        self.chipInfos[i]=chipItem
    end
end

---清空组件
function FishPrawnCrabGameView:ClearComponents()
    self.btn_1=nil;
    self.btn_recharge=nil;
    self.btn_repeat=nil;
    self.btn_players=nil;
    self.tmp_total_player_num=nil;
    self.img_1=nil;
    self.img_2=nil;
    self.img_3=nil;
    self.img_4=nil;
    self.img_5=nil;
    self.obj_PlayerRoot=nil;
    self.btn_touch=nil;
    self.btn_muen=nil;
    self.trans_menu_panel=nil;
    self.btn_setting=nil;
    self.btn_help=nil;
    self.btn_close=nil;
end

---初始化View数据
function FishPrawnCrabGameView:InitPanelData(args)
	
end

---关闭界面
function FishPrawnCrabGameView:Close()   
    self.super.Close(self);
end

---切换当前选中的底注
function FishPrawnCrabGameView:ChangeAnte(index)
    -- 参数验证
    if not index or index < 1 or index > #self.chipInfos then
        return
    end

    -- 如果点击的是当前已选中的按钮，不做任何操作
    if index == FishPrawnCrabGameConfig.anteIndex and self.chipInfos[index].effects.activeSelf then
        return
    end

    local oldIndex = FishPrawnCrabGameConfig.anteIndex
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
    FishPrawnCrabGameConfig.anteIndex = index
end

return FishPrawnCrabGameView

