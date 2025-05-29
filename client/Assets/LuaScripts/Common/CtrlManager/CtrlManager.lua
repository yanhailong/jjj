require "Common/CtrlManager/PanelManager"
require "Common/CtrlManager/BaseCtrl"
require "Common/CtrlManager/BaseView"
require "Common/CtrlManager/BaseModel"
---@class CtrlManager
CtrlManager = {}

local this = CtrlManager;
local ctrlList = {};    -- 控制器列表--
CtrlNames = {};
CtrlManager.CtrlsCollection = {};

function CtrlManager.CreateCtrl(ctrlName, param)
    local ctrl = param.ctrl.New(ctrlName, param);
    return ctrl;
end

---创建UI面板
function CtrlManager.CreatePanel(ctrl, isSync, loadGameObjectCallback)
    if isSync then
        local go = PanelManager.CreatePanel(ctrl.abName, ctrl.prefabName, ctrl.layer);
        loadGameObjectCallback(go);
    else
        PanelManager.CreatePanelAsync(ctrl.abName, ctrl.prefabName, ctrl.layer, loadGameObjectCallback);
    end

end

function CtrlManager.SingleShow(ctrlName, dataTable, isSync, obj_panel)
    this.CloseLastShow(ctrlName)
    return this.RepeatShow(ctrlName, dataTable, isSync, obj_panel)
end

function CtrlManager.CloseLastShow(ctrlName)
    local lastShow = this.GetLastShowCtrl(ctrlName)
    if lastShow then
        lastShow:Close()
    end
end

function CtrlManager.RepeatShow(ctrlName, dataTable, isSync, obj_panel)
    if ctrlName == nil then
        logError("传入的CtrlNames为空")
        return ;
    end
    local param = CtrlManager.CtrlsCollection[ctrlName];
    if param == nil then
        logError("没有注册对应的UI:" .. tostring(ctrlName))
        return ;
    end
    local ctrl = this.GetHideCtrl(ctrlName)
    if ctrl == nil then
        ctrl = this.CreateCtrl(ctrlName, param);
        table.insert(ctrlList[ctrlName], ctrl)
        --ctrlList[ctrlName]=ctrl;
        local func = function(go)
            if go == nil then
                ctrl = nil;
                logError("加载UI错误:" .. tostring(ctrlName))
                return ;
            end
            ctrl:BindGameObject(go);
            ctrl:Awake();
            ctrl:Show();
            ctrl:CtrlInit(dataTable)
        end
        if obj_panel ~= nil then
            func(obj_panel);
        else
            this.CreatePanel(ctrl, isSync, func);
        end
    else
        --二次打开界面
        if not ctrl.isBindGameObject then
            return ctrl;
        end
        ctrl:Show();
        ctrl:SecondInit(dataTable)
        look("二次打开",dataTable);
    end
    return ctrl;
end

function CtrlManager.GetHideCtrl(ctrlName)
    local ctrls = ctrlList[ctrlName]
    local result = nil
    if ctrls then
        result = table.getItemByList(ctrls, function(v)
            return not v.isActive
        end)
    else
        ctrlList[ctrlName] = {}
    end
    return result
end

function CtrlManager.GetLastShowCtrl(ctrlName)
    local ctrls = ctrlList[ctrlName]
    local result = nil
    if ctrls then
        for i = #ctrls, 1 do
            if ctrls[i].isActive then
                result = ctrls[i]
                break
            end
        end
    end
    return result
end

---打开界面
function CtrlManager.Open(ctrlName, abName, prefabName, layer, param)
    local ctrl = this.GetHideCtrl(ctrlName);
    if ctrl ~= nil then
        ctrl:Close();
    end
    PanelManager.CreatePanelAsync(abName, prefabName, layer, function(go)
        CtrlManager.SingleShow(ctrlName, param, false, go);
    end);
end

function CtrlManager.IsOpen(ctrlName)
    if ctrlList[ctrlName] ~= nil then
        return table.trueForOne(ctrlList[ctrlName],function(k, v) return v.isActive end)
    else
        return false;
    end
end

-- 获取控制器--
function CtrlManager.GetCtrl(ctrlName)
    return this.GetLastShowCtrl(ctrlName)
end

---获取所有控制器
function CtrlManager.GetAllCtrl()
    return ctrlList;
end

function CtrlManager.GetLastCtrl(ctrlName)
    local all = ctrlList[ctrlName]
    if all then
        return all[#all]
    end
    return nil
end

-- 关闭指定控制器--
function CtrlManager.Close(ctrlName)
    local closeCtrl = this.GetLastCtrl(ctrlName)
    if closeCtrl ~= nil then
        closeCtrl:Close();
    end
end

-- 关闭所有控制器--
function CtrlManager.AllCtrlClose(ignore)
    local ignoreCtrl;
    if ignore then
        ignoreCtrl = {};
        if type(ignore) == "table" then
            for _, v in ipairs(ignore) do
                local ctrl = ctrlList[v];
                ctrlList[v] = nil;
                if ctrl ~= nil then
                    ignoreCtrl[v] = ctrl;
                end
            end
        else
            local ctrl = ctrlList[ignore];
            ctrlList[ignore] = nil;
            ignoreCtrl[ignore] = ctrl;
        end
    end

    for _, v in pairs(ctrlList) do
        if v then
            this.CloseAllByName(_)
        end
    end
    ctrlList = { };
    if ignoreCtrl then
        for k, v in pairs(ignoreCtrl) do
            ctrlList[k] = v;
        end
    end
end

function CtrlManager.CloseAllByName(ctrlName)
    table.forEach(ctrlList[ctrlName], function(k, v)
        v:Close()
    end)
end

--移除控制器
function CtrlManager.RemoveCtrl(ctrlName)
    local len = #ctrlList[ctrlName]
    table.remove(ctrlList[ctrlName], len)
    if len == 1 then
        ctrlList[ctrlName] = nil;
    end
end

-- 隐藏控制器
function CtrlManager.Hiden(ctrlName)
    local closeCtrl = this.GetLastShowCtrl(ctrlName);
    if closeCtrl ~= nil then
        closeCtrl:Hiden();
    end
end

