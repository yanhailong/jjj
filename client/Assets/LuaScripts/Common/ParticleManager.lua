---@class ParticleManager
ParticleManager = {}
local this = ParticleManager;
---@type UnityEngine.GameObject
local root = GameObject("ParticleManager");
local pools = {};

--region public
---[[
--- 预加载
---@param assetName string 资源名
---@param initCount number 池子里初始化数量
---]]
function this.PreLoad(assetName, initCount)
    if not assetName then
        return;
    end
    ---@type ObjectPool
    local pool = pools[assetName];
    if not pool then
        pool = this._NewPool(assetName, initCount);
        pools[assetName] = pool;
    end
end

---[[
--- 加载一个特效（记得用完调用Push放回）
---@param assetName string 资源名
---@param parent UnityEngine.Transform 父节点
---@param pos Vector3 位置（可选，默认为0）
---@param rot Vector3 转向（可选，默认为0）
---@param scale Vector3 尺寸（可选，默认为1）
---@return UnityEngine.GameObject 
---]]
function this.Load(assetName, parent, pos, rot, scale)
    if not assetName then
        return;
    end
    ---@type ObjectPool
    local pool = pools[assetName];
    if not pool then
        pool = this._NewPool(assetName);
        pools[assetName] = pool;
    end
    return pool:Spawn(parent, pos, rot, scale);
end

---[[
--- 加载一个特效并播放
---@param assetName string 资源名
---@param parent UnityEngine.Transform 父节点
---@param pos Vector3 位置（可选，默认为0）
---@param rot Vector3 转向（可选，默认为0）
---@param scale Vector3 尺寸（可选，默认为1）
---@param callback function 播放结束回调
---]]
function this.LoadAndPlay(assetName, parent, pos, rot, scale, callback)
    local obj = this.Load(assetName, parent, pos, rot, scale);
    this.Play(obj, function()
        this.Push(assetName, obj)
        if callback then
            callback();
        end
    end)
end

---[[
--- 回收一个特效
---@param assetName string 资源名
---@param obj UnityEngine.GameObject 特效Obj
---]]]
function this.Push(assetName, obj)
    if not assetName then
        return;
    end
    ---@type ObjectPool
    local pool = pools[assetName];
    if pool then
        pool:Unspawn(obj);
    end
end

---[[
--- 播放特效
---@param particleObj UnityEngine.GameObject 特效Obj
---@param callback function 播放结束回调
---]]
function this.Play(particleObj, callback)
    local ps = particleObj:GetComponent("ParticleSystemController");
    if not ps then
        ps = particleObj:AddComponent(typeof(CS.ParticleSystemController));
    end
    ps:Play(callback);
end

---[[
--- 卸载特效
---]]
function this.Unload(assetName)
    if not assetName then
        return;
    end
    ---@type ObjectPool
    local pool = pools[assetName];
    if pool then
        pool:DestroyAll();
        pools[assetName] = nil;
    end
end
--end region


--region private
function this._NewPool(assetName, initCount)
    ---@type UnityEngine.GameObject
    local poolRoot = GameObject(assetName);
    poolRoot.transform:SetParent(root.transform);
    local prefab = resMgr:CreateGameObject('OutPut/models/Effect', assetName, poolRoot.transform);
    ---@type ObjectPool
    local pool = ObjectPoolUtil:CreatePool(assetName, prefab, initCount or 0, 50, poolRoot.transform)
    pool:Unspawn(prefab);
    return pool;
end
--end region

return ParticleManager
