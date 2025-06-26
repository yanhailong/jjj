--
--time:{time}
--{paramdesc} 
--@desc 
--
---@class RoadView
local RoadView=Class("RoadView")
local ZhuPianItem=require("SingleGames/DragonTigerFight/View/Item/ZhuPianItem")
local DaLuItem=require("SingleGames/DragonTigerFight/View/Item/DaLuItem")
local ZhiLuItem=require("SingleGames/DragonTigerFight/View/Item/ZhiLuItem")
local XiaoLuItem=require("SingleGames/DragonTigerFight/View/Item/XiaoLuItem")
local YueYouLuItem=require("SingleGames/DragonTigerFight/View/Item/YueYouLuItem")
local YuCeItem=require("SingleGames/DragonTigerFight/View/Item/YuCeItem")

function RoadView:ctor(go)
    ---@type UnityEngine.GameObject
    self.gameObject = go
    ---@type UnityEngine.Transform
    self.transform=self.gameObject.transform
    ---右侧统计数信息
    self.longWinNum=ComponentUtilGet.TextMeshProUGUI(self.transform,"TotalWin/longWinNum/num")
    self.huWinNum=ComponentUtilGet.TextMeshProUGUI(self.transform,"TotalWin/huWinNum/num")
    self.heWinNum=ComponentUtilGet.TextMeshProUGUI(self.transform,"TotalWin/heWinNum/num")
    self.totalNum=ComponentUtilGet.TextMeshProUGUI(self.transform,"TotalWin/totalNum/num")
    ---预测路信息
    self.nextLong = {
        ---@type YuCeItem{}
        zilu=YuCeItem.New(ComponentUtilGet.Transform(self.transform,"YuCe/NextLong/zilu")),
        ---@type YuCeItem{}
        xiaolu=YuCeItem.New(ComponentUtilGet.Transform(self.transform,"YuCe/NextLong/xiaolu")),
        ---@type YuCeItem{}
        yueyoulu=YuCeItem.New(ComponentUtilGet.Transform(self.transform,"YuCe/NextLong/yueyoulu")),
    }
    self.nextHu = {
        ---@type YuCeItem{}
        zilu=YuCeItem.New(ComponentUtilGet.Transform(self.transform,"YuCe/NextHu/zilu")),
        ---@type YuCeItem{}
        xiaolu=YuCeItem.New(ComponentUtilGet.Transform(self.transform,"YuCe/NextHu/xiaolu")),
        ---@type YuCeItem{}
        yueyoulu=YuCeItem.New(ComponentUtilGet.Transform(self.transform,"YuCe/NextHu/yueyoulu")),
    }
    ---游戏结果记录
    self.zhuPanScrollContent=ComponentUtilGet.Transform(self.transform,"ZhuPanScroll/Viewport/Content")
    self.zhuPanPrefab=ComponentUtilGet.GameObject(self.transform,"ZhuPanScroll/Viewport/item/zhupian")
    ---@type ZhuPianItem[]
    self.zhuPanItems={}
    for i=1,48 do
        local go = GameObject.Instantiate(self.zhuPanPrefab)
        go.transform:SetParent(self.zhuPanScrollContent,false)
        self.zhuPanItems[i] = ZhuPianItem.New(go)
        self.zhuPanItems[i]:ResetInfo()
    end
    ---游戏大路记录
    self.daLuScrollContent=ComponentUtilGet.Transform(self.transform,"DaLuScroll/Viewport/Content")
    self.daLuPrefab=ComponentUtilGet.GameObject(self.transform,"DaLuScroll/Viewport/item/dalu")
    ---@type DaLuItem[]
    self.daLuItems={}
    self.daLuRecods={}
    for i=1,144 do
        local go = GameObject.Instantiate(self.daLuPrefab)
        go.transform:SetParent(self.daLuScrollContent,false)
        self.daLuItems[i] = DaLuItem.New(go)
        self.daLuItems[i]:ResetInfo()
    end
    
    ---游戏大眼子路记录
    self.zhiLuScrollContent=ComponentUtilGet.Transform(self.transform,"DaYanZiLuScroll/Viewport/Content")
    self.zhiLuPrefab=ComponentUtilGet.GameObject(self.transform,"DaYanZiLuScroll/Viewport/item/zilu")
    ---@type ZhiLuItem[]
    self.zhiLuItems={}
    self.zhiLuRecods={}
    for i=1,144 do
        local go = GameObject.Instantiate(self.zhiLuPrefab)
        go.transform:SetParent(self.zhiLuScrollContent,false)
        self.zhiLuItems[i] = ZhiLuItem.New(go)
        self.zhiLuItems[i]:ResetInfo()
    end
    
    ---游戏小路记录
    self.xiaoLuScrollContent=ComponentUtilGet.Transform(self.transform,"XiaoLuScroll/Viewport/Content")
    self.xiaoLuPrefab=ComponentUtilGet.GameObject(self.transform,"XiaoLuScroll/Viewport/item/xiaolu")
    ---@type XiaoLuItem[]
    self.xiaoLuItems={}
    self.xiaoLuRecods={}
    for i=1,144 do
        local go = GameObject.Instantiate(self.xiaoLuPrefab)
        go.transform:SetParent(self.xiaoLuScrollContent,false)
        self.xiaoLuItems[i] = XiaoLuItem.New(go)
        self.xiaoLuItems[i]:ResetInfo()
    end
    
    ---游戏曱甴路记录
    self.yueYouLuScrollContent=ComponentUtilGet.Transform(self.transform,"YueYouLu/Viewport/Content")
    self.yueYouLuPrefab=ComponentUtilGet.GameObject(self.transform,"YueYouLu/Viewport/item/yueyoulu")
    ---@type YueYouLuItem[]
    self.yueYouLuItems={}
    self.yueYouLuRecods={}
    for i=1,144 do
        local go = GameObject.Instantiate(self.yueYouLuPrefab)
        go.transform:SetParent(self.yueYouLuScrollContent,false)
        self.yueYouLuItems[i] = YueYouLuItem.New(go)
        self.yueYouLuItems[i]:ResetInfo()
    end

    self.RoadHistoryRecord = nil
