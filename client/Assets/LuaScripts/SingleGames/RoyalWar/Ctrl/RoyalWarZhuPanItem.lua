---@class RoyalWarZhuPanItem
local RoyalWarZhuPanItem = Class("RoyalWarZhuPanItem")
---@type RoyalWarConfig
local config=require("SingleGames/RoyalWar/RoyalWarConfig")
local DOTween = CS.DG.Tweening.DOTween
local loopType =  CS.DG.Tweening.LoopType;

function RoyalWarZhuPanItem:ctor(obj,ctrl)
    ---@type ObjectPoolUtil
    self.objPools=ObjectPoolUtil.New()
    ---@type UnityEngine.GameObject
    self.gameObject = obj
    ---@type UnityEngine.Transform
    self.transform = obj.transform
    self.obj_Red = ComponentUtilGet.GameObject(self.transform,"obj_Red")
    self.obj_Black = ComponentUtilGet.GameObject(self.transform,"obj_Black")
    ---@type RoyalWarGameCtrl
    self.ctrl=ctrl
end
---初始化状态
function RoyalWarZhuPanItem:InitState()
    self.obj_Red:SetActive(false);
    self.obj_Black:SetActive(false);
end

---刷新显示
function RoyalWarZhuPanItem:RefreshShow(data,isFirst)
    self.obj_Red:SetActive(data[1]==1);
    self.obj_Black:SetActive(data[1]==2);
    if(isFirst) then
        local image;
        if(data[1]==1) then
            image = ComponentUtilGet.Image(self.obj_Red);
        else
            image = ComponentUtilGet.Image(self.obj_Black);
        end
        self.zhuPanSequence = DOTween.Sequence()
        self.zhuPanSequence:Append(image:DOFade(0,0.5))
        self.zhuPanSequence:SetLoops(6,loopType.Yoyo)
        self.zhuPanSequence:Play();
    end
    
end

function RoyalWarZhuPanItem:Destroy()
    if self.zhuPanSequence~=nil then
        self.zhuPanSequence:Kill();
    end
end

return RoyalWarZhuPanItem