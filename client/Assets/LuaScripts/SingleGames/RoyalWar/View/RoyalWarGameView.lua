---
---Create by Administrator
---DateTime: 2025-07-26 14:31:10
---
---@class RoyalWarGameView:BaseView
local RoyalWarGameView=Class("RoyalWarGameView",BaseView)

---初始化panel
function RoyalWarGameView:InitView()
	---@type RoyalWarGameCtrl
    self.ctrl=self.ctrl
	self:InitComponents()
end

---获取组件
function RoyalWarGameView:InitComponents()
    self.obj_BlackWinIcon=ComponentUtilGet.GameObject(self.transform,"content/BetBg/BlackRoot/obj_BlackWinIcon");
    self.tmp_BlackBetNum=ComponentUtilGet.TextMeshProUGUI(self.transform,"content/BetBg/BlackRoot/bg/tmp_BlackBetNum");
    self.rect_BlackBetRegion=ComponentUtilGet.RectTransform(self.transform,"content/BetBg/BlackRoot/rect_BlackBetRegion");
    self.obj_SelfBetBlack=ComponentUtilGet.GameObject(self.transform,"content/BetBg/BlackRoot/obj_SelfBetBlack");
    self.tmp_SelfBetBlackNum=ComponentUtilGet.TextMeshProUGUI(self.transform,"content/BetBg/BlackRoot/obj_SelfBetBlack/tmp_SelfBetBlackNum");
    self.btn_BetBlack=ComponentUtilGet.Button(self.transform,"content/BetBg/BlackRoot/btn_BetBlack");
    self.obj_RedWinIcon=ComponentUtilGet.GameObject(self.transform,"content/BetBg/RedRoot/obj_RedWinIcon");
    self.tmp_RedBetNum=ComponentUtilGet.TextMeshProUGUI(self.transform,"content/BetBg/RedRoot/bg/tmp_RedBetNum");
    self.rect_RedBetRegion=ComponentUtilGet.RectTransform(self.transform,"content/BetBg/RedRoot/rect_RedBetRegion");
    self.obj_SelfBetRed=ComponentUtilGet.GameObject(self.transform,"content/BetBg/RedRoot/obj_SelfBetRed");
    self.tmp_SelfBetRedNum=ComponentUtilGet.TextMeshProUGUI(self.transform,"content/BetBg/RedRoot/obj_SelfBetRed/tmp_SelfBetRedNum");
    self.btn_BetRed=ComponentUtilGet.Button(self.transform,"content/BetBg/RedRoot/btn_BetRed");
    self.obj_LuckyWinIcon=ComponentUtilGet.GameObject(self.transform,"content/BetBg/LuckyRoot/obj_LuckyWinIcon");
    self.tmp_LuckyBetNum=ComponentUtilGet.TextMeshProUGUI(self.transform,"content/BetBg/LuckyRoot/bg/tmp_LuckyBetNum");
    self.rect_LuckyBetRegion=ComponentUtilGet.RectTransform(self.transform,"content/BetBg/LuckyRoot/rect_LuckyBetRegion");
    self.obj_SelfBetLucky=ComponentUtilGet.GameObject(self.transform,"content/BetBg/LuckyRoot/obj_SelfBetLucky");
    self.tmp_SelfBetLuckyNum=ComponentUtilGet.TextMeshProUGUI(self.transform,"content/BetBg/LuckyRoot/obj_SelfBetLucky/tmp_SelfBetLuckyNum");
    self.btn_BetLucky=ComponentUtilGet.Button(self.transform,"content/BetBg/LuckyRoot/btn_BetLucky");
    self.obj_RoadRoot=ComponentUtilGet.GameObject(self.transform,"content/TopRoot/obj_RoadRoot");
    self.tmp_RedNum=ComponentUtilGet.TextMeshProUGUI(self.transform,"content/TopRoot/obj_RoadRoot/tmp_RedNum");
    self.tmp_BlackNum=ComponentUtilGet.TextMeshProUGUI(self.transform,"content/TopRoot/obj_RoadRoot/tmp_BlackNum");
    self.tmp_LuckyNum=ComponentUtilGet.TextMeshProUGUI(self.transform,"content/TopRoot/obj_RoadRoot/tmp_LuckyNum");
    self.tmp_RoundsNum=ComponentUtilGet.TextMeshProUGUI(self.transform,"content/TopRoot/obj_RoadRoot/tmp_RoundsNum");
    self.obj_ZhuPanContent=ComponentUtilGet.GameObject(self.transform,"content/TopRoot/obj_RoadRoot/ZhuPanScroll/Viewport/obj_ZhuPanContent");
    self.obj_DaLuContent=ComponentUtilGet.GameObject(self.transform,"content/TopRoot/obj_RoadRoot/DaLuScroll/Viewport/obj_DaLuContent");
    self.obj_DaluZiluContent=ComponentUtilGet.GameObject(self.transform,"content/TopRoot/obj_RoadRoot/DaluZiluScroll/Viewport/obj_DaluZiluContent");
    self.obj_XiaoLuContent=ComponentUtilGet.GameObject(self.transform,"content/TopRoot/obj_RoadRoot/XiaoLuScroll/Viewport/obj_XiaoLuContent");
    self.obj_YueYouLuContent=ComponentUtilGet.GameObject(self.transform,"content/TopRoot/obj_RoadRoot/YueYouLuScroll/Viewport/obj_YueYouLuContent");
    self.obj_CardTypeContent=ComponentUtilGet.GameObject(self.transform,"content/TopRoot/obj_RoadRoot/CardTypeScroll/Viewport/obj_CardTypeContent");
    self.ator_CardRoot=ComponentUtilGet.Animator(self.transform,"content/TopRoot/ator_CardRoot");
    self.obj_CardBg=ComponentUtilGet.GameObject(self.transform,"content/TopRoot/ator_CardRoot/obj_CardBg");
    self.img_RedCardOne=ComponentUtilGet.Image(self.transform,"content/TopRoot/ator_CardRoot/obj_CardBg/RedCardRoot/RedCardOne/img_RedCardOne");
    self.img_RedCardTwo=ComponentUtilGet.Image(self.transform,"content/TopRoot/ator_CardRoot/obj_CardBg/RedCardRoot/RedCardTwo/img_RedCardTwo");
    self.img_RedCardThree=ComponentUtilGet.Image(self.transform,"content/TopRoot/ator_CardRoot/obj_CardBg/RedCardRoot/RedCardThree/img_RedCardThree");
    self.img_RedResultBg=ComponentUtilGet.Image(self.transform,"content/TopRoot/ator_CardRoot/obj_CardBg/RedCardRoot/img_RedResultBg");
    self.img_RedResultNumber=ComponentUtilGet.Image(self.transform,"content/TopRoot/ator_CardRoot/obj_CardBg/RedCardRoot/img_RedResultBg/img_RedResultNumber");
    self.img_BlackCardOne=ComponentUtilGet.Image(self.transform,"content/TopRoot/ator_CardRoot/obj_CardBg/BlackCardRoot/BlackCardOne/img_BlackCardOne");
    self.img_BlackCardTwo=ComponentUtilGet.Image(self.transform,"content/TopRoot/ator_CardRoot/obj_CardBg/BlackCardRoot/BlackCardTwo/img_BlackCardTwo");
    self.img_BlackCardThree=ComponentUtilGet.Image(self.transform,"content/TopRoot/ator_CardRoot/obj_CardBg/BlackCardRoot/BlackCardThree/img_BlackCardThree");
    self.img_BlackResultBg=ComponentUtilGet.Image(self.transform,"content/TopRoot/ator_CardRoot/obj_CardBg/BlackCardRoot/img_BlackResultBg");
    self.img_BlackResultNumber=ComponentUtilGet.Image(self.transform,"content/TopRoot/ator_CardRoot/obj_CardBg/BlackCardRoot/img_BlackResultBg/img_BlackResultNumber");
    self.obj_WhoWin=ComponentUtilGet.GameObject(self.transform,"content/TopRoot/ator_CardRoot/obj_CardBg/obj_WhoWin");
    self.obj_RedWin=ComponentUtilGet.GameObject(self.transform,"content/TopRoot/ator_CardRoot/obj_CardBg/obj_WhoWin/obj_RedWin");
    self.obj_BlackWin=ComponentUtilGet.GameObject(self.transform,"content/TopRoot/ator_CardRoot/obj_CardBg/obj_WhoWin/obj_BlackWin");
    self.obj_Countdown=ComponentUtilGet.GameObject(self.transform,"content/Process/obj_Countdown");
    self.txt_Countdown=ComponentUtilGet.Text(self.transform,"content/Process/obj_Countdown/txt_Countdown");
    self.obj_AboutEnd=ComponentUtilGet.GameObject(self.transform,"content/Process/obj_AboutEnd");
    self.obj_VS=ComponentUtilGet.GameObject(self.transform,"content/Process/obj_VS");
    self.obj_BeginBet=ComponentUtilGet.GameObject(self.transform,"content/Process/obj_BeginBet");
    self.obj_StopBet=ComponentUtilGet.GameObject(self.transform,"content/Process/obj_StopBet");
    self.obj_Settlement=ComponentUtilGet.GameObject(self.transform,"content/Process/obj_Settlement");
    self.obj_WaitEndGame=ComponentUtilGet.GameObject(self.transform,"content/Process/obj_WaitEndGame");
    self.txt_WaitCountDown=ComponentUtilGet.Text(self.transform,"content/Process/obj_WaitEndGame/naoZhong/txt_WaitCountDown");
    self.rect_ChipParent=ComponentUtilGet.RectTransform(self.transform,"content/rect_ChipParent");
    self.obj_ChipContent=ComponentUtilGet.GameObject(self.transform,"content/DownRoot/ChipScrollView/Viewport/obj_ChipContent");
    self.obj_chipItem=ComponentUtilGet.GameObject(self.transform,"content/DownRoot/obj_chipItem");
    self.btn_AllOther=ComponentUtilGet.Button(self.transform,"content/DownRoot/btn_AllOther");
    self.tmp_AllOtherNumber=ComponentUtilGet.TextMeshProUGUI(self.transform,"content/DownRoot/btn_AllOther/tmp_AllOtherNumber");
    self.btn_Repeat=ComponentUtilGet.Button(self.transform,"content/DownRoot/btn_Repeat");
    self.obj_Player=ComponentUtilGet.GameObject(self.transform,"content/DownRoot/obj_Player");
    self.img_SelfHeadPic=ComponentUtilGet.Image(self.transform,"content/DownRoot/obj_Player/SelfHead/img_SelfHeadPic");
    self.img_SelfHead=ComponentUtilGet.Image(self.transform,"content/DownRoot/obj_Player/SelfHead/img_SelfHeadPic/img_SelfHead");
    self.tmp_SelfGoldNumber=ComponentUtilGet.TextMeshProUGUI(self.transform,"content/DownRoot/obj_Player/SelfHead/Money/tmp_SelfGoldNumber");
    self.tmp_SelfName=ComponentUtilGet.TextMeshProUGUI(self.transform,"content/DownRoot/obj_Player/SelfHead/tmp_SelfName");
    self.btn_Chipleft=ComponentUtilGet.Button(self.transform,"content/DownRoot/Image/btn_Chipleft");
    self.btn_ChipRight=ComponentUtilGet.Button(self.transform,"content/DownRoot/Image (1)/btn_ChipRight");
    self.obj_PlayerRoot=ComponentUtilGet.GameObject(self.transform,"content/obj_PlayerRoot");
    self.btn_touch=ComponentUtilGet.Button(self.transform,"content/btn_touch");
    self.btn_Menu=ComponentUtilGet.Button(self.transform,"content/btn_Menu");
    self.obj_Menu=ComponentUtilGet.GameObject(self.transform,"content/mask/obj_Menu");
    self.btn_setting=ComponentUtilGet.Button(self.transform,"content/mask/obj_Menu/btn_setting");
    self.btn_help=ComponentUtilGet.Button(self.transform,"content/mask/obj_Menu/btn_help");
    self.btn_close=ComponentUtilGet.Button(self.transform,"content/mask/obj_Menu/btn_close");
    self.obj_UpWin=ComponentUtilGet.GameObject(self.transform,"content/obj_UpWin");
