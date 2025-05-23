using System;
using System.Collections;
using System.Collections.Generic;
using UnityEngine;
using YooAsset;
/// <summary>
/// AB资源加载同步异步卸载完整版本
/// </summary>
public class AssetBundleLoadMgr : SingletonMono<AssetBundleLoadMgr>
{
    public delegate void AssetBundleLoadCallBack(AssetBundle ab);

    private class AssetBundleObject
    {
        public string abPath;
        public int refCount;
        public List<AssetBundleLoadCallBack> callFunList = new List<AssetBundleLoadCallBack>();
        public AssetBundleCreateRequest request;
        public AssetBundle assetBundle;
        public int depLoadingCount;//依赖计数用于异步加载
        public List<AssetBundleObject> depends = new List<AssetBundleObject>();
    }
    /// <summary>
    /// 同时加载的最大数量
    /// </summary>
    private const int maxLoadingCount = 10;
    /// <summary>
    /// 创建临时存储变量，用于提升性能
    /// </summary>
    private List<AssetBundleObject> tempLoadeds = new List<AssetBundleObject>();
    /// <summary>
    /// 预备加载的列表
    /// </summary>
    private Dictionary<string, AssetBundleObject> dic_ready=new Dictionary<string, AssetBundleObject>(); 
    /// <summary>
    /// 正在加载的列表
    /// </summary>
    private Dictionary<string, AssetBundleObject> dic_loading=new Dictionary<string, AssetBundleObject>();
    /// <summary>
    /// 加载完成的列表
    /// </summary>
    private Dictionary<string, AssetBundleObject> dic_loaded=new Dictionary<string, AssetBundleObject>();
    /// <summary>
    /// 准备卸载的列表
    /// </summary>
    private Dictionary<string, AssetBundleObject> dic_unload=new Dictionary<string, AssetBundleObject>();

    public void Initialized()
    {
        AssetBundleDepMgr.Instance.LoadManifest();
    }


    private string GetABName(string abPath)
    {
        abPath = abPath.ToLower();
        if (!abPath.EndsWith(AppConst.ExtName))
            abPath += AppConst.ExtName;
        return abPath;
    }
    
    /// <summary>
    /// 同步加载
    /// </summary>
    /// <param name="abPath"></param>
    /// <returns></returns>
    public AssetBundle LoadSync(string abPath)
    {
        abPath = GetABName(abPath);
        AssetBundleObject abObj = LoadAssetBundleSync(abPath);
        return abObj.assetBundle;
    }

    /// <summary>
    /// 异步加载
    /// </summary>
    /// <param name="abPath"></param>
    /// <param name="callFun"></param>
    public void LoadASync(string abPath,AssetBundleLoadCallBack callFun)
    {
        abPath = GetABName(abPath);
        LoadAssetBundleAsync(abPath, callFun);
    }

    /// <summary>
    /// 卸载（异步），每次卸载引用计数-1
    /// </summary>
    /// <param name="abPath"></param>
    public void UnLoadASync(string abPath)
    {
        abPath = abPath.ToLower();
        UnloadAssetBundleAsync(abPath);
    }
    
