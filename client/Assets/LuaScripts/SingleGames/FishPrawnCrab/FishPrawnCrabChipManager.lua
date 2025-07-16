--
--time:{time}
--{paramdesc} 
--@desc 
--
---@class FishPrawnCrabChipManager
local FishPrawnCrabChipManager = Class("FishPrawnCrabChipManager")

local FishPrawnCrabConfig = require("SingleGames/FishPrawnCrab/FishPrawnCrabConfig")

local Vector2 = CS.UnityEngine.Vector2
local Vector3 = CS.UnityEngine.Vector3
local Quaternion = CS.UnityEngine.Quaternion
local DOTween = CS.DG.Tweening.DOTween
local Ease = CS.DG.Tweening.Ease
local RotateMode = CS.DG.Tweening.RotateMode
local Rect = UnityEngine.Rect

---@type ObjectPoolUtil
local pool = ObjectPoolUtil:New("FishPrawnCrabChipManager")

---桌面上的底注
local chips = {}
DOTween:SetTweensCapacity(1000, 250);
local scale = 0.5

---
---筹码抛到桌面上
---@param chip_type 抛的筹码类型 int
---@param start_pos 抛的起始位置 Vector3
---@param target 抛的目标对象区域 RectTransform
---@return GameObject 抛的筹码
---描述 功能实现 初始筹码到对象池中，然后从对象池中取出对象，并设置初始位置，然后筹码开始抛到target区域内 不需要回收 筹码需要留在桌面上堆积
---
function FishPrawnCrabChipManager:AnimateChip(chip_type, start_pos, target)
    -- 从对象池获取金币实例
    ---@type GameObject
    local chipObj = pool:SpawnPrefab(nil, FishPrawnCrabConfig.ABNames.ChipPool, FishPrawnCrabConfig.GetChipPoolName(chip_type))

    -- 设置金币初始位置和激活状态
    chipObj.transform:SetParent(target.transform,false)
    chipObj.transform.localScale = Vector3(scale,scale,scale)
    chipObj.transform.position = start_pos
    chipObj:SetActive(true)

    chips[#chips+1] = chipObj

    -- 获取目标区域的矩形顶点
    local corners = CS.System.Array.CreateInstance(typeof(CS.UnityEngine.Vector3),4)
    target:GetWorldCorners(corners)

    local endPos = Vector3(UnityEngine.Random.Range(corners[0].x,corners[2].x), UnityEngine.Random.Range(corners[0].y,corners[2].y), 0)
    -- 计算跳跃高度
    local jumpHeight = Tools.Random(0, 0.5)

    -- 创建动画序列
    local sequence = DOTween.Sequence()

    -- 设置金币动画效果
    sequence:Append(chipObj.transform:DOMove(endPos, 0.5):SetEase(Ease.OutQuad))
    --sequence:Join(chipObj.transform:DOJump(endPos, jumpHeight, 1, 0.8):SetEase(Ease.OutQuad))
    -- sequence:Join(chipObj.transform:DORotate(Vector3(0,0, Tools.Random(0, 360)), 0.8, RotateMode.FastBeyond360))
    sequence:Join(chipObj.transform:DOScale(scale+0.2, 0.5):SetEase(Ease.OutQuad))
    sequence:Append(chipObj.transform:DOScale(scale, 0.3):SetEase(Ease.OutQuad))
    -- 动画完成后保持金币在桌面上
    sequence:OnComplete(function()
        -- 可以在这里添加金币落地后的效果，如声音等
        sequence:Kill(false)
    end)

    sequence:Play()
    
    return chipObj
end

---创建底注到区域
function FishPrawnCrabChipManager:CreatChipInArea(chip_type, target)
    local chipObj = pool:SpawnPrefab(nil, FishPrawnCrabConfig.ABNames.ChipPool, FishPrawnCrabConfig.GetChipPoolName(chip_type))

    -- 设置金币初始位置和激活状态
    chipObj.transform:SetParent(target.transform,false)
    chipObj.transform.localScale = Vector3.one
    chips[#chips+1] = chipObj

    -- 获取目标区域的矩形顶点
    local corners = CS.System.Array.CreateInstance(typeof(CS.UnityEngine.Vector3),4)
    target:GetWorldCorners(corners)

    local endPos = Vector3(UnityEngine.Random.Range(corners[0].x,corners[2].x), UnityEngine.Random.Range(corners[0].y,corners[2].y), 0)

    chipObj.transform.position = endPos
    chipObj:SetActive(true)
    
    return chipObj
end

function FishPrawnCrabChipManager:DestroyChipFly(chipObj, endPos)
    if chipObj == nil then
        return
    end
    
    -- 创建动画序列
    local sequence = DOTween.Sequence()

    -- 设置金币动画效果
    sequence:Append(chipObj.transform:DOMove(endPos, 0.8):SetEase(Ease.OutQuad))
    sequence:Join(chipObj.transform:DOScale(scale+0.3, 0.8):SetEase(Ease.OutQuad):SetDelay(1))
    -- 动画完成后保持金币在桌面上
    sequence:OnComplete(function()
        --chipObj:SetActive(false)
        --chipObj.transform:SetParent(nil)
        sequence:Kill(false)
        pool:UnSpawnPrefab(chipObj)
    end)

    sequence:Play()

    FishPrawnCrabChipManager:RemoveChip(chipObj)
end

function FishPrawnCrabChipManager:CleanChip()
    chips = {}
end

function FishPrawnCrabChipManager:GetChipArr()
    return chips
end

function FishPrawnCrabChipManager:RemoveChip(chipObj)
    local index = ArrayUtil.indexOf(chips, chipObj)
    if index ~= nil then
        table.remove(chips, index)
    end
end

function FishPrawnCrabChipManager:Destroy()
    pool:DestroyAll()
end

return FishPrawnCrabChipManager