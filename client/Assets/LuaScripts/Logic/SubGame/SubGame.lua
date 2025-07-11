local loadGameAssets=require "Logic/SubGame/LoadGameAssets"

---游戏子游戏基类
---@class subGame
SubGame=Class("SubGame")

SubGame.EventName={
    LoadError="SubGame.LoadError",
    LoadProgress="SubGame.LoadProgress",
    LoadFinished="SubGame.LoadFinished",
}

function SubGame:ctor(gameName,param)
    self.gameName=gameName;--游戏名字
    self.enterParam=param;--游戏进入参数
    self.secondUICtrlName=CtrlNames.UICommonSelection or "";--游戏二级界面名称
    self.isLoadAllAssets=nil;--是否进入游戏时加载所有资源
    self.isLoadAsync=nil;--异步加载游戏资源
    self.gameLoadingLuaPath=nil;--游戏加载界面代码路径
    self.gameLoadingPanelPath=nil;--游戏加载界面Panel路径
    self.enterGame=nil;--是否进入了游戏
    
    self.isRelease=true;--退出游戏是否释放资源

    ----进入和离开提交参数
    self.gameType=nil; --游戏类型
    self.wareHouseList={}
    self.wareId=param.wareId or 1;--游戏场次，玩家选择进入的场次
    
    self:AddListener();
end

---打开游戏
---@param gameType number 游戏类型
function SubGame:Open(gameType,wareHouseList)
    self.gameType=gameType;
    self.wareHouseList=wareHouseList
    if not AppConst.DebugMode then
        local isFinished=resMgr:CreateGameAssetMap(self.gameName);
        if not isFinished then
            return false;
        end
    end
    self:Init()
    if not self.enterGame then
        if not self:EnterSecondUI() then
            self:SendEnterRoom();
        end
    end
    return true;
end

function SubGame:Init()
    
end

---进入游戏二级界面
function SubGame:EnterSecondUI()
    self.enterGame=false;
    ---打开二级界面
    if self.secondUICtrlName~=nil and self.secondUICtrlName~="" then
        CtrlManager.SingleShow(self.secondUICtrlName,{subGame=self})
        return true;
    end
    return false;
end

---加载游戏
function SubGame:LoadGame()
    DG.Tweening.DOTween.KillAll(false);
    CorManager.StartCor(self, function
    ()
        coroutine.wait(0.05)
        ----关闭所有界面
        CtrlManager.AllCtrlClose();
        ---判断打开游戏加载界面
        if self.gameLoadingLuaPath~=nil then
            self.gameLoading=require(self.gameLoadingLuaPath).New(self.gameLoadingPanelPath);
        end
        if self.isLoadAllAssets then
            loadGameAssets.LoadGameAssets(
                    self.gameName,
                    self.isLoadAsync,
                    Handler(self,self.LoadProgress),
                    Handler(self,self.LoadFinished),
                    Handler(self,self.LoadError));
        else
            self:EnterGame();
        end
    end)
end

---进入游戏
function SubGame:EnterGame()
    self:SendLoadGameFinished();
    self.enterGame=true;
end

---游戏加载错误回调
function SubGame:LoadError()
    GlobalEvent.Notify(SubGame.EventName.LoadError);
    ---关闭游戏
    GameCenter.CloseCurGame(self.isRelease);
end

---游戏加载进度回调
---@param value number 加载进度
function SubGame:LoadProgress(value)
    GlobalEvent.Notify(SubGame.EventName.LoadProgress,value);
end

---游戏加载完成回调
function SubGame:LoadFinished()
    log("游戏加载完成");
    self:EnterGame();
end

function SubGame:AddListener()
    WebNetEvent.AddListener(pb_PlatformHall.ResChooseWare,self.ResChooseWare,self);
end

---通知服务器要进入游戏
---@param wareId number 游戏场次，默认为1
function SubGame:SendEnterRoom(wareId)
    self.wareId=wareId or 1;
    local data={}
    data.gameType=self.gameType;
    data.wareId=self.wareId;
    look("发送进入游戏数据",data)
    WebNetworkManager.SendMsg(pb_PlatformHall.ReqChooseWare,data)
end

---请求进入游戏返回
function SubGame:ResChooseWare(msg)
    look("请求进入场次游戏返回",msg)
    self:LoadGame();
end

---通知服务器加载游戏完成
function SubGame:SendLoadGameFinished()
    ---初始化游戏超时计时器
    self.initGameTimer=TimerManager.StartTimer(self,function ()
        self:LoadGameFinishedResultMsg()
    end,1,20);
end

function SubGame:LoadGameFinishedResultMsg(info)
    ---判断关闭游戏加载界面
    if self.gameLoading~=nil then
        self.gameLoading:Close();
        self.gameLoading=nil;
    end
    if self.initGameTimer~=nil then
        self.initGameTimer:Stop();
        self.initGameTimer=nil;
    end
    GlobalEvent.Notify(SubGame.EventName.LoadFinished);
end

---发送离开房间消息
function SubGame:SendLeaveGame()
    logError("发送至服务器退出游戏，服务器暂未有借口后期修改")
    self:LeaveGame()
end


---离开游戏
function SubGame:LeaveGame()
    DG.Tweening.DOTween.KillAll(false);
    CorManager.DelayInvoke(self,0.05,function ()
        if MainStateCtrl.curState~=MainStateCtrl.State.Game then
            return;
        end
        --CtrlManager.AllCtrlClose()
        GameCenter.CloseCurGame();
    end)
end

---关闭游戏
---@param isRelease boolean 是否释放资源
function SubGame:Close(isRelease)
    WebNetEvent.RemoveAllTo(self);
    self.enterGame=false;
    if not AppConst.DebugMode then
        resMgr:UnloadGameAssetMap(self.gameName,isRelease);
    end
end
