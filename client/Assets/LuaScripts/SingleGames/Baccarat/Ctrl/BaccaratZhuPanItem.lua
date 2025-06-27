
---@class BaccaratZhuPanItem
local BaccaratZhuPanItem=Class("BaccaratZhuPanItem")
---@type BaccaratConfig
local config=require("SingleGames/Baccarat/BaccaratConfig")
local DOTween = CS.DG.Tweening.DOTween
local loopType =  CS.DG.Tweening.LoopType;

function BaccaratZhuPanItem:ctor(obj,ctrl)
    ---@type ObjectPoolUtil
    self.objPools=ObjectPoolUtil.New()
    ---@type UnityEngine.GameObject
    self.gameObject = obj
    ---@type UnityEngine.Transform
    self.transform = obj.transform
    self.obj_Banker = ComponentUtilGet.GameObject(self.transform,"obj_Banker")
    self.obj_Player = ComponentUtilGet.GameObject(self.transform,"obj_Player")
    self.obj_Tie = ComponentUtilGet.GameObject(self.transform,"obj_Tie")
    self.obj_PlayerPoint = ComponentUtilGet.GameObject(self.transform,"obj_PlayerPoint")
    self.obj_BankerPoint = ComponentUtilGet.GameObject(self.transform,"obj_BankerPoint")
    ---@type USDollarExpressCarCtrl
    self.ctrl=ctrl
end
---初始化状态
function BaccaratZhuPanItem:InitState()
    self.obj_Banker:SetActive(false);
    self.obj_Player:SetActive(false);
    self.obj_Tie:SetActive(false);
    self.obj_PlayerPoint:SetActive(false);
    self.obj_BankerPoint:SetActive(false);
end

---刷新显示
function BaccaratZhuPanItem:RefreshShow(data,isFlicker)
    self.obj_Banker:SetActive(data[1]  == config.WhoWin.BankerWin);
    self.obj_Player:SetActive(data[1]  == config.WhoWin.PlayerWin);
    self.obj_Tie:SetActive(data[1]  == config.WhoWin.TieWin);
    self.obj_BankerPoint:SetActive(data[2]);
    self.obj_PlayerPoint:SetActive(data[3]);
    if(isFlicker) then
        local image;
        if(data[1] == config.WhoWin.BankerWin) then
            image = ComponentUtilGet.Image(self.obj_Banker);
        elseif (data[1] == config.WhoWin.PlayerWin) then
            image = ComponentUtilGet.Image(self.obj_Player);
        elseif (data[1] == config.WhoWin.TieWin) then
            image = ComponentUtilGet.Image(self.obj_Tie);
        end
        self.zhuPanSequence = DOTween.Sequence()
        self.zhuPanSequence:Append(image:DOFade(0,0.5))
        self.zhuPanSequence:SetLoops(6,loopType.Yoyo)
        self.zhuPanSequence:Play();
    end
end

function BaccaratZhuPanItem:Destroy()
    if self.zhuPanSequence~=nil then
        self.zhuPanSequence:Kill();
    end
end

return BaccaratZhuPanItem;