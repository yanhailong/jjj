local SlotMachine = {}
SlotMachine.__index = SlotMachine
require("SingleGames/MahjongWays/SlotMachine/XLuaUtil")
local Roller = require("SingleGames/MahjongWays/SlotMachine/Roller")
local GameState = {
    NotStarted = 1,
    Rotating = 2,
    RotationCompleted = 3,
    Dropping = 4,
    DropCompleted = 5,
    Completed = 6
}
function SlotMachine.New()
    local self = setmetatable({}, SlotMachine)

    self.itemPos = {}
    self.Root = nil
    self.Line = nil
    self.point = nil
    self.axis = {}

    -- 内部事件
    self.StopImmediatelyEvent = XLuaUtil.CreateEvent()
    self.RollerCompleted_Event = XLuaUtil.CreateEvent()
    -- 外部监听
    self.SingleRollerCompleted_Event = XLuaUtil.CreateEvent() --单轴停止事件
    self.DropCompleted_Event = XLuaUtil.CreateEvent()         --掉落完成事件
    self.ElementInitCompleted = XLuaUtil.CreateEvent()        --元素初始化完成事件
    self.AllRollerCompleted_Event = XLuaUtil.CreateEvent()    --滚动完成事件
    self.ChangeRandomIcons_Event = XLuaUtil.CreateEvent()     --切换随机滚动图标事件
    self.SetResultIcons_Event = XLuaUtil.CreateEvent()        --设置结果图标事件
    -- 状态控制
    self.RollerCompleted_Number = 0
    self.index = 0

    -- 配置
    self.waitTime = 5.0
    self.speed = 0.05
    self.isLineWait = false --是否
    self.StopInterval = 1.0
    self.isDrop = true
    self.isOpenReboundAnimation = true
    self.AxisCount = 5
    self.ItemsPerAxis = 3
    self.AddItems = 3
    self.dropTime = 0.2
    self.isOpenSingleAxisMask = false
    self.ElementHeight = 300
    self.ElementWight = 330
    self.AxisStartPos = CS.UnityEngine.Vector3(-680, -40, 0)
    self.MaskStartPos = CS.UnityEngine.Vector3(0, 0, 0)
    self.AxisOffset = 345
    self.AxisSize = CS.UnityEngine.Vector2(337, 964)
    self.AxisSizeOffset = 0
    self.StartOffset = 0
    self.ElementIconPrefab = nil
    -- 内部状态
    self.RollerCoroutines = {}
    self.lineIndex = 0


    self.State = GameState.NotStarted;
    return self
end
---@param root根节点  ,elementIconPrefab元素预制件
function SlotMachine:Create(root, elementIconPrefab)
    self.transform = root
    self.ElementIconPrefab = elementIconPrefab
    self.axis = {}
    self.RollerCoroutines = {}
    self.RollerCompleted_Number = 0
    self:Init(self.transform)
    self.RollerCompleted_Event:Add(function(i) self:RollerCompleted(i) end)
end

--停止
function SlotMachine:Stop()
    if self.State == GameState.Rotating then
        self.StopImmediatelyEvent:Invoke(self)
    end
end

function SlotMachine:Init(root)
    local parent = root
    if not self.isOpenSingleAxisMask then
        local mask = CS.UnityEngine.GameObject("Mask")
        mask.transform:SetParent(root)
        mask.transform.localScale = CS.UnityEngine.Vector3.one
        mask:AddComponent(typeof(CS.UnityEngine.RectTransform)).sizeDelta =
            CS.UnityEngine.Vector2(self.AxisOffset * self.AxisCount,
                self.ItemsPerAxis * self.ElementHeight + self.AxisSizeOffset)
        mask:AddComponent(typeof(CS.UnityEngine.UI.RectMask2D))
        mask.transform.localPosition = self.MaskStartPos
        self.AxisStartPos = CS.UnityEngine.Vector3(
            -self.ElementWight * self.AxisCount / 2 + self.ElementWight / 2 + self.MaskStartPos.x,
            0,
            0
        )
        parent = mask.transform
    end

    for i = 0, self.AxisCount - 1 do
        local go = CS.UnityEngine.GameObject("Axis" .. i)
        go.transform:SetParent(parent)
        go.transform.localScale = CS.UnityEngine.Vector3.one
        go.transform.localPosition = Vector3(-(self.AxisOffset * self.AxisCount) / 2 + self.AxisOffset / 2, 0, 0) +
        CS.UnityEngine.Vector3(1, 0, 0) * self.AxisOffset * i
        go:AddComponent(typeof(CS.UnityEngine.RectTransform)).sizeDelta =
            CS.UnityEngine.Vector2(self.ElementWight, self.ItemsPerAxis * self.ElementHeight + self.AxisSizeOffset)
        if self.isOpenSingleAxisMask then
            go:AddComponent(typeof(CS.UnityEngine.UI.RectMask2D))
        end

        local roller = Roller.New(go)
        roller:Init(self, i + 1)
        self.axis[i + 1] = roller
    end
end
--开始滚动
function SlotMachine:StartRollers()
    if self.State == GameState.Completed or self.State == GameState.NotStarted then
        self.State = GameState.Rotating
        self.RollerCompleted_Number = 0
        for i, roller in ipairs(self.axis) do
            local delay = self.isLineWait and self.waitTime or (i / self.StopInterval)
            local co = coroutine.start(roller:StartGame(delay, self.speed))
            self.RollerCoroutines[i] = co
        end
    end
end

function SlotMachine:StopAllRollers()
    for _, co in pairs(self.RollerCoroutines) do
        if co then coroutine.stop(co) end
    end
    self.RollerCoroutines = {}
end

function SlotMachine:RollerCompleted(index)
    self.SingleRollerCompleted_Event:Invoke(index)
    self.RollerCompleted_Number = self.RollerCompleted_Number + 1
    if self.RollerCompleted_Number == self.AxisCount then
        self.State = GameState.RotationCompleted
        self.AllRollerCompleted_Event:Invoke()
    end
end

function SlotMachine:SetDrop(WinPattern)
    self.State = GameState.Dropping
    self.dropFinishedCount = 0
    self.totalAxis = #self.axis
    for key, roller in ipairs(self.axis) do
        roller.onDropComplete = function()
            self.dropFinishedCount = self.dropFinishedCount + 1
            if self.dropFinishedCount == self.totalAxis then
                self:OnAllDropCompleted()
            end
        end
        if WinPattern[key] ~= nil then
            roller:Settlement(self.isDrop, WinPattern[key])
        end
    end
end

function SlotMachine:OnAllDropCompleted()
    self.State = GameState.DropCompleted
    self.DropCompleted_Event:Invoke()
end

function SlotMachine:SetCompletedState()
    self.State = GameState.Completed;
end

--改变速度
function SlotMachine:ChangeSpeed(rollerIndex, speed)
    self.axis[rollerIndex]:ChangeSpeed(speed)
end
--关闭游戏
function SlotMachine:Close()
    for i, v in ipairs(self.axis) do
        v:Close()
    end
    self:StopAllRollers()
end

return SlotMachine
