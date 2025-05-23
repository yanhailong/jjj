---@class PanelManager
PanelManager = {}

local this=PanelManager;
local t_layers={}
local t_globalUI;

---获取对应Layer的Transform
---@param layer number UI层级
function this.GetLayer(layer)
    if layer==nil then return end
    if t_layers[layer]==nil then
        if t_globalUI==nil then
            local go=GameObject.Find("Global");
            if go==nil then return end
            t_globalUI=go.transform;
        end
        t_layers[layer]=ComponentUtilGet.TransFindChild(t_globalUI,"Canvas/Layer"..layer);
    end
    return t_layers[layer];
end

function this.CreatePanel(abName,panelName,layer)
    local parent=this.GetLayer(layer);
    local go=resMgr:CreateGameObject(abName,panelName,parent);
    return go;
end

function this.CreatePanelAsync(abName,panelName,layer,loadGameObjectCallback)
    local parent=this.GetLayer(layer);
    resMgr:CreateGameObjectAsync(abName,panelName,loadGameObjectCallback,parent);
end
