---封装常用的组件获取
---@class ComponentUtilGet
ComponentUtilGet = {}
local this = ComponentUtilGet
---@return UnityEngine.UI.Text
function this.Text(transform, childPath)
    return this.GetComponent(transform, childPath, "UnityEngine.UI.Text")
end
---@return TMPro.TextMeshProUGUI
function this.TextMeshProUGUI(transform, childPath)
    return this.GetComponent(transform, childPath, "TMPro.TextMeshProUGUI")
end

---@return UnityEngine.UI.Image
function this.Image(transform, childPath)
    return this.GetComponent(transform, childPath, "UnityEngine.UI.Image")
end
---@return UnityEngine.UI.InputField
function this.InputField(transform, childPath)
    return this.GetComponent(transform, childPath, "UnityEngine.UI.InputField")
end
---@return UnityEngine.UI.Button
function this.Button(transform, childPath)
    return this.GetComponent(transform, childPath, "UnityEngine.UI.Button")
end

---@return UIButton
function this.UIButton(transform, childPath)
    return this.GetComponent(transform, childPath, "UIButton")
end
---@return UnityEngine.UI.Toggle
function this.Toggle(transform, childPath)
    return this.GetComponent(transform, childPath, "UnityEngine.UI.Toggle")
end
---@return UnityEngine.UI.ToggleGroup
function this.ToggleGroup(transform, childPath)
    return this.GetComponent(transform, childPath, "UnityEngine.UI.ToggleGroup")
end
---@return UnityEngine.UI.RawImage
function this.RawImage(transform, childPath)
    return this.GetComponent(transform, childPath, "UnityEngine.UI.RawImage")
end
---@return UnityEngine.RectTransform
function this.RectTransform(transform, childPath)
    return this.GetComponent(transform, childPath, "RectTransform")
end
---@return UnityEngine.UI.Slider
function this.Slider(transform, childPath)
    return this.GetComponent(transform, childPath, "UnityEngine.UI.Slider")
end
---@return UnityEngine.Animator
function this.Animator(transform, childPath)
    return this.GetComponent(transform, childPath, "Animator")
end
---@return UnityEngine.Camera
function this.Camera(transform, childPath)
    return this.GetComponent(transform, childPath, "Camera")
end
---@return UnityEngine.Light
function this.Light(transform, childPath)
    return this.GetComponent(transform, childPath, "Light")
end
---@return UnityEngine.UI.HorizontalLayoutGroup
function this.HorizontalLayoutGroup(transform, childPath)
    return this.GetComponent(transform, childPath, "UnityEngine.UI.HorizontalLayoutGroup")
end
---@return UnityEngine.UI.VerticalLayoutGroup
function this.VerticalLayoutGroup(transform, childPath)
    return this.GetComponent(transform, childPath, "UnityEngine.UI.VerticalLayoutGroup")
end

---@return UnityEngine.UI.ScrollRect
function this.ScrollRect(transform, childPath)
    return this.GetComponent(transform, childPath, "UnityEngine.UI.ScrollRect")
end

---@return UnityEngine.UI.Dropdown
function this.Dropdown(transform, childPath)
    return this.GetComponent(transform, childPath, "UnityEngine.UI.Dropdown")
end

---@return UnityEngine.UI.ContentSizeFitter
function this.ContentSizeFitter(transform, childPath)
    return this.GetComponent(transform, childPath, "UnityEngine.UI.ContentSizeFitter")
end

---@return UnityEngine.UI.GridLayoutGroup
function this.GridLayoutGroup(transform, childPath)
    return this.GetComponent(transform, childPath, "UnityEngine.UI.GridLayoutGroup")
end

---@return UnityEngine.CanvasGroup
function this.CanvasGroup(transform, childPath)
    return this.GetComponent(transform, childPath, "CanvasGroup")
end
---@return UnityEngine.LineRenderer
function this.LineRenderer(transform, childPath)
    return this.GetComponent(transform, childPath, "LineRenderer")
end
---@return UnityEngine.GameObject
function this.GameObject(transform, childPath)
    local trans = this.TransFindChild(transform, childPath)
    return trans.gameObject
end
---@return UnityEngine.Transform
function this.Transform(transform, childPath)
    local trans = this.TransFindChild(transform, childPath)
    return trans
end

---@return UGUITab
function this.UGUITab(transform, childPath)
    return this.GetComponent(transform, childPath, "UGUITab")
end

---@return UGUITabGroup
function this.UGUITabGroup(transform, childPath)
    return this.GetComponent(transform, childPath, "UGUITabGroup")
end

---@return SimpleScroll
function this.SimpleScroll(transform, childPath)
    return this.GetComponent(transform, childPath, "SimpleScroll")
end

---@return Spine.Unity.SkeletonGraphic
function this.SkeletonGraphic(transform, childPath)
    return this.GetComponent(transform, childPath, "Spine.Unity.SkeletonGraphic")
end

---@param获取组件
function this.GetComponent(transform, childPath, strcom)
    if transform == nil  then
        logError("CommpontUtilGet." .. strcom .. "参数有误：" .. " Trans:" .. tostring(transform))
        return
    end
    if childPath == nil or childPath == '' then
        local result=transform.gameObject:GetComponent(strcom)
        return result
    end
    local trans = this.TransFindChild(transform, childPath)
    if IsNull(trans) then
        return nil
    end
    local com = trans.gameObject:GetComponent(strcom)
    return com
end

---@param查询子物体
function this.TransFindChild(transform, str)
    if transform == nil or str == nil then
        logError("transform or str 为空")
        return nil;
    end
    local trans = transform:Find(str)
    if trans == nil then
        logError("找不到对象:" .. str)
        return nil;
    end
    return trans;
end

return ComponentUtilGet