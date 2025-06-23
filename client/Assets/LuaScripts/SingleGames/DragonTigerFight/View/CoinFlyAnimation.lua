--
--time:{time}
--{paramdesc} 
--@desc 
--
---@class CoinFlyAnimation
local CoinFlyAnimation=Class("CoinFlyAnimation")

local DOTween = CS.DG.Tweening.DOTween
local Sequence = CS.DG.Tweening.Sequence
local Ease = CS.DG.Tweening.Ease
local RotateMode = CS.DG.Tweening.RotateMode
local Rect = UnityEngine.Rect

---@type ObjectPoolUtil
local pool = ObjectPoolUtil:New("CoinFlyAnimation")

local config = {
    min_throw_force = 0.8,
    max_throw_force = 1.2,
    base_throw_duration = 0.8,
    base_jump_height = 0.4,
    bounce_factor = 0.7,
    max_bounces = 1,
    color_anim = true, -- 是否开启颜色动画
       table_y = -0.5, -- 桌面Y轴高度
       max_pool_size = 50 -- 对象池最大容量
}

-- 抛射金币（支持类型参数）
function CoinFlyAnimation:AnimateCoin(coin,coin_type,start_pos,target)
    ---@type UnityEngine.GameObject
    local go = pool:Spawn(nil, coin)
    if not go then return end
    go:SetActive(true)
    go.transform:SetParent(target,false)
    
    for i=1,5 do
        if coin_type==i then
            ComponentUtilGet.GameObject(go.transform,"img_"..i):SetActive(true)
        else
            ComponentUtilGet.GameObject(go.transform,"img_"..i):SetActive(false) 
        end
    end
    ---go.transform.localPosition = parent:InverseTransformPoint(start_pos)
    go.transform.position = start_pos
    go.transform.localScale = UnityEngine.Vector3(1,1, 1)
    -- 随机参数
    local force = math.random() * (config.max_throw_force - config.min_throw_force) + config.min_throw_force
    local duration = config.base_throw_duration * force
    local jump_height = config.base_jump_height * force
    look(target.position)
    local target_area = target.rect;
    target_area.x = target.localPosition.x-target_area.width/2;
    target_area.y = target.localPosition.x-target_area.height/2;
    -- 随机目标区域
    local end_pos = UnityEngine.Vector3(
            Tools.Random(0,target_area.width)  + target_area.x , 
            Tools.Random(0,target_area.height) + target_area.y,
            100
    )
    end_pos = target:TransformPoint(end_pos)
    
    -- 抛射动画
    local throw_seq = DOTween.Sequence()
    --throw_seq:Append(go.transform:DOJump(end_pos, jump_height, 1, duration):SetEase(Ease.OutQuad))
    throw_seq:Append(go.transform:DOMove(end_pos, 1):SetEase(Ease.OutQuad))
    throw_seq:Join(go.transform:DORotate(UnityEngine.Vector3(0, 0, 360 * force), duration, RotateMode.FastBeyond360):SetEase(Ease.Linear))
    throw_seq:SetLink(go)
    throw_seq:OnComplete(function() self:StartBounceAnimation(go.transform, end_pos, force, target_area) end)
    end

-- 弹跳动画
function CoinFlyAnimation:StartBounceAnimation(transform, landing_pos, force, area)
    local go = transform.gameObject
    local bounce_seq = DOTween.Sequence()
    local current_height = 0.2 * force
    local scale = 1.5
    -- 链式弹跳
    for i=1, config.max_bounces do
        local dur = 0.2 * config.bounce_factor^(i-1)
        bounce_seq:Append(transform:DOMoveY(landing_pos.y + current_height, dur/2))
        bounce_seq:Append(transform:DOMoveY(landing_pos.y, dur/2))
        bounce_seq:Join(transform:DOScale(scale * (1 - 0.1*i), dur):SetEase(Ease.OutElastic))
        current_height = current_height * config.bounce_factor
    end
    
end


return CoinFlyAnimation