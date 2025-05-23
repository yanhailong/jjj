using System.Collections.Generic;
using UnityEngine;
/// <summary>
/// 状态机
/// </summary>
/// <typeparam name="T">状态机拥有者类型</typeparam>

public class StateMachine
{
    public const string InvalidState = "Invalid";//无效状态
    protected Dictionary<string, State> mStateCache;
    protected State mCurrentState = null;
    protected State mLastState = null;
    protected State mGlobalState = null;
    protected object mOwner;

    /// <summary>
    /// 构造
    /// </summary>
    /// <param name="owner"></param>
    public StateMachine(object owner)
    {
        mStateCache = new Dictionary<string, State>();
        mOwner = owner;
    }

    /// <summary>
    /// 是否包含状态
    /// </summary>
    /// <param name="stateKey"></param>
    /// <returns></returns>
    public bool isExist(string stateKey)
    {
        return mStateCache.ContainsKey(stateKey);
    }

    /// <summary>
    /// 获取状态byKey
    /// </summary>
    /// <param name="stateKey"></param>
    /// <returns></returns>
    public State getStateByKey(string stateKey)
    {
        State curState = null;
        mStateCache.TryGetValue(stateKey,out curState);
        if (curState!=null)
        {
            return curState;
        }
        return null;
    }


    /// <summary>
    /// 设置拥有者
    /// </summary>
    /// <param name="owner"></param>
    public void setOwner(object owner)
    {
        mOwner = owner;
    }

    /// <summary>
    /// 注册状态
    /// </summary>
    /// <param name="type">状态类型</param>
    /// <param name="state">状态</param>
    public void registerState(string key, State state)
    {
        bool exists = mStateCache.ContainsKey(key);
        if (exists == false)
        {
            mStateCache.Add(key, state);
        }
        else
        {
            mStateCache[key] = state;
        }
    }


    public void setGlobalState(State state, object obj = null)
    {
        mGlobalState = state;
        mGlobalState.setOwner(mOwner);
        mGlobalState.onEnter(obj);
    }


    /// <summary>
    /// 移除状态
    /// </summary>
    /// <param name="type"></param>
    public void removeState(int id)
    {
        mStateCache.Remove(id.ToString());
    }

    /// <summary>
    /// 改变状态
    /// </summary>
    /// <param name="type"></param>
    public virtual void changeState(string key, object obj = null)
    {
        State newState = null;
        mStateCache.TryGetValue(key,out  newState);
        if (newState == null)
        {
            Debug.LogError("unregister state type: " + key);
            return;
        }
        if (mCurrentState != null)
        {
            mCurrentState.onLeave(newState.getStateKey());
        }

        mLastState = mCurrentState;
        mCurrentState = newState;
        mCurrentState.setOwner(mOwner);
        mCurrentState.onEnter(obj);
    }

    /// <summary>
    /// 更新
    /// </summary>
    public virtual void update(long time = 0)
    {
        if (mGlobalState != null)
            mGlobalState.onUpdate(time);
        if (mCurrentState != null)
            mCurrentState.onUpdate(time);
    }

    public virtual void FixedUpdate(long time = 0)
    {
        if (mGlobalState != null)
            mGlobalState.onFixedUpdate(time);
        if (mCurrentState != null)
            mCurrentState.onFixedUpdate(time);
    }

    /// <summary>
    /// 当前状态类型 
    /// </summary>
    /// <returns></returns>
    public string getCurrentState()
    {
        if (mCurrentState != null)
        {
            return mCurrentState.getStateKey();
        }
        return StateMachine.InvalidState;
    }

    /// <summary>
    /// 释放
    /// </summary>
    public void clear()
    {
        if (mCurrentState != null)
            mCurrentState.onLeave(StateMachine.InvalidState);
        mStateCache.Clear();
        mCurrentState = null;
        mLastState = null;
    }

}
