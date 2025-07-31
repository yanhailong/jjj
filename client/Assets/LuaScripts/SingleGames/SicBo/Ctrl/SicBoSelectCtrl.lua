---
---Create by Administrator
---DateTime: 2025-07-31 17:40:22
---
---@class SicBoSelectCtrl:BaseCtrl
local SicBoSelectCtrl = Class("SicBoSelectCtrl", BaseCtrl)
local UICommonSelectionItem = require("SingleGames/SicBo/SicBoCustom/SelectionItem")
---构造函数
function SicBoSelectCtrl:ctor(ctrlName, param)
    self.layer = 2;
    self.abName = "SingleGames/SicBo/prefabs";
    self.prefabName = "SicBoSelectPanel"
    self.super.ctor(self, ctrlName, param);
    ---@type SicBoSelectView
    self.view = self.view
    ---@type SicBoSelectModel
    self.model = self.model
end

---初始化
function SicBoSelectCtrl:CtrlInit(args)
    self.super.CtrlInit(self, args);
    self:InitData()
end

---初始化数据
function SicBoSelectCtrl:InitData()
    self.view.GoldNumber.text = PlayerManager:GetPlayerInfo().goldNum
    self.objselects = {}
    local group = ComponentUtilGet.Transform(self.view.transform, "content/center")
    for i = 1, 3 do
        local trs = group:GetChild(i - 1)
        local item = UICommonSelectionItem.New(trs, self)
        item:SetActive(false)
        self.objselects[i] = item
    end

    local wareHouseList = self.subGame.wareHouseList
    for i = 1, #wareHouseList do
        local item = self.objselects[i]
        if item then
            item:SetActive(true)
            item:InitData(wareHouseList[i])
            self.uiEventListener:AddClick(item.gameObject, function()
                self:OnClickItem(wareHouseList[i].wareId);
            end);
        end
    end
end

function SicBoSelectCtrl:Close()
    self.super.Close(self);
end

---添加UI事件
function SicBoSelectCtrl:AddUIEvent()
    self.uiEventListener:AddClick(self.view.btn_close, function
    ()
        self:OnClickReturn()
    end)
    self.uiEventListener:AddClick(self.view.btn_coinAdd, function()

    end)
end

---移除UI事件
function SicBoSelectCtrl:RemoveEvent()
    self.super.RemoveEvent(self);
end

--region UI事件方法
---返回大厅
function SicBoSelectCtrl:OnClickReturn()
    local ctrl = CtrlManager.GetCtrl(CtrlNames.UIHallGames);
    if ctrl then
        self:Close();
    else
        GameCenter.CloseCurGame(true);
    end
end

function SicBoSelectCtrl:OnClickItem(index)
    self.subGame:SendEnterRoom(index);
end

--endregion





--endregion


---销毁UI
function SicBoSelectCtrl:RealCloseDestroy()
    self.super.RealCloseDestroy(self);
end

return SicBoSelectCtrl
