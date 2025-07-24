---@class USDollarExpressSlotItem
local USDollarExpressSlotItem=Class("USDollarExpressSlotItem")
---@type USDollarExpressConfig
local config=require("SingleGames/USDollarExpress/USDollarExpressConfig")

function USDollarExpressSlotItem:ctor(go,ctrl)
    self.gameObject = go
    ---@type UnityEngine.Transform
    self.transform=self.gameObject.transform
    self.img_icon=ComponentUtilGet.Image(self.transform,"img_icon");
    --self.canvas=ComponentUtilGet.Canvas(self.transform)
    ---@type USDollarExpressMainCtrl
    self.ctrl=ctrl
    self.objDollers=resMgr:CreateGameObject("SingleGames/USDollarExpress/prefabs/txt_dollers","txt_dollers",self.transform)
    self.txt_dollers=ComponentUtilGet.Text(self.objDollers.transform)
    self.objDollers:SetActive(false)
    self:InitData()
end

function USDollarExpressSlotItem:InitData()
    self.dollarValue=0
end

---设置美元金额
function USDollarExpressSlotItem:SetDollar(bl,value)
    self.objDollers:SetActive(bl)
    if value then
        self.txt_dollers.text=Tools.numberToStrKM(value)
        self.dollarValue= value
    else
        self.dollarValue= 0
    end
end

function USDollarExpressSlotItem:SetSprite(icon,index)
    if icon=="" or icon==nil then
        logError("11111111111111")
    end
    self.img_icon.sprite=icon
    self.img_icon:SetNativeSize()
    self.iconIndex=index
    if config.gameTypeState==1 or config.gameTypeState==2 then
        self:SetItemMask(true)
    end
end

function USDollarExpressSlotItem:SetItemMask(isMask)
    if isMask==true then
        if self.iconIndex>=15 and self.iconIndex<=22 then
            self.transform:SetAsLastSibling()
        else
            self.transform:SetAsFirstSibling()
        end
    else
        self.transform:SetAsFirstSibling()
    end
end



function USDollarExpressSlotItem:SetSpriteColor(ishight)
    if ishight then
        self.img_icon.color=Color.white
    else
        self.img_icon.color=Color.New(118,118,118,255)
    end
end


function USDollarExpressSlotItem:InitIndex(index)
    self.index=index
end

function USDollarExpressSlotItem:SetActive(active)
    if self.gameObject==nil then
        return
    end
    if self.gameObject.activeSelf~=active then
        self.gameObject:SetActive(active);
    end
end
function USDollarExpressSlotItem:GetPosition()
    return self.transform.position
end
function USDollarExpressSlotItem:GetCurSprite()
    return self.img_icon.sprite
end
function USDollarExpressSlotItem:GetIconIndex()
    return self.iconIndex
end

