
using UnityEngine;

public class GameEnterGame : GameBaseState
{
    public override void onEnter(object obj = null)
    {
        base.onEnter(obj);
        TMPHelper.LoadSettings();
        XLuaManager.Instance.EnterGame(obj as GameLancher);//进入游戏
    }

    public override string getStateKey()
    {
        return GameState.EnterGame;
    }
}