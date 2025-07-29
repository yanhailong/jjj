---@class MahjongWaysMainCtrl:BaseCtrl
local MahjongWaysMainCtrl = Class("MahjongWaysMainCtrl", BaseCtrl)
local SlotMachineConfig = require "SingleGames/MahjongWays/MahjongWaysConfig"
---构造函数
function MahjongWaysMainCtrl:ctor(ctrlName, param)
    self.layer = 3;
    self.abName = "SingleGames/MahjongWays/prefab/MahjongWaysMain";
    self.prefabName = "MahjongWaysMain"
    self.super.ctor(self, ctrlName, param);
    ---@type MahjongWaysMainView
    self.view = self.view
    ---@type MahjongWaysMainModel
    self.model = self.model
end

---初始化
function MahjongWaysMainCtrl:CtrlInit(args)
    self.super.CtrlInit(self, args);
    Application.targetFrameRate=-1
    SlotMachineConfig.InitIconPic()
    self:InitData()
end

---初始化数据
function MahjongWaysMainCtrl:InitData()
    local SlotMachine = require("SingleGames/MahjongWays/SlotMachine/SlotMachine")
    self.SlotGame = SlotMachine.New();
    self.SlotGame.ElementInitCompleted_Event:Add(self.ElementInit, self)
    self.SlotGame.SingleRollerCompleted_Event:Add(self.SingleRollerCompleted, self)
    self.SlotGame.AllRollerCompleted_Event:Add(self.AllRollerCompleted, self)
    self.SlotGame.DropCompleted_Event:Add(self.DropCompleted, self)
    self.SlotGame.ChangeRandomIcons_Event:Add(self.ChangeRandomIcons, self)
    self.SlotGame.SetResultIcons_Event:Add(self.SetResultIcons, self)
    self.SlotGame:Create(self.view.obj_root.transform,
        resMgr:LoadGameObject("SingleGames/MahjongWays/prefab/", "ElementIconPrefab"))
end

--元素初始化逻辑
function MahjongWaysMainCtrl:ElementInit(rollerElement, elementIcon, rollerIndex, elementIndex)
    log("元素初始化完成")
    --可以对元素进行一些自定义数据和方法
    rollerElement.icon = elementIcon.transform:Find("UsualStatus"):GetComponent(typeof(CS.UnityEngine.UI.Image))
    rollerElement.WinStatus = elementIcon.transform:Find("WinStatus"):GetComponent(typeof(CS.UnityEngine.UI.Image))
    rollerElement.MoveStatus = elementIcon.transform:Find("MoveStatus"):GetComponent(typeof(CS.UnityEngine.UI.Image))
    rollerElement.IconData = 100; --自定义数据
    log("元素的名字" .. tostring(elementIcon.name))
    log("轴的引用" .. tostring(rollerIndex))
    log("元素引用" .. tostring(elementIndex))
    log(tostring(rollerElement.IconData))
end

function MahjongWaysMainCtrl:SingleRollerCompleted(Roller, RollerIndex)
    log(tostring(RollerIndex) .. "轴完成")
    if RollerIndex == 1 then
        --Roller:GetAllElement()   --处理自定义元素数据,包括添加的
        --Roller:GetAllViewElement()--获取可是区域的元素
        for i, v in ipairs(Roller:GetAllViewElement()) do

        end
        log("第一轴完成")
    end
    --self.SlotGame:ChangeSpeed(rollerIndex, speed)
    --处理加速，单轴事件
end

function MahjongWaysMainCtrl:ChangeRandomIcons(rollerElement, icon, rollerIdx, elementIdx)
    local index = math.floor(CS.UnityEngine.Random.Range(1, 10))
    local icon = SlotMachineConfig.icon_Pics[SlotMachineConfig.iocnPicName[index]]
    rollerElement.icon.sprite = icon
    log("改变随机图标")
end

local ResultTest = { { 8, 8, 8 }, { 1, 2, 3 }, { 3, 4, 5 }, { 6, 5, 8 }, { 6, 9, 6 } }
function MahjongWaysMainCtrl:SetResultIcons(rollerElement, icon, rollerIdx, elementIdx)
    local icon = SlotMachineConfig.icon_Pics[SlotMachineConfig.iocnPicName[ResultTest[rollerIdx][elementIdx]]]
    rollerElement.icon.sprite = icon
    log("设置开奖结果")
end

local times = 0 --连续掉落多少次
function MahjongWaysMainCtrl:AllRollerCompleted()
    --处理第一次掉落
    coroutine.start(function()
        coroutine.yield(CS.UnityEngine.WaitForSeconds(1))
        self.SlotGame:SetDrop({ { 1, 2 }, { 1, 2, 3 }, { 3 }, { 2, 3 }, { 1, 3 } })
    end)
    times = Tools.Random(0, 3) --随机掉落次数
    log("旋转完成")
end

--掉落完成
function MahjongWaysMainCtrl:DropCompleted()
    --触发多次掉落
    if times > 0 then
        coroutine.start(function()
            coroutine.yield(CS.UnityEngine.WaitForSeconds(1))
            self.SlotGame:SetDrop(self:RandomElement())
        end)
        times = times - 1;
    else
        self.view.btn_Start.interactable = true
        self.SlotGame:SetCompletedState() --游戏完成
    end
end

--测试 中奖线与结果预设
MahjongWaysMainCtrl.winPatterns = {
    { 1 }, { 2 }, { 3 },
    { 1, 2 }, { 1, 3 }, { 2, 3 },
    { 1, 2, 3 }
}
--测试图标
MahjongWaysMainCtrl.result = {
    { 2, 5,  7, 8,  9,  8, 3, 3 },
    { 3, 6,  8, 20, 12, 6, 4, 8 },
    { 4, 5,  9, 8,  9,  9, 9, 1 },
    { 2, 3,  7, 12, 9,  7, 9, 3 },
    { 2, 15, 7, 18, 9,  2, 2, 2 },
    { 3, 3,  7, 4,  9,  4, 4, 7 },
    { 3, 3,  7, 4,  9,  2, 6, 9 },
    { 3, 3,  7, 4,  9,  2, 8, 6 }
}
--测试数据随机掉落
function MahjongWaysMainCtrl:RandomElement()
    local temp = {}
    for i = 1, 5 do
        local index = math.floor(CS.UnityEngine.Random.Range(1, #self.winPatterns))
        temp[i] = self.winPatterns[index]
    end
    return temp
end

--随机掉落测试数据生产
function MahjongWaysMainCtrl:GetRandomWinPattern()
    local index = math.floor(CS.UnityEngine.Random.Range(0, #self.winPatterns))
    return self.winPatterns[index + 1]
end

function MahjongWaysMainCtrl:Close()
    self.super.Close(self);
end

---添加UI事件
function MahjongWaysMainCtrl:AddUIEvent()
    self.uiEventListener:AddClick(self.view.btn_Start, function()
        self.view.btn_Start.interactable = false
        self.view.btn_Stop.interactable = true
        self.SlotGame:StartRollers()
    end)
    self.uiEventListener:AddClick(self.view.btn_Stop, function()
        self.view.btn_Stop.interactable = false
        self.SlotGame:Stop()
    end)
end

---移除UI事件
function MahjongWaysMainCtrl:RemoveEvent()
    self.super.RemoveEvent(self);
end

--region UI事件方法

--endregion


---销毁UI
function MahjongWaysMainCtrl:RealCloseDestroy()
    self.super.RealCloseDestroy(self);
end

return MahjongWaysMainCtrl
