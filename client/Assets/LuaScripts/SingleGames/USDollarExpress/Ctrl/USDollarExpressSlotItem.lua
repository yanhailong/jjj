---@class USDollarExpressSlotItem
local USDollarExpressSlotItem=Class("USDollarExpressSlotItem")
---@type USDollarExpressConfig
local config=require("SingleGames/USDollarExpress/USDollarExpressConfig")

function USDollarExpressSlotItem:ctor(go,ctrl)
    self.gameObject = go
    ---@type UnityEngine.Transform
    self.transform=self.gameObject.transform
    self.img_icon=ComponentUtilGet.Image(self.transform,"img_icon");
    self.canvas=ComponentUtilGet.Canvas(self.transform)
    ---@type USDollarExpressMainCtrl
    self.ctrl=ctrl
end

function USDollarExpressSlotItem:SetSprite(icon,index)
    if icon=="" or icon==nil then
        logError("11111111111111")
    end
    self.img_icon.sprite=icon
    self.img_icon:SetNativeSize()
    self.iconIndex=index
    if config.gameTypeState==1 then
        if self.iconIndex>=15 and self.iconIndex<=22 then
            self.canvas.sortingOrder=3
        else
            self.canvas.sortingOrder=2
        end
    else
        self.canvas.sortingOrder=2
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
    
    if isAward==true then
        if self.iconEffect==nil then
            local effectName=config.iconEffect[self.iconIndex]
            --logError("effectName"..effectName)
            ---@type UnityEngine.GameObject
            self.iconEffect= self.ctrl.objPools:SpawnPrefab(nil, config.ABNames.iconEffect,effectName, self.ctrl.view.rootEffects)
            self.iconEffect.transform.position=self.transform.position
            local sp=ComponentUtilGet.SkeletonGraphic(self.iconEffect.transform,"Spine_Chess")
            if self.iconIndex>=16 and self.iconIndex<=18 then
                
                CorManager.StartCor(self.ctrl, function
                ()
                    Tools.PlayerSpineAniByName(sp,"action",false)
                    coroutine.wait(1.233)
                    Tools.PlayerSpineAniByName(sp,"loop",true)
                end)
            else
                Tools.PlayerSpineAniByName(sp,"action",true)
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

return USDollarExpressSlotItem