local listener = CS.JiuJiuPrincess.UIEventListener
---@class UIEventListener
local UIEventListener = Class("UIEventListener")
---@return UIEventListener
function UIEventListener.Get()
    return UIEventListener.New();
end

function UIEventListener:ctor()
    self.event = listener.Get();
end


--region 添加事件
function UIEventListener:AddClick(btn, func)
    self.event:AddClick(btn.gameObject, func);
end

---@param func fun(go:UnityEngine.GameObject,isOn:boolean)
function UIEventListener:AddToggle(gameObject, func)
    self.event:AddToggle(gameObject, func);
end

function UIEventListener:AddSlider(gameObject, func)
    self.event:AddSlider(gameObject, func);
end

function UIEventListener:AddScrollRect(gameObject, func)
    self.event:AddScrollRect(gameObject, func);
end

function UIEventListener:AddLongPress(gameObject, func)
    self.event:AddLongPress(gameObject, func);
end

function UIEventListener:AddPressDown(gameObject, func)
    self.event:AddPressDown(gameObject, func);
end

function UIEventListener:AddPressUp(gameObject, func)
    self.event:AddPressUp(gameObject, func);
end

function UIEventListener:AddInputChange(gameObject, func)
    self.event:AddInputChange(gameObject, func);
end

function UIEventListener:AddDropdownSelect(gameObject, func)
    self.event:AddDropdownSelect(gameObject, func);
end

function UIEventListener:AddInputEndEdit(gameObject, func)
    self.event:AddInputEndEdit(gameObject, func);
end

function UIEventListener:AddBeginDrag(gameObject, func)
    self.event:AddBeginDrag(gameObject, func);
end

function UIEventListener:AddDrag(gameObject, func)
    self.event:AddDrag(gameObject, func);
end

function UIEventListener:AddEndDrag(gameObject, func)
    self.event:AddEndDrag(gameObject, func);
end

--endregion

--region 移除事件

function UIEventListener:RemoveClick(gameObject)
    self.event:RemoveClick(gameObject);
end

function UIEventListener:RemoveToggle(gameObject)
    self.event:RemoveToggle(gameObject);
end

function UIEventListener:RemoveSlider(gameObject)
    self.event:RemoveSlider(gameObject);
end

function UIEventListener:RemoveScrollRect(gameObject)
    self.event:RemoveScrollRect(gameObject);
end

function UIEventListener:RemovedLongPress(gameObject)
    self.event:RemovedLongPress(gameObject);
end

function UIEventListener:RemovedPressDown(gameObject)
    self.event:RemovedPressDown(gameObject);
end

function UIEventListener:RemovedPressUp(gameObject)
    self.event:RemovedPressUp(gameObject);
end

function UIEventListener:RemovedInputChange(gameObject)
    self.event:RemovedInputChange(gameObject);
end

function UIEventListener:RemovedDropdownSelect(gameObject)
    self.event:RemovedDropdownSelect(gameObject);
end

function UIEventListener:RemovedInputEndEdit(gameObject)
    self.event:RemovedInputEndEdit(gameObject);
end

function UIEventListener:RemovedBeginDrag(gameObject)
    self.event:RemovedBeginDrag(gameObject);
end

function UIEventListener:RemovedDrag(gameObject)
    self.event:RemovedDrag(gameObject);
end

function UIEventListener:RemovedEndDrag(gameObject)
    self.event:RemovedEndDrag(gameObject);
end
--endregion

function UIEventListener:Clear()
    self.event:Clear();
end

return UIEventListener;