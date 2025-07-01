---
---Create by Administrator
---DateTime: 2025-06-30 17:02:49
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
    self.btn_close=ComponentUtilGet.Button(self.transform,"content/btn_close");
    self.obj_BlackWinIcon=ComponentUtilGet.GameObject(self.transform,"content/BetBg/BlackRoot/obj_BlackWinIcon");
    self.tmp_BlackBetNum=ComponentUtilGet.TextMeshProUGUI(self.transform,"content/BetBg/BlackRoot/bg/tmp_BlackBetNum");
    self.obj_SelfBetBlack=ComponentUtilGet.GameObject(self.transform,"content/BetBg/BlackRoot/obj_SelfBetBlack");
    self.tmp_SelfBetBlackNum=ComponentUtilGet.TextMeshProUGUI(self.transform,"content/BetBg/BlackRoot/obj_SelfBetBlack/tmp_SelfBetBlackNum");
    self.btn_BetBlackOne=ComponentUtilGet.Button(self.transform,"content/BetBg/BlackRoot/btn_BetBlackOne");
    self.btn_BetBlackTwo = ComponentUtilGet.Button(self.transform,"content/BetBg/BlackRoot/btn_BetBlackTwo")
    self.obj_RedWinIcon=ComponentUtilGet.GameObject(self.transform,"content/BetBg/RedRoot/obj_RedWinIcon");
    self.tmp_RedBetNum=ComponentUtilGet.TextMeshProUGUI(self.transform,"content/BetBg/RedRoot/bg/tmp_RedBetNum");
    self.obj_SelfBetRed=ComponentUtilGet.GameObject(self.transform,"content/BetBg/RedRoot/obj_SelfBetRed");
    self.tmp_SelfBetRedNum=ComponentUtilGet.TextMeshProUGUI(self.transform,"content/BetBg/RedRoot/obj_SelfBetRed/tmp_SelfBetRedNum");
    self.btn_BetRedOne=ComponentUtilGet.Button(self.transform,"content/BetBg/RedRoot/btn_BetRedOne");
    self.btn_BetRedTwo=ComponentUtilGet.Button(self.transform,"content/BetBg/RedRoot/btn_BetRedTwo");
    self.obj_LuckyWinIcon=ComponentUtilGet.GameObject(self.transform,"content/BetBg/LuckyRoot/obj_LuckyWinIcon");
    self.tmp_LuckyBetNum=ComponentUtilGet.TextMeshProUGUI(self.transform,"content/BetBg/LuckyRoot/bg/tmp_LuckyBetNum");
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
    self.btn_One=ComponentUtilGet.Button(self.transform,"content/DownRoot/BottomNote/btn_One");
    self.obj_checkedOne=ComponentUtilGet.GameObject(self.transform,"content/DownRoot/BottomNote/btn_One/obj_checkedOne");
    self.tmp_One=ComponentUtilGet.TextMeshProUGUI(self.transform,"content/DownRoot/BottomNote/btn_One/tmp_One");
    self.btn_Ten=ComponentUtilGet.Button(self.transform,"content/DownRoot/BottomNote/btn_Ten");
    self.obj_checkedTen=ComponentUtilGet.GameObject(self.transform,"content/DownRoot/BottomNote/btn_Ten/obj_checkedTen");
    self.tmp_Ten=ComponentUtilGet.TextMeshProUGUI(self.transform,"content/DownRoot/BottomNote/btn_Ten/tmp_Ten");
    self.btn_Fifty=ComponentUtilGet.Button(self.transform,"content/DownRoot/BottomNote/btn_Fifty");
    self.obj_checkedFifty=ComponentUtilGet.GameObject(self.transform,"content/DownRoot/BottomNote/btn_Fifty/obj_checkedFifty");
    self.tmp_Fifty=ComponentUtilGet.TextMeshProUGUI(self.transform,"content/DownRoot/BottomNote/btn_Fifty/tmp_Fifty");
    self.btn_OneHundred=ComponentUtilGet.Button(self.transform,"content/DownRoot/BottomNote/btn_OneHundred");
    self.obj_checkedOneHundred=ComponentUtilGet.GameObject(self.transform,"content/DownRoot/BottomNote/btn_OneHundred/obj_checkedOneHundred");
    self.tmp_OneHundred=ComponentUtilGet.TextMeshProUGUI(self.transform,"content/DownRoot/BottomNote/btn_OneHundred/tmp_OneHundred");
    self.btn_FiveHundred=ComponentUtilGet.Button(self.transform,"content/DownRoot/BottomNote/btn_FiveHundred");
    self.obj_checkedFiveHundred=ComponentUtilGet.GameObject(self.transform,"content/DownRoot/BottomNote/btn_FiveHundred/obj_checkedFiveHundred");
    self.tmp_FiveHundred=ComponentUtilGet.TextMeshProUGUI(self.transform,"content/DownRoot/BottomNote/btn_FiveHundred/tmp_FiveHundred");
    self.obj_AllOther=ComponentUtilGet.GameObject(self.transform,"content/DownRoot/obj_AllOther");
    self.tmp_AllOtherNumber=ComponentUtilGet.TextMeshProUGUI(self.transform,"content/DownRoot/obj_AllOther/Image/tmp_AllOtherNumber");
    self.btn_Repeat=ComponentUtilGet.Button(self.transform,"content/DownRoot/btn_Repeat");
    self.obj_Player=ComponentUtilGet.GameObject(self.transform,"content/DownRoot/obj_Player");
    self.obj_Countdown=ComponentUtilGet.GameObject(self.transform,"content/Process/obj_Countdown");
    self.tmp_Countdown=ComponentUtilGet.TextMeshProUGUI(self.transform,"content/Process/obj_Countdown/tmp_Countdown");
    self.obj_VS=ComponentUtilGet.GameObject(self.transform,"content/Process/obj_VS");
    self.obj_BeginBet=ComponentUtilGet.GameObject(self.transform,"content/Process/obj_BeginBet");
    self.obj_StopBet=ComponentUtilGet.GameObject(self.transform,"content/Process/obj_StopBet");
    self.obj_Settlement=ComponentUtilGet.GameObject(self.transform,"content/Process/obj_Settlement");
    self.rect_ChipParent=ComponentUtilGet.RectTransform(self.transform,"content/rect_ChipParent");
