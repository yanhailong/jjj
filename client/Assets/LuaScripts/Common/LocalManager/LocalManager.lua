---@type  LanguageManager
local LanManager=CS.LanguageManager.Instance
---@class LocalManager
LocalManager=Class("LocalManager")
local this=LocalManager

function this.ChangeLan(str)
    LanManager:ChangeLanguage(str)
end

---@param 根据id获取对应的值
function this.GetStrById(langId)
    return LanManager:GetLanguage(tostring(langId),"")
end