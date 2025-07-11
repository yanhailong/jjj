CtrlNames.VietnamChessGame="VietnamChessGame";
CtrlManager.CtrlsCollection[CtrlNames.VietnamChessGame]={};
CtrlManager.CtrlsCollection[CtrlNames.VietnamChessGame].ctrl =require "SingleGames/VietnamChess/Ctrl/VietnamChessGameCtrl";
CtrlManager.CtrlsCollection[CtrlNames.VietnamChessGame].view=require "SingleGames/VietnamChess/View/VietnamChessGameView";
CtrlManager.CtrlsCollection[CtrlNames.VietnamChessGame].model=require "SingleGames/VietnamChess/Model/VietnamChessGameModel";

CtrlNames.VietnamChessPlayers="VietnamChessPlayers";
CtrlManager.CtrlsCollection[CtrlNames.VietnamChessPlayers]={};
CtrlManager.CtrlsCollection[CtrlNames.VietnamChessPlayers].ctrl =require "SingleGames/VietnamChess/Ctrl/VietnamChessPlayersCtrl";
CtrlManager.CtrlsCollection[CtrlNames.VietnamChessPlayers].view=require "SingleGames/VietnamChess/View/VietnamChessPlayersView";
CtrlManager.CtrlsCollection[CtrlNames.VietnamChessPlayers].model=require "SingleGames/VietnamChess/Model/VietnamChessPlayersModel";

CtrlNames.VietnamChessRule="VietnamChessRule";
CtrlManager.CtrlsCollection[CtrlNames.VietnamChessRule]={};
CtrlManager.CtrlsCollection[CtrlNames.VietnamChessRule].ctrl =require "SingleGames/VietnamChess/Ctrl/VietnamChessRuleCtrl";
CtrlManager.CtrlsCollection[CtrlNames.VietnamChessRule].view=require "SingleGames/VietnamChess/View/VietnamChessRuleView";
CtrlManager.CtrlsCollection[CtrlNames.VietnamChessRule].model=require "SingleGames/VietnamChess/Model/VietnamChessRuleModel";

