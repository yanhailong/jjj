---@class BaccaratRoad
local BaccaratRoad = Class("BaccaratRoad")
---@type BaccaratConfig
local config=require("SingleGames/Baccarat/BaccaratConfig")

---@type BaccaratZhuPanItem
local BaccaratZhuPanItem = require"SingleGames/Baccarat/Ctrl/BaccaratZhuPanItem"
---@type BaccaratDaLuItem
local BaccaratDaLuItem = require"SingleGames/Baccarat/Ctrl/BaccaratDaLuItem"
---@type BaccaratAllChildLuItem
local BaccaratAllChildLuItem = require"SingleGames/Baccarat/Ctrl/BaccaratAllChildLuItem"
local Vector3 = CS.UnityEngine.Vector3

function BaccaratRoad:Init(ZhuPanContent,DaLuContent,DaluZiluContent,XiaoLuContent,YueYouLuContent)
    ---@type ObjectPoolUtil
    self.objPools=ObjectPoolUtil.New()

    ---主盘数据表(进入游戏向服务器拿到数据后打开界面刷新主盘数据显示)
    self.ZhuPanDataTable = {};
    ---大路数据表
    self.DaLuDataTable = {};
    ---大路大眼路数据表
    self.DaYanZaiLuDataTable ={};
    ---小路数据表
    self.xiaoLuDataTable ={};
    ---曱甴路数据表
    self.YueYouLuDataTable = {};
    ---主盘表
    self.ZhuPanTable = {};
    self.ZhuPanObjTable = {};
    ---大路表
    self.DaLuTable = {};
    self.DaLuObjTable = {};

    ---大路大眼路表
    self.DaYanZaiLuTable ={};
    self.DaYanZaiLuObjTable ={};

    ---小路表
    self.xiaoLuTable ={};
    self.xiaoLuObjTable ={};

    ---曱甴路表
    self.YueYouLuTable = {};
    self.YueYouLuObjTable = {};
    
    
    self.ZhuPanContent = ZhuPanContent;
    self.DaLuContent = DaLuContent;
    self.DaluZiluContent = DaluZiluContent;
    self.XiaoLuContent = XiaoLuContent;
    self.YueYouLuContent = YueYouLuContent;
    self:InitDaLuTable()
    self:InitDaLuZiLuTable()
    self:InitXiaoLuTable()
    self:InitYueYouLuTable()
