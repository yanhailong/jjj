---@class SimpleItem
SimpleItem = Class("SimpleItem")

function SimpleItem:ctor(go)
    ---@type UnityEngine.GameObject
    self.gameObject = go
    ---@type UnityEngine.Transform
    self.transform = self.gameObject.transform
    self:InitedItem()
end

---初始化Item
function SimpleItem:InitedItem()
    
end

---更新
function SimpleItem:UpdateItem(data, index)

end
