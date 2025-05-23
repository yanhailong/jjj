-- table has the key= ele
function table.HasKey(table, ele)
    if table == nil then
        return false
    end
    for k, v in pairs(table) do
        if k == ele then
            return true
        end
    end
    return false
end
function table.contains(table, element)
    if table == nil then
        return false
    end

    for _, value in pairs(table) do
        if value == element then
            return true
        end
    end
    return false
end
---@param table table<any,any>
---@param func fun(k:any,v:any):boolean
function table.getItemByFunc(table, func)
    if table == nil then
        return nil
    end

    for k, v in pairs(table) do
        if func(k, v) then
            return {
                key = k,
                value = v
            }
        end
    end
    return nil
end

---@param table table<number,any>
---@param func fun(v:any):boolean
function table.getItemByList(table, func)
    if table == nil then
        return nil
    end

    for k, v in ipairs(table) do
        if func(v) then
            return v
        end
    end
    return nil
end

---@param table table<any,any>
---@param func fun(k:any,v:any):boolean
function table.forEach(table, func)
    for i, v in pairs(table) do
        func(i, v)
    end
end

function table.clone(tb)
    return {table.unpack(tb)}
end

function table.shallowCopy(tb)
    local copy = {}
    for k, v in pairs(tb) do
        copy[k] = v
    end
    return copy
end

function table.deepCopy(tb)
    if tb == nil then
        return nil
    end
    local copy = {}
    for k, v in pairs(tb) do
        if type(v) == 'table' then
            copy[k] = table.deepCopy(v)
        else
            copy[k] = v
        end
    end
    setmetatable(copy, table.deepCopy(getmetatable(tb)))
    return copy
end
---@param table table<any,any>
---@param func fun(k:any,v:any):boolean
function table.containsByFunc(table, func)
    if table == nil then
        return false
    end

    for k, v in pairs(table) do
        if func(k, v) then
            return true
        end
    end
    return false
end
---@param sourceList table<number,any>
---@param addList table<number,any>
---@param repeatCheckFunc fun(v1:any,v2:any):boolean
function table.insertListWithoutRepeat(sourceList, addList, repeatCheckFunc, pos)
    if not addList then
        return
    end
    pos = pos or #sourceList + 1
    for i, v in ipairs(addList) do
        if not table.containsByFunc(sourceList, function(k, value)
            return repeatCheckFunc and repeatCheckFunc(value, v) or false
        end) then
            table.insert(sourceList, pos, v)
            pos = pos + 1
        end
    end
end
---@param source table<any,any>
---@param func fun(k:any,v:any):boolean
function table.trueForAll(source, func)
    for k, v in ipairs(source) do
        if not func(k, v) then
            return false
        end
    end
    return true
end

---@param source table<any,any>
---@param func fun(k:any,v:any):boolean
function table.trueForOne(source, func)
    for k, v in ipairs(source) do
        if func(k, v) then
            return true
        end
    end
    return false
end

---@param sourceTab table<string,any>
---@param addTable table<string,any>
function table.addDic(sourceTab, addTable)
    for i, v in pairs(addTable) do
        sourceTab[i] = v
    end
end
---@param list table<number,any>
---@param func fun(v:any):boolean
function table.removeListItemsByFunc(list, func)
    if list == nil then
        return
    end

    local newList = {}
    for i = 1, #list do
        local tmp = list[i]
        if not func(tmp) then
            table.insert(newList, tmp)
        end
    end
    return newList
end

---@param list table<number,any>
---@param func fun(v:any):boolean
function table.removeListItemByFunc(list, func)
    if list == nil then
        return
    end

    local removeIndex = -1

    local newList = {}
    for i = 1, #list do
        local tmp = list[i]
        if not func(tmp) then
            table.insert(newList, tmp)
        else
            func = function(v)
                return false
            end
            removeIndex = i
        end
    end
    return newList, removeIndex
end

function table.isEqual(a, b)
    -- 判断两个table是否相等
    local _a, _b = 0, 0
    for _ak, _av in pairs(a) do
        _a = _a + 1
    end
    for _bk, _bv in pairs(b) do
        _b = _b + 1
    end
    if _a ~= _b then
        return false
    end
    for a_k, a_v in pairs(a) do
        if type(a_v) == 'table' and type(b[a_k] == 'table') then
            if not table.isEqual(a_v, b[a_k]) then
                return false
            end
        else
            if a_v ~= b[a_k] then
                return false
            end
        end
    end
    return true
end

function table.getCount(self)
    if not self then
        return 0
    end
    local count = 0
    for k, v in pairs(self) do
        count = count + 1
    end
    return count
end

function string.starts(String, Start)
    return string.sub(String, 1, string.len(Start)) == Start
end

function string.ends(String, End)
    return End == '' or string.sub(String, -string.len(End)) == End
end

function string.isNullOrEmpty(s)
    return s == nil or s == ''
end

function string.strSplit(str, reps)
    local r = {}
    if str == nil then
        return nil
    end
    string.gsub(str, "[^" .. reps .. "]+", function(w)
        table.insert(r, w)
    end)
    return r
end

-- 计算 UTF8 字符串的长度，每一个中文算一个字符
function string.utf8len(input)
    local len = string.len(input)
    local left = len
    local cnt = 0
    local arr = {0, 0xc0, 0xe0, 0xf0, 0xf8, 0xfc}
    while left ~= 0 do
        local tmp = string.byte(input, -left)
        local i = #arr
        while arr[i] do
            if tmp >= arr[i] then
                left = left - i
                break
            end
            i = i - 1
        end
        cnt = cnt + 1
    end
    return cnt
end

