---
---Create by Administrator
---DateTime: 2025-06-23 17:39:22
---
---@class UIHallView:BaseView
local UIHallView=Class("UIHallView",BaseView)

---初始化panel
function UIHallView:InitView()
	---@type UIHallCtrl
    self.ctrl=self.ctrl
	self:InitComponents()
end

---获取组件
function UIHallView:InitComponents()
    self.btn_USDollarExpress=ComponentUtilGet.Button(self.transform,"content/middle/Scroll View/Viewport/Content/btn_USDollarExpress");
    self.btn_Baccarat=ComponentUtilGet.Button(self.transform,"content/middle/Scroll View/Viewport/Content/btn_Baccarat");
    self.btn_LongHuDou=ComponentUtilGet.Button(self.transform,"content/middle/Scroll View/Viewport/Content/gametest001")
    self.uTabs_title=ComponentUtilGet.UGUITabGroup(self.transform,"content/left/uTabs_title");
    self.btn_yqs=ComponentUtilGet.Button(self.transform,"content/left/btn_yqs");
    self.img_head=ComponentUtilGet.Image(self.transform,"content/top/playerInfo/head/img_head");
    self.txt_vip=ComponentUtilGet.Text(self.transform,"content/top/playerInfo/vip/txt_vip");
    self.tmp_name=ComponentUtilGet.TextMeshProUGUI(self.transform,"content/top/playerInfo/tmp_name");
    self.img_vipfill=ComponentUtilGet.Image(self.transform,"content/top/playerInfo/bardi/img_vipfill");
    self.btn_gemAdd=ComponentUtilGet.Button(self.transform,"content/top/gem/btn_gemAdd");
    self.tmp_gemNum=ComponentUtilGet.TextMeshProUGUI(self.transform,"content/top/gem/tmp_gemNum");
    self.btn_coinAdd=ComponentUtilGet.Button(self.transform,"content/top/coin/btn_coinAdd");
    self.tmp_coinNum=ComponentUtilGet.TextMeshProUGUI(self.transform,"content/top/coin/tmp_coinNum");
    self.btn_first=ComponentUtilGet.Button(self.transform,"content/top/btn_first");
    self.btn_pig=ComponentUtilGet.Button(self.transform,"content/top/btn_pig");
    self.btn_vip=ComponentUtilGet.Button(self.transform,"content/top/btn_vip");
    self.btn_email=ComponentUtilGet.Button(self.transform,"content/top/btn_email");
    self.btn_set=ComponentUtilGet.Button(self.transform,"content/top/btn_set");
    self.btn_minigame=ComponentUtilGet.Button(self.transform,"content/top/btn_minigame");
    self.img_buttom_di=ComponentUtilGet.Image(self.transform,"content/buttom/img_buttom_di");
    self.btn_gift=ComponentUtilGet.Button(self.transform,"content/buttom/btn_gift");
    self.btn_shop=ComponentUtilGet.Button(self.transform,"content/buttom/btn_shop");
    self.btn_casino=ComponentUtilGet.Button(self.transform,"content/buttom/one/btn_casino");
    self.btn_ranking=ComponentUtilGet.Button(self.transform,"content/buttom/one/btn_ranking");
    self.btn_mission=ComponentUtilGet.Button(self.transform,"content/buttom/one/btn_mission");
    self.btn_treasure=ComponentUtilGet.Button(self.transform,"content/buttom/one/btn_treasure");
    self.btn_fund=ComponentUtilGet.Button(self.transform,"content/buttom/one/btn_fund");
    self.btn_safey=ComponentUtilGet.Button(self.transform,"content/buttom/one/btn_safey");
    self.btn_arrow=ComponentUtilGet.Button(self.transform,"content/buttom/one/btn_arrow");
    self.obj_two=ComponentUtilGet.GameObject(self.transform,"content/buttom/obj_two");
    self.btn_travel=ComponentUtilGet.Button(self.transform,"content/buttom/obj_two/btn_travel");
    self.btn_email_obj_two=ComponentUtilGet.Button(self.transform,"content/buttom/obj_two/btn_email");
    self.btn_service=ComponentUtilGet.Button(self.transform,"content/buttom/obj_two/btn_service");
end

---清空组件
function UIHallView:ClearComponents()
    self.btn_USDollarExpress=nil;
    self.btn_Baccarat=nil;
    self.btn_LongHuDou=nil;
    self.uTabs_title=nil;
    self.btn_yqs=nil;
    self.img_head=nil;
    self.txt_vip=nil;
    self.tmp_name=nil;
    self.img_vipfill=nil;
    self.btn_gemAdd=nil;
    self.tmp_gemNum=nil;
    self.btn_coinAdd=nil;
    self.tmp_coinNum=nil;
    self.btn_first=nil;
    self.btn_pig=nil;
    self.btn_vip=nil;
    self.btn_email=nil;
    self.btn_set=nil;
    self.btn_minigame=nil;
    self.img_buttom_di=nil;
    self.btn_gift=nil;
    self.btn_shop=nil;
    self.btn_casino=nil;
    self.btn_ranking=nil;
    self.btn_mission=nil;
    self.btn_treasure=nil;
    self.btn_fund=nil;
    self.btn_safey=nil;
    self.btn_arrow=nil;
    self.obj_two=nil;
    self.btn_travel=nil;
    self.btn_email_obj_two=nil;
    self.btn_service=nil;
end

---初始化View数据
function UIHallView:InitPanelData(args)
	
end

---关闭界面
function UIHallView:Close()   
    self.super.Close(self);
end

return UIHallView

