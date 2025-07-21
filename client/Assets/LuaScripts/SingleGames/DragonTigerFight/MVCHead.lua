require("SingleGames/DragonTigerFight/MsgPro/pb_DragonTigerFight")

CtrlNames.DragonTigerFight="DragonTigerFight";
CtrlManager.CtrlsCollection[CtrlNames.DragonTigerFight]={};
CtrlManager.CtrlsCollection[CtrlNames.DragonTigerFight].ctrl =require "SingleGames/DragonTigerFight/Ctrl/DragonTigerFightCtrl";
CtrlManager.CtrlsCollection[CtrlNames.DragonTigerFight].view=require "SingleGames/DragonTigerFight/View/DragonTigerFightView";
CtrlManager.CtrlsCollection[CtrlNames.DragonTigerFight].model=require "SingleGames/DragonTigerFight/Model/DragonTigerFightModel";

CtrlNames.DragonTigerFightPlayerRank="DragonTigerFightPlayerRank";
CtrlManager.CtrlsCollection[CtrlNames.DragonTigerFightPlayerRank]={};
CtrlManager.CtrlsCollection[CtrlNames.DragonTigerFightPlayerRank].ctrl =require "SingleGames/DragonTigerFight/Ctrl/PlayerRankCtrl";
CtrlManager.CtrlsCollection[CtrlNames.DragonTigerFightPlayerRank].view=require "SingleGames/DragonTigerFight/View/PlayerRankView";
CtrlManager.CtrlsCollection[CtrlNames.DragonTigerFightPlayerRank].model=require "SingleGames/DragonTigerFight/Model/PlayerRankModel";

CtrlNames.DragonTigerFightRule="DragonTigerFightRule";
CtrlManager.CtrlsCollection[CtrlNames.DragonTigerFightRule]={};
CtrlManager.CtrlsCollection[CtrlNames.DragonTigerFightRule].ctrl =require "SingleGames/DragonTigerFight/Ctrl/RuleCtrl";
CtrlManager.CtrlsCollection[CtrlNames.DragonTigerFightRule].view=require "SingleGames/DragonTigerFight/View/RuleView";
CtrlManager.CtrlsCollection[CtrlNames.DragonTigerFightRule].model=require "SingleGames/DragonTigerFight/Model/RuleModel";
