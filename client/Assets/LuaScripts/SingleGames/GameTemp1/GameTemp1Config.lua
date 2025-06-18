--存储数据及一些配置
---@class GameTemp1Config
local GameTemp1Config=Class("GameTemp1Config")
local  this = GameTemp1Config;

this.itemSpace = 180 --行间距
this.itemStartPosY  = -268
this.lieNum = 5
this.rollItemNum = 11
this.rollItemNumTime=0.33

this.totalLineNum=25    --总线数
this.isStandAlone = false --是否单机测试
this.freeTotalNum = 0   --总免费次数
this.curFreeNum=0       --当前剩余免费次数
this.showStep=0
this.freeState=false    --游戏状态
this.isLinked=false     --link状态
this.isFirestEnterLink=0--判断是否是第一次进入link


---游戏状态
this.gameState={
    Normal=1,--闲置状态
    RollState=2,--转动状态
    AutoState=3,--自动状态
    FreeState=4,--免费
    SmallGame=5,--小游戏
}
this.curGameState=this.gameState.Normal;


this.rollTime={
    dropTime={--下落总时间
        [1]=3,
        [2]=3,
        [3]=3,
        [4]=3,
        [5]=3,
    },
    rebackTime={--回弹时间
        [1]=0.2,
        [2]=0.2,
        [3]=0.2,
        [4]=0.2,
        [5]=0.2,
    }
}

this.ABNames={
    icon="SingleGames/GameTemp1/alats/icons",--icon
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