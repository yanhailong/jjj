require "Common/Pool/Queue"
require "Common/Pool/ObjectPool"

---@class ObjectPoolUtil
local ObjectPoolUtil = Class("ObjectPoolUtil")

function ObjectPoolUtil:ctor(name)
    self.name=name
    ---@type ObjectPool[]
    self.poolFactory={}
end

--author:{author}
--time:2020-11-20 16:16:46    
--desc:创建预制体到指定位置
function ObjectPoolUtil:SpawnPrefab(callFunc,abname,assetname,layer, pos, rot, scale)
    local spawnObj=nil
    if self.poolFactory[assetname]==nil then
        local obj=resMgr:LoadGameObject(abname,assetname);
        if obj then
            self.poolFactory[assetname]=self:CreatePool(assetname,obj,1,nil,layer) 
            spawnObj=self.poolFactory[assetname]:Spawn(layer,pos,rot,scale)
        else
            logError(abname.."_"..assetname.."加载错误！")
        end
    else
        spawnObj=self.poolFactory[assetname]:Spawn(layer,pos,rot,scale)
    end
    if callFunc then
        callFunc(spawnObj)
    end
    return spawnObj
end

--author:{author}
--time:2020-11-20 16:30:55    
--desc:创建池子
function ObjectPoolUtil:CreatePool(assetname, poolObjectPrefab, initCount, maxSize,poolRoot)
    local tempPool=ObjectPool.New(assetname, poolObjectPrefab, initCount, maxSize,poolRoot)
    return tempPool
end

--author:{author}
--time:2020-11-20 16:46:35    
--desc:回收预制体
function ObjectPoolUtil:UnSpawnPrefab(obj)
    if not isnull(obj) then
        self.poolFactory[obj.name]:ReturnObjectToPool(obj.name,obj)
    end
end

--author:{author}
--time:2020-11-20 16:46:35    
--desc:回收预制体
 function ObjectPoolUtil:UnSpawnPrefabByPoolName(poolName,obj)
    if not isnull(obj) then
        self.poolFactory[poolName]:ReturnObjectToPool(poolName,obj)
    end
end

--author:{author}
--time:2020-11-20 16:53:50    
--desc:销毁poolName池子
function ObjectPoolUtil:Destory(assetname)
    self.poolFactory[assetname]:DestroyAll()
end
--author:{author}
--time:2020-11-20 16:55:40    
--desc:销毁全部
function ObjectPoolUtil:DestroyAll()  
    for k,v in pairs(self.poolFactory) do
        v:DestroyAll()
    end
    self.poolFactory={}
end

--author:{author}
--time:2020-12-16 15:09:00    
--desc:有预制体
function ObjectPoolUtil:Spawn(callFunc,obj, layer, pos, rot, scale)
    local spawnObj=nil
    if self.poolFactory[obj.name]==nil then
        self.poolFactory[obj.name]=self:CreatePool(obj.name,obj,1,nil,layer) 
        spawnObj=self.poolFactory[obj.name]:Spawn(layer,pos,rot,scale)
    else
        spawnObj=self.poolFactory[obj.name]:Spawn(layer,pos,rot,scale)
    end
    if callFunc then
        callFunc(spawnObj)
    end
    return spawnObj
end

return ObjectPoolUtil