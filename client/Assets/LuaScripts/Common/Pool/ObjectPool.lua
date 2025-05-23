---@class ObjectPool
ObjectPool={
    poolName=nil,
    poolObjectPrefab=nil,
    initCount=nil,
    maxSize=nil,
    poolRoot=nil,
    availableObjQueue=nil,
    useCount=0,
    allObject=nil,
}
function ObjectPool.New(poolName, poolObjectPrefab, initCount, maxSize,poolRoot)
    local self = {};
    setmetatable(self, {__index = ObjectPool});
    self.poolName=poolName
    self.poolObjectPrefab=poolObjectPrefab   
    self.initCount=initCount
    self.maxSize=maxSize
    self.poolRoot = poolRoot
    self.allObject={}
    self.availableObjQueue=Queue.New()
    self:Prep(self.initCount)
    return self;
end

--author:{author}
--time:2020-11-20 15:56:08    
----@num:   
--desc:生成放入
function ObjectPool:Prep(num)
    for i=1,num do
        self:CreatePrefab()
    end
end

function ObjectPool:CreatePrefab()
    local obj=self:NewObjectInstance()  
    obj:SetActive(false);
    obj.transform:SetParent(self.poolRoot, false);
    obj.transform.localPosition = Vector3.zero;
    self.availableObjQueue:Enqueue(obj);
    table.insert(self.allObject,obj)
end

--author:{author}
--time:2020-11-13 15:12:57    
----@obj:   
--desc:回收
function ObjectPool:Unspawn(obj)
    obj:SetActive(false);
    obj.transform:SetParent(self.poolRoot, false);
    obj.transform.localPosition = Vector3.zero;
    self.availableObjQueue:Enqueue(obj);
end

--author:{author}
--time:2020-11-20 15:49:52    
--desc:实例化
function ObjectPool:NewObjectInstance()
    local obj=Tools.Instance(self.poolObjectPrefab)
    obj.name=self.poolObjectPrefab.name
    return obj
end

--author:{author}
--time:2020-11-20 15:53:05    
--desc:取出
function ObjectPool:Spawn(layer, pos, rot, scale)
    local spawnObj=nil
    if self.availableObjQueue:Count() > 0 then
        spawnObj = self.availableObjQueue:Dequeue();
    else
        self:Prep(1);--
        if self.availableObjQueue:Count() > 0 then
            spawnObj = self.availableObjQueue:Dequeue();
        else
            logError("出问题了快来检查吧")
        end
    end
    spawnObj.transform.position = Vector3.zero;
    spawnObj.transform.rotation = Quaternion.identity;
    if layer ~= nil then
        spawnObj.transform:SetParent(layer);
    end
    spawnObj.transform.localPosition = pos or Vector3.zero;
    spawnObj.transform.localRotation = rot or Quaternion.identity;
    spawnObj.transform.localScale = scale or self.poolObjectPrefab.transform.localScale;
    spawnObj:SetActive(true);

    self.useCount = self.useCount +1;
    return spawnObj;
end

function ObjectPool:ReturnObjectToPool(pooName,obj)
    if self.poolName==pooName then
        self:Unspawn(obj)
    else
        logError("pooName:"..pooName.."错误")
    end
end

--author:{author}
--time:2020-11-13 15:13:29    
--desc:清理全部对象池
function ObjectPool:DestroyAll()
    for k, v in pairs(self.allObject) do
        destroy(v);
    end
    self.allObject = {};
    self.availableObjQueue:Clear();
end

    
