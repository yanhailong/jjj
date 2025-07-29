local SlotMachine = {}
SlotMachine.__index = SlotMachine
require("SingleGames/MahjongWays/SlotMachine/XLuaUtil")
local Roller = require("SingleGames/MahjongWays/SlotMachine/Roller")
local Config = require("SingleGames/MahjongWays/SlotMachine/SlotMachineConfig")
local GameState = {
    NotStarted = 1,
    Rotating = 2,
    RotationCompleted = 3,
    Dropping = 4,
    DropCompleted = 5,
    Completed = 6
}

function SlotMachine.New()
    local self                       = setmetatable({}, SlotMachine)
    self.root                        = nil
    self.axis                        = {}
    -- 内部事件
    self.StopImmediatelyEvent        = XLuaUtil.CreateEvent()
    self.RollerCompleted_Event       = XLuaUtil.CreateEvent()
    -- 外部监听
    self.SingleRollerCompleted_Event = XLuaUtil.CreateEvent() --单轴停止事件
    self.DropCompleted_Event         = XLuaUtil.CreateEvent() --掉落完成事件
    self.ElementInitCompleted_Event  = XLuaUtil.CreateEvent() --元素初始化完成事件
    self.AllRollerCompleted_Event    = XLuaUtil.CreateEvent() --滚动完成事件
    self.ChangeRandomIcons_Event     = XLuaUtil.CreateEvent() --切换随机滚动图标事件
    self.SetResultIcons_Event        = XLuaUtil.CreateEvent() --设置结果图标事件
    -- 状态控制
    self.rollerCompleted_Number      = 0
    -- 内部状态
    self.rollerCoroutines            = {}
    self.state                       = GameState.NotStarted;
    self.startOffset                 = 0
    self.elementIconPrefab           = nil
    self.config                      = Config
    return self
end

---@param root根节点  ,elementIconPrefab元素预制件
function SlotMachine:Create(root, elementIconPrefab)
    self.transform = root
    self.elementIconPrefab = elementIconPrefab
    self.axis = {}
    self.rollerCoroutines = {}
    self.rollerCompleted_Number = 0
    self:Init(self.transform)
    self.RollerCompleted_Event:Add(self.RollerCompleted, self)
end

--停止
function SlotMachine:Stop()
    if self.state == GameState.Rotating then
        self.StopImmediatelyEvent:Invoke(self)
    end
end

function SlotMachine:Init(root)
    local parent = root
    if not self.config.isOpenSingleAxisMask then
        local mask = CS.UnityEngine.GameObject("Mask")
        mask.transform:SetParent(root)
        mask.transform.localScale = CS.UnityEngine.Vector3.one
        mask:AddComponent(typeof(CS.UnityEngine.RectTransform)).sizeDelta =
            CS.UnityEngine.Vector2(self.config.AxisOffset * self.config.AxisCount,
                self.config.ItemsPerAxis * self.config.ElementHeight + self.config.AxisSizeOffset)
        mask:AddComponent(typeof(CS.UnityEngine.UI.RectMask2D))
        mask.transform.localPosition = self.config.MaskStartPos
        self.AxisStartPos = CS.UnityEngine.Vector3(
            -self.config.ElementWight * self.config.AxisCount / 2 + self.config.ElementWight / 2 +
            self.config.MaskStartPos.x,
            0,
            0
        )
        parent = mask.transform
    end

    for i = 0, self.config.AxisCount - 1 do
        local go = CS.UnityEngine.GameObject("Axis" .. i)
        go.transform:SetParent(parent)
        go.transform.localScale = CS.UnityEngine.Vector3.one
        go.transform.localPosition = Vector3(
                -(self.config.AxisOffset * self.config.AxisCount) / 2 + self.config.AxisOffset / 2, 0, 0) +
            CS.UnityEngine.Vector3(1, 0, 0) * self.config.AxisOffset * i
        go:AddComponent(typeof(CS.UnityEngine.RectTransform)).sizeDelta =
            CS.UnityEngine.Vector2(self.config.ElementWight,
                self.config.ItemsPerAxis * self.config.ElementHeight + self.config.AxisSizeOffset)
        if self.config.isOpenSingleAxisMask then
            go:AddComponent(typeof(CS.UnityEngine.UI.RectMask2D))
        end

        local roller = Roller.New(go)
        roller:Init(self, i + 1)
        self.axis[i + 1] = roller
    end
end

--开始滚动
function SlotMachine:StartRollers()
    if self.state == GameState.Completed or self.state == GameState.NotStarted then
        self.state = GameState.Rotating
        self.rollerCompleted_Number = 0
        for i, roller in ipairs(self.axis) do
            local delay = self.config.isLineWait and self.config.waitTime or (i / self.config.StopInterval)
            print((i-1)*(self.config.speed/2))
            local co = coroutine.start(roller:StartGame(delay, self.config.speed,(i-1)*(self.config.speed/2)))
            self.rollerCoroutines[i] = co
        end
    end
end

function SlotMachine:StopAllRollers()
    for _, co in pairs(self.rollerCoroutines) do
        if co then coroutine.stop(co) end
    end
    self.rollerCoroutines = {}
end

function SlotMachine:RollerCompleted(Roller, index)
    self.SingleRollerCompleted_Event:Invoke(Roller, index)
    self.rollerCompleted_Number = self.rollerCompleted_Number + 1
    if self.rollerCompleted_Number == self.config.AxisCount then
        self.state = GameState.RotationCompleted
        self.AllRollerCompleted_Event:Invoke()
    end
end

function SlotMachine:SetDrop(WinPattern)
    self.state = GameState.Dropping
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
            roller:Settlement(self.config.isDrop, WinPattern[key])
        end
    end
end

function SlotMachine:OnAllDropCompleted()
    self.state = GameState.DropCompleted
    self.DropCompleted_Event:Invoke()
end

function SlotMachine:SetCompletedState()
    self.state = GameState.Completed;
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
