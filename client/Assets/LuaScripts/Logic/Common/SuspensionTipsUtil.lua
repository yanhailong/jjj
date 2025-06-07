SuspensionTipsUtil = { };
local this = SuspensionTipsUtil;
local maxCount=3;
local objInfos={};
local obj_tips;
local transRoot;

local function SetObjTips(content)
    local objInfo;
    if #objInfos>0 then
        objInfo=objInfos[1];
        table.remove(objInfos,1);
    else
        objInfo={};
        if isnull(obj_tips) then
            local gameObject=PanelManager.CreatePanel("Common/UICommon","CommShowTips",5);
            transRoot=gameObject.transform
            obj_tips=ComponentUtilGet.GameObject(gameObject.transform,"obj_tips");
        end
        local o= Tools.Instance(obj_tips,transRoot)
        local txt_msg=ComponentUtilGet.TextMeshProUGUI(o.transform,"txt_msg");
        objInfo.gameObject=o;
        objInfo.transform=o.transform;
        objInfo.txt_msg=txt_msg;
    end

    Tools.SetActive(objInfo.gameObject,true);
    objInfo.transform:SetAsLastSibling();
    objInfo.txt_msg.text=content;

    CorManager.StartCor(this,function ()
        coroutine.wait(2.2)
        if #objInfos>=maxCount then
            Tools.Destroy(objInfo.gameObject);
            objInfo=nil;
        else
            table.insert(objInfos,objInfo);
            Tools.SetActive(objInfo.gameObject,false)
        end
    end)
    
end
function this.SuspensionTips(textContent)
    if textContent == nil or textContent == "" then
        logError("显示内容不能为空");
        return;
    end
    SetObjTips(textContent);
end