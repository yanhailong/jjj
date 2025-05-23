---@class UpdateManager
UpdateManager={}
local this = UpdateManager
local m_updateList = {};
local m_fixedUpdateList = {};
local m_lateUpdateList = {};

function this.AddUpdate(luaClass,func)
    if luaClass.curUpdate==nil then
        luaClass.curUpdate={};
        luaClass.curUpdateIndex=0
        table.insert(m_updateList,luaClass)
    end
    if luaClass.curUpdate[luaClass.curUpdateIndex] and luaClass.curUpdate[luaClass.curUpdateIndex]==func then
        luaClass.curUpdate[luaClass.curUpdateIndex]=func
        return luaClass.curUpdateIndex
    end
    luaClass.curUpdateIndex=luaClass.curUpdateIndex+1
    luaClass.curUpdate[luaClass.curUpdateIndex]=func
    return luaClass.curUpdateIndex
end
function this.RemoveUpdate(luaClass,curUpdateIndex)
    if luaClass and luaClass.curUpdate then
        luaClass.curUpdate[curUpdateIndex]=nil
    end
end

function this.ReMoveAllUpdate(luaClass)
    if luaClass and luaClass.curUpdate then
        for k,v in pairs(luaClass.curUpdate) do
            if v~=nil then
                luaClass.curUpdate[k]=nil
            end
        end
    end
    luaClass.curUpdate={}
    luaClass.curUpdate=nil
    for k,v in pairs(m_updateList) do
        if v==luaClass then
            table.remove(m_updateList,k)
        end
    end
end

function this.AddFixedUpdate(luaClass,func)
    if luaClass.curFixedUpdate==nil then
        luaClass.curFixedUpdate={};
        luaClass.curFixedUpdateIndex=0
        table.insert(m_fixedUpdateList,luaClass)
    end
    if luaClass.curFixedUpdate[luaClass.curFixedUpdateIndex] and luaClass.curFixedUpdate[luaClass.curFixedUpdateIndex]==func then
        luaClass.curFixedUpdate[luaClass.curFixedUpdateIndex]=func
        return luaClass.curFixedUpdateIndex
    end
    luaClass.curFixedUpdateIndex=luaClass.curFixedUpdateIndex+1
    luaClass.curFixedUpdate[luaClass.curFixedUpdateIndex]=func
    return luaClass.curFixedUpdateIndex
end
function this.RemoveFixedUpdate(luaClass,curFixedUpdateIndex)
    if luaClass and luaClass.curFixedUpdate then
        luaClass.curFixedUpdate[curFixedUpdateIndex]=nil
    end
end

function this.ReMoveAllFixedUpdate(luaClass)
    if luaClass and luaClass.curFixedUpdate then
        for k,v in pairs(luaClass.curFixedUpdate) do
            if v~=nil then
                luaClass.curFixedUpdate[k]=nil
            end
        end
    end
    luaClass.curFixedUpdate={}
    luaClass.curFixedUpdate=nil
    for k,v in pairs(m_fixedUpdateList) do
        if v==luaClass then
            table.remove(m_fixedUpdateList,k)
        end
    end
end


function this.AddLateUpdate(luaClass,func)
    if luaClass.curLateUpdate==nil then
        luaClass.curLateUpdate={};
        luaClass.curcurLateUpdateIndex=0
        table.insert(m_lateUpdateList,luaClass)
    end
    if luaClass.curLateUpdate[luaClass.curcurLateUpdateIndex] and luaClass.curLateUpdate[luaClass.curcurLateUpdateIndex]==func then
        luaClass.curLateUpdate[luaClass.curcurLateUpdateIndex]=func
        return luaClass.curcurLateUpdateIndex
    end
    luaClass.curcurLateUpdateIndex=luaClass.curcurLateUpdateIndex+1
    luaClass.curLateUpdate[luaClass.curcurLateUpdateIndex]=func
    return luaClass.curcurLateUpdateIndex
end
function this.RemoveLateUpdate(luaClass,curcurLateUpdateIndex)
    if luaClass and luaClass.curLateUpdate then
        luaClass.curLateUpdate[curcurLateUpdateIndex]=nil
    end
end

function this.ReMoveAllLateUpdate(luaClass)
    if luaClass and luaClass.curLateUpdate then
        for k,v in pairs(luaClass.curLateUpdate) do
            if v~=nil then
                luaClass.curLateUpdate[k]=nil
            end
        end
    end
    luaClass.curLateUpdate={}
    luaClass.curLateUpdate=nil
    for k,v in pairs(m_lateUpdateList) do
        if v==luaClass then
            table.remove(m_lateUpdateList,k)
        end
    end
end


function Update()
    for i, v in pairs(m_updateList) do
        if v then
            for k,u in pairs(v.curUpdate) do
                if u then
                    u(v)
                end
            end
        end
    end
end

function FixedUpdate()
    for i, v in pairs(m_fixedUpdateList) do
        if v then
            for k,u in pairs(v.curFixedUpdate) do
                u(v)
            end
        end
    end
end

function LateUpdate()
     for i, v in pairs(m_lateUpdateList) do
        if v then
            for k,u in pairs(v.curLateUpdate) do
                u(v)
            end
        end
    end
end
---移除单个类的所有Update
function this.ReMoveAll(luaClass)
    this.ReMoveAllUpdate(luaClass)
    this.ReMoveAllFixedUpdate(luaClass)
    this.ReMoveAllLateUpdate(luaClass)
    collectgarbage("collect")--释放一下内存
end
---移除添加的所有update一般跨场景使用
function this.CloseAll()
    for i, v in pairs(m_updateList) do
        if v then
            this.ReMoveAllUpdate(v)
        end
    end
    for i, v in pairs(m_fixedUpdateList) do
        if v then
            this.ReMoveAllFixedUpdate(v)
        end
    end
    for i, v in pairs(m_lateUpdateList) do
        if v then
            this.ReMoveAllLateUpdate(v)
        end
    end
    m_updateList={}
    m_fixedUpdateList={}
    m_lateUpdateList={}
    collectgarbage("collect")--释放一下内存
end