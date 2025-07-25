---游戏资源加载
---@class LoadGameAssets
local LoadGameAssets=Class("LoadGameAssets")
local this=LoadGameAssets
local maxCorCount=8; --最大加载协程数
local fileList;--要加载的文件列表
local progressFunc;--加载进度回调
local loadFinishedFunc;--加载完成回调
local errorFunc;--加载错误回调
local maxFileCount=0;--加载的文件总数
local loadFinishedCount=0;--加载完成协程数量

local function Clear()
    fileList= { };
    loadFinishedCount=0;
    maxFileCount=0;
    progressFunc=nil;
    loadFinishedFunc=nil;
    errorFunc=nil;
end

--获取游戏根目录
local function GetGameRootPath(gameName)
    return AppConst.GameAssetLocalPath..string.lower(gameName).."/";
end

--获取资源文件列表
local function GetAssetFiles(gameName)
    local path=GetGameRootPath(gameName).."files.txt";
    local list=Util.GetFileTextList(path);
    local files={};
    if list==nil then
        return files;
    end
    local len=list.Length;
    if len==0 then
        return files;
    end

    for i=0,len-1 do
        local v=list[i];
        local file=string.split(v,'|')
        local pt=file[1];
        if pt then
            if string.match(pt,".unity3d") and not string.match(pt,"manifest.unity3d") then
                local arr={ loadCount=0,path=pt };
                table.insert(files,arr);
            end
        end
    end
    return files;
end

---加载错误调用
local function LoadError()
    if errorFunc~=nil then
        errorFunc();
    end
    CorManager.StopAll(this);
end

---加载完成调用，maxCorCount次加载完成后才是所有资源加载完成
local function LoadFinished()
    if AppConst.DebugMode then
        if loadFinishedFunc~=nil then
            loadFinishedFunc();
        end
        return;
    end

    loadFinishedCount=loadFinishedCount+1;
    if loadFinishedCount<maxCorCount then
        return;
    end
    if #fileList>0 then
        LoadError();
    else
        if loadFinishedFunc~=nil then
            loadFinishedFunc();
        end
    end
    Clear();
end

---加载进度调用
local function LoadProgressFunc()
    if progressFunc==nil or fileList==nil then
        return;
    end
    progressFunc(1-(#fileList/maxFileCount));
end

---
---加载所有游戏资源
---@param gameName string 游戏名字
---@param isAsync boolean 是否异加载
---@param progressCallback function 加载进度回调
---@param loadFinishedCallback function 加载完成回调
---@param errorCallback function 加载错误回调
function this.LoadGameAssets(gameName,isAsync,progressCallback,loadFinishedCallback, errorCallback)
    progressFunc=progressCallback;
    errorFunc=errorCallback;
    loadFinishedFunc=loadFinishedCallback;

    if AppConst.DebugMode then
        this.DebugLoad();
        return;
    end

    fileList=GetAssetFiles(gameName);
    if #fileList==0 then
        if errorCallback~=nil then
            errorCallback();
        end
        return;
    end


    maxFileCount=#fileList;

    local loadFunc;
    if isAsync then
        loadFunc=this.LoadAsync;
    else
        loadFunc=this.Load;
    end

    for _ = 1, maxCorCount do
        CorManager.StartCor(this,loadFunc);
    end
end

---同步加载
function this.Load()
    while #fileList>0 do
        local info=fileList[1];
        table.remove(fileList,1);
        info.loadCount=info.loadCount+1;
        local ab=resMgr:LoadBundle(info.path);
        if ab==nil then
            if info.loadCount>1 then
                LoadError();
                return;
            else
                table.insert(fileList,info);
            end
        else
            LoadProgressFunc();
        end
        coroutine.wait(0.02);
    end
    LoadFinished();
end

---异步加载
function this.LoadAsync()
    while #fileList>0 do
        local info=fileList[1];
        table.remove(fileList,1);
        info.loadCount=info.loadCount+1;
        local b=false;
        local err=false;
        resMgr:LoadBundleAsync(info.path,function (ab)
            if ab==nil then
                if info.loadCount>1 then
                    LoadError();
                    return;
                else
                    table.insert(fileList,info);
                end
                err=true;
            end
            b=true;
        end,false);
        while not b do
            coroutine.wait(0.02);
        end
        if not err then
            LoadProgressFunc();
        end
    end
    LoadFinished();
end

---调试模式下模拟加载
function this.DebugLoad()
    CorManager.StartCor(this,function ()
        for i = 1, 20 do
            coroutine.wait(0.03);
            if progressFunc~=nil then
                progressFunc(i/20)
            end
        end
        loadFinishedCount=maxCorCount;
        LoadFinished();
    end);
end

---停止加载
function this.StopLoad()
    CorManager.StopAll(this);
    Clear();
end

return this

