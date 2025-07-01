---@class RoyalWarConfig
local RoyalWarConfig = Class("RoyalWarConfig");
local this = RoyalWarConfig;

this.GameSate = {
    Start = 1,--开始阶段
    Bet =2,--下注阶段
    Settlement =3,--结算阶段
}
---筹码类型
this.ChipState={
    One = 1,
    Ten = 10,
    Fifty = 50,
    OneHundred = 100,
    FiveHundred = 500,
}
---下注区域
this.BetState = {
    Red = 1,
    Black =2,
    Lucky = 3,
}

---花色类型
this.ColourType = {
    Square =1,--方块
    PlumBlossom = 2, --梅花
    RedPeach =3, --红桃
    Spades = 4 --黑桃
}
---牌型
this.CardType = {
    Leopard =6, --豹子
    ShunJin = 5, --顺金
    JinHua = 4, -- 金花
    ShunZi = 3, -- 顺子
    DuiZi = 2, -- 对子
    DanZhang = 1, --单张
    
}
---获取是哪种牌型
function this.GetCardType(oneNum,twoNum,threeNum,oneColour,twoColour,threeColour)
    if(oneNum == twoNum and oneNum == threeNum) then--豹子
        return this.CardType.Leopard;
    elseif(oneColour==twoColour and twoColour == threeColour) then--花色相同
        if(this.GetCardIsShunZi(oneNum,twoNum,threeNum)) then--是顺子
            return this.CardType.ShunJin;
        else--不是顺子
            return this.CardType.JinHua;
        end
    elseif(this.GetCardIsShunZi(oneNum,twoNum,threeNum)) then--是顺子
        return this.CardType.ShunZi;
    elseif(oneNum == twoNum or oneNum == threeNum or twoNum==threeNum ) then--是对子
        return this.CardType.DuiZi;
    else
        return this.CardType.DanZhang;
    end    
end
---返回是不是顺子
function this.GetCardIsShunZi(oneNum,twoNum,threeNum)
    local nums = {oneNum,twoNum,threeNum}
    table.sort(nums)
    return ((nums[2]-nums[1]) == 1) and ((nums[3]-nums[2]) == 1)
end


this.ABNames = {
    icons="SingleGames/RoyalWar/atlas",--icon
    prefabsItem = "SingleGames/RoyalWar/prefabs" ,--预支item路径
    chipPool = "SingleGames/RoyalWar/prefabs/Pool",--筹码
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

function this.GetColourName(num)
    if(num == this.ColourType.Square) then
        return "diamond"
    elseif(num==this.ColourType.PlumBlossom) then
        return "club"
    elseif(num==this.ColourType.RedPeach) then
        return "heart"
    elseif(num==this.ColourType.Spades) then
        return "spade"
    end
end
---获取牌型的资源名字
function this.GetCardTypeName(type)
    if(type == this.CardType.Leopard) then
        return "rwn_PBaoZi"
    elseif(type == this.CardType.ShunJin) then
        return "rwn_PtongHuaShun"
    elseif(type == this.CardType.JinHua) then
        return "rwn_PtongHua"
    elseif(type == this.CardType.ShunZi) then
        return "rwn_PShunZi"
    elseif(type == this.CardType.DuiZi) then
        return "rwn_PDuiZi"
    elseif(type == this.CardType.DanZhang) then
        return "rwn_PdanZhang"
    end
end

---获取对应筹码的预支名字
function this.GetChipPoolName(chipStateName)
    if chipStateName == this.ChipState.One then
        return "RoyalWarOneChip";
    elseif chipStateName == this.ChipState.Ten then
        return "RoyalWarTenChip";
    elseif chipStateName == this.ChipState.Fifty then
        return "RoyalWarFiftyChip";
    elseif chipStateName == this.ChipState.OneHundred then
        return "RoyalWarOneHundredChip";
    elseif chipStateName == this.ChipState.FiveHundred then
        return "RoyalWarFiveHundredChip";
    end
end
return this;