local SicBoAnimation = {}
SicBoAnimation.__index = SicBoAnimation

function SicBoAnimation.New(gameObject, Mini, sicBoMainCtrl)
    local self = setmetatable({}, SicBoAnimation)
    self.gameObject = gameObject
    self.transform = gameObject.transform
    self.position = gameObject.transform.position
    self.mini = Mini
    self.sicBoMainCtrl = sicBoMainCtrl
    self:Init()
    return self
end

function SicBoAnimation:Init()
    self.Lid = self.transform:Find("Lid")                                                             --盖子
    self.DiceImage1 = self.transform:Find("DiceImage1"):GetComponent(typeof(CS.UnityEngine.UI.Image)) --筛子1
    self.DiceImage2 = self.transform:Find("DiceImage2"):GetComponent(typeof(CS.UnityEngine.UI.Image)) --筛子2
    self.DiceImage3 = self.transform:Find("DiceImage3"):GetComponent(typeof(CS.UnityEngine.UI.Image)) --筛子3
end

function SicBoAnimation:Create(state, data)
    self.DiceImage1.sprite = self.sicBoMainCtrl.config.Dice3dIcon[6]
    self.DiceImage2.sprite = self.sicBoMainCtrl.config.Dice3dIcon[6]
    self.DiceImage3.sprite = self.sicBoMainCtrl.config.Dice3dIcon[6]
    self.Lid.gameObject:SetActive(false)
    self.transform.localScale = self.mini.transform.localScale
    self.transform.position = self.mini.transform.position
    self.gameObject:SetActive(true)
end

function SicBoAnimation:ShakDice()
    self.Lid.gameObject:SetActive(true)
    self.transform.position = self.position
    self.transform.localScale = Vector3.one
    local shakeDuration = 0.2
    local shakeHeight = 2
    local originalPosition = self.transform.position

    local shakeSequence = DOTween.Sequence()
    for i = 0, 12 do
        if i % 2 == 0 then
            shakeSequence:Append(self.transform:DOMoveY(
                originalPosition.y + shakeHeight,
                shakeDuration / 2
            ):SetEase(CS.DG.Tweening.Ease.InOutQuad));
        else
            shakeSequence:Append(self.transform:DOMoveY(
                originalPosition.y,
                shakeDuration / 2
            ):SetEase(CS.DG.Tweening.Ease.InOutQuad));
        end
    end
    shakeSequence:AppendInterval(0.3)
    shakeSequence:Append(self.transform:DOMoveY(
        originalPosition.y,
        0.05
    ):SetEase(CS.DG.Tweening.Ease.InOutQuad))
    shakeSequence:AppendCallback(function() self.sicBoMainCtrl.sounds.PlayRollDice() end)
    shakeSequence:Append(self.transform:DOShakePosition(0.1, 2, 50, 0, false, false))
    --shakeSequence:Append(self.view.obj_DiceBox_Big.transform:DOShakePosition(
    --0.5, Vector3(0.05, 0.02, 0.05), 5, 90));
        :AppendInterval(1)
        :Append(self.transform:DOMove(self.mini.transform.position, 0.2):SetEase(CS.DG
            .Tweening.Ease.InOutQuad))
        :Join(self.transform:DOScale(Vector3(0.25, 0.25, 0.25), 0.2))
        :WaitForCompletion()
    return shakeSequence:WaitForCompletion()
end

function SicBoAnimation:MoveScale()
    local Duration = 0.2
    return DOTween.Sequence()
        :Append(self.transform:DOMove(self.mini.transform.position, 0.2):SetEase(CS.DG
            .Tweening.Ease.InOutQuad))
        :Join(self.transform:DOScale(Vector3(0.25, 0.25, 0.25), Duration))
        :WaitForCompletion()
end

--开奖动画
function SicBoAnimation:Lottery(data)
    self.Lid.gameObject:SetActive(true)
    local Duration = 0.2
    return DOTween.Sequence()
        :Append(self.transform:DOMove(self.position, 0.2):SetEase(CS.DG
            .Tweening.Ease.InOutQuad))
        :Join(self.transform:DOScale(Vector3.one, Duration))
        :AppendInterval(0.5)
        :AppendCallback(function()
            self.DiceImage1.sprite = self.sicBoMainCtrl.config.Dice3dIcon[data[1]]
            self.DiceImage2.sprite = self.sicBoMainCtrl.config.Dice3dIcon[data[2]]
            self.DiceImage3.sprite = self.sicBoMainCtrl.config.Dice3dIcon[data[3]]
            self.Lid.gameObject:SetActive(false)
        end)
        :AppendInterval(1)
        :Append(self.transform:DOMove(self.mini.transform.position, 0.2):SetEase(CS.DG
            .Tweening.Ease.InOutQuad))
        :Join(self.transform:DOScale(Vector3(0.25, 0.25, 0.25), Duration))
        :WaitForCompletion()
