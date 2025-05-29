using System;
using System.Collections;
using System.Collections.Generic;
using System.IO;
using Spine.Unity;
using TMPro;
using UnityEngine;
using UnityEngine.Android;
using UnityEngine.Networking;
using XLua;
using JiuJiuPrincess;
/// <summary>
/// 游戏状态
/// </summary>
public class GameState
{
    public const string Invalid = "Invalid";
    public const string InitSDK = "InitSDK";                    //初始化SDK 
    public const string ReleaseAsset = "ReleaseAsset";          //释放本地资源
    public const string CheckUpdateRes = "CheckUpdateRes";      //检测更新资源
    public const string EnterGame = "EnterGame";                //进入游戏大厅
}
[Hotfix]
[LuaCallCSharp]
public class GameLancher : MonoBehaviour
{
    public PreLoading preLoading;
    private StateMachine mStateMachine;
    private bool isBoolInistall = false;//默认不是

    private TextMeshProUGUI sss;
    private void Awake()
    {
        Screen.sleepTimeout = SleepTimeout.NeverSleep;
        Application.runInBackground = true;
        Application.targetFrameRate = 60;
        InitGameState();
    }

    // Start is called before the first frame update
    void Start()
    {
#if UNITY_EDITOR
        AppConst.DebugMode = true;
        mStateMachine.changeState(GameState.EnterGame,this);
#else
        new PreLoading(this);
#endif
    }
      
    /// <summary>
    /// //初始化状态机
    /// </summary>
    private void InitGameState()
    {
        mStateMachine = new StateMachine(this);
        mStateMachine.registerState(GameState.ReleaseAsset, new GameReleaseAsset());
        mStateMachine.registerState(GameState.CheckUpdateRes, new GameCheckUpdate());
        mStateMachine.registerState(GameState.InitSDK, new GameInitSdk());
        mStateMachine.registerState(GameState.EnterGame, new GameEnterGame());
    }

    /// <summary>
    /// loading面板加载成功
    /// </summary>
    /// <param name="preLoading"></param>
    public void LoadingPanelLoadFinished(PreLoading preLoading)
    {
        this.preLoading = preLoading;
        this.preLoading.SetVersion("应用版本:" + AppConst.ToVersionString(AppConst.version));
        StartCoroutine(InitAppStart());
    }

    IEnumerator InitAppStart()
    {
        yield return isFirstInstall();
        bool isReleaseLocal = isBoolInistall;//是否需要释放本地资源
        if (isReleaseLocal)
        {
            mStateMachine.changeState(GameState.ReleaseAsset,this);
        }
        else
        {
            CheckUpdateAsset();
        }
    }
    
    /// <summary>
    /// 是否是第一次安装
    /// </summary>
    /// <returns></returns>
    IEnumerator isFirstInstall()
    {
        bool isRBool = false;
        bool isWRBool = false;
        //判断只读目录是否存在版本文件
        string ReadPath = Path.Combine(Util.AppContentPath(),"AssetBundles/files.txt");
        UnityWebRequest www = UnityWebRequest.Get(ReadPath);
        yield return www.SendWebRequest();
        if (www.result==UnityWebRequest.Result.Success)
            isRBool = true;
        else
            isRBool = false;
        www.Dispose();
        //判断可读写目录是否存在版本文件
        string ReadWritePath = Path.Combine(AppConst.AssetLocalPath,"files.txt");
        isWRBool=File.Exists(ReadWritePath);
        if (isRBool && !isWRBool)
            isBoolInistall = true;
        else
            isBoolInistall = false;
    }
    
    
    /// <summary>
    /// 检测更新
    /// </summary>
    public void CheckUpdateAsset()
    {
        mStateMachine.changeState(GameState.CheckUpdateRes,this);
    }
    
    /// <summary>
    /// 资源释放更新完成进入游戏
    /// </summary>
    public void EnterGame()
    {
        AssetsManager.Instance.Initialized();//初始化资源
        LuaBytes.Instance.Init();//初始化lua代码
        mStateMachine.changeState(GameState.EnterGame,this);
        // PreLoadingClose();
    }

    /// <summary>
    /// 关闭预加载loing界面
    /// </summary>
    public void PreLoadingClose()
    {
        //关闭loading界面
        if (this.preLoading != null)
            this.preLoading.Close(0.1f);
    }
    
    
    private void OnDestroy()
    {
        if (mStateMachine!=null)
        {
            mStateMachine.clear();
            mStateMachine = null;
        }
    }
}
