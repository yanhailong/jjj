require("SingleGames/BirdsAnimals/MsgPro/pb_BirdsAnimals")

CtrlNames.BirdsAnimalsGame="BirdsAnimalsGame";
CtrlManager.CtrlsCollection[CtrlNames.BirdsAnimalsGame]={};
CtrlManager.CtrlsCollection[CtrlNames.BirdsAnimalsGame].ctrl =require "SingleGames/BirdsAnimals/Ctrl/BirdsAnimalsGameCtrl";
CtrlManager.CtrlsCollection[CtrlNames.BirdsAnimalsGame].view=require "SingleGames/BirdsAnimals/View/BirdsAnimalsGameView";
CtrlManager.CtrlsCollection[CtrlNames.BirdsAnimalsGame].model=require "SingleGames/BirdsAnimals/Model/BirdsAnimalsGameModel";

CtrlNames.BirdsAnimalsPlayers="BirdsAnimalsPlayers";
CtrlManager.CtrlsCollection[CtrlNames.BirdsAnimalsPlayers]={};
CtrlManager.CtrlsCollection[CtrlNames.BirdsAnimalsPlayers].ctrl =require "SingleGames/BirdsAnimals/Ctrl/BirdsAnimalsPlayersCtrl";
CtrlManager.CtrlsCollection[CtrlNames.BirdsAnimalsPlayers].view=require "SingleGames/BirdsAnimals/View/BirdsAnimalsPlayersView";
CtrlManager.CtrlsCollection[CtrlNames.BirdsAnimalsPlayers].model=require "SingleGames/BirdsAnimals/Model/BirdsAnimalsPlayersModel";

CtrlNames.BirdsAnimalsRule="BirdsAnimalsRule";
CtrlManager.CtrlsCollection[CtrlNames.BirdsAnimalsRule]={};
CtrlManager.CtrlsCollection[CtrlNames.BirdsAnimalsRule].ctrl =require "SingleGames/BirdsAnimals/Ctrl/BirdsAnimalsRuleCtrl";
CtrlManager.CtrlsCollection[CtrlNames.BirdsAnimalsRule].view=require "SingleGames/BirdsAnimals/View/BirdsAnimalsRuleView";
CtrlManager.CtrlsCollection[CtrlNames.BirdsAnimalsRule].model=require "SingleGames/BirdsAnimals/Model/BirdsAnimalsRuleModel";

CtrlNames.BirdsAnimalsTrend="BirdsAnimalsTrend";
CtrlManager.CtrlsCollection[CtrlNames.BirdsAnimalsTrend]={};
CtrlManager.CtrlsCollection[CtrlNames.BirdsAnimalsTrend].ctrl =require "SingleGames/BirdsAnimals/Ctrl/BirdsAnimalsTrendCtrl";
CtrlManager.CtrlsCollection[CtrlNames.BirdsAnimalsTrend].view=require "SingleGames/BirdsAnimals/View/BirdsAnimalsTrendView";
CtrlManager.CtrlsCollection[CtrlNames.BirdsAnimalsTrend].model=require "SingleGames/BirdsAnimals/Model/BirdsAnimalsTrendModel";

