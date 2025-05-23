
/// <summary>
/// 游戏状态
/// </summary>
public abstract class GameBaseState : State
{
    public override void onEnter(object obj = null)
    {

    }

    public override void onReEnter(object obj = null)
    {

    }

    public override void onUpdate(long time = 0)
    {

    }

    public override void onLeave(string stateKey)
    {
        removeAllListeners();
    }
    /// <summary>
    /// 添加事件
    /// </summary>
    protected void addListener()
    {

    }

    protected void removeListener()
    {

    }

    protected void removeAllListeners()
    {
    }
}
