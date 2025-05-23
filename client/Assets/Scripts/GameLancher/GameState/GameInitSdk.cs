
using UnityEngine;

public class GameInitSdk : GameBaseState
{
    public override void onEnter(object obj = null)
    {
        base.onEnter(obj);
    }
    
    public override string getStateKey()
    {
        return GameState.InitSDK;
    }
    
}
