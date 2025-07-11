--- 游戏资源更新
---@class UpdateGameAssets
UpdateGameAssets=Class("UpdateGameAssets")
local this=UpdateGameAssets
local updateAssets;
local curGameName;
local curUpdateSize=0;---当前更新进度
local curUpdateTotalSize=1;---当前更新总进度
local isUpdate=false;--是否正在更新游戏

local updateGameList={};

function this.StartUpdate(gameName)
    if gameName==nil or gameName==curGameName or  this.IsWaitUpdate(gameName) then
        return;
    end
    if isUpdate then
        table.insert(updateGameList,gameName)
        this.WaitUpdate(gameName)
        return;
    end
    curGameName=gameName;
    isUpdate=true;
    local pathName=string.lower(gameName)
    local localPath=AppConst.AssetLocalPath;--游戏资源本地目录
    local url=AppConst.GameAssetUpdateUrl;--游戏服务器本地目录
    updateAssets=UpdateAssets(localPath,url,pathName);
    updateAssets:StartUpdate(this.UpdateError,this.UpdateProgress,this.UpdateFinished);
    this.UpdateProgress(0,1);
end

---更新下一个游戏
local function UpdateNextGame()
    if #updateGameList>0 then
        local name=updateGameList[1];
        table.remove(updateGameList,1);
        this.StartUpdate(name);
    end
end

---等待更新
function this.WaitUpdate(gameName)
    GlobalEvent.Notify(UpdateGameEvent.waitUpdate,gameName);
end

---取消等待更新
function this.CancelWaitUpdateGame(gameName)
    GlobalEvent.Notify(UpdateGameEvent.cancelWaitUpdate,gameName);
end

---更新错误回调
function this.UpdateError(state,msg)
    GlobalEvent.Notify(UpdateGameEvent.updateError,curGameName,state,msg);
    isUpdate=false;
    curGameName=nil;
    UpdateNextGame();
    logError("更新错误:"..tostring(msg));
end

---更新进度回调
function this.UpdateProgress(cur,total)
    curUpdateSize=cur;
    curUpdateTotalSize=total;
    GlobalEvent.Notify(UpdateGameEvent.updateProgress,curGameName,cur,total);
end

---更新完成回调
function this.UpdateFinished()
    HallConfig.SaveGameConfig(curGameName);
    local tempGameName=curGameName;
    isUpdate=false;
    curGameName=nil;
    curUpdateSize=0;
    curUpdateTotalSize=1;
    UpdateNextGame();
    GlobalEvent.Notify(UpdateGameEvent.updateFinished,tempGameName);
    if MainStateCtrl.curState==MainStateCtrl.State.Hall then
       SuspensionTipsUtil.SuspensionTips("游戏更新完成！");
    end
end

---是否是正在等待更新的游戏
---@param name string 游戏名
---@return boolean
function this.IsWaitUpdate(name)
    for _,v in ipairs(updateGameList) do
        if v==name then
            return true;
        end
    end
    return;
end

---游戏是否更新中
function this.IsUpdate(name)
    if name==nil then return false end
    return name==curGameName;
end

---获取正在更新的游戏列表
function this.GetWaitUpdateGameList()
    return updateGameList;
end

---取消游戏等待更新
function this.CancelWaitGame(name)
    if curGameName==name then
        return;
    end
    local index=0;
    for _,v in ipairs(updateGameList) do
        index=index+1;
        if v==name then
            break;
        end
    end
    if index==0 then return false end
    table.remove(updateGameList,index);
    this.CancelWaitUpdateGame(name);
    return true;
end

---获取当前更新的游戏名
function this.GetCurUpdateGameName()
    return curGameName;
end

---获取当前更新进度
function this.GetCurUpdateProgress()
    return curUpdateSize,curUpdateTotalSize;
end