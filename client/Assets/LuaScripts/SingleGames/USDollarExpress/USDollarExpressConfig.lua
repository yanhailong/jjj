--存储数据及一些配置
---@class USDollarExpressConfig
local USDollarExpressConfig=Class("USDollarExpressConfig")
local  this = USDollarExpressConfig;

this.itemSpace = 240 --行间距
this.itemStartPosY  = -360
this.lieNum = 5
this.rollItemNum = 11
this.rollItemNumTime=0.33

this.totalLineNum=25    --总线数
this.isStandAlone = false --是否单机测试
this.freeTotalNum = 0   --总免费次数
this.curFreeNum=0       --当前剩余免费次数
this.showStep=0
this.freeState=false    --游戏状态

---游戏状态
this.gameState={
    Normal=1,--闲置状态
    RollState=2,--转动状态
    AutoState=3,--自动状态
    FreeState=4,--免费
    SmallGame=5,--小游戏
}
this.curGameState=this.gameState.Normal;

---@火车颜色
this.TrainColorType={
    GreenTrain=10,--绿车
    BlueTrain=11,--蓝车
    VioletTrain=12,--紫车
    RedTrain=13,--红车
    GoldTrain=14,--金车
}

this.trainAssetName={
    [1]="chexiang_group_01",
    [2]="chexiang_group_02",
    [3]="chexiang_group_03",
}

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
    icon="SingleGames/USDollarExpress/alats/icons",--icon
    train={
        [this.TrainColorType.GreenTrain]="SingleGames/USDollarExpress/effects/prefab/huoche/green",
        [this.TrainColorType.BlueTrain]="SingleGames/USDollarExpress/effects/prefab/huoche/blue",
        [this.TrainColorType.VioletTrain]="SingleGames/USDollarExpress/effects/prefab/huoche/violet",
        [this.TrainColorType.RedTrain]="SingleGames/USDollarExpress/effects/prefab/huoche/red",
        [this.TrainColorType.GoldTrain]="SingleGames/USDollarExpress/effects/prefab/huoche/yellow",
    },
    iconEffect="SingleGames/USDollarExpress/effects/prefab"
}


this.icon_Pics={}
--iconName
this.iocnPicName={
    [1]="mykd_TB_0",
    [2]="mykd_TB_1",
    [3]="mykd_TB_2",
    [4]="mykd_TB_3",
    [5]="mykd_TB_4",
    [6]="mykd_TB_5",
    [7]="mykd_TB_6",
    [8]="mykd_TB_7",
    [9]="mykd_TB_8",
    [10]="mykd_TB_9",
    [11]="mykd_TB_10",
    [12]="mykd_TB_11",
    [13]="mykd_TB_12",
    [14]="mykd_TB_13",
    [15]="mykd_TB_14",
    [16]="mykd_TB_15",
    [17]="mykd_TB_16",
    [18]="mykd_TB_17",
    [19]="mykd_TB_18",
    [20]="mykd_TB_19",
    [21]="mykd_TB_20",
    [22]="mykd_TB_21",
}

this.iconEffect={
    [1]="Eff_Chess_9",
    [2]="Eff_Chess_10",
    [3]="Eff_Chess_J",
    [4]="Eff_Chess_Q",
    [5]="Eff_Chess_K",
    [6]="Eff_Chess_A",
    [7]="Eff_Chess_9",
    [8]="Eff_Chess_9",
    [9]="Eff_Chess_9",
    [10]="Eff_Chess_9",
    [11]="Eff_Chess_9",
    [12]="Eff_Chess_9",
    [13]="Eff_Chess_9",
    [14]="Eff_Chess_9",
    [15]="Eff_Chess_9",
    [16]="Eff_Chess_wild",
    [17]="Eff_Chess_wild2x",
    [18]="Eff_Chess_wild5x",
    [19]="Eff_Chess_jinbi_$",
    [20]="Eff_Chess_jinbi_$",
    [21]="Eff_Chess_9",
    [22]="Eff_Chess_9",
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