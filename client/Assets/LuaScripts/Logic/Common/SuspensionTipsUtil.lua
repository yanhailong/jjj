---
---@author:Y00                   
---@CreateTime: 2022-12-28 14:37
---
---@class SuspensionTipsUtil
SuspensionTipsUtil = { };
local this = SuspensionTipsUtil;
local CoroutineManager = CS.CoroutineManager.Instance
local objInfos = {};
local t_tips;
---@type UnityEngine.GameObject
local tips = {}
local uiEvent = UIEventListener.Get()
local okEvent
local cancelEvent
function this.SuspensionTips(textContent)
    if textContent == nil or textContent == "" then
        logError("显示内容不能为空");
        return ;
    end
    this.SetObjTips(textContent);
end

function this.SetObjTips(content)
    local objInfo;
    if #objInfos > 0 then
        objInfo = objInfos[1];
        table.remove(objInfos, 1);
    else
        objInfo = {};
        if not t_tips then
            local gameObject = PanelManager.CreatePanel("OutPut/UI/CommTips", "CommShowTips", 5);
            t_tips = CommpontUtilGet.GameObject(gameObject.transform, "content/obj_tips");
        end
        local t = Tools.Instance(t_tips, t_tips.transform.parent)
        local txt_msg = CommpontUtilGet.Text(t.transform, "txt_msg");
        objInfo.gameObject = t.gameObject;
        objInfo.transform = t;
        objInfo.txt_msg = txt_msg;
    end

    Tools.SetActive(objInfo.gameObject, true);
    --objInfo.transform:SetAsLastSibling();
    objInfo.txt_msg.text = content;
    CoroutineManager:DelayCall(this, 1.5, function()
        table.insert(objInfos, objInfo);
        Tools.SetActive(objInfo.gameObject, false)
    end)
end

function this.SetOneBtnTip(content, okFunc)
    this.ShowBtnTip('OneBtnTip')
    CommpontUtilGet.Text(tips['OneBtnTip'].transform, 'Scroll/Viewport/txt_msg').text = content
    this.RectPosToZero(CommpontUtilGet.RectTransform(tips['OneBtnTip'].transform, 'Scroll/Viewport/txt_msg'))
    okEvent = okFunc
end

function this.RectPosToZero(rect)
    TimerManager.StartTimer(SuspensionTipsUtil,function()
        rect.anchoredPosition = Vector2.New(0, 0)
    end,0.1)
end

function this.SetTwoBtnTip(content, okFunc, cancelFunc, okText, cancelText)
    this.ShowBtnTip('TwoBtnTip')
    local root = tips['TwoBtnTip'].transform
    CommpontUtilGet.Text(root, 'Scroll/Viewport/txt_msg').text = content
    CommpontUtilGet.Text(root, 'okBtn/Text').text = okText or '确定'
    CommpontUtilGet.Text(root, 'cancelBtn/Text').text = cancelText or '取消'
    this.RectPosToZero(CommpontUtilGet.RectTransform(tips['TwoBtnTip'].transform, 'Scroll/Viewport/txt_msg'))
    okEvent = okFunc
    cancelEvent = cancelFunc
end

function this.ShowBtnTip(tipName)
    if not tips[tipName] then
        local tip = PanelManager.CreatePanel("OutPut/UI/CommTips", tipName, 4);
        local okBtn = CommpontUtilGet.Transform(tip.transform, 'okBtn')
        if okBtn then
            uiEvent:RemoveClick(okBtn.gameObject)
            uiEvent:AddClick(okBtn.gameObject, function()
                this.OKFunc(tipName)
            end)
        end
        local cancelBtn = CommpontUtilGet.Transform(tip.transform, 'cancelBtn')
        if cancelBtn then
            uiEvent:RemoveClick(cancelBtn.gameObject)
            uiEvent:AddClick(cancelBtn.gameObject, function()
                this.CancelFunc(tipName)
            end)
        end
        tips[tipName] = tip
    else
        tips[tipName]:SetActive(true)
    end
    tips[tipName]:SetScale(Vector3.Zero(), 0)
    tips[tipName]:SetScale(Vector3.One(), 0.3)
end

function this.OKFunc(tipName)
    tips[tipName]:SetActive(false)
    if okEvent then
        okEvent()
    end
end

function this.CancelFunc(tipName)
    tips[tipName]:SetActive(false)
    if cancelEvent then
        cancelEvent()
    end
end



