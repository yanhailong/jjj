---@class UITestScrollItem
local UITestScrollItem=Class("UITestScrollItem",SimpleItem)

function UITestScrollItem:ctor(go)
    self.super.ctor(self, go)
end

function UITestScrollItem:InitedItem()
    logError("初始化组件")
    self.txt_name=ComponentUtilGet.TextMeshProUGUI(self.transform,"txt_name")
end

function UITestScrollItem:UpdateItem(data, index)
    self.txt_name.text=data.name
end

return UITestScrollItem