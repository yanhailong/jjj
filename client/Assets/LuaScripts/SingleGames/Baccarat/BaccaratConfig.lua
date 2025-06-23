---@class BaccaratConfig
local BaccaratConfig = Class("BaccaratConfig")
local this = BaccaratConfig;
this.ABNames={
    icons="SingleGames/Baccarat/alats/icons",--icon
}
this.icon_Pics={}
function this.InitIconPic()
    local pics=resMgr:LoadAllAssets(this.ABNames.icons,typeof(UnityEngine.Sprite))
    for i = 0, pics.Length-1 do
        local pic=pics[i];
        this.icon_Pics[pic.name]=pic;
    end
end

function this.GetIconPic(iconName)
    return this.icon_Pics[iconName];
end
return this;