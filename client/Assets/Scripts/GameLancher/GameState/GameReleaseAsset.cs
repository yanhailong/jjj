using System.Collections;
using System.Collections.Generic;
using System.IO;
using UnityEngine;
using UnityEngine.Networking;
using JiuJiuPrincess;
public class GameReleaseAsset : GameBaseState
{
    private GameLancher gameLancher;
    private ReleaseAssetsManager releaseAssetsManager;


    public override void onEnter(object obj = null)
    {
        base.onEnter(obj);
        gameLancher = obj as GameLancher;
        StartReleaseAsset();
    }


    private void StartReleaseAsset()
    {
         gameLancher.preLoading.SetDesc("开始释放本地资源...", 0, true);
         releaseAssetsManager = new ReleaseAssetsManager();
        releaseAssetsManager.ReleaseAssets(ReleaseProgress,ReleaseError,ReleaseFinished);
    }

    //更新错误
    private void ReleaseError(string msg)
    {
        gameLancher.preLoading.SetTipsInfo(msg, () => { Application.Quit(); }, () => { Application.Quit(); });
    }


    private void ReleaseProgress(int pro, int maxcount)
    {
        gameLancher.preLoading.SetDesc("正在释放本地资源...", 1, true);
        float vpro = pro / (float) maxcount;
        gameLancher.preLoading.SetSlider(vpro);
    }

    private void ReleaseFinished()
    {
        gameLancher.CheckUpdateAsset();
    }

    public override string getStateKey()
    {
        return GameState.CheckUpdateRes;
    }
}