end

function RoadView:ResetAllInfo()
    self.longWinNum.text=0
    self.huWinNum.text=0
    self.heWinNum.text=0
    self.totalNum.text=0

    self.longTotal = 0
    self.huTotal = 0
    self.heTotal = 0
    self.count = 0
    
    for i=1,#self.zhuPanItems do
        self.zhuPanItems[i]:ResetInfo()
    end
    
    for i=1,#self.daLuItems do
        self.daLuItems[i]:ResetInfo()
    end
    self.daLuRecods={}
    
    for i=1,#self.zhiLuItems do
        self.zhiLuItems[i]:ResetInfo()
    end
    self.zhiLuRecods={}
    
    for i=1,#self.xiaoLuItems do
        self.xiaoLuItems[i]:ResetInfo()
    end
    self.xiaoLuRecods={}
    
    for i=1,#self.yueYouLuItems do
        self.yueYouLuItems[i]:ResetInfo()
    end
    self.yueYouLuRecods={}
end

function RoadView:Show()
    self.gameObject:SetActive(false)
end

function RoadView:Hiden()
    self.gameObject:SetActive(true)
end

function RoadView:UpdatePanelInfo(data,showFade)
    self.RoadHistoryRecord = data
    self.ShowFade = showFade
    
    self:ResetAllInfo()
    
    if #self.RoadHistoryRecord == 0 then
        return
    end
    
    self:UpdateZhuPianInfo()
    self:UpdateDaLuInfo()
    self:UpdateZhiLuInfo()
    self:UpdateXiaoLuInfo()
    self:UpdateYueYouLuInfo()
    self:UpdateYuCeInfo()
    self:UpdateRightTotalInfo()
end

function RoadView:UpdateZhuPianInfo()
    local total = #self.RoadHistoryRecord

    if  total>48 then
        local prev=math.ceil((total-48)/6)*6
        for i=1,total-prev do
            self.zhuPanItems[i]:UpdateInfo(self.RoadHistoryRecord[prev+i],self.ShowFade and self.RoadHistoryRecord[prev+i].seri_id==self.RoadHistoryRecord[total].seri_id)
        end
    else
        for i=1,total do
            self.zhuPanItems[i]:UpdateInfo(self.RoadHistoryRecord[i],self.ShowFade and self.RoadHistoryRecord[i].seri_id==self.RoadHistoryRecord[total].seri_id)
        end 
    end
end

