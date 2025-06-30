using System.Collections;
using System.Collections.Generic;
using UnityEngine;
using System.IO;
using System;
using JiuJiuPrincess;
using Object = UnityEngine.Object;
#if UNITY_EDITOR
using UnityEditor;


public class EditorResourceLoad
{
    private static string[] searchPath = new string[] { "Assets/AssetsPackage/" };

    public static T LoadAsset<T>(string abName, string assetName) where T : Object
    {
        string pt = string.Empty;
        for (int i = 0; i < searchPath.Length; i++)
        {
            pt = searchPath[i] + abName;

            string dir = Path.GetDirectoryName(pt);
            if (Directory.Exists(dir))
            {
                var t = EditorLoadAsset<T>(dir, assetName);
                if (t) return t;
            }

            if (Directory.Exists(pt))
            {
                var t = EditorLoadAsset<T>(pt, assetName);
                if (t) return t;
            }
        }
        Debug.LogError(string.Format("加载的资源为空,path:{0},assetName:{1},type{2}", abName, assetName, typeof(T)));
        return null;
    }

    private static T EditorLoadAsset<T>(string dir, string fileName) where T : Object
    {
        string[] files = Directory.GetFiles(dir, fileName + ".*");

        foreach (var v in files)
        {
            if (!v.EndsWith(".meta"))
            {
                var obj = AssetDatabase.LoadAssetAtPath(v, typeof(T));
                if (obj != null)
                {
                    T t = obj as T;
                    if (t) return t;
                }
            }
        }
        return null;
    }

    public static Object[] LoadAssetAll(string abName, Type t)
    {
        string pt = string.Empty;
        for (int i = 0; i < searchPath.Length; i++)
        {
            pt = searchPath[i] + abName;
            if (Directory.Exists(pt))
            {
                var ts = EditorLoadAssetAll(pt, t);
                return ts;
            }
        }
        return new Object[0];
    }

    private static Object[] EditorLoadAssetAll(string dir, Type t)
    {
        string[] files = Directory.GetFiles(dir);
        List<Object> list = new List<Object>();

        foreach (var v in files)
        {
            if (!v.EndsWith(".meta"))
            {
                var obj = AssetDatabase.LoadAssetAtPath(v, t);
                if (obj != null)
                    list.Add(obj);
            }
        }
        return list.ToArray();
    }
}
#endif