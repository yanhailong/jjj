using System.Collections;
using System.Collections.Generic;
using UnityEngine;
using JiuJiuPrincess;
public class AssetBundleDepMgr : Singleton<AssetBundleDepMgr>
{
    private string manifestPath;
    private Dictionary<string, string[]> allDeps = new Dictionary<string, string[]>();
    public void LoadManifest()
    {
        allDeps.Clear();
        manifestPath = AppConst.AssetLocalPath + "manifest.unity3d";
        if (string.IsNullOrEmpty(manifestPath)) return;
        AssetBundle ab = AssetBundle.LoadFromFile(manifestPath);
        if(ab == null)
        {
            string errormsg = string.Format("LoadMainfest ab NULL error !");
            Debug.LogError(errormsg);
            return;
        }
        AssetBundleManifest mainfest = ab.LoadAsset("AssetBundleManifest") as AssetBundleManifest;
        if (mainfest == null)
        {
            string errormsg = string.Format("LoadMainfest NULL error !");
            Debug.LogError(errormsg);
            return;
        }
        foreach(string assetName in mainfest.GetAllAssetBundles())
        {
            string[] dps = mainfest.GetAllDependencies(assetName);
            allDeps.Add(assetName, dps);
        }
        ab.Unload(true);
        ab = null;
    }

    public string[] GetDeps(string abPath)
    {
        string[] deps=new string[0];
        if (allDeps.ContainsKey(abPath))
        {
            deps = allDeps[abPath];
        }
        return deps;
    }
}
