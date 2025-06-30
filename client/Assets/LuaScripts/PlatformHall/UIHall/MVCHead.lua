CtrlNames.UIHallGames="UIHallGames";
CtrlManager.CtrlsCollection[CtrlNames.UIHallGames]={};
CtrlManager.CtrlsCollection[CtrlNames.UIHallGames].ctrl =require "PlatformHall/UIHall/Ctrl/UIHallGamesCtrl";
CtrlManager.CtrlsCollection[CtrlNames.UIHallGames].view=require "PlatformHall/UIHall/View/UIHallGamesView";
CtrlManager.CtrlsCollection[CtrlNames.UIHallGames].model=require "PlatformHall/UIHall/Model/UIHallGamesModel";

CtrlNames.UIHall="UIHall";
CtrlManager.CtrlsCollection[CtrlNames.UIHall]={};
CtrlManager.CtrlsCollection[CtrlNames.UIHall].ctrl =require "PlatformHall/UIHall/Ctrl/UIHallCtrl";
CtrlManager.CtrlsCollection[CtrlNames.UIHall].view=require "PlatformHall/UIHall/View/UIHallView";
CtrlManager.CtrlsCollection[CtrlNames.UIHall].model=require "PlatformHall/UIHall/Model/UIHallModel";

