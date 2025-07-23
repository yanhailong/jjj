---@class BaccaratItemScripts
local BaccaratItemScripts = Class("BaccaratItemScripts")
---@type BaccaratConfig
local config=require("SingleGames/Baccarat/BaccaratConfig")
---@type BaccaratZhuPanItem
local BaccaratZhuPanItem = require"SingleGames/Baccarat/Ctrl/BaccaratZhuPanItem"
---@type BaccaratRoad
local BaccaratRoad = require("SingleGames/Baccarat/Ctrl/BaccaratRoad")
local Vector3 = CS.UnityEngine.Vector3
local Time = CS.UnityEngine.Time

function BaccaratItemScripts:ctor(obj,ctrl)
    ---@type UnityEngine.GameObject
    self.gameObject = obj
    ---@type UnityEngine.Transform
    self.transform = obj.transform
    ---@type BaccaratMainCtrl
    self.ctrl=ctrl
    self.obj_ZhuPanContent = ComponentUtilGet.GameObject(self.transform,"BaccaratRoad/ZhuPanScroll/Viewport/obj_ZhuPanContent");
    self.obj_DaLuContent = ComponentUtilGet.GameObject(self.transform,"BaccaratRoad/DaLuScroll/Viewport/obj_DaLuContent");
    self.obj_DaluZiluContent = ComponentUtilGet.GameObject(self.transform,"BaccaratRoad/DaluZiluScroll/Viewport/obj_DaluZiluContent");
    self.obj_XiaoLuContent = ComponentUtilGet.GameObject(self.transform,"BaccaratRoad/XiaoLuScroll/Viewport/obj_XiaoLuContent");
    self.obj_YueYouLuContent = ComponentUtilGet.GameObject(self.transform,"BaccaratRoad/YueYouLuScroll/Viewport/obj_YueYouLuContent");
    self.btn_EnterGame = ComponentUtilGet.Button(self.transform,"btn_EnterGame");
    self.tmp_ZNum = ComponentUtilGet.TextMeshProUGUI(self.transform,"DownRoot/tmp_ZNum")
    self.tmp_XNum = ComponentUtilGet.TextMeshProUGUI(self.transform,"DownRoot/tmp_XNum")
    self.tmp_HNum = ComponentUtilGet.TextMeshProUGUI(self.transform,"DownRoot/tmp_HNum")
    self.txt_ClassicNumber = ComponentUtilGet.Text(self.transform,"TopRoot/Classic/txt_ClassicNumber")
    self.tmp_RemainingNumber = ComponentUtilGet.TextMeshProUGUI(self.transform,"TopRoot/Remaining/tmp_RemainingNumber")
    self.tmp_Stage = ComponentUtilGet.TextMeshProUGUI(self.transform,"TopRoot/tmp_Stage")
    self.slider_CountdownTime = ComponentUtilGet.Slider(self.transform,"TopRoot/slider_CountdownTime")
    ---@type BaccaratRoad
    self.BaccaratRoadScripts =BaccaratRoad.New()
    self.BaccaratRoadScripts:Init(self.obj_ZhuPanContent,self.obj_DaLuContent,self.obj_DaluZiluContent,self.obj_XiaoLuContent,self.obj_YueYouLuContent);
    self.ctrl.uiEventListener:AddClick(self.btn_EnterGame,function()
        self:EnterGame()
    end )
    self.isCount = false;
    UpdateManager.AddUpdate(self,self.Update)
end

