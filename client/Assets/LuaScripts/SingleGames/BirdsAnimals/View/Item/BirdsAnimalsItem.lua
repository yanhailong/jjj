
---@class BirdsAnimalsItem
local BirdsAnimalsItem=Class("BirdsAnimalsItem")
local BirdsAnimalsHelper=require("SingleGames/BirdsAnimals/BirdsAnimalsHelper")
local BirdsAnimalsConfig=require("SingleGames/BirdsAnimals/BirdsAnimalsConfig")
local Vector3 = CS.UnityEngine.Vector3
local DOTween = CS.DG.Tweening.DOTween
local Ease = CS.DG.Tweening.Ease

function BirdsAnimalsItem:ctor(trs)
    self.transform=trs
    self.bg = ComponentUtilGet.Image(self.transform, "LogoBg")
    self.image = ComponentUtilGet.Image(self.transform, "Icon");
    self.choose = ComponentUtilGet.Image(self.transform,"Choose");
    self.Rate = ComponentUtilGet.Image(self.transform,"Rate")
    self.Text = ComponentUtilGet.Text(self.transform,"Text")
    self.choose.gameObject:SetActive(true)
    self.Rate.gameObject:SetActive(false)
    self.Text.gameObject:SetActive(false)
    self:ShowChoose(false)
end

function BirdsAnimalsItem:FlyLogoHistory(result,target)
    local gameObj = Tools.Instance(self.image.gameObject)
    gameObj.transform:SetParent(result)
    gameObj.transform.localScale = Vector3(0.52,0.52,1);
    gameObj.transform.position = self.transform.position;
    gameObj.transform:DOMove(target,1):SetEase(Ease.InOutQuad):OnComplete(function ()
        Tools.Destroy(gameObj)
    end);
end

---
function BirdsAnimalsItem:ShowLogo(logo_id)
    self.image.sprite = BirdsAnimalsHelper.LoadLogoSprite(logo_id);
    self.image:SetNativeSize()
    if logo_id==BirdsAnimalsConfig.ANIMAL_TYPE.JINSHA  or logo_id==BirdsAnimalsConfig.ANIMAL_TYPE.YINSHA then
        self.Text.text="X100"
        self.Text.gameObject:SetActive(true)
    elseif logo_id==BirdsAnimalsConfig.ANIMAL_TYPE.TONGPEI then
        self.Rate.sprite = BirdsAnimalsHelper.LoadTxtSprite("fqzs_txt_take")
        self.Rate.gameObject:SetActive(true)
    elseif logo_id==BirdsAnimalsConfig.ANIMAL_TYPE.TONGSHA then
        self.Rate.sprite = BirdsAnimalsHelper.LoadTxtSprite("fqzs_txt_pay")
        self.Rate.gameObject:SetActive(true)
    end
    self.logoId = logo_id;
end


--显示选中
function BirdsAnimalsItem:ShowChoose(state, doTween)
    if state then
        if doTween then
            Tools.SetColorAlpha_Float(self.choose, 0)
            -- 选中的图标由大变小效果
            self:DOFade(false)
        else
            Tools.SetColorAlpha_Float(self.choose, 1)
            -- 选中的图标由大变小效果
            self:DOFade(true)
        end
    else
        Tools.SetColorAlpha_Float(self.choose, 0)
        self:DOFade(false)
    end
end

---閃燈
function BirdsAnimalsItem:FlashLight(time,fadeTimes,delayTime)
    self:ShowChoose(false)
    Tools.DOFade_Repeat(self.choose,time,fadeTimes,delayTime,function() self:ShowChoose(false) end)
end

--- 选中的图标由大变小效果
function BirdsAnimalsItem:DOFade(doTween)
    if doTween then
        -- 选中的图标由大变小效果
        self.transform.localScale = Vector3(1.12,1.12,1)
        DG.Tweening.DOTween.Sequence():Append(self.transform:DOScale(1, 0.4)):OnComplete(
                function() self.transform.localScale = Vector3(1,1,1) end)
    else
        self.transform.localScale = Vector3(1,1,1)
    end
end


return BirdsAnimalsItem