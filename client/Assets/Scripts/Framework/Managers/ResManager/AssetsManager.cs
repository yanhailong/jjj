using System.Collections;
using System.Collections.Generic;
using UnityEngine;
using System.IO;
using System;
using Spine.Unity;
using Object = UnityEngine.Object;
using YooAsset;
public class AssetsManager : SingletonMono<AssetsManager>
{
    public void Initialized()
    {
        AssetBundleLoadMgr.Instance.Initialized();
    }
    
    public T LoadAsset<T>(string abName, string assetName) where T : Object
    {
        abName = abName.ToLower();
        if (string.IsNullOrEmpty(assetName))
            assetName = Path.GetFileNameWithoutExtension(abName).ToLower();
        if (AppConst.DebugMode)
        {
#if UNITY_EDITOR
            return EditorResourceLoad.LoadAsset<T>(abName, assetName);
#else
            return null;
#endif
        }
        else
        {
            AssetBundle bundle= AssetBundleLoadMgr.Instance.LoadSync(abName);
            if (bundle == null) return null;
            return bundle.LoadAsset<T>(assetName);
        }
    }
    
    
    #region 同步加载资源
    //加载资源
    public T[] LoadAllAsset<T>(string abName) where T : Object
    {
        abName = abName.ToLower();
        if (AppConst.DebugMode)
        {
            return Resources.LoadAll<T>(abName);
        }
        else
        {
            AssetBundle bundle = AssetBundleLoadMgr.Instance.LoadSync(abName);
            if (bundle == null) return null;
            return bundle.LoadAllAssets<T>();
        }
    }

    //加载ab包里面所有资源
    public Object[] LoadAllAssets(string abName, Type t)
    {
        if (t == null) t = typeof(Object);

        abName = abName.ToLower();
        if (AppConst.DebugMode)
        {
#if UNITY_EDITOR
            return EditorResourceLoad.LoadAssetAll(abName, t);
#else
            return null;
#endif
        }
        else
        {
            AssetBundle bundle = AssetBundleLoadMgr.Instance.LoadSync(abName);
            if (bundle == null) return null;
            return bundle.LoadAllAssets(t);
        }
    }

    //创建游戏对象
    public GameObject CreateGameObject(string abName, string assetName, Transform parent = null)
    {
        GameObject obj = LoadAsset<GameObject>(abName, assetName);
        if (obj == null)
            return null;
        GameObject go;
        go = Instantiate(obj, parent);
        go.name = obj.name;
        go.transform.localScale = Vector3.one;
        go.transform.localPosition = Vector3.zero;
        return go;
    }

    
    public string LoadTextAssetStr(string abName, string assetName = null)
    {
        string str = LoadAsset<TextAsset>(abName, assetName).text;
        return str;
    }
    //加载游戏对象
    public GameObject LoadGameObject(string abName, string assetName = null)
    {
        GameObject obj = LoadAsset<GameObject>(abName, assetName);
        return obj;
    }
    //加载单个Sprite
    public Sprite LoadSprite(string abName, string assetName = null)
    {
        Sprite sprite = LoadAsset<Sprite>(abName, assetName);
        return sprite;
    }
    //加载贴图
    public Texture2D LoadTexture2D(string abName, string assetName = null)
    {
        Texture2D t2d = LoadAsset<Texture2D>(abName, assetName);
        return t2d;
    }
    //加载字体
    public Font LoadFont(string abName, string assetName = null)
    {
        Font font = LoadAsset<Font>(abName, assetName);
        return font;
    }
    //加载音频剪辑
    public AudioClip LoadAudioClip(string abName, string assetName = null)
    {
        AudioClip clip = LoadAsset<AudioClip>(abName, assetName);
        return clip;
    }
    //加载动画剪辑
    public AnimationClip LoadAnimationClip(string abName, string assetName = null)
    {
        AnimationClip clip = LoadAsset<AnimationClip>(abName, assetName);
        return clip;
    }
    //加载动画控制器
    public RuntimeAnimatorController LoadAnimatorController(string abName, string assetName = null)
    {
        RuntimeAnimatorController ac = LoadAsset<RuntimeAnimatorController>(abName, assetName);
        return ac;
    }
    //加载材质
    public Material LoadMaterial(string abName, string assetName)
    {
        Material mat = LoadAsset<Material>(abName, assetName);
        return mat;
    }

    public SkeletonDataAsset LoadSkeletonDataAsset(string abName, string assetName)
    {
        SkeletonDataAsset skeletonDataAsset= LoadAsset<SkeletonDataAsset>(abName, assetName);
        return skeletonDataAsset;
    }

    #endregion

    #region 异步加载资源
    //异步读取资源(模拟异步加载ab包)
    private IEnumerator ResourceLoadAsync<T>(string abname, string assetName, Action<T> action) where T : Object
    {
#if UNITY_EDITOR
        var v = EditorResourceLoad.LoadAsset<T>(abname, assetName);
        yield return new WaitForSeconds(0.05f);//模拟ab包异步加载
        action?.Invoke(v);
#else
        action?.Invoke(null);
        yield break;
#endif      
    }

