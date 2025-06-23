local math = math
local Vector2 = CS.UnityEngine.Vector2
local Quaternion = CS.UnityEngine.Quaternion
local DOTween = CS.DG.Tweening.DOTween
local Sequence = CS.DG.Tweening.Sequence
local Ease = CS.DG.Tweening.Ease
local RotateMode = CS.DG.Tweening.RotateMode

-- 配置参数
local config = {
    min_throw_force = 0.8,
    max_throw_force = 1.2,
    base_throw_duration = 0.8,
    base_jump_height = 0.5,
    bounce_factor = 0.7,
    max_bounces = 3,
    color_anim = true -- 是否开启颜色动画
}

-- Lua 动画函数（由 C# 桥接调用）
function AnimateCoin(coin_obj, start_pos)
    local coin_transform = coin_obj.transform
    local sr = coin_obj:GetComponent(typeof(CS.UnityEngine.SpriteRenderer))
    local bridge = CS.XLuaBridge.Instance -- 获取桥接组件

    -- 随机参数
    local force = math.random() * (config.max_throw_force - config.min_throw_force) + config.min_throw_force
    local duration = config.base_throw_duration * force
    local jump_height = config.base_jump_height * force

    -- 随机目标区域
    local target_area = bridge.tableAreas[math.random(1, #bridge.tableAreas)]
    local end_pos = Vector2(
            math.random() * target_area.width + target_area.x,
            bridge.tableY
    )

    -- 抛射动画（抛物线 + 旋转）
    local throw_seq = DOTween.Sequence()
    throw_seq:Append(coin_transform:DOJump(end_pos, jump_height, 1, duration):SetEase(Ease.OutQuad))
    throw_seq:Join(coin_transform:DORotate(Vector3(0, 0, 360 * force), duration, RotateMode.FastBeyond360):SetEase(Ease.Linear))
    throw_seq:SetLink(coin_obj)
    throw_seq:OnComplete(function() StartBounceAnimation(coin_transform, end_pos, force, sr) end)

    -- 颜色动画（可选）
    if config.color_anim then
        local r = math.random()
        local g = math.random()
        sr:DOColor(CS.UnityEngine.Color(r, g, 1), duration/2)
    end
end

-- 弹跳动画
function StartBounceAnimation(transform, landing_pos, force, sr)
    local bounce_seq = DOTween.Sequence()
    local current_height = 0.2 * force
    local bounce_factor = config.bounce_factor

    -- 链式弹跳
    for i=1, config.max_bounces do
        local dur = 0.2 * math.pow(bounce_factor, i-1)
        bounce_seq:Append(transform:DOMoveY(landing_pos.y + current_height, dur/2))
        bounce_seq:Append(transform:DOMoveY(landing_pos.y, dur/2))
        bounce_seq:Join(transform:DOScale(1 - 0.1*i, dur):SetEase(Ease.OutElastic))
        current_height = current_height * bounce_factor
    end

    -- 吸附到最近角点
    local area = GetTargetArea(landing_pos, bridge.tableAreas)
    local corners = GetAreaCorners(area)
    local closest = GetClosestPoint(landing_pos, corners)

    bounce_seq:Append(transform:DOMove(closest, 0.3):SetEase(Ease.InQuad))
    bounce_seq:OnComplete(function()
        transform:DOKill()
        transform.localScale = Vector3.one
        -- 回收逻辑（可选）
        -- coin_obj:SetActive(false)
    end)
end

-- 辅助函数：查找目标区域
function GetTargetArea(pos, areas)
    for i=1, #areas do
        local area = areas[i]
        if area:Contains(pos) then
            return area
        end
    end
    return areas[1]
end

-- 辅助函数：获取矩形角点
function GetAreaCorners(area)
    local x, y = area.x, area.y
    local w, h = area.width, area.height
    return {
        Vector2(x, y),
        Vector2(x + w, y),
        Vector2(x, y + h),
        Vector2(x + w, y + h)
    }
end

-- 辅助函数：计算最近点
function GetClosestPoint(pos, points)
    local closest = points[1]
    local min_dist = (pos - closest).magnitude
    for i=2, #points do
        local dist = (pos - points[i]).magnitude
        if dist < min_dist then
            closest = points[i]
            min_dist = dist
        end
    end
    return closest
end