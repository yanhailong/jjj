-- 老虎机控制器
SlotMachineController = {
    isSpinning = false,
    stopTime = 2.0, -- 每列停止间隔时间
    spinDuration = 3.0, -- 旋转总时间
    reels = {}, -- 存储所有滚轮
    symbols = {}, -- 符号列表
    currentReelIndex = 1, -- 当前停止的滚轮索引
    onSpinComplete = nil -- 旋转完成回调
}

-- 初始化老虎机
function SlotMachineController:Init(reels, symbols)
    self.reels = reels
    self.symbols = symbols

    -- 初始化每个滚轮的符号
    for i, reel in ipairs(self.reels) do
        self:ResetReel(reel)
    end
end

-- 重置滚轮符号
function SlotMachineController:ResetReel(reel)
    local children = reel.transform.childCount
    for i = 0, children - 1 do
        local child = reel.transform:GetChild(i)
        local randomIndex = math.random(1, #self.symbols)
        ComponentUtilGet.Image(child).sprite = self.symbols[randomIndex]
    end
end

-- 开始旋转
function SlotMachineController:StartSpin(onComplete)
    if self.isSpinning then return end

    self.isSpinning = true
    self.currentReelIndex = 1
    self.onSpinComplete = onComplete

    -- 重置所有滚轮为旋转状态
    for i, reel in ipairs(self.reels) do
        self:StartReelSpin(reel)
    end

    -- 设置停止顺序
    self:ScheduleStop()
end

-- 单个滚轮开始旋转
function SlotMachineController:StartReelSpin(reel)
    local speed = 30 -- 旋转速度

    -- 使用协程实现平滑旋转
    CorManager.StartCor(self, function
    ()
        while self.isSpinning do
            reel.transform.localPosition = reel.transform.localPosition - Vector3(0, speed * Time.deltaTime, 0)

            -- 如果符号移出视图，将其移动到顶部
            for i = 0, reel.transform.childCount - 1 do
                local child = reel.transform:GetChild(i)
                if child.localPosition.y < -200 then -- 假设200是下边界
                    child.localPosition = child.localPosition + Vector3(0, reel.transform.childCount * 100, 0)
                    -- 随机更换新符号
                    local randomIndex = math.random(1, #self.symbols)
                    ComponentUtilGet.Image(child).sprite = self.symbols[randomIndex]
                end
            end

            coroutine.yield(0)
        end
    end)
end

-- 安排停止顺序
function SlotMachineController:ScheduleStop()
    -- 第一个滚轮在spinDuration后停止
    local delay = self.spinDuration

    for i = 1, #self.reels do
        self:DelayedStopReel(i, delay)
        delay = delay + self.stopTime -- 每个滚轮间隔stopTime秒停止
    end
end

-- 延迟停止单个滚轮
function SlotMachineController:DelayedStopReel(reelIndex, delay)
    CorManager.StartCor(self, function()
        coroutine.yield(WaitForSeconds(delay))
        self:StopReel(reelIndex)
    end)
end

-- 停止单个滚轮
function SlotMachineController:StopReel(reelIndex)
    if reelIndex > #self.reels then return end

    local reel = self.reels[reelIndex]

    -- 停止滚轮动画
    -- 这里可以添加对齐到最近符号的逻辑

    -- 检查是否所有滚轮都已停止
    if reelIndex == #self.reels then
        self.isSpinning = false
        if self.onSpinComplete then
            self.onSpinComplete()
        end
    else
        self.currentReelIndex = reelIndex + 1
    end
end

-- 对齐滚轮到最近的符号位置
function SlotMachineController:AlignReelToSymbol(reel)
    -- 实现对齐逻辑，确保停止时符号居中显示
    -- 可能需要计算最近符号位置并平滑移动过去
end