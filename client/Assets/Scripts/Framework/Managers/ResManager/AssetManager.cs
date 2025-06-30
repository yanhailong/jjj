using System.Collections;
using System.Collections.Generic;
using UnityEngine;
using System.IO;
using System;
using JiuJiuPrincess;
using Object = UnityEngine.Object;

public class AssetManager : SingletonMono<AssetManager>
{
    private string[] m_Variants = { };

    //游戏根目录名字
    public string gameRootDirName;
    //大厅资源包
    private AssetBundleMap hallAssetBundleMap;
    //当前游戏资源包
    private AssetBundleMap curGameAssetMap;
    //未使用游戏资源包
    private Dictionary<string, AssetBundleMap> unuseGameAssetMap;

    //当前正在异步加载的ab包
    private Dictionary<string, AssetBundleCreateRequest> curAsyncLoadBundle = new Dictionary<string, AssetBundleCreateRequest>();

    //初始化
    public void Initialized()
    {
        if (AppConst.DebugMode || hallAssetBundleMap != null) return;

        //获取大厅清单列表
        string manifestPath = AppConst.AssetLocalPath + "manifest.unity3d";
        AssetBundleManifest hallManifest = this.LoadManifest(manifestPath);
        hallAssetBundleMap = new AssetBundleMap("hall", hallManifest);

        unuseGameAssetMap = new Dictionary<string, AssetBundleMap>();

        //获取游戏根目录名字
        this.gameRootDirName = Path.GetDirectoryName(AppConst.GameAssetLocalPath).ToLower() + "/";
    }

    //加载ab包清单文件
    private AssetBundleManifest LoadManifest(string path)
    {
        if (!File.Exists(path))
        {
            Debug.LogError("加载清单文件错误:" + path);
            return null;
        }
        var ab = AssetBundle.LoadFromFile(path);
        AssetBundleManifest manifest = ab.LoadAsset<AssetBundleManifest>("AssetBundleManifest");
        ab.Unload(false);
        return manifest;
    }

    //新建一个游戏资源包
    public bool CreateGameAssetMap(string gameName)
    {
        gameName = gameName.ToLower();
        if (curGameAssetMap != null)
        {
            if (!unuseGameAssetMap.ContainsKey(curGameAssetMap.name))
                unuseGameAssetMap.Add(curGameAssetMap.name, curGameAssetMap);          
        }
        //未使用游戏资源包里面有当前要创建的游戏资源
        if (unuseGameAssetMap.ContainsKey(gameName))
        {
            curGameAssetMap = unuseGameAssetMap[gameName];
            unuseGameAssetMap.Remove(gameName);
            return true;
        }

        gameName = gameName.ToLower();
        string manifestPath = AppConst.GameAssetLocalPath + gameName + "/manifest.unity3d";
        AssetBundleManifest gameManifest = this.LoadManifest(manifestPath);
        if (gameManifest == null)
        {
            Debug.LogError("找不到对应的游戏清单路径:" + manifestPath);
            return false;
        }
        curGameAssetMap = new AssetBundleMap(gameName, gameManifest);
        return true;

    }

    //卸载一个游戏资源包
    public bool UnloadGameAssetMap(string gameName, bool unloadAllLoadedObjects)
    {
        gameName = gameName.ToLower();
        //是否是卸载当前游戏资源
        if (gameName.Equals(curGameAssetMap.name))
        {
            curGameAssetMap.UnloadAll(unloadAllLoadedObjects);
            curGameAssetMap = null;
            if (unuseGameAssetMap.ContainsKey(gameName))
                unuseGameAssetMap.Remove(gameName);
            return true;
        }

        if (!unuseGameAssetMap.ContainsKey(gameName))
        {
            Debug.LogError("找不到对应的游戏资源包:" + gameName);
            return false;
        }
        unuseGameAssetMap[gameName].UnloadAll(unloadAllLoadedObjects);

        return unuseGameAssetMap.Remove(gameName);
    }

    //是否是游戏路径
    private bool PathIsCurGame(string path)
    {
        if (curGameAssetMap == null) return false;
        return path.StartsWith(AppConst.GameDir);
    }

    //获取ab包依赖
    private AssetBundleManifest GetDependencies(string abName)
    {
        AssetBundleManifest bundleManifest = null;
        //是否是游戏资源
        if (this.PathIsCurGame(abName))
        {
            if (curGameAssetMap == null) return null;
            bundleManifest = curGameAssetMap.manifest;
        }
        else
        {
            if (hallAssetBundleMap == null) return null;
            bundleManifest = hallAssetBundleMap.manifest;
        }
        return bundleManifest;
    }

    //获取资源包
    private AssetBundleMap GetAssetBundleMap(string abName)
    {
        AssetBundleMap assetBundleMap = null;
        //是否是游戏资源
        if (PathIsCurGame(abName))
            assetBundleMap = curGameAssetMap;
        else
            assetBundleMap = hallAssetBundleMap;
        return assetBundleMap;
    }

    // Remaps the asset bundle name to the best fitting asset bundle variant.
    private string RemapVariantName(string assetBundleName, AssetBundleManifest manifest)
    {
        string[] bundlesWithVariant = manifest.GetAllAssetBundlesWithVariant();

        // If the asset bundle doesn't have variant, simply return.
        if (System.Array.IndexOf(bundlesWithVariant, assetBundleName) < 0)
            return assetBundleName;

        string[] split = assetBundleName.Split('.');

        int bestFit = int.MaxValue;
        int bestFitIndex = -1;
        // Loop all the assetBundles with variant to find the best fit variant assetBundle.
        for (int i = 0; i < bundlesWithVariant.Length; i++)
        {
            string[] curSplit = bundlesWithVariant[i].Split('.');
            if (curSplit[0] != split[0])
                continue;

            int found = System.Array.IndexOf(m_Variants, curSplit[1]);
            if (found != -1 && found < bestFit)
            {
                bestFit = found;
                bestFitIndex = i;
            }
        }
        if (bestFitIndex != -1)
            return bundlesWithVariant[bestFitIndex];
        else
            return assetBundleName;
    }

