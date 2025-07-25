local Roller = {}
Roller.__index = Roller

local RollerElement = require("SingleGames/MahjongWays/SlotMachine/RollerElement") -- 引用模块

function Roller.New(gameObject)
    local self = setmetatable({}, Roller)
    self.gameObject = gameObject
    self.transform = gameObject.transform
    self.elements = {}
    self.stop = XLuaUtil.CreateEvent()
    self.changeSpeed = XLuaUtil.CreateEvent()
    return self
end

function Roller:Init(manager, index)
    self.Manager = manager
    self.index = index
    self.column = manager.ItemsPerAxis
    self.drop = manager.dropTime
    self.Multiple = 1
    self.stopImmediately = false
    self.Manager.StopImmediatelyEvent:Add(function(_) self.stopImmediately = true end)

    local content = CS.UnityEngine.GameObject("Content")
    content.transform:SetParent(self.transform)
    content.transform.localScale = CS.UnityEngine.Vector3.one
    content:AddComponent(typeof(CS.UnityEngine.RectTransform))
    self:SetParentNode(content.transform)
end

function Roller:SetParentNode(content)
    local contentHeight = self.Manager.ElementHeight * (self.Manager.ItemsPerAxis + self.Manager.AddItems * 2)
    local contentWidth = self.Manager.AxisSize.x
    local offset = contentHeight / 2
    self.Manager.StartOffset = offset

    content:GetComponent(typeof(CS.UnityEngine.RectTransform)).sizeDelta =
    CS.UnityEngine.Vector2(contentWidth, contentHeight)
    content.localPosition = CS.UnityEngine.Vector3.zero

    self:CreateElement(content, self.Manager.ItemsPerAxis + self.Manager.AddItems * 2)
end

function Roller:CreateElement(root, total)
    self.elements = {}
    for i = 0, total - 1 do
        local go = CS.UnityEngine.GameObject(tostring(i + 1))
        go.transform:SetParent(root)
        go.transform.localScale = CS.UnityEngine.Vector3.one
        go:AddComponent(typeof(CS.UnityEngine.RectTransform)).sizeDelta =
        CS.UnityEngine.Vector2(self.Manager.ElementWight, self.Manager.ElementHeight)
        go.transform.localPosition = CS.UnityEngine.Vector3(
                0,
                (self.Manager.StartOffset - i * self.Manager.ElementHeight) - self.Manager.ElementHeight / 2,
                0
        )
        local element = RollerElement.New(go)
        table.insert(self.elements, element)
        element:Init(
                self,
                self.Manager.icons,
                i,
                self.Manager.ItemsPerAxis + self.Manager.AddItems * 2,
                self.Manager.ElementHeight,
                self.Manager.ElementIconPrefab,
                self.Manager.ElementHeight,
                self.Manager,
                self.Manager.StartOffset - self.Manager.ElementHeight / 2,
                self.Manager.AddItems,
                self.Manager.isOpenReboundAnimation,
                self.Manager.ElementInitCompleted,
                self.Manager.ChangeRandomIcons_Event,
                self.Manager.SetResultIcons_Event

        )
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
    local temp={}
    for k,v in pairs(self.elements) do
     local IsView,index,Element=   v:IsView()
        if IsView then
            temp[index]=Element
        end
    end
    return temp
end
--是否包含某个元素
function Roller:IsContainselement()
    ---self.elements[i]
end

function Roller:Completed()
    self.Manager.RollerCompleted_Event:Invoke(self,self.index)
end

function Roller:StartGame(waitTime, speed)
    return function()
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
        if idx >= self.Manager.AddItems and idx < self.column + self.Manager.AddItems then
            keyValues[idx - (self.Manager.AddItems - 1)] = elem
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
