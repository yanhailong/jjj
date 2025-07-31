---
---Create by Administrator
---DateTime: 2025-07-31 17:29:10
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
    self.img_HeadImageSelf=ComponentUtilGet.Image(self.transform,"Table/Bottom/obj_palyerSelf/Head/img_HeadImageSelf");
    self.txt_PlayerNameSelf=ComponentUtilGet.Text(self.transform,"Table/Bottom/obj_palyerSelf/txt_PlayerNameSelf");
    self.txt_GoldTextSelf=ComponentUtilGet.Text(self.transform,"Table/Bottom/obj_palyerSelf/Gold/txt_GoldTextSelf");
    self.obj_BetButtonPrefab=ComponentUtilGet.GameObject(self.transform,"Table/Bottom/BetButtons/ButtonsList/Viewport/obj_BetButtonPrefab");
    self.txt_betMoneyText=ComponentUtilGet.Text(self.transform,"Table/Bottom/BetButtons/ButtonsList/Viewport/obj_BetButtonPrefab/txt_betMoneyText");
    self.obj_Content=ComponentUtilGet.GameObject(self.transform,"Table/Bottom/BetButtons/ButtonsList/Viewport/obj_Content");
    self.txt_otherPlayer=ComponentUtilGet.Text(self.transform,"Table/Bottom/OtherPlayer/txt_otherPlayer");
    self.btn_Rebet=ComponentUtilGet.Button(self.transform,"Table/Bottom/btn_Rebet");
    self.img_HeadImage=ComponentUtilGet.Image(self.transform,"Table/Palyers/palyer_1/Head/img_HeadImage");
    self.txt_PlayerName=ComponentUtilGet.Text(self.transform,"Table/Palyers/palyer_1/txt_PlayerName");
    self.txt_GoldText=ComponentUtilGet.Text(self.transform,"Table/Palyers/palyer_1/Gold/txt_GoldText");
    self.img_HeadImage_Head=ComponentUtilGet.Image(self.transform,"Table/Palyers/palyer_2/Head/img_HeadImage");
    self.txt_PlayerName_palyer_2=ComponentUtilGet.Text(self.transform,"Table/Palyers/palyer_2/txt_PlayerName");
    self.txt_GoldText_Gold=ComponentUtilGet.Text(self.transform,"Table/Palyers/palyer_2/Gold/txt_GoldText");
    self.img_HeadImage_Head1030=ComponentUtilGet.Image(self.transform,"Table/Palyers/palyer_3/Head/img_HeadImage");
    self.txt_PlayerName_palyer_3=ComponentUtilGet.Text(self.transform,"Table/Palyers/palyer_3/txt_PlayerName");
    self.txt_GoldText_Gold653=ComponentUtilGet.Text(self.transform,"Table/Palyers/palyer_3/Gold/txt_GoldText");
    self.img_HeadImage_Head7306=ComponentUtilGet.Image(self.transform,"Table/Palyers1/palyer4/Head/img_HeadImage");
    self.txt_PlayerName_palyer4=ComponentUtilGet.Text(self.transform,"Table/Palyers1/palyer4/txt_PlayerName");
    self.txt_GoldText_Gold9661=ComponentUtilGet.Text(self.transform,"Table/Palyers1/palyer4/Gold/txt_GoldText");
    self.img_HeadImage_Head309=ComponentUtilGet.Image(self.transform,"Table/Palyers1/palyer5/Head/img_HeadImage");
    self.txt_PlayerName_palyer5=ComponentUtilGet.Text(self.transform,"Table/Palyers1/palyer5/txt_PlayerName");
    self.txt_GoldText_Gold2579=ComponentUtilGet.Text(self.transform,"Table/Palyers1/palyer5/Gold/txt_GoldText");
    self.img_HeadImage_Head6278=ComponentUtilGet.Image(self.transform,"Table/Palyers1/palyer6/Head/img_HeadImage");
    self.txt_PlayerName_palyer6=ComponentUtilGet.Text(self.transform,"Table/Palyers1/palyer6/txt_PlayerName");
    self.txt_GoldText_Gold7582=ComponentUtilGet.Text(self.transform,"Table/Palyers1/palyer6/Gold/txt_GoldText");
    self.obj_ChipPool=ComponentUtilGet.GameObject(self.transform,"Table/obj_ChipPool");
    self.obj_SelectArea=ComponentUtilGet.GameObject(self.transform,"Table/obj_SelectArea");
    self.obj_DiceBox_Big=ComponentUtilGet.GameObject(self.transform,"Table/obj_DiceBox_Big");
    self.img_BigDice1=ComponentUtilGet.Image(self.transform,"Table/obj_DiceBox_Big/img_BigDice1");
    self.img_BigDice2=ComponentUtilGet.Image(self.transform,"Table/obj_DiceBox_Big/img_BigDice2");
    self.img_BigDice3=ComponentUtilGet.Image(self.transform,"Table/obj_DiceBox_Big/img_BigDice3");
    self.obj_Lid=ComponentUtilGet.GameObject(self.transform,"Table/obj_DiceBox_Big/obj_Lid");
    self.obj_DiceBox_Mini=ComponentUtilGet.GameObject(self.transform,"Table/obj_DiceBox_Mini");
    self.img_MiniDice1=ComponentUtilGet.Image(self.transform,"Table/obj_DiceBox_Mini/img_MiniDice1");
    self.img_MiniDice2=ComponentUtilGet.Image(self.transform,"Table/obj_DiceBox_Mini/img_MiniDice2");
    self.img_MiniDice3=ComponentUtilGet.Image(self.transform,"Table/obj_DiceBox_Mini/img_MiniDice3");
    self.obj_Lid_obj_DiceBox_Mini=ComponentUtilGet.GameObject(self.transform,"Table/obj_DiceBox_Mini/obj_Lid");
    self.obj_StartGame=ComponentUtilGet.GameObject(self.transform,"Table/GameState/obj_StartGame");
    self.obj_StartBet=ComponentUtilGet.GameObject(self.transform,"Table/GameState/obj_StartBet");
    self.obj_StopBet=ComponentUtilGet.GameObject(self.transform,"Table/GameState/obj_StopBet");
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
    self.img_HeadImageSelf=nil;
    self.txt_PlayerNameSelf=nil;
    self.txt_GoldTextSelf=nil;
    self.obj_BetButtonPrefab=nil;
    self.txt_betMoneyText=nil;
    self.obj_Content=nil;
    self.txt_otherPlayer=nil;
    self.btn_Rebet=nil;
    self.img_HeadImage=nil;
    self.txt_PlayerName=nil;
    self.txt_GoldText=nil;
    self.img_HeadImage_Head=nil;
    self.txt_PlayerName_palyer_2=nil;
    self.txt_GoldText_Gold=nil;
    self.img_HeadImage_Head1030=nil;
    self.txt_PlayerName_palyer_3=nil;
    self.txt_GoldText_Gold653=nil;
    self.img_HeadImage_Head7306=nil;
    self.txt_PlayerName_palyer4=nil;
    self.txt_GoldText_Gold9661=nil;
    self.img_HeadImage_Head309=nil;
    self.txt_PlayerName_palyer5=nil;
    self.txt_GoldText_Gold2579=nil;
    self.img_HeadImage_Head6278=nil;
    self.txt_PlayerName_palyer6=nil;
    self.txt_GoldText_Gold7582=nil;
    self.obj_ChipPool=nil;
    self.obj_SelectArea=nil;
    self.obj_DiceBox_Big=nil;
    self.img_BigDice1=nil;
    self.img_BigDice2=nil;
    self.img_BigDice3=nil;
    self.obj_Lid=nil;
    self.obj_DiceBox_Mini=nil;
    self.img_MiniDice1=nil;
    self.img_MiniDice2=nil;
    self.img_MiniDice3=nil;
    self.obj_Lid_obj_DiceBox_Mini=nil;
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

