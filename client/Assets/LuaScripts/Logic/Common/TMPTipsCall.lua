
---@param tmpText TMPro.TextMeshProUGUI
function OnClickTMPTips(tmpText)
    look("获取的点击文本为：",tmpText.text)
    SuspensionTipsUtil.SuspensionTips(tmpText.text)
end