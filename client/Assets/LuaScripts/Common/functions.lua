---日志相关--------------------------
local function getLogDate()
    return os.date('%m-%d %H:%M:%S') .. " "
end

local function getDebugTraceback(traceback)
    return "\n" .. traceback .. "\n<color=#99ffff>---------------------------------------------------</color>"
end
--输出日志--
function log(param)
    if not IsShowLog then
        return
    end
    local traceback = debug.traceback() or ""
    local date = getLogDate();
    --local date = Util.GetDateTime('MM-dd HH:mm:ss.fff')
    --local date =  Util.TimeStampToString(ServerTimeSync:GetTimeStamp(),'MM-dd HH:mm:ss.fff')
    if param == nil then
        CS.UnityEngine.Debug.LogError(date .. "nil" .. getDebugTraceback(traceback));
        return ;
    end
    local t = type(param);
    if t == "string" then
        CS.UnityEngine.Debug.Log(date .. param .. getDebugTraceback(traceback));
    elseif t == "table" then
        CS.UnityEngine.Debug.Log(date .. tableTostring(param) .. getDebugTraceback(traceback));
    else
        CS.UnityEngine.Debug.Log(date .. tostring(param) .. getDebugTraceback(traceback));
    end
end

--错误日志--
function logError(param)
    if not IsShowLog then
        return
    end
    local traceback = debug.traceback() or ""
    local date = getLogDate();
    if param == nil then
        Util.LogError(date .. "nil" .. getDebugTraceback(traceback));
        return ;
    end
    local t = type(param);
    if t == "string" then
        CS.UnityEngine.Debug.LogError(date .. param .. getDebugTraceback(traceback));
    elseif t == "table" then
        CS.UnityEngine.Debug.LogError(date .. tableTostring(param) .. getDebugTraceback(traceback));
    else
        CS.UnityEngine.Debug.LogError(date .. tostring(param) .. getDebugTraceback(traceback));
    end
end

--警告日志--
function logWarn(param)
    if not IsShowLog then
        return
    end
    local traceback = debug.traceback() or ""
    local date = getLogDate();
    if param == nil then
        CS.UnityEngine.Debug.LogError(date .. "nil" .. getDebugTraceback(traceback));
        return ;
    end
    local t = type(param);
    if t == "string" then
        CS.UnityEngine.Debug.LogWarning(date .. param .. getDebugTraceback(traceback));
    elseif t == "table" then
        CS.UnityEngine.Debug.LogWarning(date .. tableTostring(param) .. getDebugTraceback(traceback));
    else
        CS.UnityEngine.Debug.LogWarning(date .. tostring(param) .. getDebugTraceback(traceback));
    end
end

function look(...)
    if not IsShowLog then
        return
    end
    -- 用来记录循环嵌套表的值
    local allTables = { }
    local function internal(tab, str, i, space)
        space = space or ""
        if allTables[tab] or tab._listener_for_children then
            str = str .. space .. tostring(tab) .. ",\n"
            return str
        else
            allTables[tab] = true
        end
        for k, v in pairs(tab) do
            if type(v) == "table" then
                str = str .. space .. "[" .. tostring(k) .. "] = \n" .. space .. "{\n"
                -- 如果递归的层数到达9次，就显示内存地址
                if i <= 100 then
                    str = internal(v, str, i + 1, space .. "    ")
                else
                    str = str .. tostring(v)
                end
                str = str .. space .. "},\n"
            else
                str = str .. space .. "[" .. tostring(k) .. "] = " .. tostring(v) .. ",\n"
            end
        end
        return str
    end
    local str = ""
    local t = ...
    if t then
        t = { ... }
        if type(t) ~= "table" then
            str = tostring(t)
        else
            str = internal(t, str, 1)
        end
        local msg = debug.traceback("", 2)
        str = str .. "\n" .. msg
        log("\n" .. str);
    end
end
---日志相关--------------------------


function Destroy(obj)
    GameObject.Destroy(obj);
end

function DestroyImmediate(obj)
    GameObject.DestroyImmediate(obj)
end

function NewObject(prefab)
    return GameObject.Instantiate(prefab);
end

function Handler(nowSelf, func)
    return function(...)
        return func(nowSelf, ...)
    end
end
local unpack = unpack or table.unpack

-- 解决原生pack的nil截断问题，SafePack与SafeUnpack要成对使用
function SafePack(...)
	local params = {...}
	params.n = select('#', ...) --返回可变参数的数量,赋值给n
	return params
end

-- 解决原生unpack的nil截断问题，SafePack与SafeUnpack要成对使用
function SafeUnpack(safe_pack_tb)
	return unpack(safe_pack_tb, 1, safe_pack_tb.n)
end

local json = require "xLua/json/json"
function jsonDecode(jsonStr)
    return json.decode(jsonStr)
end
function jsonEncode(obj)
    return json.encode(obj)
end

-- 判断Unity物体是否为空 暂时的后边需要修改
function isnull(item)
    if not item then
        return true
    end
    return false
end