end

---清空组件
function RoyalWarGameView:ClearComponents()
    self.btn_close=nil;
    self.obj_BlackWinIcon=nil;
    self.tmp_BlackBetNum=nil;
    self.obj_SelfBetBlack=nil;
    self.tmp_SelfBetBlackNum=nil;
    self.btn_BetBlackOne=nil;
    self.btn_BetBlackTwo=nil;
    self.obj_RedWinIcon=nil;
    self.tmp_RedBetNum=nil;
    self.obj_SelfBetRed=nil;
    self.tmp_SelfBetRedNum=nil;
    self.btn_BetRedOne=nil;
    self.btn_BetRedTwo=nil;
    self.obj_LuckyWinIcon=nil;
    self.tmp_LuckyBetNum=nil;
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
    self.btn_One=nil;
    self.obj_checkedOne=nil;
    self.tmp_One=nil;
    self.btn_Ten=nil;
    self.obj_checkedTen=nil;
    self.tmp_Ten=nil;
    self.btn_Fifty=nil;
    self.obj_checkedFifty=nil;
    self.tmp_Fifty=nil;
    self.btn_OneHundred=nil;
    self.obj_checkedOneHundred=nil;
    self.tmp_OneHundred=nil;
    self.btn_FiveHundred=nil;
    self.obj_checkedFiveHundred=nil;
    self.tmp_FiveHundred=nil;
    self.obj_AllOther=nil;
    self.tmp_AllOtherNumber=nil;
    self.btn_Repeat=nil;
    self.obj_Player=nil;
    self.obj_Countdown=nil;
    self.tmp_Countdown=nil;
    self.obj_VS=nil;
    self.obj_BeginBet=nil;
    self.obj_StopBet=nil;
    self.obj_Settlement=nil;
    self.rect_ChipParent=nil;
end

---初始化View数据
function RoyalWarGameView:InitPanelData(args)
	
end

---关闭界面
function RoyalWarGameView:Close()   
    self.super.Close(self);
end

return RoyalWarGameView

