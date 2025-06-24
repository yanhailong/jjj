local Vector2 = CS.UnityEngine.Vector2
local Vector3 = CS.UnityEngine.Vector3
local Quaternion = CS.UnityEngine.Quaternion
local DOTween = CS.DG.Tweening.DOTween
local Sequence = CS.DG.Tweening.Sequence
local Ease = CS.DG.Tweening.Ease
local RotateMode = CS.DG.Tweening.RotateMode
local Rect = UnityEngine.Rect

---@class PlayCoin
local PlayCoin=Class("PlayCoin")

---@type ObjectPoolUtil
local pool = ObjectPoolUtil:New("PlayCoin")

---
---金币抛到桌面上
---@param coin 抛的硬币 gameObject
---@param coin_type 抛的硬币类型 int
---@param start_pos 抛的起始位置 Vector3
---@param target 抛的目标对象区域 CanvasRenderer
---描述 功能实现 初始coin到对象池中，然后从对象池中取出对象，并设置初始位置，然后金币开始抛到target区域内 不需要回收 金币需要留在桌面上堆积
---
function PlayCoin:AnimateCoin(coin,coin_type,start_pos,target)
     -- 从对象池获取金币实例
    ---@type GameObject
    local coinObj = pool:Spawn(nil,coin)
    
    -- 设置金币初始位置和激活状态
    coinObj.transform:SetParent(target.transform,false)
    coinObj.transform.localScale = Vector3.one
    coinObj.transform.position = start_pos
    coinObj:SetActive(true)

    local images = {}
    for i = 1, 5 do
        images[i] = ComponentUtilGet.GameObject(coinObj.transform, "img_" .. i)
    end

    for i = 1, 5 do
        images[i]:SetActive(coin_type == i)
    end
    
    -- 获取目标区域的矩形顶点
    local corners = CS.System.Array.CreateInstance(typeof(CS.UnityEngine.Vector3),4)
    target:GetWorldCorners(corners)
 
    local endPos = Vector3(UnityEngine.Random.Range(corners[0].x,corners[2].x), UnityEngine.Random.Range(corners[0].y,corners[2].y), 0)
    -- 计算跳跃高度
    local jumpHeight = Tools.Random(-1.5, 0.5)
    
    -- 创建动画序列
    local sequence = DOTween.Sequence()
    
    -- 设置金币动画效果
    sequence:Append(coinObj.transform:DOMove(endPos, 0.8):SetEase(Ease.OutQuad))
    sequence:Join(coinObj.transform:DOJump(endPos, jumpHeight, 1, 0.8):SetEase(Ease.OutQuad))
    -- sequence:Join(coinObj.transform:DORotate(Vector3(0,0, Tools.Random(0, 360)), 0.8, RotateMode.FastBeyond360))
    sequence:Append(coinObj.transform:DOScale(1.2, 0.3):SetEase(Ease.OutQuad))
    sequence:Append(coinObj.transform:DOScale(1, 0.4):SetEase(Ease.OutQuad))
    -- 动画完成后保持金币在桌面上
    sequence:OnComplete(function()
        -- 可以在这里添加金币落地后的效果，如声音等
    end)
    
    sequence:Play()
end

function PlayCoin:Distroy()
    pool:DestroyAll()
end

return PlayCoin