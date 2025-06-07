--存储数据及一些配置
---@class GameSlotConfig
local GameSlotConfig=Class("GameSlotConfig")
local  this = GameSlotConfig;

this.itemSpace = -230 --行间距
this.lieNum = 5
this.itemNum = 32
this.totalLineNum=25--总线数
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
        [1]=1.2,
        [2]=1.6,
        [3]=2,
        [4]=2.4,
        [5]=2.8,
    },
    rebackTime={--回弹时间
        [1]=0.1,
        [2]=0.1,
        [3]=0.1,
        [4]=0.1,
        [5]=0.1,
    }
}


this.ABNames={
    icon="SingleGames/GameTemp/alats/icons",--icon
}


this.icon_Pics={}
--iconName
this.iocnPicName={
    [1]="icon 1",
    [2]="icon 2",
    [3]="icon 3",
    [4]="icon 4",
    [5]="icon 5",
    [6]="icon 6",
    [7]="icon 7",
    [8]="icon 8",
    [9]="icon 9",
    [10]="icon 10",
}

this.LinlIconName={
    [1]="icon 1",
    [2]="icon 2",
    [3]="icon 3",
    [4]="icon 4",
    [5]="icon 5",
    [6]="icon 6",
    [7]="icon 7",
    [8]="icon 8",
    [9]="icon 9",
    [10]="icon 10",
}

function this.InitIconPic()
    local pics=resMgr:LoadAllAssets(this.ABNames.icon,typeof(UnityEngine.Sprite))
    for i = 0, pics.Length-1 do
        local pic=pics[i];
        this.icon_Pics[pic.name]=pic;
    end
    look("this.icon_Pics",this.icon_Pics)
end



return this