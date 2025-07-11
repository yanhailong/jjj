---@class BaccaratItemScripts
local BaccaratItemScripts = Class("BaccaratItemScripts")
---当前房间数据
local BaccaratTableSummary;
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
    self.slider_CountdownTime = ComponentUtilGet.Slider(self.transform,"TopRoot/slider_CountdownTime")
    self.ctrl.uiEventListener:AddClick(self.btn_EnterGame,function()
        require("SingleGames/Baccarat/MVCHead")
        CtrlManager.SingleShow(CtrlNames.BaccaratGame)
    end)
end

---刷新数据显示
function BaccaratItemScripts:RefreshDataShow(data)
    BaccaratTableSummary = data;
end



function BaccaratItemScripts:Destroy()
   
end


return BaccaratItemScripts