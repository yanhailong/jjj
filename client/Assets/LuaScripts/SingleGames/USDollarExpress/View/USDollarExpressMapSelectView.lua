---
---Create by Administrator
---DateTime: 2025-07-23 16:48:20
---
---@class USDollarExpressMapSelectView:BaseView
local USDollarExpressMapSelectView=Class("USDollarExpressMapSelectView",BaseView)

---初始化panel
function USDollarExpressMapSelectView:InitView()
	---@type USDollarExpressMapSelectCtrl
    self.ctrl=self.ctrl
	self:InitComponents()
    self:InitMaps()
end

---获取组件
function USDollarExpressMapSelectView:InitComponents()
    self.obj_des=ComponentUtilGet.GameObject(self.transform,"content/obj_des");
    self.txt_leftNum=ComponentUtilGet.Text(self.transform,"content/obj_des/txt_leftNum");
    self.obj_zhang=ComponentUtilGet.GameObject(self.transform,"content/obj_zhang");
    self.spine_zhang=ComponentUtilGet.SkeletonGraphic(self.transform,"content/obj_zhang/spine_zhang");
    self.efects=ComponentUtilGet.Transform(self.transform,"content/efects")
end

---清空组件
function USDollarExpressMapSelectView:ClearComponents()
    self.obj_des=nil;
    self.txt_leftNum=nil;
    self.obj_zhang=nil;
    self.spine_zhang=nil;
end

function USDollarExpressMapSelectView:InitMaps()
    self.allMaps={}
    for i = 1, 8 do
        local item={}
        item.cItem={}
        local obj=ComponentUtilGet.GameObject(self.transform,"content/map"..i)
        local childCount=obj.transform.childCount
        for i = 1, childCount do
            local cItem={}
            cItem.obj=ComponentUtilGet.GameObject(obj.transform,tostring(i))
            cItem.light=ComponentUtilGet.GameObject(cItem.obj.transform,"light")
            cItem.light:SetActive(false)
            cItem.img=ComponentUtilGet.Image(cItem.obj.transform)
            cItem.img.alphaHitTestMinimumThreshold=0.1
            item.cItem[i]=cItem
        end

        item.obj= obj
        self.allMaps[i]=item
        obj:SetActive(false)
    end
    
    self.redCirle={}
    for i = 1, 3 do
        self.redCirle[i]=ComponentUtilGet.GameObject(self.transform,"content/redCirle"..i)
        self.redCirle[i]:SetActive(false)
    end
    
    self.objWin=ComponentUtilGet.GameObject(self.transform,"content/obj_win")
    self.objWin:SetActive(false)
    self.txt_win=ComponentUtilGet.Text(self.objWin.transform,"txt_win")
    self.btn_collect=ComponentUtilGet.Button(self.objWin.transform,"btn_collect")
    
    ---topShow
    self.obj_des=ComponentUtilGet.GameObject(self.transform,"content/obj_des")
    self.obj_show=ComponentUtilGet.GameObject(self.transform,"content/obj_show")
    self.obj_goldTrain=ComponentUtilGet.GameObject(self.transform,"content/obj_goldTrain")
    self.txt_repeatWin=ComponentUtilGet.Text(self.transform,"content/obj_goldTrain/txt_repeatWin")
    self.txt_repeatWin.text=""
end

---设置top状态 state=1默认，2中奖，火车
function USDollarExpressMapSelectView:SetTopState(state)
    self.obj_des:SetActive(state==1)
    self.obj_show:SetActive(state==2)
    self.obj_goldTrain:SetActive(state==3)
end

function USDollarExpressMapSelectView:SetWinText(num)
    self.objWin:SetActive(true)
    local form=num*0.2
    self.textTw= Tools.NumJump(form,num,0.5, function
    (v1)
        self.txt_win.text=math.floor(v1)
    end, function
    ()
        self.txt_win.text=num
    end)

end

---初始化View数据
function USDollarExpressMapSelectView:InitPanelData(args)
	
end

---关闭界面
function USDollarExpressMapSelectView:Close()   
    self.super.Close(self);
    if self.textTw then
        self.textTw:Kill()
    end
end

return USDollarExpressMapSelectView

