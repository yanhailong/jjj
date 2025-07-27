
---@class CarLogoItem
local CarLogoItem=Class("CarLogoItem")
local CarLogoHelper=require("SingleGames/CarLogo/CarLogoHelper")
local Vector3 = CS.UnityEngine.Vector3
local DOTween = CS.DG.Tweening.DOTween
local Ease = CS.DG.Tweening.Ease

function CarLogoItem:ctor(go,luaClass)
    self.luaClass = luaClass
    self.transform=go.transform
    self.bg = ComponentUtilGet.Image(self.transform, "LogoBg")
    self.image = ComponentUtilGet.Image(self.transform, "Icon");
    self.choose = ComponentUtilGet.GameObject(self.transform,"effect_CarLogo_xz_bk"):GetComponent("ParticleSystem");
    
    self.choose.gameObject:SetActive(true)
    self.image.transform.localScale = Vector3(0.56,0.56,1)
    self:ShowChoose(false)
end

function CarLogoItem:FlyLogoHistory(result,target)
    local gameObj = Tools.Instance(self.image.gameObject)
    gameObj.transform:SetParent(result,false)
    gameObj.transform.localScale = Vector3(0.56,0.56,1);
    gameObj.transform.position = self.transform.position;
    gameObj.transform:DOMove(target,1):SetEase(Ease.InOutQuad):OnComplete(function ()
        Tools.Destroy(gameObj)
    end);
end

---
function CarLogoItem:ShowLogo(logo_id)
    self.image.sprite = CarLogoHelper.LoadLogoSprite(logo_id);
    
    self.logoId = logo_id;
end

--显示选中
function CarLogoItem:ShowChoose(state, doTween)
    if state then
        if doTween then
            self.choose.gameObject:SetActive(false)
            -- 选中的图标由大变小效果
            self:DOFade(false)
        else
            self.choose.gameObject:SetActive(true)
            if self.choose.isStopped  then
                self.choose:Play();
            end
            -- 选中的图标由大变小效果
            self:DOFade(true)
        end
    else
        self.choose.gameObject:SetActive(false)
        self:DOFade(false)
    end
end

---閃燈
function CarLogoItem:FlashLight(time,fadeTimes)
    --self:ShowChoose(false)
    --Tools.DOFade_Repeat(self.choose,time,fadeTimes,0,function()
    --    Tools.SetColorAlpha_Float(self.choose, 0)
    --end)
    local t = fadeTimes
    self.choose.gameObject:SetActive(true)
    if self.choose.isStopped  then
        self.choose:Play();
    end
    TimerManager.StartTimer(self.luaClass,function()
        self.choose:Stop();
        self.choose.gameObject:SetActive(false)
    end,t)
end

--- 选中的图标由大变小效果
function CarLogoItem:DOFade(doTween)
    if doTween then
        -- 选中的图标由大变小效果
        self.transform.localScale = Vector3(1.12,1.12,1)
        DG.Tweening.DOTween.Sequence():Append(self.transform:DOScale(1, 0.4)):OnComplete(
                function() self.transform.localScale = Vector3(1,1,1) end)
    else
        self.transform.localScale = Vector3(1,1,1)
    end
end


return CarLogoItem