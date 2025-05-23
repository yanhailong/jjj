require("Common/Scroll/SimpleItem")
---@class SimpleScroll
SimpleScroll = Class("SimpleScroll")

---@param uiDynamic
---@param actionInitItem
function SimpleScroll:Init(uiDynamic, actionInitItem)
    ---@type SimpleScroll
    self.uiDynamic = uiDynamic
    self.actionInitItem = actionInitItem
    self.itemTabs = {}
    self.uiDynamic.UpdateItem = Handler(self, self.UpdateItem)
end

function SimpleScroll:InitData(data)
    self.data = data
    self.uiDynamic:Init(#self.data)
end

function SimpleScroll:UpdateItem(go, index)
    local item = self.itemTabs[go]
    if item then
        item:UpdateItem(self.data[index], index)
    else
        item = self.actionInitItem(go)
        item:UpdateItem(self.data[index], index)
        self.itemTabs[go] = item
    end
end

return SimpleScroll
