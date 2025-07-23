---
---Create by Administrator
---DateTime: 2025-06-21 15:09:13
---
---@class DragonTigerFightCtrl:BaseCtrl
local DragonTigerFightCtrl=Class("DragonTigerFightCtrl",BaseCtrl)
---@type DragonTigerFightConfig
local config=require("SingleGames/DragonTigerFight/DragonTigerFightConfig")

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
    
end


function DragonTigerFightCtrl:AddUIEvent()
    self:AddFunctionButtons()
    self:AddBetButtons()
    self:AddAreaClickEvents()
end

function DragonTigerFightCtrl:AddFunctionButtons()
    self.uiEventListener:AddClick(self.view.btn_close, function() self:Close() end)
    self.uiEventListener:AddClick(self.view.btn_muen,function() self.view:SettingFade()  end)
    self.uiEventListener:AddClick(self.view.btn_touch,function() self.view:SettingFade()  end)
    self.uiEventListener:AddClick(self.view.btn_help, function() CtrlManager.SingleShow(CtrlNames.DragonTigerFightRule) end)
    self.uiEventListener:AddClick(self.view.btn_setting, function() look("打开设置界面") end)
    self.uiEventListener:AddClick(self.view.btn_players, function()
        --CtrlManager.SingleShow(CtrlNames.DragonTigerFightPlayerRank)
    end)
    self.uiEventListener:AddClick(self.view.btn_repeat, function() self:RepeatBet() end)
    self.uiEventListener:AddClick(self.view.btn_prev,function()  self.view:DizhuPrev(false) end)
    self.uiEventListener:AddClick(self.view.btn_next,function()  self.view:DizhuPrev(true) end)
end


function DragonTigerFightCtrl:AddBetButtons()
    for i, chipInfo in ipairs(self.view.chipInfos) do
        self.uiEventListener:AddClick(chipInfo.button, function()
            if config.allow then
                self.view:ChangeDiZhu(i)
                look("btn 抵住数值" .. config.dizhuNumArr[config.dizhuIndex])
            end
        end)
    end
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
            if not config.allow or config.dizhuNumArr[info.index] > PlayerManager:GetPlayerInfo().goldNum then
                break
            end
            table.insert(ReqBet.reqBetBeans, {betValue = self.model.betPointList[info.index],betAreaIdx=config.gameID*100+info.side} )
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
end

return DragonTigerFightCtrl