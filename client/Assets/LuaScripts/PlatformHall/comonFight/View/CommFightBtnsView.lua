---
---Create by Administrator
---DateTime: 2025-07-28 14:41:11
---
---@class CommFightBtnsView:BaseView
local CommFightBtnsView=Class("CommFightBtnsView",BaseView)

---初始化panel
function CommFightBtnsView:InitView()
	---@type CommFightBtnsCtrl
    self.ctrl=self.ctrl
	self:InitComponents()
end

---获取组件
function CommFightBtnsView:InitComponents()
    self.btn_recharge=ComponentUtilGet.Button(self.transform,"content/top/btn_recharge");
    self.btn_players=ComponentUtilGet.Button(self.transform,"content/bottom/btn_players");
    self.tmp_totalPlayerNum=ComponentUtilGet.Text(self.transform,"content/bottom/btn_players/tmp_total_player_num");
    self.btn_muen=ComponentUtilGet.GameObject(self.transform,"content/setting/btn_muen");
    self.btn_touch=ComponentUtilGet.Button(self.transform,"content/setting/btn_touch");
    self.btn_setting=ComponentUtilGet.Button(self.transform,"content/setting/mask/muen/btn_setting");
    self.btn_help=ComponentUtilGet.Button(self.transform,"content/setting/mask/muen/btn_help");
    self.btn_close=ComponentUtilGet.Button(self.transform,"content/setting/mask/muen/btn_close");
    self.dizhuNode = ComponentUtilGet.GameObject(self.transform,"content/bottom/nodes")
    self.dizhu=ComponentUtilGet.Transform(self.transform,"content/bottom/chouma/Viewport/Content");
    self.dizhuScrollRect=ComponentUtilGet.ScrollRect(self.transform,"content/bottom/chouma")
    self.btn_prev = ComponentUtilGet.Button(self.transform, "content/bottom/chouma/prev");
    self.btn_next = ComponentUtilGet.Button(self.transform, "content/bottom/chouma/next");
    self.img_prev = ComponentUtilGet.Image(self.btn_prev.transform,"img");
    self.img_next = ComponentUtilGet.Image(self.btn_next.transform,"img");
    self.selfPlayerRoot  = ComponentUtilGet.Transform(self.transform,"content/bottom/SelfHead")
    self.daojishiObj =ComponentUtilGet.GameObject(self.transform,"content/daojishi/effect_Common_daojishi/effect_Common_daojishi")
    self.muenRect=ComponentUtilGet.RectTransform(self.transform,"content/setting/mask/muen")
    self.ctrl:InitUI()
end

---清空组件
function CommFightBtnsView:ClearComponents()
    self.btn_recharge=nil;
    self.btn_muen=nil;
    self.btn_players=nil;
    self.tmp_totalPlayerNum=nil;
    self.btn_touch=nil;
    self.btn_setting=nil;
    self.btn_help=nil;
    self.btn_close=nil;
end

---初始化View数据
function CommFightBtnsView:InitPanelData(args)
	
end

---关闭界面
function CommFightBtnsView:Close()   
    self.super.Close(self);
end

return CommFightBtnsView