---播放动画
function USDollarExpressSlotItem:SetIsAward(isAward)
    if false then
    else
        if isAward==true then
            if self.iconEffect==nil then
                local effectName=config.iconEffect[self.iconIndex]
                --logError("effectName"..effectName)
                ---@type UnityEngine.GameObject
                self.iconEffect= self.ctrl.objPools:SpawnPrefab(nil, config.ABNames.iconEffect,effectName, self.ctrl.view.rootEffects)
                self.iconEffect.transform.position=self.transform.position
                local sp=ComponentUtilGet.SkeletonGraphic(self.iconEffect.transform,"Spine_Chess")
                if self.iconIndex>=12 and self.iconIndex<=14 then

                    CorManager.StartCor(self.ctrl, function
                    ()
                        Tools.PlayerSpineAniByName(sp,"action",false)
                        coroutine.wait(1.233)
                        Tools.PlayerSpineAniByName(sp,"loop",true)
                    end)
                elseif self.iconIndex==18  then
                    CorManager.StartCor(self.ctrl, function
                    ()
                        Tools.PlayerSpineAniByName(sp,"action",false)
                        coroutine.wait(0.5)
                        Tools.PlayerSpineAniByName(sp,"idle",true)
                    end)
                elseif self.iconIndex==16 then
                    CorManager.StartCor(self.ctrl, function
                    ()
                        Tools.PlayerSpineAniByName(sp,"action",false)
                        coroutine.wait(0.667)
                        Tools.PlayerSpineAniByName(sp,"xunhuan",true)
                    end)
                elseif self.iconIndex>=19 and self.iconIndex<=22 then
                    CorManager.StartCor(self.ctrl, function
                    ()
                        Tools.PlayerSpineAniByName(sp,"action",false)
                        coroutine.wait(0.667)
                        Tools.PlayerSpineAniByName(sp,"loop",true)
                    end)
                elseif self.iconIndex==15 then
                    CorManager.StartCor(self.ctrl, function
                    ()
                        Tools.PlayerSpineAniByName(sp,"action",false)
                        coroutine.wait(0.5)
                        Tools.PlayerSpineAniByName(sp,"loop",true)
                    end)
                else
                    Tools.PlayerSpineAniByName(sp,"action",true)
                end

                if self.iconIndex==18 then
                    local txt_dollars=ComponentUtilGet.Text(self.iconEffect.transform,"txt_dollers")
                    txt_dollars.gameObject:SetActive(true)
                    --ComponentUtilGet.GameObject(dollar.transform,"effect_jinzhuan_trail"):SetActive(false)
                    txt_dollars.text=Tools.numberToStrKM(self.dollarValue)
                    self.objDollers:SetActive(false)
                end
                if self.iconIndex==17 then
                    --SoundManager:PlayClip(config.ABNames.audios.."reel_notify1")
                    config.aboradCount=config.aboradCount+1
                    if config.aboradCount<=5 then
                        SoundManager:PlayClip(config.ABNames.audios.."scatter_appear"..config.aboradCount)
                    end
                end
            end
        else
            if self.iconEffect then
                self.ctrl.objPools:UnSpawnPrefab(self.iconEffect)
                self.iconEffect=nil
            end
        end
        Tools.SetActive(self.img_icon.gameObject,not isAward)
    end

end

function USDollarExpressSlotItem:DollarsFlyTo(pos)
    if self.iconIndex==18 then
        local txt_dollars=ComponentUtilGet.Text(self.iconEffect.transform,"txt_dollers")
        txt_dollars.gameObject:SetActive(false)
        ---@type  UnityEngine.GameObject
        local dollar= self.ctrl.objPools:SpawnPrefab(nil, "SingleGames/USDollarExpress/prefabs/txt_dollers","txt_dollers", self.ctrl.buttomCtrl.view.effects)
        dollar.transform.position=self.transform.position
        ComponentUtilGet.Text(dollar.transform).text=txt_dollars.text
        ComponentUtilGet.GameObject(dollar.transform,"effect_jinzhuan_trail"):SetActive(true)
        ---@type DG.Tweening.Tween
        self.twDollars= dollar.transform:DOMove(pos,0.5)
        self.twDollars.onComplete= function
        ()
            self.ctrl.objPools:UnSpawnPrefab(dollar)
            self.ctrl:RefreshRepeatWin(self.dollarValue)
            CorManager.StartCor(self.ctrl, function
            ()
                ---@type  UnityEngine.GameObject
                local effect_jinzhuan_trail_bd= self.ctrl.objPools:SpawnPrefab(nil, "SingleGames/USDollarExpress/effects/prefab/effect_jinzhuan_trail_bd","effect_jinzhuan_trail_bd", self.ctrl.buttomCtrl.view.effects)
                effect_jinzhuan_trail_bd.transform.position=pos
                coroutine.wait(1.3)
                self.ctrl.objPools:UnSpawnPrefab(effect_jinzhuan_trail_bd)
            end)
        end
    end
end

return USDollarExpressSlotItem