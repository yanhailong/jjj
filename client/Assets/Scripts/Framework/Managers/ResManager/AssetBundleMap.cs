using System;
using System.Collections.Generic;
using UnityEngine;

public class AssetBundleMap
{
    public string name;
    public Dictionary<string, AssetBundle> map;
    public AssetBundleManifest manifest;

    public AssetBundleMap(string name, AssetBundleManifest manifest)
    {
        this.name = name;
        this.manifest = manifest;
        map = new Dictionary<string, AssetBundle>();
    }

    //是否有对应名称的ab包
    public bool IsHas(string abName)
    {
        return map.ContainsKey(abName);
    }

    //添加ab包到map
    public bool Add(string abName, AssetBundle ab)
    {
        if (ab == null || string.IsNullOrEmpty(abName)) return false;
        if (IsHas(abName)) return false;
        map.Add(abName, ab);
        return true;
    }

    //获取一个ab包
    public AssetBundle Get(string abName)
    {
        if (!IsHas(abName)) return null;
        return map[abName];
    }

    public bool Remove(string abName)
    {
        return this.map.Remove(abName);
    }

    public void Unload(string abName, bool unloadAllLoadedObjects)
    {
        var ab = this.Get(abName);
        if (ab == null) return;
        ab.Unload(unloadAllLoadedObjects);
        this.Remove(abName);
    }

    public void UnloadAll(bool unloadAllLoadedObjects)
    {
        foreach (var v in map)
        {
            if (v.Value == null) continue;
            v.Value.Unload(unloadAllLoadedObjects);
        }
        map.Clear();

        Resources.UnloadUnusedAssets();
        GC.Collect();

    }
}