local UICommonSelectionItem=Class("UICommonSelectionItem")

function UICommonSelectionItem:ctor(go,ctrl)
    self.transform=go.transform
    self.gameObject=go
    self.tmp_name=ComponentUtilGet.TextMeshProUGUI(self.transform,"name")
    self.tmp_value=ComponentUtilGet.TextMeshProUGUI(self.transform,"value")
    ---@type UICommonSelectionCtrl
    self.ctrl=ctrl
end

function UICommonSelectionItem:InitData()
    
end

function UICommonSelectionItem:AddClick()
    self.ctrl.uiEventListener:AddClick(self.gameObject, function
    ()
        logError("进入游戏------》")
    end)
end

return UICommonSelectionItem