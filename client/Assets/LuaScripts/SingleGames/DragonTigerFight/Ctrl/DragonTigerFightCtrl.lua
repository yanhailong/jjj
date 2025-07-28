---
---Create by Administrator
---DateTime: 2025-06-21 15:09:13
---
---@class DragonTigerFightCtrl:BaseCtrl
local DragonTigerFightCtrl=Class("DragonTigerFightCtrl",BaseCtrl)
---@type DragonTigerFightConfig
local config=require("SingleGames/DragonTigerFight/DragonTigerFightConfig")
local DragonTigerFightSounds = require("SingleGames/DragonTigerFight/DragonTigerFightSounds")

---构造函数
function DragonTigerFightCtrl:ctor(ctrlName,param)
    self.layer=2;
    self.abName="SingleGames/DragonTigerFight/prefabs/DragonTigerFight";
    self.prefabName="DragonTigerFight"
    self.super.ctor(self,ctrlName,param);
	---@type DragonTigerFightView
	self.view = self.view
	---@type DragonTigerFightModel
	self.model = self.model
end

function DragonTigerFightCtrl:CtrlInit(args)
    self.super.CtrlInit(self, args)
    self:InitData()
end

function DragonTigerFightCtrl:InitData()
    ---@type CommFightBtnsCtrl
    self.commCtrl = CtrlManager.SingleShow(CtrlNames.CommFightBtns, self):AddAsyncOpenCallback(function()
        --请求进入房间
        self.model:ReqEnterRoom()
    end)
    self:BindCommFightData()
end

function DragonTigerFightCtrl:BindCommFightData()
    self.commCtrl:BindData(config,true,self.view.xiazhuStarAreas)
    self.commCtrl.OnClickHelp = function()
        CtrlManager.SingleShow(CtrlNames.DragonTigerFightRule)
    end
    self.commCtrl.OnClickClose = function()
        self:Close()
    end
    self.commCtrl.UpdateXiaZhuLabel = function() 
        self.view:UpdateXiaZhuLabel()
    end
    self.commCtrl.PayOtherXiaZhuCoinFlyEnd = function()
        --其余玩家筹码下注飞行音效
        DragonTigerFightSounds.OtherFlyBet()
    end
    self.commCtrl.PaySelfXiaZhuCoinFlyEnd = function()
        --下注音效
        DragonTigerFightSounds.PlaySoundEffic(config.AUDIO_KEY.ADD_CHIP)
    end
    self.commCtrl.PlayCompeleCoinFLyEnd = function()
        --分筹码音效
        DragonTigerFightSounds.PlaySoundEffic(config.AUDIO_KEY.END_COIN_FLY)
    end
    self.commCtrl.PlayCompeleCoinFLySelfEnd = function()
        -- 播放得奖音效
    end
end

function DragonTigerFightCtrl:AddUIEvent()
    self:AddFunctionButtons()
    self:AddAreaClickEvents()
end

function DragonTigerFightCtrl:AddFunctionButtons()
    self.uiEventListener:AddClick(self.view.btn_repeat, function() self:RepeatBet() end)
end

function DragonTigerFightCtrl:AddAreaClickEvents()
    local areaButtons = {self.view.longClickArea, self.view.huClickArea, self.view.heClickArea}
    for idx, btn in ipairs(areaButtons) do
        self.uiEventListener:AddClick(btn, function(obj) self:OnClickCenterYaZhuSide(idx) end)
    end
end

function DragonTigerFightCtrl:RepeatBet()
    if #config.lastXiaZhuInfo > 0 and not config.isRepeat then
        config.isRepeat = true
        local ReqBet = { reqBetBeans = {} }
        for _, info in ipairs(config.lastXiaZhuInfo) do
            if not config.allow or self.model.betPointList[info.index] > PlayerManager:GetPlayerInfo().goldNum then
                goto continue
            end
            table.insert(ReqBet.reqBetBeans, {betValue = self.model.betPointList[info.index],betAreaIdx=config.gameID*100+info.side} )
            ::continue::
        end
        self.view.btn_repeat.interactable = false
        self.model:Bet(ReqBet)
    end
end

---中心下注区域
function DragonTigerFightCtrl:OnClickCenterYaZhuSide(area)
    if config.allow == false then
        return
    end
    local ReqBet = {
        reqBetBeans = {
            {betValue = self.model.betPointList[config.dizhuIndex],betAreaIdx=config.gameID*100+area}
        }
    }
    self.model:Bet(ReqBet)
end


---移除UI事件
function DragonTigerFightCtrl:RemoveEvent()
	self.model:ExitRoom()
    self.super.RemoveEvent(self);
end

--region UI事件方法

--endregion


---销毁UI
function DragonTigerFightCtrl:RealCloseDestroy()
	self.super.RealCloseDestroy(self);
    self.commCtrl:Close()
end

return DragonTigerFightCtrl