function RoadView:UpdateDaLuInfo()
    ---分析大路数据
    self.daLuRecods={}
    local side = 0
    local index = 0
    local heTimes = 0
    
    ---数据处理
    for i=1,#self.RoadHistoryRecord do
        if self.RoadHistoryRecord[i].win_side == DRAGON_TIGER_FIGHT_WIN_SIDE.HE then
            heTimes = heTimes + 1
            if index == 0 then
                index = index + 1
                self.daLuRecods[index] = {}
                table.insert(self.daLuRecods[index],{DRAGON_TIGER_FIGHT_WIN_SIDE.HE,heTimes})
            else
                self.daLuRecods[index][#self.daLuRecods[index]][2] = heTimes
            end
        else
            heTimes = 0
            if self.RoadHistoryRecord[i].win_side ~= side then
                index = index + 1
                self.daLuRecods[index] = {}
            end
            side = self.RoadHistoryRecord[i].win_side
            table.insert(self.daLuRecods[index],{side,heTimes})
        end
    end
    look(self.daLuRecods)

    ---更新UI
    if self.daLuRecods then
        self:UpdateRightGridView(self.daLuItems,self.daLuRecods)
    end
    if true then
        return
    end
end

---规则
---当第二列第二行出现子或者第三列第一行出现子开始分析
---非第一列通过比较对应前一行前一列和前一例同行的数据是否都有数据或没有数据
---第一例的比较 前两列数据数目相等
function RoadView:UpdateZhiLuInfo()
    ---大眼子路数据处理
    self.zhiLuRecods=self:CacRightChildRoadData(2)
    ---更新UI
    if self.zhiLuRecods then
        self:UpdateRightGridView(self.zhiLuItems,self.zhiLuRecods)
    end
end

function RoadView:UpdateXiaoLuInfo()
    ---小路数据处理
    self.xiaoLuRecods=self:CacRightChildRoadData(3)
    ---更新UI
    if self.xiaoLuRecods then
        self:UpdateRightGridView(self.xiaoLuItems,self.xiaoLuRecods)
    end
end

function RoadView:UpdateYueYouLuInfo()
    ---曱甴路数据处理
    self.yueYouLuRecods=self:CacRightChildRoadData(4)
    ---更新UI
    if self.yueYouLuRecods then
        self:UpdateRightGridView(self.yueYouLuItems,self.yueYouLuRecods)
    end
end

---处理右侧子路数据 【大眼子路、小路、曱甴路】
function RoadView:CacRightChildRoadData(move)
    local recods = {}
    local index = 0
    local side = 0
    local old = 0
    local before = move-1
    ---排除没有达到触发条件的更新
    if self.daLuRecods and #self.daLuRecods<move or (#self.daLuRecods<move+1 and #self.daLuRecods[move]<2) then
        return nil
    end

    for i=move, #self.daLuRecods do
        for c=1, #self.daLuRecods[i] do
            if i>move then
                if c==1 then
                    if #self.daLuRecods[i-1] ~= #self.daLuRecods[i-move] then
                        --无规则
                        side = DRAGON_TIGER_FIGHT_ROAD_SIDE.NO
                    else
                        --有规则
                        side = DRAGON_TIGER_FIGHT_ROAD_SIDE.YES
                    end
                else
                    --都无数据或数据相等
                    if self.daLuRecods[i-before][c] == nil and self.daLuRecods[i-before][c-1] ~= nil then
                        --无规则
                        side = DRAGON_TIGER_FIGHT_ROAD_SIDE.NO
                    else
                        --有规则
                        side = DRAGON_TIGER_FIGHT_ROAD_SIDE.YES
                    end
                end

                if side~=old then
                    index = index+1
                    recods[index] = {}
                end
                old = side
                table.insert(recods[index],side)

            elseif #self.daLuRecods[i-before]>=2 and c>=2 then
                if self.daLuRecods[i-before][c] == nil and self.daLuRecods[i-before][c-1] ~= nil then
                    --无规则
                    side = DRAGON_TIGER_FIGHT_ROAD_SIDE.NO
                else
                    --有规则
                    side = DRAGON_TIGER_FIGHT_ROAD_SIDE.YES
                end

                if side~=old then
                    index = index+1
                    recods[index] = {}
                end
                old = side
                table.insert(recods[index],side)
            end
        end
    end
    
    return recods
end

---更新右侧各路信息 【大路、大眼子路、小路、曱甴路】
function RoadView:UpdateRightGridView(items,recods)
    ---更新UI
    local rowCount = #recods
    ---L型导致扩列的情况判断
    local maxRowCount = rowCount
    for i=1,rowCount do
        local row = i
        if #recods[i]>6 then
            row = i+#recods[i]-6
        end
        maxRowCount = math.max(row, maxRowCount)
    end

    if maxRowCount>24 then
        local prev=maxRowCount-24
        for i=1,rowCount do
            local colCount = #recods[i]
            for c=1,colCount do
                local data = recods[i][c]
                if i>prev then
                    if c>6 then
                        ---L型显示
                        local index = (i+c-6-prev)*6
                        items[index]:UpdateInfo(data,self.ShowFade and rowCount==i and c==colCount)
                    else
                        ---跳过右移的数据
                        local index = (i-prev-1)*6+c
                        items[index]:UpdateInfo(data,self.ShowFade and rowCount==i and c==colCount)
                    end
                elseif c>6 and (i+c-6)>prev then
                    ---被移动隐藏的L是否在显示的列里面
                    local index = (i+c-6-prev)*6
                    items[index]:UpdateInfo(data,self.ShowFade and rowCount==i and c==colCount)
                end
            end
        end
    else
        for i=1,rowCount do
            local colCount = #recods[i]
            for c=1,colCount do
                local data = recods[i][c]
                if c>6 then
                    ---L型显示
                    local index = (i+c-6)*6
                    items[index]:UpdateInfo(data,self.ShowFade and rowCount==i and c==colCount)
                else
                    local index = (i-1)*6+c
                    items[index]:UpdateInfo(data,self.ShowFade and rowCount==i and c==colCount)
                end
            end
        end
    end
end

---更新预测信息
function RoadView:UpdateYuCeInfo()
    self:YuCeNextValue(self.nextLong,DRAGON_TIGER_FIGHT_WIN_SIDE.LONG)
    self:YuCeNextValue(self.nextHu,DRAGON_TIGER_FIGHT_WIN_SIDE.HE)
end

---预测数据计算
function RoadView:YuCeNextValue(yuceItems,winType)
    local DaYanValue = nil
    local XiaoLuValue = nil
    local YueYouValue = nil

    if self.zhiLuRecods and #self.zhiLuRecods>0 then
        --有大眼 才有其他路
        if self.daLuRecods and self.daLuRecods[#self.daLuRecods][1][1] == winType then
            local count = #self.daLuRecods
            local col = #self.daLuRecods[#self.daLuRecods]
            if self.daLuRecods[count -1][col]~= nil and  self.daLuRecods[count -1][col +1]==nil then
                DaYanValue = DRAGON_TIGER_FIGHT_ROAD_SIDE.YES 
            else
                DaYanValue = DRAGON_TIGER_FIGHT_ROAD_SIDE.NO 
            end

            if self.xiaoLuRecods and #self.xiaoLuRecods > 0 and #self.xiaoLuRecods[1]>0 then
                if self.daLuRecods[count -2][col]~= nil and  self.daLuRecods[count -2][col +1]==nil then
                    XiaoLuValue = DRAGON_TIGER_FIGHT_ROAD_SIDE.YES 
                else
                    XiaoLuValue = DRAGON_TIGER_FIGHT_ROAD_SIDE.NO 
                end
            end

            if self.yueYouLuRecods and #self.yueYouLuRecods>0 and #self.yueYouLuRecods[1]>0 then
                if self.daLuRecods[count -3][col]~= nil and  self.daLuRecods[count -3][col +1]==nil then
                    YueYouValue = DRAGON_TIGER_FIGHT_ROAD_SIDE.YES 
                else
                    YueYouValue = DRAGON_TIGER_FIGHT_ROAD_SIDE.NO 
                end
            end
        elseif self.daLuRecods[#self.daLuRecods].side ~= DRAGON_TIGER_FIGHT_WIN_SIDE.HE then
            local cont = #self.daLuRecods
            if #self.daLuRecods[cont] ~= #self.daLuRecods[cont -1] then
                DaYanValue = DRAGON_TIGER_FIGHT_ROAD_SIDE.YES 
            else
                DaYanValue = DRAGON_TIGER_FIGHT_ROAD_SIDE.NO 
            end

            if self.xiaoLuRecods and #self.xiaoLuRecods > 0 and #self.xiaoLuRecods[1]>0 then
                if #self.daLuRecods[cont] ~= #self.daLuRecods[cont -2] then
                    XiaoLuValue = DRAGON_TIGER_FIGHT_ROAD_SIDE.YES 
                else
                    XiaoLuValue = DRAGON_TIGER_FIGHT_ROAD_SIDE.NO 
                end
            end

            if self.yueYouLuRecods and #self.yueYouLuRecods>0 and #self.yueYouLuRecods[1]>0 then
                if #self.daLuRecods[cont] ~= #self.daLuRecods[cont -3] then
                    YueYouValue = DRAGON_TIGER_FIGHT_ROAD_SIDE.YES 
                else
                    YueYouValue = DRAGON_TIGER_FIGHT_ROAD_SIDE.NO 
                end
            end
        end
    end

    yuceItems.zilu:UpdateInfo(DaYanValue)
    yuceItems.xiaolu:UpdateInfo(XiaoLuValue)
    yuceItems.yueyoulu:UpdateInfo(YueYouValue)
end

---更新右侧统计数信息
function RoadView:UpdateRightTotalInfo()
    ---数据统计
    self.longTotal = 0
    self.huTotal = 0
    self.heTotal = 0
    self.count = #self.RoadHistoryRecord
    
    for i=1,self.count do
        if self.RoadHistoryRecord[i].win_side == DRAGON_TIGER_FIGHT_WIN_SIDE.LONG then
            self.longTotal = self.longTotal+1
        elseif self.RoadHistoryRecord[i].win_side == DRAGON_TIGER_FIGHT_WIN_SIDE.HU then
            self.huTotal = self.huTotal+1
        else
            self.heTotal = self.heTotal+1
        end
    end
    ---更新UI
    self.longWinNum.text=self.longTotal
    self.huWinNum.text=self.huTotal
    self.heWinNum.text=self.heTotal
    self.totalNum.text=self.count
end

return RoadView