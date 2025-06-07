CtrlNames.GameTemp="GameTemp";
CtrlManager.CtrlsCollection[CtrlNames.GameTemp]={};
CtrlManager.CtrlsCollection[CtrlNames.GameTemp].ctrl =require "SingleGames/GameTemp/Ctrl/GameTempCtrl";
CtrlManager.CtrlsCollection[CtrlNames.GameTemp].view=require "SingleGames/GameTemp/View/GameTempView";
CtrlManager.CtrlsCollection[CtrlNames.GameTemp].model=require "SingleGames/GameTemp/Model/GameTempModel";

