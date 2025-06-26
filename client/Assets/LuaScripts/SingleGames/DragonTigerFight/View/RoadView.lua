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
    self.xiaoLuNums=0
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
    self.yueYouLuNums=0
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
    
    for i=1,#self.zhuPanItems do
        self.zhuPanItems[i]:ResetInfo()
    end
    
    for i=1,#self.daLuItems do
        self.daLuItems[i]:ResetInfo()
    end
    self.daLuRecods={}
    
    for i=1,#self.zhiLuItems do
        self.daLuItems[i]:ResetInfo()
    end
    self.zhiLuRecods={}
    
    for i=1,#self.xiaoLuItems do
        self.xiaoLuItems[i]:ResetInfo()
    end
    self.xiaoLuNums=0
    
    for i=1,#self.yueYouLuItems do
        self.yueYouLuItems[i]:ResetInfo()
    end
    self.yueYouLuNums=0
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
    local rowCount = #self.daLuRecods
    ---L型导致扩列的情况判断
    local maxRowCount = rowCount
    for i=1,rowCount do
        maxRowCount = math.max(i+#self.daLuRecods[i]%6, maxRowCount)
    end
    
    if maxRowCount>24 then
        local prev=maxRowCount-24
        for i=1,rowCount do
            local colCount = #self.daLuRecods[i]
            for c=1,colCount do
                local data = self.daLuRecods[i][c]
                if i>prev then
                    if c>6 then
                        ---L型显示
                        local index = (i+c-6-prev)*6
                        self.daLuItems[index]:UpdateInfo(data,self.ShowFade and rowCount==i and c==colCount)
                    else
                        ---跳过右移的数据
                        local index = (i-prev-1)*6+c
                        self.daLuItems[index]:UpdateInfo(data,self.ShowFade and rowCount==i and c==colCount)
                    end
                elseif c>6 and (i+c-6)>prev then
                    ---被移动隐藏的L是否在显示的列里面
                    local index = (i+c-6-prev)*6
                    self.daLuItems[index]:UpdateInfo(data,self.ShowFade and rowCount==i and c==colCount)
                end
            end
        end
    else
        for i=1,rowCount do
            local colCount = #self.daLuRecods[i]
            for c=1,colCount do
                local data = self.daLuRecods[i][c]
                if c>6 then
                    ---L型显示
                    local index = (i+c-6)*6
                    self.daLuItems[index]:UpdateInfo(data,self.ShowFade and rowCount==i and c==colCount)
                else
                    local index = (i-1)*6+c
                    self.daLuItems[index]:UpdateInfo(data,self.ShowFade and rowCount==i and c==colCount)     
                end
            end
        end
    end
end

function RoadView:UpdateZhiLuInfo()
    ---大眼子路数据处理
    self.zhiLuRecods={}


    ---更新UI
    local rowCount = #self.zhiLuRecods
    if rowCount>24 then
        local prev=math.ceil((total-48)/6)*6
    else
        for i=1,rowCount do
            local colCount = #self.zhiLuRecods[i]
            for c=1,colCount do
                local side = self.zhiLuRecods[i][c]
                if c>6 then
                    ---L型显示
                    local index = (i-1)*6+6+(c-6)*6
                    self.zhiLuItems[index]:UpdateInfo(side,self.ShowFade and rowCount==i and c==colCount)
                else
                    local index = (i-1)*6+c
                    self.zhiLuItems[index]:UpdateInfo(side,self.ShowFade and rowCount==i and c==colCount)
                end
            end
        end
    end
end

function RoadView:UpdateXiaoLuInfo()

end

function RoadView:UpdateYueYouLuInfo()

end

function RoadView:UpdateYuCeInfo()
    
end

return RoadView