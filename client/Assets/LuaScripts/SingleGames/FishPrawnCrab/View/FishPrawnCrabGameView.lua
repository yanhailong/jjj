---
---Create by Administrator
---DateTime: 2025-07-11 17:40:01
---
---@class FishPrawnCrabGameView:BaseView
local FishPrawnCrabGameView=Class("FishPrawnCrabGameView",BaseView)

---初始化panel
function FishPrawnCrabGameView:InitView()
	---@type FishPrawnCrabGameCtrl
    self.ctrl=self.ctrl
	self:InitComponents()
end

---获取组件
function FishPrawnCrabGameView:InitComponents()
    self.obj_PlayerRoot=ComponentUtilGet.GameObject(self.transform,"content/obj_PlayerRoot");
    self.img_GameRoundIndex=ComponentUtilGet.Image(self.transform,"content/TopRoot/img_GameRoundIndex");
    self.tmp_RoundIndex=ComponentUtilGet.TextMeshProUGUI(self.transform,"content/TopRoot/img_GameRoundIndex/tmp_RoundIndex");
    self.btn_Menu=ComponentUtilGet.Button(self.transform,"content/TopRoot/btn_Menu");
    self.btn_touch=ComponentUtilGet.Button(self.transform,"content/TopRoot/btn_touch");
    self.obj_Menu=ComponentUtilGet.GameObject(self.transform,"content/TopRoot/mask/obj_Menu");
    self.btn_setting=ComponentUtilGet.Button(self.transform,"content/TopRoot/mask/obj_Menu/btn_setting");
    self.btn_help=ComponentUtilGet.Button(self.transform,"content/TopRoot/mask/obj_Menu/btn_help");
    self.btn_close=ComponentUtilGet.Button(self.transform,"content/TopRoot/mask/obj_Menu/btn_close");
    self.btn_One=ComponentUtilGet.Button(self.transform,"content/DownRoot/BottomNote/btn_One");
    self.obj_checkedOne=ComponentUtilGet.GameObject(self.transform,"content/DownRoot/BottomNote/btn_One/obj_checkedOne");
    self.txt_One=ComponentUtilGet.Text(self.transform,"content/DownRoot/BottomNote/btn_One/txt_One");
    self.btn_Ten=ComponentUtilGet.Button(self.transform,"content/DownRoot/BottomNote/btn_Ten");
    self.obj_checkedTen=ComponentUtilGet.GameObject(self.transform,"content/DownRoot/BottomNote/btn_Ten/obj_checkedTen");
    self.txt_Ten=ComponentUtilGet.Text(self.transform,"content/DownRoot/BottomNote/btn_Ten/txt_Ten");
    self.btn_Fifty=ComponentUtilGet.Button(self.transform,"content/DownRoot/BottomNote/btn_Fifty");
    self.obj_checkedFifty=ComponentUtilGet.GameObject(self.transform,"content/DownRoot/BottomNote/btn_Fifty/obj_checkedFifty");
    self.txt_Fifty=ComponentUtilGet.Text(self.transform,"content/DownRoot/BottomNote/btn_Fifty/txt_Fifty");
    self.btn_OneHundred=ComponentUtilGet.Button(self.transform,"content/DownRoot/BottomNote/btn_OneHundred");
    self.obj_checkedOneHundred=ComponentUtilGet.GameObject(self.transform,"content/DownRoot/BottomNote/btn_OneHundred/obj_checkedOneHundred");
    self.txt_OneHundred=ComponentUtilGet.Text(self.transform,"content/DownRoot/BottomNote/btn_OneHundred/txt_OneHundred");
    self.btn_FiveHundred=ComponentUtilGet.Button(self.transform,"content/DownRoot/BottomNote/btn_FiveHundred");
    self.obj_checkedFiveHundred=ComponentUtilGet.GameObject(self.transform,"content/DownRoot/BottomNote/btn_FiveHundred/obj_checkedFiveHundred");
    self.txt_FiveHundred=ComponentUtilGet.Text(self.transform,"content/DownRoot/BottomNote/btn_FiveHundred/txt_FiveHundred");
    self.btn_AllOther=ComponentUtilGet.Button(self.transform,"content/DownRoot/btn_AllOther");
    self.tmp_AllOtherNumber=ComponentUtilGet.TextMeshProUGUI(self.transform,"content/DownRoot/btn_AllOther/tmp_AllOtherNumber");
    self.btn_Repeat=ComponentUtilGet.Button(self.transform,"content/DownRoot/btn_Repeat");
    self.obj_Player=ComponentUtilGet.GameObject(self.transform,"content/DownRoot/obj_Player");
    self.img_SelfHeadPic=ComponentUtilGet.Image(self.transform,"content/DownRoot/obj_Player/SelfHead/img_SelfHeadPic");
    self.img_SelfHead=ComponentUtilGet.Image(self.transform,"content/DownRoot/obj_Player/SelfHead/img_SelfHeadPic/img_SelfHead");
    self.tmp_SelfGoldNumber=ComponentUtilGet.TextMeshProUGUI(self.transform,"content/DownRoot/obj_Player/SelfHead/Money/tmp_SelfGoldNumber");
    self.tmp_SelfName=ComponentUtilGet.TextMeshProUGUI(self.transform,"content/DownRoot/obj_Player/SelfHead/tmp_SelfName");
end

---清空组件
function FishPrawnCrabGameView:ClearComponents()
    self.obj_PlayerRoot=nil;
    self.img_GameRoundIndex=nil;
    self.tmp_RoundIndex=nil;
    self.btn_Menu=nil;
    self.btn_touch=nil;
    self.obj_Menu=nil;
    self.btn_setting=nil;
    self.btn_help=nil;
    self.btn_close=nil;
    self.btn_One=nil;
    self.obj_checkedOne=nil;
    self.txt_One=nil;
    self.btn_Ten=nil;
    self.obj_checkedTen=nil;
    self.txt_Ten=nil;
    self.btn_Fifty=nil;
    self.obj_checkedFifty=nil;
    self.txt_Fifty=nil;
    self.btn_OneHundred=nil;
    self.obj_checkedOneHundred=nil;
    self.txt_OneHundred=nil;
    self.btn_FiveHundred=nil;
    self.obj_checkedFiveHundred=nil;
    self.txt_FiveHundred=nil;
    self.btn_AllOther=nil;
    self.tmp_AllOtherNumber=nil;
    self.btn_Repeat=nil;
    self.obj_Player=nil;
    self.img_SelfHeadPic=nil;
    self.img_SelfHead=nil;
    self.tmp_SelfGoldNumber=nil;
    self.tmp_SelfName=nil;
end

---初始化View数据
function FishPrawnCrabGameView:InitPanelData(args)
	
end

---关闭界面
function FishPrawnCrabGameView:Close()   
    self.super.Close(self);
end

return FishPrawnCrabGameView

