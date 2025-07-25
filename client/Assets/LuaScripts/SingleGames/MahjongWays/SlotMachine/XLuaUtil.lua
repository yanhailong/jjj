XLuaUtil = {}

function XLuaUtil.CreateEvent()
    local evt = {}
    evt._handlers = {}
    function evt:Add(func)
        table.insert(self._handlers, func)
    end
    function evt:Remove(func)
        for i, v in ipairs(self._handlers) do
            if v == func then
                table.remove(self._handlers, i)
                break
            end
        end
    end
    function evt:Invoke(...)
        for _, func in ipairs(self._handlers) do
            func(...)
        end
    end
    return evt
end
