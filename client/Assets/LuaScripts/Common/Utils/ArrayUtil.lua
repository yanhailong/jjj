ArrayUtil = {};
local this = ArrayUtil;

-- 添加元素到数组
function ArrayUtil.add(array, value)
    table.insert(array, value)
end

-- 从数组中删除元素
function ArrayUtil.remove(array, index)
    if index >= 1 and index <= #array then
        table.remove(array, index)
    end
end

-- 检查数组中是否包含指定值
function ArrayUtil.contains(array, value)
    for _, v in ipairs(array) do
        if v == value then
            return true
        end
    end
    return false
end

-- 获取数组中的最大值
function ArrayUtil.max(array)
    local max = array[1]
    for i = 2, #array do
        if array[i] > max then
            max = array[i]
        end
    end
    return max
end

-- 获取数组中的最小值
function ArrayUtil.min(array)
    local min = array[1]
    for i = 2, #array do
        if array[i] < min then
            min = array[i]
        end
    end
    return min
end

-- 对数组进行排序
function ArrayUtil.sort(array)
    table.sort(array)
end

-- 返回数组的长度
function ArrayUtil.size(array)
    return #array
end

-- 返回序号 
function ArrayUtil.indexOf(array,value)
    for i, v in ipairs(array) do
        if v == value then
            return i
        end
    end
    return nil
end

-- 统计指定值数量
function ArrayUtil.countByVale(array,value)
    local count =0
    for k, v in pairs(array) do
        if v == value then
            count = count + 1
        end
    end
    return count
end

return this