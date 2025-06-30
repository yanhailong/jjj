
using JiuJiuPrincess;
using UnityEngine;

public class GameCheckUpdate : GameBaseState
{
    private GameLancher gameLancher;
    private UpdateAssets updateAssets;//资源更新
    
    public override void onEnter(object obj = null)
    {
        base.onEnter(obj);
        Debug.LogError("进入游戏更新模式");
        gameLancher=obj as GameLancher;
        InitConfig();
        
    }


    private void InitConfig()
    {
        gameLancher.preLoading.SetDesc("正在检测版本...", 0, true);
        //加载配置
        CommonConfigManager.Instance.LoadConfig((erroCode, msg) =>
            {
                gameLancher.preLoading.SetTipsInfo(msg, () => { Application.Quit(); }, () => { Application.Quit(); });
            },
            () =>
            {
                this.StartCheckVersion();
            });
    }
    /// <summary>
    /// 开始检测版本
    /// </summary>
    private void StartCheckVersion()
    {
        gameLancher.preLoading.SetDesc("正在检测版本...", 0, true);
        int serverVersion = CommonConfigManager.Instance.GetServerVersion();
        int localVersion = CommonConfigManager.Instance.GetLocalVersion();
        if (serverVersion == -1)
        {
            //版本检测错误
            gameLancher.preLoading.SetTipsInfo("服务器版本错误", () => { Application.Quit(); }, () => { Application.Quit(); });
            return;
        }
        Debug.LogError("localVersion:"+localVersion);
        gameLancher.preLoading.SetVersion("本地版本:" + AppConst.ToVersionString(localVersion));

        VersionCheck versionCheck = new VersionCheck(serverVersion, localVersion);
        switch (versionCheck.versionState)
        {
            case VersionCheck.VersionState.Error:
                gameLancher.preLoading.SetTipsInfo("版本检测错误", () => { Application.Quit(); }, () => { Application.Quit(); });
                break;
            case VersionCheck.VersionState.None:
                NoUpdateRes();
                break;
            case VersionCheck.VersionState.UpateAssets:
                StartUpdateAsset();
                break;
            case VersionCheck.VersionState.UpdatePackage:
                UpdateApplication();
                break;
        }
    }

    /// <summary>
    /// 启动游戏
    /// </summary>
    private void StartUpGame()
    {
        gameLancher.EnterGame();
    }

    /// <summary>
    /// 无需更新
    /// </summary>
    private void NoUpdateRes()
    {
        Debug.LogError("无需更新直接进入游戏");
        StartUpGame();
    }
    private void StartUpdateAsset()
    {
        Debug.LogError("开始检查更新");
        gameLancher.preLoading.SetDesc("正在检测更新文件...", 0, true);
        updateAssets = new UpdateAssets(AppConst.AssetLocalPath, AppConst.AssetUpdateUrl,null ,CommonConfigManager.Instance.GetServerVersion());
        updateAssets.MAXUPDATECOUNT = 10;
        updateAssets.StartUpdate(UpdateError, UpdateProgress, UpdateFinished,null);
    }

    /// <summary>
    /// 需要更新应用UICommonButtomCtrl
    /// </summary>
    private void UpdateApplication()
    {
        string msg = "版本过低，请更新应用包!";
        gameLancher.preLoading.SetTipsInfo(msg, () =>
            {
                string url = CommonConfigManager.Instance.GetApplicationDownloadUrl();
                Application.OpenURL(url);
            },
            () =>
            {
                Application.Quit();
            });
    }
    
    //更新错误
    private void UpdateError(int errCode, string msg)
    {
        gameLancher.preLoading.SetTipsInfo(msg, () => { Application.Quit(); }, () => { Application.Quit(); });
    }

    //更新进度
    private void UpdateProgress(int updateFinishedSize, int updateTotalSize)
    {
        gameLancher.preLoading.SetDesc("正在更新中...", 1, true);
        gameLancher.preLoading.UpdateProgress(updateFinishedSize, updateTotalSize);
    }

    //更新完成
    private void UpdateFinished()
    {
        gameLancher.preLoading.SetSlider(1);
        CommonConfigManager.Instance.SaveServerHallConfig();
        updateAssets.Clear();
        updateAssets = null;
        Debug.LogError("更新完成");
        StartUpGame();       
    }

    
    public override string getStateKey()
    {
        return GameState.CheckUpdateRes; 
    }

    public override void onLeave(string stateKey)
    {
        base.onLeave(stateKey);
        gameLancher = null;
        updateAssets = null;
    }
}
