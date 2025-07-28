
CtrlNames.DragonTigerFight="DragonTigerFight";
CtrlManager.CtrlsCollection[CtrlNames.DragonTigerFight]={};
CtrlManager.CtrlsCollection[CtrlNames.DragonTigerFight].ctrl =require "SingleGames/DragonTigerFight/Ctrl/DragonTigerFightCtrl";
CtrlManager.CtrlsCollection[CtrlNames.DragonTigerFight].view=require "SingleGames/DragonTigerFight/View/DragonTigerFightView";
CtrlManager.CtrlsCollection[CtrlNames.DragonTigerFight].model=require "SingleGames/DragonTigerFight/Model/DragonTigerFightModel";

CtrlNames.DragonTigerFightRule="DragonTigerFightRule";
CtrlManager.CtrlsCollection[CtrlNames.DragonTigerFightRule]={};
CtrlManager.CtrlsCollection[CtrlNames.DragonTigerFightRule].ctrl =require "SingleGames/DragonTigerFight/Ctrl/RuleCtrl";
CtrlManager.CtrlsCollection[CtrlNames.DragonTigerFightRule].view=require "SingleGames/DragonTigerFight/View/RuleView";
CtrlManager.CtrlsCollection[CtrlNames.DragonTigerFightRule].model=require "SingleGames/DragonTigerFight/Model/RuleModel";

CtrlNames.DragonTigerSelect="DragonTigerSelect";
CtrlManager.CtrlsCollection[CtrlNames.DragonTigerSelect]={};
CtrlManager.CtrlsCollection[CtrlNames.DragonTigerSelect].ctrl =require "SingleGames/DragonTigerFight/Ctrl/DragonTigerSelectCtrl";
CtrlManager.CtrlsCollection[CtrlNames.DragonTigerSelect].view=require "SingleGames/DragonTigerFight/View/DragonTigerSelectView";
CtrlManager.CtrlsCollection[CtrlNames.DragonTigerSelect].model=require "SingleGames/DragonTigerFight/Model/DragonTigerSelectModel";