    //异步读取资源(模拟异步加载ab包)
    private IEnumerator ResourceLoadAllAsync(string abname, Type t, Action<Object[]> action)
    {
#if UNITY_EDITOR
        var v = EditorResourceLoad.LoadAssetAll(abname, t);
        yield return new WaitForSeconds(0.05f);//模拟ab包异步加载
        action?.Invoke(v);
#else
        action?.Invoke(null);
        yield break;
#endif
    }

    private IEnumerator LoadAssetCor<T>(AssetBundle bundle, string assetName, Action<T> action) where T : Object
    {
        AssetBundleRequest request = bundle.LoadAssetAsync<T>(assetName);
        yield return request;
        if (request.asset == null)
        {
            action?.Invoke(null);
            yield break;
        }
        action?.Invoke(request.asset as T);
    }

    private IEnumerator LoadAllAssetCor(AssetBundle bundle, Type t, Action<Object[]> action)
    {
        AssetBundleRequest request = bundle.LoadAllAssetsAsync(t);
        yield return request;
        if (request.allAssets == null)
        {
            action?.Invoke(null);
            yield break;
        }
        action?.Invoke(request.allAssets);
    }

    //加载资源
    public void LoadAssetAsync<T>(string abName, string assetName, Action<T> action) where T : Object
    {
        abName = abName.ToLower();
        if (string.IsNullOrEmpty(assetName))
            assetName = Path.GetFileNameWithoutExtension(abName).ToLower();
        if (AppConst.DebugMode)
        {
            StartCoroutine(ResourceLoadAsync(abName, assetName, action));
        }
        else
        {
            AssetBundleLoadMgr.Instance.LoadASync(abName, (bundle) =>
            {
                if (bundle == null) action?.Invoke(null);
                StartCoroutine(LoadAssetCor<T>(bundle, assetName, action));
            });
        }
    }

    //加载资源
    public void LoadAllAssetAsync<T>(string abName, Action<T[]> action) where T : Object
    {

        Action<Object[]> run = (objs) =>
        {
            if (objs != null)
                action?.Invoke(objs as T[]);
            else
                action?.Invoke(null);
        };

        abName = abName.ToLower();
        if (AppConst.DebugMode)
        {
            StartCoroutine(ResourceLoadAllAsync(abName, typeof(T), run));
        }
        else
        {
            AssetBundleLoadMgr.Instance.LoadASync(abName, (bundle) =>
            {
                if (bundle == null) action?.Invoke(null);
                StartCoroutine(LoadAllAssetCor(bundle, typeof(T), run));
            });
        }
    }

    //加载所有资源
    public void LoadAllAssetAsync(string abName, Type t, Action<Object[]> action)
    {
        abName = abName.ToLower();
        if (AppConst.DebugMode)
        {
            StartCoroutine(ResourceLoadAllAsync(abName, t, action));
        }
        else
        {
            AssetBundleLoadMgr.Instance.LoadASync(abName, (bundle) =>
            {
                if (bundle == null) action?.Invoke(null);
                StartCoroutine(LoadAllAssetCor(bundle, t, action));
            });
        }
    }

    //创建游戏对象
    public void CreateGameObjectAsync(string abName, string assetName, Action<GameObject> action, Transform parent = null)
    {
        LoadAssetAsync<GameObject>(abName, assetName, (obj) =>
        {
            if (obj == null)
                return;
            GameObject go;
            go = Instantiate(obj, parent);
            go.name = obj.name;
            go.transform.localScale = Vector3.one;
            go.transform.localPosition = Vector3.zero;
            action?.Invoke(go);
        });
    }
    //加载游戏对象
    public void LoadGameObjectAsync(string abName, Action<GameObject> action, string assetName = null)
    {
        LoadAssetAsync(abName, assetName, action);
    }
    //加载单个Sprite
    public void LoadSpriteAsync(string abName, Action<Sprite> action, string assetName = null)
    {
        LoadAssetAsync(abName, assetName, action);
    }

    //加载贴图
    public void LoadTexture2DAsync(string abName, Action<Texture2D> action, string assetName = null)
    {
        LoadAssetAsync(abName, assetName, action);
    }
    //加载字体
    public void LoadFontAsync(string abName, Action<Font> action, string assetName = null)
    {
        LoadAssetAsync(abName, assetName, action);
    }
    //加载音频剪辑
    public void LoadAudioClipAsync(string abName, Action<AudioClip> action, string assetName = null)
    {
        LoadAssetAsync(abName, assetName, action);
    }
    //加载动画剪辑
    public void LoadAnimationClipAsync(string abName, Action<AnimationClip> action, string assetName = null)
    {
        LoadAssetAsync(abName, assetName, action);
    }
    //加载动画控制器
    public void LoadAnimatorControllerAsync(string abName, Action<RuntimeAnimatorController> action, string assetName = null)
    {
        LoadAssetAsync(abName, assetName, action);
    }
    //加载材质
    public void LoadMaterialAsync(string abName, Action<Material> action, string assetName)
    {
        LoadAssetAsync(abName, assetName, action);
    }
    //加载SkeletonDataAsset
    public void LoadSkeletonDataAssetAsync(string abName, string assetName,Action<SkeletonDataAsset> action)
    {
        LoadAssetAsync(abName, assetName, action);
    }
    
    #endregion
}
