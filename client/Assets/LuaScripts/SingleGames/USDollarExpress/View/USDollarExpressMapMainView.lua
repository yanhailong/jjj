---
---Create by Administrator
---DateTime: 2025-07-23 15:35:06
---
---@class USDollarExpressMapMainView:BaseView
local USDollarExpressMapMainView=Class("USDollarExpressMapMainView",BaseView)

---初始化panel
function USDollarExpressMapMainView:InitView()
	---@type USDollarExpressMapMainCtrl
    self.ctrl=self.ctrl
	self:InitComponents()
end

---获取组件
function USDollarExpressMapMainView:InitComponents()
    self.maps={}
    for i = 1, 8 do
        local obj =ComponentUtilGet.GameObject(self.transform,"content/draks/map"..i)
        local map={}
        map.obj=obj
        map.img=ComponentUtilGet.Image(obj.transform)
        map.img.alphaHitTestMinimumThreshold=0.1
        map.objSelect=ComponentUtilGet.GameObject(obj.transform,"redCircle")
        map.objSelect:SetActive(false)
        map.obj:SetActive(false)
        self.maps[i]=map
    end
end

---清空组件
function USDollarExpressMapMainView:ClearComponents()

end

---初始化View数据
function USDollarExpressMapMainView:InitPanelData(args)
	
end

---关闭界面
function USDollarExpressMapMainView:Close()   
    self.super.Close(self);
end

return USDollarExpressMapMainView

