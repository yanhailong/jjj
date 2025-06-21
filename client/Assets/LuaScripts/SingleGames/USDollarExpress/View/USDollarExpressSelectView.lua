---
---Create by Administrator
---DateTime: 2025-06-21 10:15:12
---
---@class USDollarExpressSelectView:BaseView
local USDollarExpressSelectView=Class("USDollarExpressSelectView",BaseView)

---初始化panel
function USDollarExpressSelectView:InitView()
	---@type USDollarExpressSelectCtrl
    self.ctrl=self.ctrl
	self:InitComponents()
    self:InitSelect()
end

---获取组件
function USDollarExpressSelectView:InitComponents()
    self.tmp_loading=ComponentUtilGet.TextMeshProUGUI(self.transform,"content/tmp_loading");
end

function USDollarExpressSelectView:InitSelect()
    self.selectItems={}
    for i = 1, 4 do
        local item={}
        item.obj=ComponentUtilGet.GameObject(self.transform,"content/obj/select"..i);
        item.obj:SetActive(false)
        item.txt_name=ComponentUtilGet.TextMeshProUGUI(item.obj.transform,"name");
        item.txt_value=ComponentUtilGet.TextMeshProUGUI(item.obj.transform,"value");
        self.selectItems[i]=item
    end
end


---清空组件
function USDollarExpressSelectView:ClearComponents()
    self.tmp_loading=nil;
end

---初始化View数据
function USDollarExpressSelectView:InitPanelData(args)
	
end

---关闭界面
function USDollarExpressSelectView:Close()   
    self.super.Close(self);
end

return USDollarExpressSelectView

