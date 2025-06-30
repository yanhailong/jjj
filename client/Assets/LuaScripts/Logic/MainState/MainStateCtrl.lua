---游戏状态控制
---@class MainStateCtrl
MainStateCtrl = Class("MainStateCtrl")
local this = MainStateCtrl;
this.State={
    Login=1,
    Hall=2,
    Game=3
}

this.curState=this.State.Login;

---进入登录
function this.EnterLogin(func)
    this.ChangeState(this.State.Login);
    local ctrl= CtrlManager.SingleShow(CtrlNames.UILogin)
    ctrl:AddAsyncOpenCallback(function ()
        if func then
            func();
        end
    end)
end
---进入大厅
function this.EnterHall(enterFunc)
    this.ChangeState(this.State.Hall);
    local ctrl= CtrlManager.GetCtrl(CtrlNames.UIHallGames)
    if not ctrl then
        CtrlManager.SingleShow(CtrlNames.UIHallGames)
    end
end

---进入游戏
function this.EnterGame()
    this.ChangeState(this.State.Game)
end

function this.ChangeState(state)
    this.curState=state;
end