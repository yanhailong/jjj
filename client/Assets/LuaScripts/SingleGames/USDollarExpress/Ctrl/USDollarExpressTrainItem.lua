---@class USDollarExpressTrainItem
local USDollarExpressTrainItem=Class("USDollarExpressTrainItem")

function USDollarExpressTrainItem:ctor(obj,ctrl)
    ---@type UnityEngine.GameObject
    self.gameObject = obj
    ---@type UnityEngine.Transform
    self.transform = obj.transform
    ---@type USDollarExpressCarCtrl
    self.ctrl=ctrl
    self:InitData()
end


function USDollarExpressTrainItem:InitData()
    self.isArriveCenterPos = false
    self.isArriveEndPos=false
end

function USDollarExpressTrainItem:SetText(value)
    --self.tmp_value.text = value
    local obj=self.ctrl.objPools:SpawnPrefab(nil,"SingleGames/USDollarExpress/prefabs/txt_TrainValue","txt_TrainValue",self.transform)
    self.txt_value= ComponentUtilGet.Text(obj)
    self.txt_value.transform.position=self.transform.position
    self.txt_value.transform.localRotation=Quaternion.Euler(0,180,0)
    self.txt_value.text = value
    
end

function USDollarExpressTrainItem:DOPlayerAni()
    --self.transform:DOScale(1.1, 0.2)
    ---@type UnityEngine.GameObject
    local objText=Tools.Instance(self.txt_value.gameObject,self.transform.parent.parent)
    local tempText=ComponentUtilGet.Text(objText.transform)
    tempText.text = self.txt_value.text
    tempText.transform:DOScale(1.1, 0.2)

    -- 创建动画序列
    local sequence = DOTween.Sequence()


    local midPos = -300
    local endPos =-650

    -- 最大放大比例
    local maxScale = 1.5
    local minScale=0.4


    ---@type DG.Tweening.Tween
    local tw= tempText.transform:DOLocalMoveY(endPos, 0.6)
            :SetEase(DG.Tweening.Ease.OutQuad)
    DOTween.To(function
    (val)
        tempText.transform.localScale = CS.UnityEngine.Vector3.one * val
    end,1,maxScale,0.3):OnComplete(function()
        -- 前半段放大完成后开始后半段缩小
        DOTween.To(function(val)
            tempText.transform.localScale = CS.UnityEngine.Vector3.one * val
        end, 1.5, 0.4, 0.3).onComplete= function
        ()
            logError("动画执行完毕！")
            local gold=tonumber(tempText.text)
            self.ctrl:Settmp_value(gold)
            objText:SetActive(false)
        end
    end)


    
    
    ---- 创建动画序列
    --local sequence = DOTween.Sequence()
    --
    ---- 前半段：移动到中间点并放大
    --sequence:Append(
    --        tempText.transform:DOLocalMoveY(midPos, 0.3)
    --                :SetEase(DG.Tweening.Ease.OutQuad)
    --)
    --sequence:Join(
    --        tempText.transform:DOScale(maxScale, 0.3) 
    --                :SetEase(DG.Tweening.Ease.OutQuad)
    --)
    --
    ---- 后半段：移动到终点并缩小
    --sequence:Append(
    --        tempText.transform:DOLocalMoveY(endPos, 0.3)
    --                :SetEase(DG.Tweening.Ease.InQuad)
    --)
    --sequence:Join(
    --        tempText.transform:DOScale(minScale, 0.3)
    --                :SetEase(DG.Tweening.Ease.InQuad
    --)
    --
    --sequence:OnComplete(function()
    --    logError("动画执行完毕！")
    --    local gold=tonumber(tempText.text)
    --    self.ctrl:Settmp_value(gold)
    --    objText:SetActive(false)
    --end)

    sequence:Play()
    self.txt_value.gameObject:SetActive(false)
    
    
    
end



function USDollarExpressTrainItem:MoveToPos(pos)
    self.transform:DOLocalMove(pos, 0.3)
end

return USDollarExpressTrainItem