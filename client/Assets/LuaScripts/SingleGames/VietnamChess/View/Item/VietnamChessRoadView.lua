--
--time:{time}
--{paramdesc} 
--@desc 
--
---@class VietnamChessRoadView
local VietnamChessRoadView=Class("VietnamChessRoadView")
local VietnamChessLuItem=require("SingleGames/VietnamChess/View/Item/VietnamChessLuItem")
local VietnamChessConfig=require("SingleGames/VietnamChess/VietnamChessConfig")
function VietnamChessRoadView:ctor(go)
    ---@type UnityEngine.GameObject
    self.gameObject = go
    ---@type UnityEngine.Transform
    self.transform=self.gameObject.transform
    ---右侧统计数信息
    self.ouNum=ComponentUtilGet.TextMeshProUGUI(self.transform,"num1")
    self.jiNum=ComponentUtilGet.TextMeshProUGUI(self.transform,"num2")

    ---游戏结果记录
    self.scrollContent=ComponentUtilGet.Transform(self.transform,"scroll/Viewport/Content")
    self.LuPrefab = ComponentUtilGet.Transform(self.transform,"scroll/Viewport/item/luItem")
    ---@type ZhuPianItem[]
    self.LuItems ={}
    self.LuRecods ={}
    local countLu = (VIETNAM_CHESS_ROAD_COL+1)*6
    for i=1,countLu do
        local go = GameObject.Instantiate(self.LuPrefab)
        go.transform:SetParent(self.scrollContent,false)
        self.LuItems[i] = VietnamChessLuItem.New(go)
        self.LuItems[i]:ResetInfo()
    end
    self.RoadHistoryRecord = nil
end

function VietnamChessRoadView:ResetAllInfo()
    self.ouNum.text=0
    self.jiNum.text=0
    self.count = 0
    
    for i=1,#self.LuItems do
        self.LuItems[i]:ResetInfo()
    end
    self.LuRecods ={}
    
end

function VietnamChessRoadView:Show()
    self.gameObject:SetActive(false)
end

function VietnamChessRoadView:Hiden()
    self.gameObject:SetActive(true)
end

function VietnamChessRoadView:UpdatePanelInfo(data,showFade)
    self.RoadHistoryRecord = data
    self.ShowFade = showFade
    
    self:ResetAllInfo()
    
    if #self.RoadHistoryRecord == 0 then
        return
    end
    
    self:UpdateLuInfo()
end

function VietnamChessRoadView:UpdateLuInfo()
    ---分析大路数据 【奇/偶，棋型序号】
    self.LuRecods={}
    ---数据统计
    self.num1 = 0
    self.num2 = 0
    self.count = #self.RoadHistoryRecord
    
    local side = 0
    local index = 0
    local serial = 0
    local oldSide = nil
    
    ---数据处理
    for i=1,self.count do
        local count = ArrayUtil.countByVale(self.RoadHistoryRecord[i],VietnamChessConfig.QICOLOR.WHITE)
        if count%2==0 then
            side = VietnamChessConfig.QICOLOR.WHITE
            self.num1 = self.num1+1
        else
            side = VietnamChessConfig.QICOLOR.BLACK
            self.num2 = self.num2+1
        end
        serial = ArrayUtil.indexOf(VietnamChessConfig.CHESS_TYPE,count)

        if oldSide~=side then
            index = index + 1
            self.LuRecods[index] = {}
        end
        table.insert(self.LuRecods[index],{ side, serial })
        oldSide = side
        
    end

    ---更新UI
    if self.LuRecods then
        self:UpdateRightGridView(self.LuItems,self.LuRecods)
    end
    
    self.ouNum.text=self.num1
    self.jiNum.text=self.num2
end

---更新右侧各路信息
function VietnamChessRoadView:UpdateRightGridView(items,recods)
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

    if maxRowCount>VIETNAM_CHESS_ROAD_COL then
        local prev=maxRowCount-VIETNAM_CHESS_ROAD_COL
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


return VietnamChessRoadView