---初始化数据显示
function BaccaratItemScripts:InitDataShow(index,data)
    self.BaccaratTableSummary = data;
    self.RemainingCardNum = self.BaccaratTableSummary.baccaratBaseInfo.remainingCardNum--剩余牌数量
    self.BankerWinNum=0;
    self.PlayerWinNum=0;
    self.TieWinNum=0;
    self.CurGamePhase = data.baccaratBaseInfo.eGamePhase;
    self.txt_ClassicNumber.text = string.format("%02d",index);
    for i, v in ipairs(data.cardStateList) do
        if(self.CurGamePhase == "GAME_ROUND_OVER_SETTLEMENT" and i == #data.cardStateList ) then
            self.BaccaratBaseInfo = v;
            break;
        end
        if(v.winState == config.WhoWin.BankerWin) then 
            self.BankerWinNum = self.BankerWinNum+1
        elseif(v.winState==config.WhoWin.PlayerWin) then
            self.PlayerWinNum = self.PlayerWinNum+1
        elseif(v.winState==config.WhoWin.TieWin) then
            self.TieWinNum = self.TieWinNum+1
        end
    end
    self:RefreshUIShow(data)
    self:RefreshTmpShow();
    self.BaccaratRoadScripts:InitData(data,self.CurGamePhase == 5);
end
---刷新单个数据显示
function BaccaratItemScripts:RefreshDataShow(data)
    self.CurGamePhase = data.baccaratBaseInfo.eGamePhase;
    self.IsNewRound = data.baccaratBaseInfo.remainingCardNum > self.RemainingCardNum;
    self.RemainingCardNum = data.baccaratBaseInfo.remainingCardNum;
    if( data.baccaratBaseInfo.eGamePhase == "GAME_ROUND_OVER_SETTLEMENT" ) then
        self.BaccaratBaseInfo = data.baccaratCardState;
        table.insert(self.BaccaratTableSummary.cardStateList,data.baccaratCardState)
    end
    self:RefreshUIShow(data)
end
---刷新UI显示显示
function BaccaratItemScripts:RefreshUIShow(data)
    self.tmp_RemainingNumber.text = string.format("%d/%d",data.baccaratBaseInfo.remainingCardNum,data.baccaratBaseInfo.totalCardNum)
    if  self.CurGamePhase == "BET" then--下注中
        self.tmp_Stage.text = LocalManager.GetStrById(200500004)
    elseif  self.CurGamePhase == "GAME_ROUND_OVER_SETTLEMENT" then -- 结算中
        self.tmp_Stage.text = LocalManager.GetStrById(200500003)
    end
    self.CountdownTime = data.baccaratBaseInfo.phaseEndTimestamp - data.baccaratBaseInfo.serverCurrentTime-1000;
    self.slider_CountdownTime.maxValue = data.baccaratBaseInfo.phaseTotalTime-1000
    self.slider_CountdownTime.value = self.CountdownTime;
    self.isCount=true;
end

function BaccaratItemScripts:RefreshTmpShow()
    self.tmp_ZNum.text = self.BankerWinNum;
    self.tmp_XNum.text = self.PlayerWinNum;
    self.tmp_HNum.text = self.TieWinNum;
end
---请求服务器进入房间
function BaccaratItemScripts:EnterGame()
    --请求进入房间
    self.ctrl.model:ReqJoinRoomInGame(self.BaccaratTableSummary.baccaratBaseInfo.roomId,200500,self.BaccaratTableSummary.baccaratBaseInfo.wareId);
end
function BaccaratItemScripts:Update()
    if (self.isCount) then
        self.CountdownTime = self.CountdownTime-(Time.deltaTime*1000);
        self.slider_CountdownTime.value = self.CountdownTime;
        if(self.CountdownTime<=0) then
            self.isCount = false;
            if(self.CurGamePhase == "GAME_ROUND_OVER_SETTLEMENT") then 
                self.BaccaratRoadScripts:RefreshData(self.BaccaratBaseInfo,false,self.IsNewRound)
                if(self.BaccaratBaseInfo.winState==  config.WhoWin.BankerWin) then
                    self.BankerWinNum = self.BankerWinNum+1
                elseif(self.BaccaratBaseInfo.winState==config.WhoWin.PlayerWin) then
                    self.PlayerWinNum = self.PlayerWinNum+1
                elseif(self.BaccaratBaseInfo.winState==config.WhoWin.TieWin) then
                    self.TieWinNum = self.TieWinNum+1
                end
                self:RefreshTmpShow();
            end
            --if(self.CurGamePhase == "BET") then--下注结束请求结算
            --    self.ctrl.model:ReqBaccaratTableSummary(self.BaccaratTableSummary.baccaratBaseInfo.roomId, #self.BaccaratTableSummary.cardStateList)
            --elseif(self.CurGamePhase == "GAME_ROUND_OVER_SETTLEMENT") then --结算结算，请求下一局    
            --    self.BaccaratRoadScripts:RefreshData(self.BaccaratBaseInfo,false,self.IsNewRound)
            --    if(self.BaccaratBaseInfo.winState==  config.WhoWin.BankerWin) then
            --        self.BankerWinNum = self.BankerWinNum+1
            --    elseif(self.BaccaratBaseInfo.winState==config.WhoWin.PlayerWin) then
            --        self.PlayerWinNum = self.PlayerWinNum+1
            --    elseif(self.BaccaratBaseInfo.winState==config.WhoWin.TieWin) then
            --        self.TieWinNum = self.TieWinNum+1
            --    end
            --    self:RefreshTmpShow();
            --    self.ctrl.model:ReqBaccaratTableSummary(self.BaccaratTableSummary.baccaratBaseInfo.roomId, #self.BaccaratTableSummary.cardStateList)
            --end
        end
    end
end

function BaccaratItemScripts:Destroy()
    UpdateManager.ReMoveAllUpdate(self)
    self.BaccaratRoadScripts:Destroy()
end


return BaccaratItemScripts