end
---第一次拉取到数据初始化数据
---@param data 牌型数据
---@param isSettlement 是不是结算阶段
function BaccaratRoad:InitData(data,isSettlement)
    for i, v in ipairs(data.cardStateList) do
        if(isSettlement and i== #data.cardStateList) then
            break;
        end
        local data2 = {};
        data2[1] = v.winState
        data2[2] = v.cardTypeWinState
        table.insert(self.ZhuPanDataTable,data2)
    end
    for _, v in ipairs(self.ZhuPanDataTable) do
        self:RefreshZhuPanShow(v)
    end
end
---刷新数据显示
function BaccaratRoad:RefreshData(data,isFlicker,IsNewRound)
    if(IsNewRound) then
        self:CloseLuTable()
    end
    local data2 = {};
    data2[1] = data.winState;
    data2[2] = data.cardTypeWinState
    self:RefreshZhuPanShow(data2,isFlicker)
    table.insert(self.ZhuPanDataTable,data2);
end

---初始化大路预制体表
function BaccaratRoad:InitDaLuTable()
    for i = 1, 6*70 do
        local obj = self.objPools:SpawnPrefab(nil,config.ABNames.prefabsItem,"DaLuItem",self.DaLuContent.transform)
        ---@type BaccaratDaLuItem
        local item = BaccaratDaLuItem.New(obj,self);
        obj:SetActive(true);
        obj.transform.localScale = Vector3.one;
        item:InitState();
        item:InitIndex(i);
        table.insert(self.DaLuObjTable,obj);
        table.insert(self.DaLuTable,item);
    end
end
---初始化大路大眼路预制体表
function BaccaratRoad:InitDaLuZiLuTable()
    for i = 1, 6*70 do
        local obj = self.objPools:SpawnPrefab(nil,config.ABNames.prefabsItem,"DaluZiluItem",self.DaluZiluContent.transform)
        ---@type BaccaratAllChildLuItem
        local item = BaccaratAllChildLuItem.New(obj,self);
        obj:SetActive(true);
        obj.transform.localScale = Vector3.one;
        item:InitState();
        item:InitIndex(i);
        table.insert(self.DaYanZaiLuObjTable,obj);
        table.insert(self.DaYanZaiLuTable,item);
    end

end
---初始化大路大眼路预制体表
function BaccaratRoad:InitXiaoLuTable()
    for i = 1, 6*70 do
        local obj = self.objPools:SpawnPrefab(nil,config.ABNames.prefabsItem,"XiaoLuItem",self.XiaoLuContent.transform)
        ---@type BaccaratAllChildLuItem
        local item = BaccaratAllChildLuItem.New(obj,self);
        obj:SetActive(true);
        obj.transform.localScale = Vector3.one;
        item:InitState();
        item:InitIndex(i);
        table.insert(self.xiaoLuObjTable,obj);
        table.insert(self.xiaoLuTable,item);
    end

end
---初始化曱甴路预制体表
function BaccaratRoad:InitYueYouLuTable()
    for i = 1, 6*70 do
        local obj = self.objPools:SpawnPrefab(nil,config.ABNames.prefabsItem,"YueYouLuItem",self.YueYouLuContent.transform)
        ---@type BaccaratAllChildLuItem
        local item = BaccaratAllChildLuItem.New(obj,self);
        obj:SetActive(true);
        obj.transform.localScale = Vector3.one;
        item:InitState();
        item:InitIndex(i);
        table.insert(self.YueYouLuObjTable,obj);
        table.insert(self.YueYouLuTable,item);
    end
end

---刷新主盘路显示
function BaccaratRoad:RefreshZhuPanShow(data,isFlicker)
    if(#self.ZhuPanObjTable>=48) then
        local length = math.floor((#self.ZhuPanObjTable-48)/6) +1;
        for i = 1, length*6 do
            self.ZhuPanObjTable[i]:SetActive(false);
        end
    end
    local obj = self.objPools:SpawnPrefab(nil,config.ABNames.prefabsItem,"ZhuPanItem",self.ZhuPanContent.transform)
    ---@type BaccaratZhuPanItem
    local item = BaccaratZhuPanItem.New(obj,self);
    obj:SetActive(true);
    obj.transform.localScale = Vector3.one;
    table.insert(self.ZhuPanObjTable,obj);
    item:RefreshShow(data,isFlicker)
    table.insert(self.ZhuPanTable,item);
    self:AddDaLuTableShow(data);
end

--region 路单显示
---大路新增显示
function BaccaratRoad:AddDaLuTableShow(data)
    local curIndex = 0; --当前的索引
    local curList = 0;--当前是第几列
    local tieNum = 0;--和的数字
    local whoWin;--谁赢
    local dataTable = {};--缓存的需要加入到数据结构里面的表
    local IsGoL; --是否走了L型了
    if(#self.DaLuDataTable==0) then--刚开始
        ---@type BaccaratDaLuItem
        local item = self.DaLuTable[1];
        if(data[1] == 3) then--和
            tieNum=tieNum+1;
            item:RefreshTieNumShow(tieNum);
        else
            whoWin = data[1];
            item:RefreshShow(whoWin);
        end
        curList = 1;
        self.DaLuDataTable[curList] ={};
        dataTable[1] = whoWin;
        dataTable[2] = tieNum;
        dataTable[3] = item;
        dataTable[4] = false;
        table.insert(self.DaLuDataTable[curList],dataTable)
    else
        curList = #self.DaLuDataTable;
        local lastPiece= self.DaLuDataTable[curList]
        if data[1] == 3 then --如果是和就不往下面加，而是显示数字
            tieNum = lastPiece[#lastPiece][2];
            tieNum = tieNum+1;
            lastPiece[#lastPiece][2] = tieNum;
            ---@type BaccaratDaLuItem
            local lastItem = lastPiece[#lastPiece][3];
            lastItem:RefreshTieNumShow(tieNum);
        elseif(lastPiece[#lastPiece][1] == data[1]) then --如果和上一次的一样就往后面加
            IsGoL = lastPiece[#lastPiece][4];
            local lastItem = lastPiece[#lastPiece][3];
            if(IsGoL) then -- 已经开始走L型了
                curIndex = lastItem:GetIndex()+6;
            else
                curIndex = lastItem:GetIndex()+1;
                ---@type BaccaratDaLuItem
                local item = self.DaLuTable[curIndex];
                if(item:IsActive()or (curIndex-1)%6==0) then --如果下一个索引的物体已经被激活了就走L型
                    curIndex = lastItem:GetIndex()+6;
                    IsGoL = true;
                end
            end
            ---@type BaccaratDaLuItem
            local item = self.DaLuTable[curIndex];
            dataTable[1] = data[1];
            dataTable[2] = tieNum;
            dataTable[3] = item;
            dataTable[4] = IsGoL;
            item:RefreshShow(data[1])
            table.insert(self.DaLuDataTable[curList],dataTable)
            self:AddDaYanZiLuTableShow();
            self:AddXiaoLuTableShow();
            self:AddYueYouLuTableShow();
        elseif(lastPiece[#lastPiece][1] ~= data[1]) then --如果和上一次的不一样就往另外开一列
            if(#self.DaLuDataTable>=24) then--超出列表了，需要隐藏前面
                for i = 1, (#self.DaLuDataTable-23)*6 do
                    self.DaLuObjTable[i]:SetActive(false);
                end
            end
            curList = #self.DaLuDataTable+1;
            curIndex = #self.DaLuDataTable*6+1;
            ---@type BaccaratDaLuItem
            local item = self.DaLuTable[curIndex];
            dataTable[1] =  data[1];
            dataTable[2] = tieNum;
            dataTable[3] = item;
            dataTable[4] = IsGoL;
            item:RefreshShow(data[1])
            self.DaLuDataTable[curList] ={};
            table.insert(self.DaLuDataTable[curList],dataTable)
            self:AddDaYanZiLuTableShow();
            self:AddXiaoLuTableShow();
            self:AddYueYouLuTableShow();
        end
    end

end

---大眼路刷新显示
function BaccaratRoad:AddDaYanZiLuTableShow()
    local curList = #self.DaLuDataTable;
    local lastPiece= self.DaLuDataTable[curList]
    ---@type BaccaratDaLuItem
    local lastItem = lastPiece[#lastPiece][3];
    local index = lastItem:GetIndex();
    if(index>=8) then--开始演化大眼路的走向
        local isEqual;
        if((index-1)%6==0)then--在第一行对比前面2列的数量是否相等
            local list1 = curList-1;
            local list2 = curList-2;
            local lastItems1 = self.DaLuDataTable[list1]
            local lastItems2 = self.DaLuDataTable[list2]
            isEqual = #lastItems1==#lastItems2;
        else --不在第一行
            local index1 = index-6;
            local index2 = index-7;
            ---@type BaccaratDaLuItem
            local item1 =  self.DaLuTable[index1];
            local item2 =  self.DaLuTable[index2];
            isEqual = item1:IsActive()==item2:IsActive();
        end

        local dataTable = {};--缓存的需要加入到数据结构里面的表
        local IsGoL; --是否走了L型了
        local CurIndex;
        if(#self.DaYanZaiLuDataTable==0) then--刚开始走
            ---@type BaccaratAllChildLuItem
            local item = self.DaYanZaiLuTable[1];
            item:RefreshShow(isEqual);
            IsGoL = false;
            dataTable[1] = isEqual;
            dataTable[2] = IsGoL;
            dataTable[3] = item;
            self.DaYanZaiLuDataTable[1] = {}
            table.insert(self.DaYanZaiLuDataTable[1],dataTable);
        else
            local ListCur = #self.DaYanZaiLuDataTable;
            local childList =self.DaYanZaiLuDataTable[ListCur];
            local child = childList[#childList];
            ---@type BaccaratAllChildLuItem
            local listItem2 = child[3];
            if(isEqual == child[1])then -- 如果相等就往后面加
                IsGoL = child[2];
                if(IsGoL) then -- 已经开始走L型了
                    CurIndex = listItem2:GetIndex()+6;
                else
                    CurIndex =  listItem2:GetIndex()+1;
                    ---@type BaccaratAllChildLuItem
                    local item = self.DaYanZaiLuTable[CurIndex];
                    if(item:IsActive()or (CurIndex-1)%6==0) then --如果下一个索引的物体已经被激活了就走L型
                        CurIndex = listItem2:GetIndex()+6;
                        IsGoL = true;
                    end
                end
                ---@type BaccaratAllChildLuItem
                local item = self.DaYanZaiLuTable[CurIndex];
                item:RefreshShow(isEqual);
                dataTable[1] = isEqual;
                dataTable[2] = IsGoL;
                dataTable[3] = item;
                table.insert(self.DaYanZaiLuDataTable[ListCur],dataTable);
            else -- 不等就另外开一列
                if(#self.DaYanZaiLuDataTable>=24) then--超出列表了，需要隐藏前面
                    for i = 1, (#self.DaYanZaiLuDataTable-23)*6 do
                        self.DaYanZaiLuObjTable[i]:SetActive(false);
                    end
                end
                ListCur = #self.DaYanZaiLuDataTable+1
                CurIndex = #self.DaYanZaiLuDataTable*6+1;
                ---@type BaccaratAllChildLuItem
                local item = self.DaYanZaiLuTable[CurIndex];
                item:RefreshShow(isEqual)
                dataTable[1] = isEqual;
                dataTable[2] = IsGoL;
                dataTable[3] = item;
                self.DaYanZaiLuDataTable[ListCur] ={};
                table.insert(self.DaYanZaiLuDataTable[ListCur],dataTable)
            end
        end

    end
end

---小路刷新显示
function BaccaratRoad:AddXiaoLuTableShow()
    local curList = #self.DaLuDataTable;
    local lastPiece= self.DaLuDataTable[curList]
    ---@type BaccaratDaLuItem
    local lastItem = lastPiece[#lastPiece][3];
    local index = lastItem:GetIndex();
    if(index>=14) then--开始演化小路的走向
        local isEqual;
        if((index-1)%6==0)then--在第一行对比前面2列的数量是否相等
            local list1 = curList-1;
            local list2 = curList-3;
            local lastItems1 = self.DaLuDataTable[list1]
            local lastItems2 = self.DaLuDataTable[list2]
            isEqual = #lastItems1==#lastItems2;
        else --不在第一行
            local index1 = index-12;
            local index2 = index-13;
            ---@type BaccaratDaLuItem
            local item1 =  self.DaLuTable[index1];
            local item2 =  self.DaLuTable[index2];
            isEqual = item1:IsActive()==item2:IsActive();
        end

        local dataTable = {};--缓存的需要加入到数据结构里面的表
        local IsGoL; --是否走了L型了
        local CurIndex;
        if(#self.xiaoLuDataTable==0) then--刚开始走iao
            ---@type BaccaratAllChildLuItem
            local item = self.xiaoLuTable[1];
            item:RefreshShow(isEqual);
            IsGoL = false;
            dataTable[1] = isEqual;
            dataTable[2] = IsGoL;
            dataTable[3] = item;
            self.xiaoLuDataTable[1] = {}
            table.insert(self.xiaoLuDataTable[1],dataTable);
        else
            local ListCur = #self.xiaoLuDataTable;
            local childList = self.xiaoLuDataTable[ListCur];
            local child = childList[#childList];
            ---@type BaccaratAllChildLuItem
            local listItem2 = child[3];
            if(isEqual == child[1])then -- 如果相等就往后面加
                IsGoL = child[2];
                if(IsGoL) then -- 已经开始走L型了
                    CurIndex = listItem2:GetIndex()+6;
                else
                    CurIndex =  listItem2:GetIndex()+1;
                    ---@type BaccaratAllChildLuItem
                    local item = self.xiaoLuTable[CurIndex];
                    if(item:IsActive()or (CurIndex-1)%6==0) then --如果下一个索引的物体已经被激活了就走L型
                        CurIndex = listItem2:GetIndex()+6;
                        IsGoL = true;
                    end
                end
                ---@type BaccaratAllChildLuItem
                local item = self.xiaoLuTable[CurIndex];
                item:RefreshShow(isEqual);
                dataTable[1] = isEqual;
                dataTable[2] = IsGoL;
                dataTable[3] = item;
                table.insert(self.xiaoLuDataTable[ListCur],dataTable);
            else -- 不等就另外开一列
                if(#self.xiaoLuDataTable>=24) then--超出列表了，需要隐藏前面
                    for i = 1, (#self.xiaoLuDataTable-23)*6 do
                        self.xiaoLuObjTable[i]:SetActive(false);
                    end
                end
                ListCur = #self.xiaoLuDataTable+1
                CurIndex = #self.xiaoLuDataTable*6+1;
                ---@type BaccaratAllChildLuItem
                local item = self.xiaoLuTable[CurIndex];
                item:RefreshShow(isEqual)
                dataTable[1] = isEqual;
                dataTable[2] = IsGoL;
                dataTable[3] = item;
                self.xiaoLuDataTable[ListCur] ={};
                table.insert(self.xiaoLuDataTable[ListCur],dataTable)
            end
        end

    end
end
---曱甴刷新显示
function BaccaratRoad:AddYueYouLuTableShow()
    local curList = #self.DaLuDataTable;
    local lastPiece= self.DaLuDataTable[curList]
    ---@type BaccaratDaLuItem
    local lastItem = lastPiece[#lastPiece][3];
    local index = lastItem:GetIndex();
    if(index>=20) then--开始演化小路的走向
        local isEqual;
        if((index-1)%6==0)then--在第一行对比前面2列的数量是否相等
            local list1 = curList-1;
            local list2 = curList-4;
            local lastItems1 = self.DaLuDataTable[list1]
            local lastItems2 = self.DaLuDataTable[list2]
            isEqual = #lastItems1==#lastItems2;
        else --不在第一行
            local index1 = index-18;
            local index2 = index-19;
            ---@type BaccaratDaLuItem
            local item1 =  self.DaLuTable[index1];
            local item2 =  self.DaLuTable[index2];
            isEqual = item1:IsActive()==item2:IsActive();
        end

        local dataTable = {};--缓存的需要加入到数据结构里面的表
        local IsGoL; --是否走了L型了
        local CurIndex;
        if(#self.YueYouLuDataTable==0) then--刚开始走iao
            ---@type BaccaratAllChildLuItem
            local item = self.YueYouLuTable[1];
            item:RefreshShow(isEqual);
            IsGoL = false;
            dataTable[1] = isEqual;
            dataTable[2] = IsGoL;
            dataTable[3] = item;
            self.YueYouLuDataTable[1] = {}
            table.insert(self.YueYouLuDataTable[1],dataTable);
        else
            local ListCur = #self.YueYouLuDataTable;
            local childList = self.YueYouLuDataTable[ListCur];
            local child = childList[#childList];
            ---@type BaccaratAllChildLuItem
            local listItem2 = child[3];
            if(isEqual == child[1])then -- 如果相等就往后面加
                IsGoL = child[2];
                if(IsGoL) then -- 已经开始走L型了
                    CurIndex = listItem2:GetIndex()+6;
                else
                    CurIndex =  listItem2:GetIndex()+1;
                    ---@type BaccaratAllChildLuItem
                    local item = self.YueYouLuTable[CurIndex];
                    if(item:IsActive()or (CurIndex-1)%6==0) then --如果下一个索引的物体已经被激活了就走L型
                        CurIndex = listItem2:GetIndex()+6;
                        IsGoL = true;
                    end
                end
                ---@type BaccaratAllChildLuItem
                local item = self.YueYouLuTable[CurIndex];
                item:RefreshShow(isEqual);
                dataTable[1] = isEqual;
                dataTable[2] = IsGoL;
                dataTable[3] = item;
                table.insert(self.YueYouLuDataTable[ListCur],dataTable);
            else -- 不等就另外开一列
                if(#self.YueYouLuDataTable>=24) then--超出列表了，需要隐藏前面
                    for i = 1, (#self.YueYouLuDataTable-23)*6 do
                        self.YueYouLuObjTable[i]:SetActive(false);
                    end
                end
                ListCur = #self.YueYouLuDataTable+1
                CurIndex = #self.YueYouLuDataTable*6+1;
                ---@type BaccaratAllChildLuItem
                local item = self.YueYouLuTable[CurIndex];
                item:RefreshShow(isEqual)
                dataTable[1] = isEqual;
                dataTable[2] = IsGoL;
                dataTable[3] = item;
                self.YueYouLuDataTable[ListCur] ={};
                table.insert(self.YueYouLuDataTable[ListCur],dataTable)
            end
        end

    end
end
--endregion

---清空所有路表
function BaccaratRoad:CloseLuTable()
    for _, v in ipairs(self.ZhuPanObjTable) do
        self.objPools:UnSpawnPrefab(v);
    end
    self.ZhuPanTable = {}
    self.ZhuPanDataTable ={}

    for _, v in ipairs(self.DaLuTable) do
        v:InitState()
    end
    for _, v in ipairs(self.DaLuObjTable) do
        v:SetActive(true)
    end
    self.DaLuDataTable = {}

    for _, v in ipairs(self.DaYanZaiLuTable) do
        v:InitState()
    end
    for _, v in ipairs(self.DaYanZaiLuObjTable) do
        v:SetActive(true)
    end
    self.DaYanZaiLuDataTable = {}

    for _, v in ipairs(self.xiaoLuTable) do
        v:InitState()
    end
    for _, v in ipairs(self.xiaoLuObjTable) do
        v:SetActive(true)
    end
    self.xiaoLuDataTable = {}

    for _, v in ipairs(self.YueYouLuTable) do
        v:InitState()
    end
    for _, v in ipairs(self.YueYouLuObjTable) do
        v:SetActive(true)
    end
    self.YueYouLuDataTable = {}
end

function BaccaratRoad:Destroy()
    self.objPools:DestroyAll();
    for _, v in ipairs(self.ZhuPanTable) do
        ---@type BaccaratZhuPanItem
        local item =v;
        item:Destroy();
    end
    self.ZhuPanObjTable = {}
    self.ZhuPanTable ={}
    self.ZhuPanDataTable ={}

    for _, v in ipairs(self.DaLuTable) do
        ---@type BaccaratDaLuItem
        local item =v;
        item:Destroy();
    end
    self.DaLuObjTable ={};
    self.DaLuTable ={}
    self.DaLuDataTable ={}


    for _, v in ipairs(self.DaYanZaiLuTable) do
        ---@type BaccaratAllChildLuItem
        local item =v;
        item:Destroy();
    end
    self.DaYanZaiLuObjTable = {}
    self.DaYanZaiLuTable = {}
    self.DaYanZaiLuDataTable = {}

    for _, v in ipairs(self.xiaoLuTable) do
        ---@type BaccaratAllChildLuItem
        local item =v;
        item:Destroy();
    end

    self.xiaoLuObjTable ={}
    self.xiaoLuTable = {}
    self.xiaoLuDataTable ={}

    for _, v in ipairs(self.YueYouLuTable) do
        ---@type BaccaratAllChildLuItem
        local item =v;
        item:Destroy();
    end

    self.YueYouLuObjTable = {}
    self.YueYouLuTable ={}
    self.YueYouLuDataTable ={}
end

return BaccaratRoad;