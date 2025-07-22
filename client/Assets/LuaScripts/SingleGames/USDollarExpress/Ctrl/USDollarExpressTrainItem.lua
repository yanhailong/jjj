---@class USDollarExpressTrainItem
local USDollarExpressTrainItem=Class("USDollarExpressTrainItem")
---@type USDollarExpressConfig
local config=require"SingleGames/USDollarExpress/USDollarExpressConfig"
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
    self.ishasJackpot=false
end

function USDollarExpressTrainItem:SetText(value,jackPotVale)
    if self.ctrl:GetJackPotId(value)>0 then
        logError("最后一节车厢中奖池")
        self.jackpotvalue=jackPotVale
        self.poolId=value
        self.twObj=self.ctrl.objPools:SpawnPrefab(nil,"SingleGames/USDollarExpress/prefabs/img_traincar","img_traincar",self.transform)
        self.img_jackpot= ComponentUtilGet.Image(self.twObj)
        self.img_jackpot.sprite=resMgr:LoadSprite("SingleGames/USDollarExpress/alats/lang_english",config.jackPotPicName[self.poolId])
        self.img_jackpot:SetNativeSize()
        self.img_jackpot.transform.position=self.transform.position
        self.img_jackpot.transform.localRotation=Quaternion.Euler(0,180,0)
        self.ishasJackpot=true
    else
        self.twObj=self.ctrl.objPools:SpawnPrefab(nil,"SingleGames/USDollarExpress/prefabs/txt_TrainValue","txt_TrainValue",self.transform)
        self.txt_value= ComponentUtilGet.Text(self.twObj)
        self.txt_value.transform.position=self.transform.position
        self.txt_value.transform.localRotation=Quaternion.Euler(0,180,0)
        self.curValue=value
        self.txt_value.text = Tools.numberToStrKM(value)
        self.ishasJackpot=false
    end

    
end

--function USDollarExpressTrainItem:DOPlayerAni()
--
--    self.twObj.transform:SetParent(self.transform.parent.parent)
--    self.twObj.transform:DOScale(1.1, 0.2)
--    -- 创建动画序列
--    local sequence = DOTween.Sequence()
--    local midPos = self.ctrl.view.trans_txtMidd.position
--    local endPos =self.ctrl.view.txt_value.transform.position
--    -- 最大放大比例
--    local maxScale = 1.5
--    local minScale=0.45
--
--
--    ---@type DG.Tweening.Tween
--    local tw= self.twObj.transform:DOMove(endPos, 0.6)
--            :SetEase(DG.Tweening.Ease.OutQuad)
--    local tw1= DOTween.To(function
--    (val)
--        self.twObj.transform.localScale = CS.UnityEngine.Vector3.one * val
--    end,1,maxScale,0.3):OnComplete(function()
--        -- 前半段放大完成后开始后半段缩小
--        DOTween.To(function(val)
--            self.twObj.transform.localScale = CS.UnityEngine.Vector3.one * val
--        end, 1.5, 0.4, 0.3).onComplete= function
--        ()
--            logError("动画执行完毕！")
--            if self.ishasJackpot==true then
--                logError("这一节车厢是奖池.....")
--                if self.jackpotvalue and self.jackpotvalue>0 then
--                    local data={}
--                    data.poolId=self.poolId
--                    data.jackpotvalue=self.jackpotvalue
--                    CtrlManager.SingleShow(CtrlNames.USDollarExpressJackPots,data)
--                else
--                    logError("数据错误了.....！")
--                end
--                
--            else
--                self.ctrl:Settmp_value(self.curValue)
--                self.twObj:SetActive(false)
--            end
--
--        end
--    end)
--    sequence:Play()
--end

function USDollarExpressTrainItem:DOPlayerAni()
    
    local ani= ComponentUtilGet.Animator(self.transform,"chesuofang")
    ani:Play("chexiang_xuanzhong",0)
    self.twObj.transform:SetParent(self.transform.parent.parent)
    self.twObj.transform:DOScale(1.1, 0.2)

    local midPos = self.ctrl.view.trans_txtMidd.position
    local endPos = self.ctrl.view.txt_value.transform.position
    local maxScale = 1.5

    ---@type DG.Tweening.Tween
    local tw = self.twObj.transform:DOMove(endPos, 0.6):SetEase(DG.Tweening.Ease.OutQuad)
    local tw1 = DOTween.To(function(val)
        self.twObj.transform.localScale = CS.UnityEngine.Vector3.one * val
    end, 1, maxScale, 0.3):OnComplete(function()
        local tw2= DOTween.To(function(val)
            self.twObj.transform.localScale = CS.UnityEngine.Vector3.one * val
        end, maxScale, 0.4, 0.3):OnComplete(function()
            if self.ishasJackpot==true then
                if self.jackpotvalue and self.jackpotvalue > 0 then
                    local data = {}
                    data.poolId = self.poolId
                    data.jackpotvalue = self.jackpotvalue
                    data.func=function()
                        self.ctrl:NextStep()
                    end
                    CtrlManager.SingleShow(CtrlNames.USDollarExpressJackPots, data)
                else
                    logError("数据错误了.....！")
                end
                self.twObj:SetActive(false)
            else
                self.ctrl:Settmp_value(self.curValue)
                self.twObj:SetActive(false)
            end
        end)
        table.insert(self.ctrl.allTweens, tw2)
    end)
    
    table.insert(self.ctrl.allTweens, tw)
    table.insert(self.ctrl.allTweens, tw1)
end

function USDollarExpressTrainItem:MoveToPos(pos)
    self.transform:DOLocalMove(pos, 0.3)
end

return USDollarExpressTrainItem