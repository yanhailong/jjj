local Vector2 = CS.UnityEngine.Vector2
local Vector3 = CS.UnityEngine.Vector3
local Quaternion = CS.UnityEngine.Quaternion
local DOTween = CS.DG.Tweening.DOTween
local Ease = CS.DG.Tweening.Ease
local RotateMode = CS.DG.Tweening.RotateMode
local Rect = UnityEngine.Rect

---@class CarLogoPlayCoinView
local CarLogoPlayCoinView=Class("CarLogoPlayCoinView")

---@type ObjectPoolUtil
local pool = ObjectPoolUtil:New("CarLogoPlayCoinView")

---scale
local scale = 0.45
---桌面上的底注
local coins = {}
DOTween:SetTweensCapacity(1000, 250); 
---
---金币抛到桌面上
---@param coin 抛的硬币 gameObject
---@param coin_type 抛的硬币类型 int
---@param start_pos 抛的起始位置 Vector3
---@param target 抛的目标对象区域 RectTransform
---描述 功能实现 初始coin到对象池中，然后从对象池中取出对象，并设置初始位置，然后金币开始抛到target区域内 不需要回收 金币需要留在桌面上堆积
---
function CarLogoPlayCoinView:AnimateCoin(coin,coin_type,start_pos,target)
     -- 从对象池获取金币实例
    ---@type GameObject
    local coinObj = pool:Spawn(nil,coin)
    
    -- 设置金币初始位置和激活状态
    coinObj.transform:SetParent(target.transform,false)
    coinObj.transform.localScale = Vector3(scale,scale,1)
    coinObj.transform.position = start_pos
    coinObj:SetActive(true)

    coins[#coins+1] = coinObj
    
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
    local jumpHeight = Tools.Random(0, 0.5)
    
    -- 创建动画序列
    local sequence = DOTween.Sequence()
    
    -- 设置金币动画效果
    sequence:Append(coinObj.transform:DOMove(endPos, 0.5):SetEase(Ease.OutQuad))
    --sequence:Join(coinObj.transform:DOJump(endPos, jumpHeight, 1, 0.8):SetEase(Ease.OutQuad))
    -- sequence:Join(coinObj.transform:DORotate(Vector3(0,0, Tools.Random(0, 360)), 0.8, RotateMode.FastBeyond360))
    sequence:Join(coinObj.transform:DOScale(scale+0.2, 0.5):SetEase(Ease.OutQuad))
    sequence:Append(coinObj.transform:DOScale(scale, 0.3):SetEase(Ease.OutQuad))
    -- 动画完成后保持金币在桌面上
    sequence:OnComplete(function()
        -- 可以在这里添加金币落地后的效果，如声音等
        sequence:Kill(false)
    end)
    
    sequence:Play()
end

---创建底注到区域
function CarLogoPlayCoinView:CreatCoinInArea(coin,coin_type,target)
    local coinObj = pool:Spawn(nil,coin)

    -- 设置金币初始位置和激活状态
    coinObj.transform:SetParent(target.transform,false)
    coinObj.transform.localScale = Vector3(scale,scale,1)
    coins[#coins+1] = coinObj

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

    coinObj.transform.position = endPos
    coinObj:SetActive(true)
end

---
---targetPos 目标 {v3,v3,v3...}
---ratios 比例 {0.1,0.3,0.6}
function CarLogoPlayCoinView:DestroyCoin(targetPos,ratios)
    local results = distributeCoins(#coins,ratios)
    local index = 1
    local next = 0
    for i=1,#coins do
        if next + results[index] >= i then
            self:DestroyCoinFly(coins[i],targetPos[index])
        else
            next = next + results[index]
            index = index + 1
            self:DestroyCoinFly(coins[i],targetPos[index])
        end
    end
end

function CarLogoPlayCoinView:DestroyCoinFly(coinObj,endPos)
    -- 创建动画序列
    local sequence = DOTween.Sequence()

    -- 设置金币动画效果
    sequence:Append(coinObj.transform:DOMove(endPos, 0.8):SetEase(Ease.OutQuad))
    sequence:Join(coinObj.transform:DOScale(0.9, 0.8):SetEase(Ease.OutQuad):SetDelay(1))
    -- 动画完成后保持金币在桌面上
    sequence:OnComplete(function()
        --coinObj:SetActive(false)
        --coinObj.transform:SetParent(nil)
        sequence:Kill(false)
        pool:UnSpawnPrefab(coinObj)
    end)

    sequence:Play()
end

---金币分配
function distributeCoins(totalCoins, ratios)
    local n = #ratios
    local result = {}
    local sum = 0

    -- Step 1: Calculate the expected number of coins for each person
    for i = 1, n do
        result[i] = totalCoins * ratios[i]
        sum = sum + result[i]
    end

    -- Step 2: Adjust the results to make them integers
    local remaining = totalCoins
    for i = 1, n do
        result[i] = math.floor(result[i])
        remaining = remaining - result[i]
    end

    -- Step 3: Distribute the remaining coins
    local index = 1
    while remaining > 0 do
        result[index] = result[index] + 1
        remaining = remaining - 1
        index = index + 1
        if index > n then
            index = 1
        end
    end

    -- Step 4: Ensure each person gets at least one coin
    for i = 1, n do
        if result[i] == 0 then
            -- Find someone with more than one coin to give
            for j = 1, n do
                if result[j] > 1 then
                    result[j] = result[j] - 1
                    result[i] = result[i] + 1
                    break
                end
            end
        end
    end

    return result
end

function CarLogoPlayCoinView:Destroy()
    pool:DestroyAll()
end

return CarLogoPlayCoinView