    /// <summary>
    /// 同步加载
    /// </summary>
    /// <param name="abPath"></param>
    /// <returns></returns>
    private AssetBundleObject LoadAssetBundleSync(string abPath)
    {
        AssetBundleObject abObj = null;
        if (dic_loaded.ContainsKey(abPath))                     //已经加载
        {
            abObj = dic_loaded[abPath];
            abObj.refCount++;
            foreach (var dpObj in abObj.depends)
                LoadAssetBundleSync(dpObj.abPath);              //递归依赖项，附加引用计数
            return abObj;
        }
        else if (dic_loading.ContainsKey(abPath))               //在加载中,异步改同步
        {
            abObj = dic_loading[abPath];
            abObj.refCount++;
            foreach(var dpObj in abObj.depends)
                LoadAssetBundleSync(dpObj.abPath);              //递归依赖项，加载完
            DoLoadedCallFun(abObj, false);                      //强制完成，回调
            return abObj;
        }
        else if (dic_ready.ContainsKey(abPath))                 //在准备加载中
        {
            abObj = dic_ready[abPath];
            abObj.refCount++;
            foreach (var dpObj in abObj.depends)
                LoadAssetBundleSync(dpObj.abPath);              //递归依赖项，加载完
            abObj.assetBundle = AssetBundle.LoadFromFile(abPath);
            dic_ready.Remove(abObj.abPath);
            dic_loaded.Add(abObj.abPath, abObj);
            DoLoadedCallFun(abObj, false);                      //强制完成，回调
            return abObj;
        }

        //创建一个加载
        abObj = new AssetBundleObject();
        abObj.abPath = abPath;
        abObj.refCount = 1;
        string path = AppConst.AssetLocalPath + abPath;
        abObj.assetBundle = AssetBundle.LoadFromFile(path);
        
        //加载依赖项
        string[] deps = AssetBundleDepMgr.Instance.GetDeps(abPath);
        if (deps.Length>0)
        {
            abObj.depLoadingCount = 0;
            foreach (var dep in deps)
            {
                var depObj = LoadAssetBundleSync(dep);
                abObj.depends.Add(depObj);
            }
        }
        dic_loaded.Add(abObj.abPath,abObj);
        return abObj;
    }
    /// <summary>
    /// 同步加载
    /// </summary>
    /// <param name="abPath"></param>
    /// <param name="callFun"></param>
    /// <returns></returns>
    private AssetBundleObject LoadAssetBundleAsync(string abPath, AssetBundleLoadCallBack callFun)
    {
        AssetBundleObject abObj = null;
        if (dic_loaded.ContainsKey(abPath)) //已经加载
        {
            abObj = dic_loaded[abPath];
            AddRefCountASync(abObj);
            callFun(abObj.assetBundle);
            return abObj;
        }
        else if(dic_loading.ContainsKey(abPath)) //在加载中
        {
            abObj = dic_loading[abPath];
            AddRefCountASync(abObj);
            abObj.callFunList.Add(callFun);
            return abObj;
        }
        else if (dic_ready.ContainsKey(abPath)) //在准备加载中
        {
            abObj = dic_ready[abPath];
            AddRefCountASync(abObj);
            abObj.callFunList.Add(callFun);
            return abObj;
        }

        //创建一个加载
        abObj = new AssetBundleObject();
        abObj.abPath = abPath;
        abObj.refCount = 1;
        abObj.callFunList.Add(callFun);

        //加载依赖项
        string[] deps = AssetBundleDepMgr.Instance.GetDeps(abPath);
        if (deps.Length>0)
        {
            abObj.depLoadingCount = deps.Length;
            foreach (var dep in deps)
            {
                var depObj = LoadAssetBundleAsync(dep, (AssetBundle ab) =>
                {
                    if (abObj.depLoadingCount<=0)
                    {
                        Debug.LogError(string.Format("加载ab：{0}依赖错误！",abPath));
                        return;
                    }
                    abObj.depLoadingCount--;
                    //依赖加载完
                    if (abObj.depLoadingCount == 0 && abObj.request != null && abObj.request.isDone)
                    {
                        DoLoadedCallFun(abObj);
                    }
                });
                abObj.depends.Add(depObj);
            }
        }

        if (dic_loading.Count<maxLoadingCount)
        {
            DoLoadASync(abObj);
            dic_loading.Add(abPath, abObj);
        }
        else
        {
            dic_ready.Add(abPath, abObj);
        }
        return abObj;
    }

    /// <summary>
    /// 异步加载增加引用计数
    /// </summary>
    /// <param name="abObj"></param>
    private void AddRefCountASync(AssetBundleObject abObj)
    {
        abObj.refCount++;
        if (abObj.depends.Count == 0) return;
        foreach (var dpObj in abObj.depends)//递归依赖项，加载完
            AddRefCountASync(dpObj);
    }
    
