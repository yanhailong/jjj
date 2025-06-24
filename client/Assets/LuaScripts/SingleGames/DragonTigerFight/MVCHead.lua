CtrlNames.DragonTigerFight="DragonTigerFight";
CtrlManager.CtrlsCollection[CtrlNames.DragonTigerFight]={};
CtrlManager.CtrlsCollection[CtrlNames.DragonTigerFight].ctrl =require "SingleGames/DragonTigerFight/Ctrl/DragonTigerFightCtrl";
CtrlManager.CtrlsCollection[CtrlNames.DragonTigerFight].view=require "SingleGames/DragonTigerFight/View/DragonTigerFightView";
CtrlManager.CtrlsCollection[CtrlNames.DragonTigerFight].model=require "SingleGames/DragonTigerFight/Model/DragonTigerFightModel";

package.cpath = package.cpath .. ';C:/Users/Administrator/AppData/Roaming/JetBrains/Rider2020.3/plugins/intellij-emmylua/classes/debugger/emmy/windows/x64/?.dll'
local dbg = require('emmy_core')
dbg.tcpConnect('localhost', 9966)
