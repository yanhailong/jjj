require "Logic/SubGame/GameState"
require "Logic/SubGame/SubGame"
require "Logic/SubGame/UpdateGameAssets"
require "Logic/SubGame/UpdateGameEvent"
require "Logic/SubGame/GameLoading"
-----@type GameConnect
GameConnect= require ("Logic/SubGame/GameConnect").New()

---游戏控制中心
---@class GameCenter
GameCenter=Class("GameCenter")
local this=GameCenter
local game;
---当前运行游戏
---@type SubGame
local curGame;
---游戏对象创建函数
local gameCreatorFunc;
---当前游戏配置
local gameConfig;
---游戏场次信息
local wareHouseList;

---准备进入游戏
---@param gameName string 游戏名字
---@param param table 进入参数
---@param enterPreFunc function 进入游戏前回调
---@return number 当前游戏状态
function this.EnterGame(gameName,param,enterPreFunc)
    if gameName==nil then
        logError("游戏名为空")
        this.EnterGameErrorTips("进入游戏错误!")
        return GameState.Error;
    end
    param=param or {}
    local state=this.CheckGameState(gameName);
    --是否能正常进入游戏
    if state ~=GameState.Normal then
        this.GameStateTips(state,gameName,param.isReconnect);
        return state;
    end

    gameConfig=GameConfig[gameName];

    if gameConfig==nil then
        logError("GameConfig 里面没有对应游戏的配置:"..tostring(gameName))
        this.EnterGameErrorTips("进入游戏错误!")
        return GameState.Error;
    end

    ---可以正常进入游戏,进入游戏逻辑
    this.LoadGameLuaCode(string.lower(gameName));
    game=require(gameConfig.Manager);
    if game==nil then
        logError("游戏管理器为空")
        this.EnterGameErrorTips("进入游戏错误!")
        return GameState.Error;
    end
    
    if curGame then
        curGame:Close(true)
        curGame=nil
    end
    
    gameCreatorFunc=function()
        curGame=game.New(gameName,param);
        if enterPreFunc~=nil then
            enterPreFunc(curGame);
        end
        local success=curGame:Open(gameConfig.gameType,wareHouseList);
        if not success then
            this.EnterGameErrorTips("打开游戏错误!")
            curGame=nil;
            return;
        end
        MainStateCtrl.EnterGame();
    end
    GameConnect:ReqChooseGame(gameConfig.gameType)
    return GameState.Normal;
end




---收到服务器返回场次信息
function this.ResChooseGame(msg)
    wareHouseList=msg.wareHouseList;
    if curGame==nil then
        gameCreatorFunc();
        return;
    end
end



---游戏状态提示
---@param state GameState 游戏状态
---@param gameName string 游戏名称
function this.GameStateTips(state,gameName)
    if state==GameState.Error then
        this.EnterGameErrorTips("进入游戏错误!")
    elseif state ==GameState.NotOpen then
        this.EnterGameErrorTips("游戏暂未开放!")
    elseif state ==GameState.Maintenance then
        this.EnterGameErrorTips("游戏正在维护中!")
    elseif state ==GameState.Updating then
        this.EnterGameErrorTips("游戏正在更新中!")
    elseif state ==GameState.WaitUpdate then
        SuspensionTipsUtil.SuspensionTips(gameName.."游戏正在等待更新中....")
    elseif state ==GameState.Update then
        UpdateGameAssets.StartUpdate(gameName);
    end
end

---进入游戏错误提示
---@param msg string 提示信息
function this.EnterGameErrorTips(msg)
    SuspensionTipsUtil.SuspensionTips(msg);
end

---检测游戏状态
---@param gameName string 游戏名字
---@return GameState 游戏状态
function this.CheckGameState(gameName)
    if AppConst.DebugMode then
        return GameState.Normal;
    end
    ---游戏正在更新中
    if UpdateGameAssets.IsUpdate(gameName) then
        return GameState.Updating;
    end

    ---游戏正在等待更新
    if UpdateGameAssets.IsWaitUpdate(gameName) then
        return GameState.WaitUpdate;
    end

    local serverConfig=HallConfig.GetServerConfig();
    local localConfig=HallConfig.GetLocalConfig();
    ---获取服务器游戏配置
    local serverGameConfig=serverConfig.gameConfig[gameName];
    if serverGameConfig==nil then
        return GameState.NotOpen;
    end
    ---获取服务器游戏状态
    local serverState=serverGameConfig.state;

    ---游戏未开放
    if serverState==GameState.NotOpen then
        return GameState.NotOpen;
    end
    ---游戏维护中
    if serverState==GameState.Maintenance then
       return GameState.Maintenance;
    end

    ---没有本地游戏配置，需要更新游戏
    if localConfig.gameConfig==nil then
        return GameState.Update;
    end

    ---获取本地游戏配置
    local localGameConfig=localConfig.gameConfig[gameName];
    if localGameConfig==nil then
        return GameState.Update;
    end
    ---获取本地游戏版本
    local localVersion=localGameConfig.gameVersion or -1;
    local serverVersion=serverGameConfig.gameVersion or -1;
    if serverVersion==-1 then
        return GameState.Error;
    end
    if localVersion~=serverVersion then
        return GameState.Update;
    end
    return GameState.Normal;
end

---加载游戏lua代码
---@param gameName string 游戏名称
function this.LoadGameLuaCode(gameName)
    if not AppConst.DebugMode then
        local path=AppConst.GameAssetLocalPath..gameName.."/lua/lua.bytes";
        LuaBytes:LoadByPath(path,true,true);
    end
end

---离开游戏
function this.LeaveGame()
    if curGame==nil then
        return;
    end
    curGame:SendLeaveGame();
end

function this.LeaveGameResultMsg(msg)
    curGame:LeaveRoomResultMsg(msg)
end

---是否在游戏内
function this.IsInGame()
    return curGame~=nil;
end

---获取当前游戏名
function this.GetCurGameName()
    if not curGame then
        return nil;
    end
    return curGame.gameName;
end

---游戏更新
---@param gameName string 游戏名称
function this.UpdateGame(gameName)
    local state=this.CheckGameState(gameName);
    if state~=GameState.Update then
        logError("更新检测错误")
        return false;
    end
    UpdateGameAssets.StartUpdate(gameName);
end

---关闭当前游戏
---@param isForceRelease boolean 是否释放资源
---@param isNotReturn boolean 是否不返回上级见面
function this.CloseCurGame(isForceRelease)
    if curGame==nil then
        return;
    end
    logError("关闭游戏")
    curGame:Close(isForceRelease);
    curGame=nil;
    MainStateCtrl.EnterHall();
end