    #region 同步加载资源
    //加载ab包
    public AssetBundle LoadBundle(string abName)
    {
        abName = abName.ToLower();
        if (!abName.EndsWith(AppConst.ExtName))
            abName += AppConst.ExtName;

        AssetBundleMap assetBundleMap = this.GetAssetBundleMap(abName);
        //当前资源包是否包含这个资源
        if (assetBundleMap.IsHas(abName))
            return assetBundleMap.Get(abName);

        //加载依赖
        LoadDependencies(abName);

        string path = AppConst.AssetLocalPath + abName;

        if (!File.Exists(path))
        {
            Debug.LogError("加载的资源不存在:" + path);
            return null;
        }

        AssetBundle bundle = AssetBundle.LoadFromFile(path);
        Debug.LogError("同步加载加载的资源:" + abName);
        assetBundleMap.Add(abName, bundle);
        return bundle;
    }

    //加载依赖文件
    private void LoadDependencies(string abName)
    {
        AssetBundleManifest manifest = this.GetDependencies(abName);
        if (manifest == null)
        {
            Debug.LogError("找不到对应的清单文件:" + abName);
            return;
        }
        string[] dependencies = manifest.GetAllDependencies(abName);
        if (dependencies.Length == 0) return;

        for (int i = 0; i < dependencies.Length; i++)
            dependencies[i] = RemapVariantName(dependencies[i], manifest);
        for (int i = 0; i < dependencies.Length; i++)
        {
            this.LoadBundle(dependencies[i]);
        }
    }

    //加载资源
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
            AssetBundle bundle = LoadBundle(abName);
            if (bundle == null) return null;
            return bundle.LoadAsset<T>(assetName);
        }
    }

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
            AssetBundle bundle = LoadBundle(abName);
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
            AssetBundle bundle = LoadBundle(abName);
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
    
    public string LoadTextAssetStr(string abName, string assetName = null)
    {
        string str = LoadAsset<TextAsset>(abName, assetName).text;
        return str;
    }

    #endregion

    #region 异步加载资源

    //加载ab包(异步)
    public void LoadBundleAsync(string abName, Action<AssetBundle> action, bool isLoadDependencies = true)
    {
        StartCoroutine(LoadBundleCor(abName, action, isLoadDependencies));
    }

    private IEnumerator LoadBundleCor(string abName, Action<AssetBundle> action, bool isLoadDependencies = true)
    {
        Debug.LogError("加载abName:"+abName);
        abName = abName.ToLower();
        if (!abName.EndsWith(AppConst.ExtName))
            abName += AppConst.ExtName;

        AssetBundleMap assetBundleMap = this.GetAssetBundleMap(abName);

        //当前资源包是否包含这个资源
        if (assetBundleMap.IsHas(abName))
        {
            action?.Invoke(assetBundleMap.Get(abName));
            yield break;
        }
        if (isLoadDependencies)
            //加载依赖
            yield return LoadDependenciesAsync(abName);
        string path = AppConst.AssetLocalPath + abName;
        if (!File.Exists(path))
        {
            Debug.LogError("加载的资源不存在:" + path);
            action?.Invoke(null);
            yield break;
        }


        AssetBundleCreateRequest request;
        if (!curAsyncLoadBundle.TryGetValue(path, out request))//是否正在加载当前ab包
        {
            request = AssetBundle.LoadFromFileAsync(path);
            curAsyncLoadBundle.Add(path, request);
            yield return request;
        }
        else
        {
            //等待加载完成
            while (!request.isDone)
            {
                yield return null;
            }
        }

        //AssetBundleCreateRequest request = AssetBundle.LoadFromFileAsync(path);
        //yield return request;

        curAsyncLoadBundle.Remove(path);

        AssetBundle assetBundle = request.assetBundle;
        if (assetBundle == null)
        {
            Debug.LogError("加载ab包错误:" + path);
            yield break;
        }
        assetBundleMap.Add(abName, assetBundle);
        action?.Invoke(assetBundle);
    }

    //加载依赖文件(异步)
    private IEnumerator LoadDependenciesAsync(string abName)
    {
        AssetBundleManifest manifest = this.GetDependencies(abName);
        if (manifest == null)
        {
            Debug.LogError("找不到对应的清单文件:" + abName);
            yield break;
        }
        string[] dependencies = manifest.GetAllDependencies(abName);
        if (dependencies.Length == 0) yield break;
        for (int i = 0; i < dependencies.Length; i++)
            dependencies[i] = RemapVariantName(dependencies[i], manifest);
        for (int i = 0; i < dependencies.Length; i++)
        {
            yield return this.LoadBundleCor(dependencies[i], null);
        }
    }

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
            LoadBundleAsync(abName, (bundle) =>
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
            LoadBundleAsync(abName, (bundle) =>
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
            LoadBundleAsync(abName, (bundle) =>
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
    
    public void LoadTextAssetStrAsync(string abName, Action<TextAsset> action,string assetName)
    {
        LoadAssetAsync(abName, assetName, action);
    }

    #endregion
}