end

--设置历史记录动画
function SicBoAnimation:ReplaceHistoryRecord(Transform, controlPoint, endPos)
    local startPos = self.DiceImage1.transform.position
    local startPos1 = self.DiceImage2.transform.position
    local startPos2 = self.DiceImage3.transform.position
    --self.DiceImage1.sprite = self.sicBoMainCtrl.config.Dice3dIcon[6]
    --self.DiceImage2.sprite = self.sicBoMainCtrl.config.Dice3dIcon[6]
    --self.DiceImage3.
    local endPos = self.sicBoMainCtrl.History[1].DiceImage1.transform.position
    local endPos1 = self.sicBoMainCtrl.History[1].DiceImage2.transform.position
    local endPos2 = self.sicBoMainCtrl.History[1].DiceImage3.transform.position
    local controlPoint = startPos + Vector3(3, 0, 0)   -- 控制点决定曲线高度
    local controlPoint1 = startPos1 + Vector3(3, 0, 0) -- 控制点决定曲线高度
    local controlPoint2 = startPos2 + Vector3(3, 0, 0) -- 控制点决定曲线高度
    local shakeSequence = DOTween.Sequence()

    shakeSequence:Append(DOTween.To(
            function()
                return 0     -- 初始值（不重要，因为插值由 t 控制）
            end,
            function(t)      -- t 是插值（0 → 1）
                local u = 1 - t
                local pos = u * u * startPos
                    + 2 * u * t * controlPoint
                    + t * t * endPos
                self.DiceImage1.transform.position = pos     -- 直接设置位置
            end,
            1,                                               -- 目标值（t=1）
            1                                                -- 持续时间（秒）
        )
        :SetEase(CS.DG.Tweening.Ease.OutQuad):OnComplete(
            function()
                self.DiceImage1.transform.position = startPos
            end
        ):SetDelay(0.1)
    );
    shakeSequence:Join(DOTween.To(
            function()
                return 0 -- 初始值（不重要，因为插值由 t 控制）
            end,
            function(t)  -- t 是插值（0 → 1）
                local u = 1 - t
                local pos = u * u * startPos1
                    + 2 * u * t * controlPoint1
                    + t * t * endPos1
                self.DiceImage2.transform.position = pos -- 直接设置位置
            end,
            1,                                           -- 目标值（t=1）
            1.1                                            -- 持续时间（秒）
        )
        :SetEase(CS.DG.Tweening.Ease.OutQuad):OnComplete(
            function()
                self.DiceImage2.transform.position = startPos1
            end
        ):SetDelay(0.2)
    );
    shakeSequence:Join(DOTween.To(
            function()
                return 0 -- 初始值（不重要，因为插值由 t 控制）
            end,
            function(t)  -- t 是插值（0 → 1）
                local u = 1 - t
                local pos = u * u * startPos2
                    + 2 * u * t * controlPoint2
                    + t * t * endPos2
                self.DiceImage3.transform.position = pos -- 直接设置位置
            end,
            1,                                           -- 目标值（t=1）
            1.2                                            -- 持续时间（秒）
        )
        :SetEase(CS.DG.Tweening.Ease.OutQuad):OnComplete(
            function()
                self.DiceImage3.transform.position = startPos2
            end
        ):SetDelay(0.3)
    );
    return shakeSequence:WaitForCompletion()
end

function SicBoAnimation:ChangeStateAnimation(canvasGroup)
    log("开始调用")
    return DOTween.Sequence()
        :Append(canvasGroup:DOFade(1, 0.2))
        :AppendInterval(0.5)
        :Append(canvasGroup:DOFade(0, 0.2):SetEase(CS.DG.Tweening.Ease.InOutQuad))
        :WaitForCompletion()
end

function SicBoAnimation:TextAnimation(TextTransform, Text, callback)
    return DOTween.Sequence()
        :Append(TextTransform:DOLocalMoveY(TextTransform.localPosition.y + 100, 2):SetEase(CS.DG.Tweening.Ease.Linear))
        :Join(Text:DOFade(1, 1):From(0))
        :Insert(1.5, Text:DOFade(0, 0.5))
        :AppendCallback(callback)
        :WaitForCompletion()
end

function SicBoAnimation:Close()
    self.transform:DOKill()
end

return SicBoAnimation
