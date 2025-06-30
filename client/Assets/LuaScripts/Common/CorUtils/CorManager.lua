---@class CorManager
CorManager = {}
local this = CorManager;
local m_allLuaClass={}

--延时调用
function this.DelayInvoke(luaClass,time,func,...)
    if luaClass.curCor==nil then
        luaClass.curCor={};
    end
    local cor;
    local arr={ ... }
    cor= coroutine.start(function ()
        coroutine.wait(time)
        func(arr);
        for i = 1, #luaClass.curCor do
            if cor==luaClass.curCor[i] then
                table.remove(luaClass.curCor,i);
            end
        end
        cor=nil;
    end)
    table.insert(luaClass.curCor,cor);
    return cor;
end

--重复延时调用
function this.RepeatInvoke(luaClass,time,c,func,...)
    if luaClass.curCor==nil then
        luaClass.curCor={};
    end
    if c==0 then
        c=268435455;
    end
    local cor;
    local arr={ ... }
    cor= coroutine.start(function ()
        for i = 1, c do
            coroutine.wait(time)
            func(arr);
        end
        for i = 1, #luaClass.curCor do
            if cor==luaClass.curCor[i] then
                table.remove(luaClass.curCor,i);
            end
        end
        cor=nil;
    end)
    table.insert(luaClass.curCor,cor);
    return cor;
end


function this.StartCor(luaClass,func,...)
    if luaClass.curCor==nil then
        luaClass.curCor={};
        table.insert(m_allLuaClass,luaClass)
    end
    local cor;
    local arr={ ... };
    cor=coroutine.start(function ()
        func(luaClass,arr);
        for i = 1, #luaClass.curCor do
            if cor==luaClass.curCor[i] then
                table.remove(luaClass.curCor,i);
            end
        end
        cor=nil;
    end)
    table.insert(luaClass.curCor,cor);
    return cor;
end

function this.StartCorNew(luaClass,func,...)
    if luaClass.curCor==nil then
        luaClass.curCor={};
        table.insert(m_allLuaClass,luaClass)
    end
    local cor;
    local arr={ ... };
    cor=coroutine.newStart(func,luaClass,...)
    table.insert(luaClass.curCor,cor);
    return cor;
end

function this.StopCor(luaClass,cor)
    if cor==nil then
        return;
    end
    if luaClass then
        for i = 1, #luaClass.curCor do
            if cor==luaClass.curCor[i] then
                coroutine.stop(cor);
                table.remove(luaClass.curCor,i);
            end
        end
    else
        coroutine.stop(cor);
    end
    cor=nil;
end

function this.StopAll(luaClass)
    if luaClass and luaClass.curCor then
        for k,v in pairs(luaClass.curCor) do
            if v~=nil then
                coroutine.stop(v)
            end
        end
        luaClass.curCor={};
    end
end

---停止当前behaviour上的所有协程
function this.StopAllCoroutines()
    coroutine.stopAllCor();
    for k,v in pairs(m_allLuaClass) do
        if v then
            v.curCor={}
        end
    end
end