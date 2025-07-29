---
---Create by Administrator
---DateTime: 2025-07-22 17:17:10
---
---@class DragonTigerSelectView:BaseView
local DragonTigerSelectView=Class("DragonTigerSelectView",BaseView)

---初始化panel
function DragonTigerSelectView:InitView()
    ---@type CarLogoSelectCtrl
    self.ctrl=self.ctrl
    self:InitComponents()
end

---获取组件
function DragonTigerSelectView:InitComponents()
    self.img_title=ComponentUtilGet.Image(self.transform,"BackGround/img_title");
    self.btn_coinAdd=ComponentUtilGet.Button(self.transform,"content/top/SelfHead/Money/btn_coinAdd");
    self.btn_close=ComponentUtilGet.Button(self.transform,"content/top/btn_close");
    self.GoldNumber=ComponentUtilGet.TextMeshProUGUI(self.transform,"content/top/SelfHead/Money/GoldNumber");
    self.img_head=ComponentUtilGet.Image(self.transform,"content/top/SelfHead/HeadPic/Head");
    self.img_kuang=ComponentUtilGet.Image(self.transform,"content/top/SelfHead/HeadPic");
end

---清空组件
function DragonTigerSelectView:ClearComponents()
    self.img_title=nil;
    self.btn_coinAdd=nil;
    self.btn_close=nil;
    self.GoldNumber=nil;
    self.img_head=nil;
    self.img_kuang=nil;
end

---初始化View数据
function DragonTigerSelectView:InitPanelData(args)

end

---关闭界面
function DragonTigerSelectView:Close()
    self.super.Close(self);
end

return DragonTigerSelectView

