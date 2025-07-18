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
---下注的区域
this.BetState={
    BPair = 1,
    Tie = 2,
    PPair =3,
    Player = 4,
    Banker = 5,
}


this.WhoWin = {
    BankerWin = 1,
    PlayerWin =2,
    TieWin = 3,
}
this.ABNames={
    Main="SingleGames/Baccarat/atlas/Main",
    Card="Common/GameArtsCommon/GameFight/alats/card",--牌
    chipPool="SingleGames/Baccarat/prefabs/Pool",--筹码
    prefabsItem = "SingleGames/Baccarat/prefabs" ,--预支item路径
    commonMain = "Common/GameArtsCommon/GameFight/alats/main",--通用资源主路径
}
---通用资源
this.commonMain_Pics = {}
function this.InitCommonMainPic()
    local pics=resMgr:LoadAllAssets(this.ABNames.commonMain,typeof(UnityEngine.Sprite))
    for i = 0, pics.Length-1 do
        local pic=pics[i];
        this.commonMain_Pics[pic.name]=pic;
    end
end
---获取通用资源Sprite
function this.GetCommonMainPic(iconName)
    return this.commonMain_Pics[iconName];
end
---Main里面的图片
this.icon_Pics={}
function this.InitIconPic()
    local pics=resMgr:LoadAllAssets(this.ABNames.Main,typeof(UnityEngine.Sprite))
    for i = 0, pics.Length-1 do
        local pic=pics[i];
        this.icon_Pics[pic.name]=pic;
    end
end

---扑克牌的图片
this.card_Pics={}
function this.InitCardPic()
    local pics=resMgr:LoadAllAssets(this.ABNames.Card,typeof(UnityEngine.Sprite))
    for i = 0, pics.Length-1 do
        local pic=pics[i];
        this.card_Pics[pic.name]=pic;
    end
end

function this.InitUIImageGray()
    this.material = resMgr:LoadAsset("Common/Material/UIImageGray",typeof(UnityEngine.Material))
end

function this.GetUIImageGray()
    return this.material;
end
---通过资源名获取Sprite
function this.GetIconPic(iconName)
    return this.icon_Pics[iconName];
end

function this.GetCardPic(cardName)
    return this.card_Pics[cardName];
end
---随机获取一个牌型
function this.GetPaiXing()
   local num = math.random(1,4);
    if(num==1) then
        return "fk_"
    elseif(num == 2) then
        return "hm_"
    elseif(num == 3) then
        return "hx_"
    elseif(num == 4) then
        return "heix_"
    end
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

function this.GetChipMoneyNum(chipStateName)
    if chipStateName == this.ChipState.One then
        return 1
    elseif chipStateName == this.ChipState.Ten then
        return 10
    elseif chipStateName == this.ChipState.Fifty then
        return 50
    elseif chipStateName == this.ChipState.OneHundred then
        return 100
    elseif chipStateName == this.ChipState.FiveHundred then
        return 500
    end
end
return this;