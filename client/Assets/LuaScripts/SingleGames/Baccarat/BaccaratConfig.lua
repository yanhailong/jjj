---@class BaccaratConfig
local BaccaratConfig = Class("BaccaratConfig")
local this = BaccaratConfig;
---筹码类型
this.ChipState={
    One = 1,
    Ten = 10,
    Fifty = 50,
    OneHundred = 100,
    FiveHundred = 500,
}
---当前选中的筹码
this.ABNames={
    icons="SingleGames/Baccarat/alats/icons",--icon
    chipPool="SingleGames/Baccarat/prefabs/Pool"--筹码
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
---获取对应筹码的预支名字
function this.GetChipPoolName(chipStateName)
    if chipStateName == this.ChipState.One then
        return "BaccaratOneChip";
    elseif chipStateName == this.ChipState.Ten then
        return "BaccaratTenChip";
    elseif chipStateName == this.ChipState.Fifty then
        return "BaccaratFiftyChip";
    elseif chipStateName == this.ChipState.OneHundred then
        return "BaccaratOneHundredChip";
    elseif chipStateName == this.ChipState.FiveHundred then
        return "BaccaratFiveHundredChip";
    end
end
return this;