    private void DoLoadedCallFun(AssetBundleObject abObj, bool isAsync = true)
    {
        //提取ab
        if(abObj.request != null)
        {
            abObj.assetBundle = abObj.request.assetBundle; //如果没加载完，会异步转同步
            abObj.request = null;
            dic_loading.Remove(abObj.abPath);
            dic_loaded.Add(abObj.abPath, abObj);
        }
        //直接移除
        if (abObj.assetBundle == null)
        {
            if (dic_loaded.ContainsKey(abObj.abPath)) dic_loaded.Remove(abObj.abPath);
            else if (dic_loading.ContainsKey(abObj.abPath)) dic_loading.Remove(abObj.abPath);
            Debug.LogError(abObj.abPath+"加载失败！请检查！");
        }
        //运行回调
        foreach (var callback in abObj.callFunList)
            callback(abObj.assetBundle);
        abObj.callFunList.Clear();
    }
    /// <summary>
    /// 异步加载AssetBundle
    /// </summary>
    /// <param name="abObj"></param>
    private void DoLoadASync(AssetBundleObject abObj)
    {
        string path = AppConst.AssetLocalPath + abObj.abPath;
        abObj.request = AssetBundle.LoadFromFileAsync(path);
        if (abObj.request == null)
        {
            Debug.LogError(string.Format("加载ab错误 ! abPath:{0}", abObj.abPath));
        }

    }
    
    /// <summary>
    /// 卸载AB资源
    /// </summary>
    /// <param name="abPath"></param>
    private void UnloadAssetBundleAsync(string abPath)
    {
        AssetBundleObject abObj = null;
        if (dic_loaded.ContainsKey(abPath))
            abObj = dic_loaded[abPath];
        else if (dic_loading.ContainsKey(abPath))
            abObj = dic_loading[abPath];
        else if (dic_ready.ContainsKey(abPath))
            abObj = dic_ready[abPath];
        if (abObj == null||abObj.refCount == 0)
        {
            string errormsg = string.Format("卸载AB错误 ! abPath:{0}",abPath);
            Debug.LogError(errormsg);
            return;
        }
        abObj.refCount--;
        foreach (var dpObj in abObj.depends)
            UnloadAssetBundleAsync(dpObj.abPath);
        if (abObj.refCount == 0)
            dic_unload.Add(abObj.abPath, abObj);
    }

    /// <summary>
    /// 准备加载
    /// </summary>
    private void OnUpdateReady()
    {
        if (dic_ready.Count == 0) return;
        if (dic_loading.Count >= maxLoadingCount) return;
        tempLoadeds.Clear();
        foreach (var abObj in dic_ready.Values)
        {
            DoLoadASync(abObj);
            tempLoadeds.Add(abObj);
            dic_loading.Add(abObj.abPath, abObj);
            if (dic_loading.Count >= maxLoadingCount) break;
        }
        foreach (var abObj in tempLoadeds)
        {
            dic_ready.Remove(abObj.abPath);
        }
    }
    /// <summary>
    /// 加载
    /// </summary>
    private void OnUpdateLoad()
    {
        if (dic_loading.Count == 0) return;
        //检测加载完的
        tempLoadeds.Clear();
        foreach (var abObj in dic_loading.Values)
        {
            if (abObj.depLoadingCount == 0 && abObj.request != null && abObj.request.isDone)
            {
                tempLoadeds.Add(abObj);
            }
        }
        //回调中有可能对dic_loading进行操作，提取后回调
        foreach (var abObj in tempLoadeds)
        {
            //加载完进行回调
            DoLoadedCallFun(abObj);
        }
    }
    /// <summary>
    /// 卸载
    /// </summary>
    private void OnUpdateUnLoad()
    {
        if (dic_unload.Count == 0) return;
        tempLoadeds.Clear();
        foreach (var abObj in dic_unload.Values)
        {
            if (abObj.refCount == 0 && abObj.assetBundle != null)
            {
                //引用计数为0并且已经加载完，没加载完等加载完销毁
                DoUnload(abObj);
                tempLoadeds.Add(abObj);
            }
            if (abObj.refCount > 0)
            {
                //引用计数加回来（销毁又瞬间重新加载，不销毁，从销毁列表移除）
                tempLoadeds.Add(abObj);
            }
        }
        foreach(var abObj in tempLoadeds)
        {
            dic_unload.Remove(abObj.abPath);
            dic_loaded.Remove(abObj.abPath);
        }
    }
    private void DoUnload(AssetBundleObject abObj)
    {
        //这里用true，卸载Asset内存，实现指定卸载
        if(abObj.assetBundle == null)
        {
            string errormsg = string.Format("卸载错误! abPath:{0}", abObj.abPath);
            Debug.LogError(errormsg);
            return;
        }
        abObj.assetBundle.Unload(true);
        abObj.assetBundle = null;
    }
    
    private void Update()
    {
        OnUpdateLoad();
        OnUpdateReady();
        OnUpdateUnLoad();
    }
}