end

---清空组件
function RoyalWarGameView:ClearComponents()
    self.obj_BlackWinIcon=nil;
    self.tmp_BlackBetNum=nil;
    self.rect_BlackBetRegion=nil;
    self.obj_SelfBetBlack=nil;
    self.tmp_SelfBetBlackNum=nil;
    self.btn_BetBlack=nil;
    self.obj_RedWinIcon=nil;
    self.tmp_RedBetNum=nil;
    self.rect_RedBetRegion=nil;
    self.obj_SelfBetRed=nil;
    self.tmp_SelfBetRedNum=nil;
    self.btn_BetRed=nil;
    self.obj_LuckyWinIcon=nil;
    self.tmp_LuckyBetNum=nil;
    self.rect_LuckyBetRegion=nil;
    self.obj_SelfBetLucky=nil;
    self.tmp_SelfBetLuckyNum=nil;
    self.btn_BetLucky=nil;
    self.obj_RoadRoot=nil;
    self.tmp_RedNum=nil;
    self.tmp_BlackNum=nil;
    self.tmp_LuckyNum=nil;
    self.tmp_RoundsNum=nil;
    self.obj_ZhuPanContent=nil;
    self.obj_DaLuContent=nil;
    self.obj_DaluZiluContent=nil;
    self.obj_XiaoLuContent=nil;
    self.obj_YueYouLuContent=nil;
    self.obj_CardTypeContent=nil;
    self.ator_CardRoot=nil;
    self.obj_CardBg=nil;
    self.img_RedCardOne=nil;
    self.img_RedCardTwo=nil;
    self.img_RedCardThree=nil;
    self.img_RedResultBg=nil;
    self.img_RedResultNumber=nil;
    self.img_BlackCardOne=nil;
    self.img_BlackCardTwo=nil;
    self.img_BlackCardThree=nil;
    self.img_BlackResultBg=nil;
    self.img_BlackResultNumber=nil;
    self.obj_WhoWin=nil;
    self.obj_RedWin=nil;
    self.obj_BlackWin=nil;
    self.obj_Countdown=nil;
    self.txt_Countdown=nil;
    self.obj_AboutEnd=nil;
    self.obj_VS=nil;
    self.obj_BeginBet=nil;
    self.obj_StopBet=nil;
    self.obj_Settlement=nil;
    self.obj_WaitEndGame=nil;
    self.txt_WaitCountDown=nil;
    self.rect_ChipParent=nil;
    self.obj_ChipContent=nil;
    self.obj_chipItem=nil;
    self.btn_AllOther=nil;
    self.tmp_AllOtherNumber=nil;
    self.btn_Repeat=nil;
    self.obj_Player=nil;
    self.img_SelfHeadPic=nil;
    self.img_SelfHead=nil;
    self.tmp_SelfGoldNumber=nil;
    self.tmp_SelfName=nil;
    self.btn_Chipleft=nil;
    self.btn_ChipRight=nil;
    self.obj_PlayerRoot=nil;
    self.btn_touch=nil;
    self.btn_Menu=nil;
    self.obj_Menu=nil;
    self.btn_setting=nil;
    self.btn_help=nil;
    self.btn_close=nil;
    self.obj_UpWin=nil;
end

---初始化View数据
function RoyalWarGameView:InitPanelData(args)
	
end

---关闭界面
function RoyalWarGameView:Close()   
    self.super.Close(self);
end

return RoyalWarGameView

