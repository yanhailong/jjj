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
        require("SingleGames/Baccarat/MVCHead")
        CtrlManager.SingleShow(CtrlNames.BaccaratGame)
    end)
    self.isCount = false;
    UpdateManager.AddUpdate(self,self.Update)
end

---初始化数据显示
function BaccaratItemScripts:InitDataShow(index,data)
    self.BaccaratTableSummary = data;
    self.CurGamePhase = data.eGamePhase;
    self.txt_ClassicNumber.text = string.format("%02d",index);
    self:RefreshUIShow(data)
    self.BaccaratRoadScripts:InitData(data);
end
---刷新单个数据显示
function BaccaratItemScripts:RefreshDataShow(data)
    self.CurGamePhase = data.eGamePhase;
    self:RefreshUIShow(data)
    table.insert( self.BaccaratTableSummary.winStateList,data.winState)
    table.insert( self.BaccaratTableSummary.cardTypeWinStateList,data.cardTypeWinState)
    self.BaccaratRoadScripts:RefreshData(data,false)
end
---刷新UI显示显示
function BaccaratItemScripts:RefreshUIShow(data)
    self.tmp_RemainingNumber.text = string.format("%d/%d",data.restCardNum,data.totalCardNum)
    if data.eGamePhase == 0 then--下注中
        self.tmp_Stage.text = LocalManager.GetStrById(200500004)
    elseif data.eGamePhase == 4 then -- 结算中
        self.tmp_Stage.text = LocalManager.GetStrById(200500003)
    end
    self.slider_CountdownTime.maxValue = data.phaseTotalTime
    self.CountdownTime = data.phaseRemainingTime;
    self.slider_CountdownTime.value = self.CountdownTime;
    self.isCount = true;
end

function BaccaratItemScripts:Update()
    if(self.isCount) then
        self.CountdownTime = self.CountdownTime-Time.deltaTime;
        if( self.CountdownTime<=0) then
            self.isCount = false;
            self.ctrl.model:ReqBaccaratTableSummary()
            if(self.CurGamePhase == 0) then--下注结束请求结算
                self.ctrl.model:ReqBaccaratTableSummary(self.BaccaratTableSummary.roomId, #self.BaccaratTableSummary.winStateList)
            elseif(self.CurGamePhase == 4) then --结算结算，请求下一局    
                self.ctrl.model:ReqBaccaratTableSummary(self.BaccaratTableSummary.roomId, #self.BaccaratTableSummary.winStateList+1)
            end
        else
            self.slider_CountdownTime.value = self.CountdownTime;
        end
    end
end

function BaccaratItemScripts:Destroy()
   UpdateManager.ReMoveAllUpdate(self)
    self.BaccaratRoadScripts:Destroy()
end


return BaccaratItemScripts