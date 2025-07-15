---
---Create by Administrator
---DateTime: 2025-06-26 11:27:13
---
---@class UIHallGamesView:BaseView
local UIHallGamesView=Class("UIHallGamesView",BaseView)
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
        self.itemInfos[i]=info;
    end

    self.iconListview=ComponentUtilGet.ScrollRect(self.transform,"content/middle/ScrollView");
end

---清空组件
function UIHallGamesView:ClearComponents()

end

---初始化View数据
function UIHallGamesView:InitPanelData(args)
    for i = 1, #self.itemInfos do
        local objInfo=self.itemInfos[i];
        local gameName=GameSortID[i];
        local obj_state;
        local gameState;
        if not gameName then
            obj_state=self:LoadStateObj("notOpen",objInfo.transform);
            gameState=GameState.NotOpen;
        else
            --获取对应的游戏状态
            gameState=GameCenter.CheckGameState(gameName);
        end
        objInfo.gameName=gameName or tostring(i);
        self:ChangeStateObjInfo(gameName,gameState,objInfo);
        ---当前游戏是否在更新中
        if gameState==GameState.Updating then
            local cur,total=UpdateGameAssets.GetCurUpdateProgress();
            self:SetUpdateProgress(gameName,cur,total);
        end
    end

    if iconViewPos~=0 then
        self.iconListview.horizontalNormalizedPosition=iconViewPos;
    end
end
---创建状态对象
function UIHallGamesView:LoadStateObj(name,parent)
    return resMgr:CreateGameObject("PlatformHall/GameState/prefabs",name,parent);
end

---设置更新进度
function UIHallGamesView:SetUpdateProgress(gameName,cur,total)
    if self.curUpdateObjInfo==nil then
        self.curUpdateObjInfo=self:GetStateObjInfoByGameName(gameName)
    end

    if self.curUpdateObjInfo==nil then return end

    if self.curUpdateObjInfo.gameState~=GameState.Updating then
        self:ChangeStateObjInfo(gameName,GameState.Updating);
    end

    if self.lerpCor~=nil then
        self.curUpdateValue=self.tempUpdateValue;
        CorManager.StopCor(self,self.lerpCor);
    end
    local time=Time.time;
    self.lerpCor=CorManager.StartCor(self,function ()
        while true do
            local dt=Time.time-time;
            if dt>=0.5 then
                break;
            end
            self.tempUpdateValue=Tools.Lerp(self.curUpdateValue,cur,dt/0.5);
            local value=self.tempUpdateValue/total;
            self.curUpdateObjInfo.txt_pro.text=math.ceil(value*100).."%";
            self.curUpdateObjInfo.sil.value=value;
            coroutine.wait(0.03);
        end
        local value=cur/total;
        self.curUpdateObjInfo.txt_pro.text=math.ceil(value*100).."%";
        self.curUpdateObjInfo.sil.value=value;
        self.tempUpdateValue=cur;
        self.curUpdateValue=cur;
        self.lerpCor=nil;
    end)
end

---更新完成
function UIHallGamesView:UpdateFinished(gameName)
    self:ChangeStateObjInfo(gameName,GameState.Normal);
    if self.lerpCor~=nil then
        CorManager.StopCor(self,self.lerpCor);
    end
    self.curUpdateObjInfo=nil;
    self.curUpdateValue=0
    self.tempUpdateValue=0;
end
---更新错误
function UIHallGamesView:UpdateError(gameName)
    self:ChangeStateObjInfo(gameName,GameState.Update);
    self.curUpdateValue=0
    self.tempUpdateValue=0;
end
---等待更新
function UIHallGamesView:WaitUpdate(gameName)
    self:ChangeStateObjInfo(gameName,GameState.WaitUpdate);
end
---取消等待更新
function UIHallGamesView:CancelWaitUpdate(gameName)
    self:ChangeStateObjInfo(gameName,GameState.Update);
end
---获取状态对象信息
function UIHallGamesView:GetStateObjInfoByGameName(gameName)
    ---设置游戏状态
    for i = 1, #self.itemInfos do
        local objInfo=self.itemInfos[i];
        if objInfo.gameName==gameName then
            return objInfo;
        end
    end
end

---切换游戏状态信息
function UIHallGamesView:ChangeStateObjInfo(gameName,gameState,objInfo)
    objInfo=objInfo or self:GetStateObjInfoByGameName(gameName);
    if objInfo==nil then return end
    if gameState~=GameState.Normal then
        local stateName;
        local parent;
        if gameState==GameState.WaitUpdate then
            stateName="waitUpdate"
            parent=objInfo.t_point;
        elseif gameState==GameState.NotOpen or
                gameState==GameState.Maintenance or
                gameState==GameState.Error then
            stateName="notOpen"
            parent=objInfo.transform;
        elseif gameState==GameState.Update then
            stateName="update"
            parent=objInfo.t_point;
        elseif gameState==GameState.Updating then
            stateName="download"
            parent=objInfo.t_point;
        end

        if not isnull(objInfo.obj_state) then
            Tools.Destroy(objInfo.obj_state);
        end
        local obj_state;
        if stateName then
            obj_state=self:LoadStateObj(stateName,parent);
            --如果是更新状态则获取对应的组件
            if gameState==GameState.Updating then
                objInfo.txt_pro=ComponentUtilGet.TextMeshProUGUI(obj_state.transform,"tmp_pro")
                objInfo.sil=ComponentUtilGet.Slider(obj_state.transform,"slider")
            end
        end
        objInfo.obj_state=obj_state;
    else
        if not isnull(objInfo.obj_state) then
            Tools.Destroy(objInfo.obj_state);
        end
    end
    objInfo.gameState=gameState;
end
---关闭界面
function UIHallGamesView:Close()
    CorManager.StopAll(self);
    iconViewPos=self.iconListview.horizontalNormalizedPosition;
    self.lerpCor=nil;
    self.curUpdateValue=nil;
    self.tempUpdateValue=nil;
    self.super.Close(self);
end

return UIHallGamesView

