---
---Create by Administrator
---DateTime: 2025-06-26 11:27:13
---
---@class UIHallGamesView:BaseView
local UIHallGamesView=Class("UIHallGamesView",BaseView)
local UIHallConfig=require("PlatformHall/UIHall/UIHallConfig")
local iconViewPos=0;
---初始化panel
function UIHallGamesView:InitView()
	---@type UIHallGamesCtrl
    self.ctrl=self.ctrl
	self:InitComponents()
end

---获取组件
function UIHallGamesView:InitComponents()
    self.curUpdateValue=0;
    self.tempUpdateValue=0;
    self.gameIconCount=8
    self.itemInfos={}
    for i = 1, self.gameIconCount do
        local info={};
        local t=ComponentUtilGet.Transform(self.transform,"content/middle/ScrollView/Viewport/Content/Item"..i);
        info.button=ComponentUtilGet.Button(self.transform);
        info.gameObject=t.gameObject;
        info.transform=t;
        info.t_point=ComponentUtilGet.Transform(t,"updateState");
        info.icon=ComponentUtilGet.Image(t);
        info.name=ComponentUtilGet.TextMeshProUGUI(t,"Text (TMP)");
        info.name.text=UIHallConfig.GAME_NAME[i]
        self.itemInfos[i]=info;
    end

    self.iconListview=ComponentUtilGet.ScrollRect(self.transform,"content/middle/ScrollView");
end

---清空组件
function UIHallGamesView:ClearComponents()

end

---初始化View数据
function UIHallGamesView:InitPanelData(args)
end


---关闭界面
function UIHallGamesView:Close()
    CorManager.StopAll(self);
    iconViewPos=self.iconListview.horizontalNormalizedPosition;
    self.lerpCor=nil;
    self.super.Close(self);
end

return UIHallGamesView

