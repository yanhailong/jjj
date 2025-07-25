--存储数据及一些配置
---@class SlotMachineConfig
local SlotMachineConfig=Class("SlotMachineConfig")
local  this = SlotMachineConfig;


this.ABNames={
    icon="SingleGames/MahjongWays/alats/icons",--icon
}

this.icon_Pics={}
--iconName
this.iocnPicName={
    [1]="1053_symbol_000",
    [2]="1053_symbol_001",
    [3]="1053_symbol_002",
    [4]="1053_symbol_003",
    [5]="1053_symbol_004",
    [6]="1053_symbol_005",
    [7]="1053_symbol_103",
    [8]="1053_symbol_007",
    [9]="1053_symbol_008",
    [10]="1053_symbol_009",
}
function this.InitIconPic()
    local pics=resMgr:LoadAllAssets(this.ABNames.icon,typeof(UnityEngine.Sprite))
    for i = 0, pics.Length-1 do
        local pic=pics[i];
        this.icon_Pics[pic.name]=pic;
    end
end



return this