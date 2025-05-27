CtrlNames.UILogin="UILogin";
CtrlManager.CtrlsCollection[CtrlNames.UILogin]={};
CtrlManager.CtrlsCollection[CtrlNames.UILogin].ctrl =require "PlatformHall/UILogin/Ctrl/UILoginCtrl";
CtrlManager.CtrlsCollection[CtrlNames.UILogin].view=require "PlatformHall/UILogin/View/UILoginView";
CtrlManager.CtrlsCollection[CtrlNames.UILogin].model=require "PlatformHall/UILogin/Model/UILoginModel";