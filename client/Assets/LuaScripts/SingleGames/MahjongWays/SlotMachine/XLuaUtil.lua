XLuaUtil = {}

function XLuaUtil.CreateEvent()
    local evt = {}
    evt._handlers = {}

    function evt:Add(func, target)
        if target then
            table.insert(self._handlers, { func = func, target = target })
        else
            table.insert(self._handlers, { func = func })
        end
    end

    function evt:Remove(func, target)
        for i, v in ipairs(self._handlers) do
            if v.func == func and v.target == target then
                table.remove(self._handlers, i)
                break
            end
        end
    end

    function evt:Invoke(...)
        for _, v in ipairs(self._handlers) do
            if v.target then
                v.func(v.target, ...)
            else
                v.func(...)
            end
        end
    end

    return evt
end
