---
---Create by Administrator
---DateTime: 2025-07-18 15:45:49
---
---@class FishPrawnCrabHelpView:BaseView
local FishPrawnCrabHelpView=Class("FishPrawnCrabHelpView",BaseView)

---初始化panel
function FishPrawnCrabHelpView:InitView()
	---@type FishPrawnCrabHelpCtrl
    self.ctrl=self.ctrl
	self:InitComponents()
end

---获取组件
function FishPrawnCrabHelpView:InitComponents()
    self.img_title=ComponentUtilGet.Image(self.transform,"content/BackGround/img_title");
    self.btn_close=ComponentUtilGet.Button(self.transform,"content/BackGround/btn_close");
end

---清空组件
function FishPrawnCrabHelpView:ClearComponents()
    self.img_title=nil;
    self.btn_close=nil;
end

---初始化View数据
function FishPrawnCrabHelpView:InitPanelData(args)
	
end

---关闭界面
function FishPrawnCrabHelpView:Close()   
    self.super.Close(self);
end

return FishPrawnCrabHelpView

