local RollerElement = {}
RollerElement.__index = RollerElement

function RollerElement.New(go)
    local self = setmetatable({}, RollerElement)
    self.gameObject = go
    self.transform = go.transform
    return self
end

function RollerElement:Init(roller, index, slotMachine)
    self.roller = roller
    self.index = index
    self.ItemsPerAxis = slotMachine.ItemsPerAxis + slotMachine.AddItems * 2
    self.ElementHeight = slotMachine.ElementHeight
    self.slotMachine = slotMachine
    self.offset = slotMachine.StartOffset - self.slotMachine.ElementHeight / 2
    self.AddItems = slotMachine.AddItems
    self.isOpenReboundAnimation = slotMachine.isOpenReboundAnimation
    self.BounceOffset = slotMachine.ElementHeight / 2
    self.top = (slotMachine.ElementHeight * self.ItemsPerAxis) / 2 - self.BounceOffset
    self.ResetThreshold = -self.top - 50
    self.originalPos = self.transform.localPosition
    self.elementIcon = CS.UnityEngine.GameObject.Instantiate(slotMachine.ElementIconPrefab, self.transform)
    self.elementIcon.transform.localPosition = CS.UnityEngine.Vector3.zero
    self.elementIcon.transform.localScale = CS.UnityEngine.Vector3.one
    roller.stop:Add(function() self.StartRoll = false end)
    roller.changeSpeed:Add(function(speed) self.speed = speed end)
    slotMachine.ElementInitCompleted:Invoke(self, self.elementIcon, self.roller.index, self.index);
    self.ChangeRandomIcons_Event = slotMachine.ChangeRandomIcons_Event;
    self.SetResultIcons_Event = slotMachine.SetResultIcons_Event;
end

function RollerElement:GetIndex()
    return math.floor(math.abs(self.transform.localPosition.y - self.offset) / self.ElementHeight + 0.5)
end

function RollerElement:Roll(time, onComplete)
    self.StartRoll = true
    self.speed = time
    coroutine.start(self:LoopRoll(onComplete))
end

function RollerElement:LoopRoll(onComplete)
    return function()
        while self.StartRoll do
            coroutine.yield(self:RotatingAnimation(self.speed))
        end
        coroutine.yield(self:SetAsynResult(true))
        if self.isOpenReboundAnimation then
            coroutine.yield(self:ReboundAnimation())
        end
        if onComplete then onComplete() end
    end
end

function RollerElement:RotatingAnimation(time)
    return self.transform:DOLocalMoveY(self.transform.localPosition.y - self.ElementHeight, time)
        :SetEase(CS.DG.Tweening.Ease.Linear)
        :OnComplete(function()
            if self.transform.localPosition.y <= self.ResetThreshold then
                self.ChangeRandomIcons_Event:Invoke(self, self.elementIcon, self.roller.index, self.index)
                self.transform.localPosition = CS.UnityEngine.Vector3(self.originalPos.x, self.top, self.originalPos.z)
            end
        end)
        :WaitForCompletion()
end

function RollerElement:SetAsynResult(isAsyn)
    return coroutine.start(function()
        local index = self:GetIndex()
        if not isAsyn then
            if index >= self.AddItems and index < self.ItemsPerAxis - self.AddItems then
                self.SetResultIcons_Event:Invoke(self, self.elementIcon, self.roller.index, index - (self.AddItems - 1))
            end
            return
        end
        for i = 1, self.ItemsPerAxis do
            coroutine.yield(
                self.transform:DOLocalMoveY(self.transform.localPosition.y - self.ElementHeight, self.speed)
                :SetEase(CS.DG.Tweening.Ease.Linear)
                :OnComplete(function()
                    if self.transform.localPosition.y <= self.ResetThreshold then
                        if index >= self.AddItems and index < (self.ItemsPerAxis - self.AddItems) then
                            self.SetResultIcons_Event:Invoke(self, self.elementIcon, self.roller.index,
                                index - (self.AddItems - 1))
                        end
                        self.transform.localPosition = CS.UnityEngine.Vector3(self.originalPos.x, self.top,
                            self.originalPos.z)
                    end
                end)
                :WaitForCompletion()
            )
        end
    end)
end

function RollerElement:ReboundAnimation()
    return coroutine.start(function()
        coroutine.yield(
            self.transform:DOLocalMoveY(self.transform.localPosition.y - self.BounceOffset, 0.2)
            :SetEase(CS.DG.Tweening.Ease.Linear):WaitForCompletion()
        )
        coroutine.yield(
            self.transform:DOLocalMoveY(self.transform.localPosition.y + self.BounceOffset, 0.2)
            :SetEase(CS.DG.Tweening.Ease.Linear):WaitForCompletion()
        )
    end)
end

function RollerElement:Win(steps, time, sequentialIndex, onComplete)
    coroutine.start(self:DropAnimation(steps, time, sequentialIndex, onComplete))
end

function RollerElement:DropAnimation(steps, time, sequentialIndex, onComplete)
    return function()
        if sequentialIndex and sequentialIndex >= 0 then
            self.transform.localPosition = CS.UnityEngine.Vector3(
                0,
                (self.offset - (self.AddItems - 1) * self.ElementHeight) + self.ElementHeight * sequentialIndex,
                0
            )
            coroutine.yield(0)
            --设置掉落图标
        end

        for i = 1, steps do
            local targetY = self.transform.localPosition.y - self.ElementHeight
            coroutine.yield(
                self.transform:DOLocalMoveY(targetY, time)
                :SetEase(CS.DG.Tweening.Ease.Linear)
                :WaitForCompletion()
            )
        end

        self.index = self:GetIndex()

        if onComplete then onComplete() end
    end
end

function RollerElement:IsView()
    local index = self:GetIndex()
    if index >= self.AddItems and index < self.ItemsPerAxis - self.AddItems then
        return true, index, self
    end
    return false, index, self
end

function RollerElement:Close()
    self.transform:DOKill()
end

return RollerElement
