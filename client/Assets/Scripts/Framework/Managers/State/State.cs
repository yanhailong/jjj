using System;
using System.Collections;

/// <summary>
/// 状态
/// </summary>
public abstract class State
{
    protected object mOwner;

    /// <summary>
    /// 状态拥有者
    /// </summary>
    /// <param name="owner"></param>
    public virtual void setOwner(object owner)
    {
        mOwner = owner;
    }

    /// <summary>
    /// 返回状态拥有者
    /// </summary>
    /// <returns></returns>
    public object getOwner()
    {
        return mOwner;
    }
    /// <summary>
    /// 进入状态
    /// </summary>
    /// <param name="owner"></param>
    public abstract void onEnter(object obj = null);
    /// <summary>
    /// 再次进入
    /// </summary>
    /// <param name="obj"></param>
    public abstract void onReEnter(object obj=null);
    /// <summary>
    /// 状态更新
    /// </summary>
    /// <param name="owner"></param>
    public abstract void onUpdate(long time = 0);
    public virtual void onFixedUpdate(long time = 0) { }
    /// <summary>
    /// 状态结束
    /// </summary>
    /// <param name="owner"></param>
    public abstract void onLeave(string stateKey);

    /// <summary>
    /// 返回状态ID
    /// </summary>
    public abstract string getStateKey();

}

