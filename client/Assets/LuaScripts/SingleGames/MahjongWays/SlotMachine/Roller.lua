local Roller = {}
Roller.__index = Roller

local RollerElement = require("SingleGames/MahjongWays/SlotMachine/RollerElement")

function Roller.New(gameObject)
    local self = setmetatable({}, Roller)
    self.gameObject = gameObject
    self.transform = gameObject.transform
    self.elements = {}
    self.stop = XLuaUtil.CreateEvent()
    self.changeSpeed = XLuaUtil.CreateEvent()
    return self
end

function Roller:Init(slotMachine, index)
    self.slotMachine = slotMachine
    self.index = index
    self.column = slotMachine.config.ItemsPerAxis
    self.drop = slotMachine.config.dropTime
    self.Multiple = 1
    self.stopImmediately = false
    self.slotMachine.StopImmediatelyEvent:Add(function(_) self.stopImmediately = true end)

    local content = CS.UnityEngine.GameObject("Content")
    content.transform:SetParent(self.transform)
    content.transform.localScale = CS.UnityEngine.Vector3.one
    content:AddComponent(typeof(CS.UnityEngine.RectTransform))
    self:SetParentNode(content.transform)
end

function Roller:SetParentNode(content)
    local contentHeight = self.slotMachine.config.ElementHeight * (self.slotMachine.config.ItemsPerAxis + self.slotMachine.config.AddItems * 2)
    local contentWidth = self.slotMachine.config.AxisSize.x
    local offset = contentHeight / 2
    self.slotMachine.startOffset = offset

    content:GetComponent(typeof(CS.UnityEngine.RectTransform)).sizeDelta =
        CS.UnityEngine.Vector2(contentWidth, contentHeight)
    content.localPosition = CS.UnityEngine.Vector3.zero

    self:CreateElement(content, self.slotMachine.config.ItemsPerAxis + self.slotMachine.config.AddItems * 2)
end

function Roller:CreateElement(root, total)
    self.elements = {}
    for i = 0, total - 1 do
        local go = CS.UnityEngine.GameObject(tostring(i + 1))
        go.transform:SetParent(root)
        go.transform.localScale = CS.UnityEngine.Vector3.one
        go:AddComponent(typeof(CS.UnityEngine.RectTransform)).sizeDelta =
            CS.UnityEngine.Vector2(self.slotMachine.config.ElementWight, self.slotMachine.config.ElementHeight)
        go.transform.localPosition = CS.UnityEngine.Vector3(
            0,
            (self.slotMachine.startOffset - i * self.slotMachine.config.ElementHeight) - self.slotMachine.config.ElementHeight / 2,
            0
        )
        local element = RollerElement.New(go)
        table.insert(self.elements, element)
        element:Init(self, i, self.slotMachine)
    end
end

function Roller:ChangeSpeed(speed)
    self.changeSpeed:Invoke(speed)
end

--得到当前轴上的所有元素
function Roller:GetAllElement()
    return self.elements
end

--得到当前轴上的所有元素
function Roller:GetAllViewElement()
    local temp = {}
    for k, v in pairs(self.elements) do
        local IsView, index, Element = v:IsView()
        if IsView then
            temp[index] = Element
        end
    end
    return temp
end

--是否包含某个元素
function Roller:IsContainselement()
    ---self.elements[i]
end

function Roller:Completed()
    self.slotMachine.RollerCompleted_Event:Invoke(self, self.index)
end

function Roller:StartGame(waitTime, speed,delayed)
    return function()
        coroutine.yield(CS.UnityEngine.WaitForSeconds(delayed))
        self.stopImmediately = false
        for i, element in ipairs(self.elements) do
            element:Roll(speed / self.Multiple, i == #self.elements and function() self:Completed() end or nil)
        end

        local startTime = CS.UnityEngine.Time.time
        while not self.stopImmediately and CS.UnityEngine.Time.time - startTime < waitTime do
            coroutine.yield(nil)
        end

        self.stop:Invoke()
    end
end

function Roller:Settlement(isDrop, winList)
    if isDrop then
        self:Drop(winList)
    end
end

function Roller:Drop(winningIndices)
    if not winningIndices or #winningIndices == 0 then
        if self.onDropComplete then self.onDropComplete() end
        return
    end

    table.sort(winningIndices)
    local maxWinIndex = winningIndices[#winningIndices]
    local winCount = 0
    local finished = 0
    local dropCount = 0

    local keyValues = {}
    for _, elem in ipairs(self.elements) do
        local idx = elem:GetIndex()
        if idx >= self.slotMachine.config.AddItems and idx < self.column + self.slotMachine.config.AddItems then
            keyValues[idx - (self.slotMachine.config.AddItems - 1)] = elem
        end
    end

    local temp = {}
    for key, elem in pairs(keyValues) do
        if table.contains(winningIndices, key) then
            dropCount = dropCount + 1
            elem:Win(#winningIndices, self.drop, winCount, function()
                finished = finished + 1
                if finished == dropCount and self.onDropComplete then
                    self.onDropComplete()
                end
            end)
            winCount = winCount + 1
        else
            table.insert(temp, key)
        end
    end

    for _, key in ipairs(temp) do
        local steps = 0
        for _, win in ipairs(winningIndices) do
            if win > key then steps = steps + 1 end
        end
        dropCount = dropCount + 1
        keyValues[key]:Win(steps, self.drop, nil, function()
            finished = finished + 1
            if finished == dropCount and self.onDropComplete then
                self.onDropComplete()
            end
        end)
    end
end

function table.contains(tbl, val)
    for _, v in ipairs(tbl) do
        if v == val then return true end
    end
    return false
end

function Roller:Close()
    for i, v in ipairs(self.elements) do
        v:Close();
    end
end

return Roller
