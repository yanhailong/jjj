--
--time:{time}
--{paramdesc} 
--@desc 
--
---@class CardItem
local CardItem=Class("CardItem")
local DOTween = CS.DG.Tweening.DOTween
local Ease = CS.DG.Tweening.Ease
local Vector3 = CS.UnityEngine.Vector3
local DragonTigerFightSounds = require("SingleGames/DragonTigerFight/DragonTigerFightSounds")

function CardItem:ctor(go)
    self.gameObject = go
    ---@type UnityEngine.Transform
    self.transform=self.gameObject.transform
    self.front=ComponentUtilGet.GameObject(self.transform,"front")
    self.back=ComponentUtilGet.GameObject(self.transform,"back")
    self.img_front=ComponentUtilGet.Image(self.transform,"front")
    self.img_back=ComponentUtilGet.Image(self.transform,"back")
    self:Hiden()
end

function CardItem:LoadCard(carIndex)
    
    if carIndex<1 or carIndex>52 then return end
    self.carIndex = carIndex
    local assetName =  "card_"..carIndex
    local cardsPath = "Common/GameArtsCommon/GameFight/alats/card"

    self.img_front.sprite = resMgr:LoadSprite(cardsPath,assetName)
    --self.img_front:SetNativeSize()
    self.img_back.sprite = resMgr:LoadSprite(cardsPath,"pai_beim")
    --self.img_back:SetNativeSize()
end

function CardItem:ShowFront()
    self:ShowBack()
    
    local seq = DOTween.Sequence()
    :Append(self.transform:DOScale(Vector3(1.2, 1.2, 1), 0.3):SetEase(Ease.OutQuad))
    :Append(self.transform:DOLocalRotate(Vector3(0,90,0), 0.3, CS.DG.Tweening.RotateMode.Fast))
    :AppendCallback(function()
        self.back:SetActive(false)
        self.front:SetActive(true) -- 显示正面
    end)
    :Append(self.transform:DOLocalRotate(Vector3(0,0,0), 0.3, CS.DG.Tweening.RotateMode.Fast))
    :Append(self.transform:DOScale(Vector3(1, 1, 1), 0.3):SetEase(Ease.OutQuad))
    seq:OnComplete(function()
        seq:Kill(false)
        --翻盘音效
        DragonTigerFightSounds.PlaySoundCard(self.carIndex or 1)
    end)
    :Play()
end

function CardItem:ShowBack()
    self.front:SetActive(false)
    self.back:SetActive(true)
    self.transform.localScale = Vector3(1, 1, 1)
end

function CardItem:Hiden()
    self.front:SetActive(false)
    self.back:SetActive(false)
end

--- 进场动画
--- @param p0 起点 Vector3
--- @param p1 控制点 Vector3
--- @param p2 终点 Vector3
function CardItem:Approach(p0,p1,p2)
    if p2 == nil then p2 = self.transform.position end
    
    self.transform.position = p0;
    self:ShowBack()
    -- 生成曲线坐标 
    local path = CardItem.GenerateBezierCurve(p0, p1, p2, 10)

    -- 使用DOTween执行路径动画（在Unity的Lua环境中调用）
    local seq = DOTween.Sequence()
    seq:Append(self.transform:DOPath(path, 1))  -- 3秒内沿路径移动
       :SetEase(Ease.InBack)  -- 缓动效果
    seq:Play()
end

--- 生成二次贝塞尔曲线坐标
--- @param p0 起点Vector3
--- @param p1 控制点Vector3
--- @param p2 终点 Vector3
--- @param segments: 分段数点数=segments+1，默认10段
--- @return Vector3数组
function CardItem.GenerateBezierCurve(p0, p1, p2, segments)
    segments = segments or 10  -- 默认10个分段
    local path = {}
    for i = 0, segments do
        local t = i / segments  -- 参数t从0到1
        local oneMinusT = 1 - t
        -- 计算贝塞尔曲线坐标
        local x = oneMinusT * oneMinusT * p0.x +
                2 * oneMinusT * t * p1.x +
                t * t * p2.x
        local y = oneMinusT * oneMinusT * p0.y +
                2 * oneMinusT * t * p1.y +
                t * t * p2.y
        local z = oneMinusT * oneMinusT * p0.z +
                2 * oneMinusT * t * p1.z +
                t * t * p2.z
        table.insert(path, Vector3(x, y, z))
    end
    return path
end

return CardItem