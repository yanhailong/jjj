---
---Create by Administrator
---DateTime: 2025-08-02 16:14:04
---
---@class SicBoMainView:BaseView
local SicBoMainView=Class("SicBoMainView",BaseView)

---初始化panel
function SicBoMainView:InitView()
	---@type SicBoMainCtrl
    self.ctrl=self.ctrl
	self:InitComponents()
end

---获取组件
function SicBoMainView:InitComponents()
    self.obj_croupier=ComponentUtilGet.GameObject(self.transform,"Table/bg/chair/obj_croupier");
    self.obj_palyerSelf=ComponentUtilGet.GameObject(self.transform,"Table/Bottom/obj_palyerSelf");
    self.btn_BetButtonMove_Left=ComponentUtilGet.Button(self.transform,"Table/Bottom/BetButtons/btn_BetButtonMove_Left");
    self.obj_disabe_Left=ComponentUtilGet.GameObject(self.transform,"Table/Bottom/BetButtons/btn_BetButtonMove_Left/obj_disabe_Left");
    self.obj_enable_Left=ComponentUtilGet.GameObject(self.transform,"Table/Bottom/BetButtons/btn_BetButtonMove_Left/obj_enable_Left");
    self.btn_BetButtonMove_Right=ComponentUtilGet.Button(self.transform,"Table/Bottom/BetButtons/btn_BetButtonMove_Right");
    self.obj_disabe_Right=ComponentUtilGet.GameObject(self.transform,"Table/Bottom/BetButtons/btn_BetButtonMove_Right/obj_disabe_Right");
    self.obj_enable_Right=ComponentUtilGet.GameObject(self.transform,"Table/Bottom/BetButtons/btn_BetButtonMove_Right/obj_enable_Right");
    self.rect_ButtonsList=ComponentUtilGet.RectTransform(self.transform,"Table/Bottom/BetButtons/rect_ButtonsList");
    self.obj_BetButtonPrefab=ComponentUtilGet.GameObject(self.transform,"Table/Bottom/BetButtons/rect_ButtonsList/obj_BetButtonPrefab");
    self.obj_Content=ComponentUtilGet.GameObject(self.transform,"Table/Bottom/BetButtons/rect_ButtonsList/obj_Content");
    self.txt_otherPlayer=ComponentUtilGet.Text(self.transform,"Table/Bottom/OtherPlayer/txt_otherPlayer");
    self.btn_Rebet=ComponentUtilGet.Button(self.transform,"Table/Bottom/btn_Rebet");
    self.obj_Palyers=ComponentUtilGet.GameObject(self.transform,"Table/obj_Palyers");
    self.obj_ChipPool=ComponentUtilGet.GameObject(self.transform,"Table/obj_ChipPool");
    self.obj_SelectArea=ComponentUtilGet.GameObject(self.transform,"Table/obj_SelectArea");
    self.obj_History=ComponentUtilGet.GameObject(self.transform,"Table/History/obj_History");
    self.obj_DiceBox=ComponentUtilGet.GameObject(self.transform,"Table/obj_DiceBox");
    self.obj_DiceBox_MiniPos=ComponentUtilGet.GameObject(self.transform,"Table/obj_DiceBox_MiniPos");
    self.obj_StartGame=ComponentUtilGet.CanvasGroup(self.transform,"Table/GameState/obj_StartGame");
    self.obj_StartBet=ComponentUtilGet.CanvasGroup(self.transform,"Table/GameState/obj_StartBet");
    self.obj_StopBet=ComponentUtilGet.CanvasGroup(self.transform,"Table/GameState/obj_StopBet");
    self.obj_Tips=ComponentUtilGet.GameObject(self.transform,"Table/GameState/obj_Tips");
    self.obj_TipsBet=ComponentUtilGet.GameObject(self.transform,"Table/GameState/obj_Tips/obj_TipsBet");
    self.obj_TipsPrepare=ComponentUtilGet.GameObject(self.transform,"Table/GameState/obj_Tips/obj_TipsPrepare");
    self.obj_TipsCounting=ComponentUtilGet.GameObject(self.transform,"Table/GameState/obj_Tips/obj_TipsCounting");
    self.txt_TimeText=ComponentUtilGet.Text(self.transform,"Table/GameState/obj_Tips/txt_TimeText");
    self.obj_Timer=ComponentUtilGet.GameObject(self.transform,"Table/obj_Timer");
    self.txt_TimeText_obj_Timer=ComponentUtilGet.Text(self.transform,"Table/obj_Timer/txt_TimeText");
    self.btn_MoreButton=ComponentUtilGet.Button(self.transform,"btn_MoreButton");
    self.btn_ShopButton=ComponentUtilGet.Button(self.transform,"btn_ShopButton");
end

---清空组件
function SicBoMainView:ClearComponents()
    self.obj_croupier=nil;
    self.obj_palyerSelf=nil;
    self.btn_BetButtonMove_Left=nil;
    self.obj_disabe_Left=nil;
    self.obj_enable_Left=nil;
    self.btn_BetButtonMove_Right=nil;
    self.obj_disabe_Right=nil;
    self.obj_enable_Right=nil;
    self.rect_ButtonsList=nil;
    self.obj_BetButtonPrefab=nil;
    self.obj_Content=nil;
    self.txt_otherPlayer=nil;
    self.btn_Rebet=nil;
    self.obj_Palyers=nil;
    self.obj_ChipPool=nil;
    self.obj_SelectArea=nil;
    self.obj_History=nil;
    self.obj_DiceBox=nil;
    self.obj_DiceBox_MiniPos=nil;
    self.obj_StartGame=nil;
    self.obj_StartBet=nil;
    self.obj_StopBet=nil;
    self.obj_Tips=nil;
    self.obj_TipsBet=nil;
    self.obj_TipsPrepare=nil;
    self.obj_TipsCounting=nil;
    self.txt_TimeText=nil;
    self.obj_Timer=nil;
    self.txt_TimeText_obj_Timer=nil;
    self.btn_MoreButton=nil;
    self.btn_ShopButton=nil;
end

---初始化View数据
function SicBoMainView:InitPanelData(args)
	
end

---关闭界面
function SicBoMainView:Close()   
    self.super.Close(self);
end

return SicBoMainView

