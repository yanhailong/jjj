using System;
using System.Collections.Generic;
using System.IO;
using System.Linq;
using System.Text;
using Language;
using Newtonsoft.Json;
using TMPro;
using UnityEngine;

/// <summary>
/// 语言管理
/// </summary>
public class LanguageManager
{

    private static string abName="Common/Languages";
    // public FontManager font;
    public static LanguageManager Instance = new LanguageManager();

    private string _curLanguage;
    
    private TMP_FontAsset _fallbackFont;
    public TMP_FontAsset FallbackFont => _fallbackFont;
    public delegate void EventFunc();
    private event EventFunc _handler;

    //public Dictionary<string, ConfigurationData> Cfgs => _cfgs;
    //private readonly Dictionary<string, ConfigurationData> _cfgs = new Dictionary<string, ConfigurationData>();

    // private Dictionary<string, LanguageData> languagesData;
    /// <summary>
    /// 存储所有支持的语言
    /// </summary>
    public HashSet<string> allLang = new HashSet<string>();
    /// <summary>
    /// 语言配置
    /// </summary>
    public ConfigurationData lanCfg;
    /// <summary>
    /// 存储当前语言key-value
    /// </summary>
    private Dictionary<string, string> curLangData;

    public string Language
    {
        get => _curLanguage;
        set
        {
            if (!string.IsNullOrEmpty(_curLanguage) && 
                _curLanguage.Equals(value)) 
                return;
            if (!allLang.Contains(value))
            {
                Debug.unityLogger.Log(LogType.Error, "不支持该语言 " + value);
                _curLanguage = SystemLanguage.English.ToString();
            }
            else
            {
                _curLanguage = value;
            }
            
            curLangData = LoadJson<Dictionary<string, string>>(_curLanguage);
            RefreshFallbackFont();
            _handler?.Invoke();
        }
    }

    private void RefreshFallbackFont()
    {
        _fallbackFont = null;
        
        // var extra = GetLanguage("default_font_extra");
        // Font fontExtra = null;
        // if (!string.IsNullOrEmpty(extra))
        // {
        //     // var assetRef = AssetRef.Parse(extra);
        //     // fontExtra = assetRef?.Load<Font>();
        // }
        // if (fontExtra != null)
        // {
        //     _fallbackFont = TMP_FontAsset.CreateFontAsset(fontExtra);
        //     return;
        // }
        
        // #if UNITY_EDITOR
        // var fontName = GetLanguage("default_font_name");
        // #elif UNITY_ANDROID
        // var fontName = GetLanguage("default_font_name_android");
        // #elif UNITY_IOS
        // var fontName = GetLanguage("default_font_name_ios");
        // #else
        // var fontName = default(string);
        // #endif
        
        var fontName = default(string);
        if (string.IsNullOrEmpty(fontName))
            return;
        
        // Get paths to OS Fonts
        var fontPaths = Font.GetPathsToOSFonts();

        var alterFont = default(string);
        foreach (var fontPath in fontPaths)
        {
            if (System.IO.Path.GetFileNameWithoutExtension(fontPath).Equals(fontName, StringComparison.InvariantCultureIgnoreCase))
            {
                alterFont = fontPath;
                break;
            }
        }

        if (string.IsNullOrEmpty(alterFont))
            foreach (var fontPath in fontPaths)
            {
                if (System.IO.Path.GetFileNameWithoutExtension(fontPath).Contains(fontName, StringComparison.InvariantCultureIgnoreCase))
                {
                    alterFont = fontPath;
                    break;
                }
            }
        if (string.IsNullOrEmpty(alterFont))
            return;
        
        // Create new font object from one of those paths
        var osFont = new Font(alterFont);
        Debug.Log($"Create Font {osFont}");
        
        _fallbackFont = TMP_FontAsset.CreateFontAsset(osFont);
        
    }


    private T LoadJson<T>(string file)
    {
#if UNITY_EDITOR
        file = "Assets/AssetsPackage/"+abName+"/"+ file + ".json";
        var asset = UnityEditor.AssetDatabase.LoadAssetAtPath<TextAsset>(file);
        return JsonConvert.DeserializeObject<T>(asset.text);
#else
        var asset = AssetsManager.Instance.LoadAsset<TextAsset>(abName,file);
        Debug.LogError("加载资源："+asset);
        return JsonConvert.DeserializeObject<T>(asset.text);
#endif
    }


    public LanguageManager()
    {
        _curLanguage = null;
        curLangData ??= new Dictionary<string, string>();

        var langCfgData= LoadJson<LangCfgData>("lanconfig");
        lanCfg = langCfgData.ConfigurationData;
        foreach (var item in lanCfg.languages)
        {
            allLang.Add(item);
        }
        var language = "";
        if (language == "")
        {
            var systemLanguage = lanCfg.defaultLanguage;
            if (allLang.Contains(systemLanguage))
            {
                language = systemLanguage;
            }
            else
            {
                language = SystemLanguage.English.ToString();
                Debug.unityLogger.Log(LogType.Error, "语言种类配置文件中，没有Default标识!");
            }
        }
        Language = language;
    }

    /// <summary>
    /// 添加监听
    /// </summary>
    /// <param name="handler"></param>
    public void AddEventHandler(EventFunc handler)
    {
        _handler += handler;
    }

    /// <summary>
    /// 移除监听
    /// </summary>
    /// <param name="handler"></param>
    public void RemoveEventHandler(EventFunc handler)
    {
        _handler -= handler;
    }

    /// <summary>
    /// 当前语言是否是英文
    /// </summary>
    /// <returns></returns>
    public bool IsEnglish()
    {
        return _curLanguage.Equals("en");
    }

    /// <summary>
    /// 清除静态对象
    /// </summary>
    public void Clear()
    {
        allLang.Clear();
        lanCfg = null;
        curLangData.Clear();
        Instance = new LanguageManager();
    }

    /// <summary>
    /// 得到预制体
    /// </summary>
    /// <param name="key"></param>
    /// <returns></returns>
    public GameObject GetPrefab(string key)
    {
        var data = GetLanguage(key);
        // if (data.dataType == (int) LanguageDataType.Prefab) {
        var obj = Resources.Load("Language/Prefab/" + data) as GameObject;
        if (!obj) Debug.unityLogger.Log(LogType.Error, "没有找到预制体 " + data);
        else return obj;
        // }
        return null;
    }

    #region 语言种类的配置文件

    /// <summary>
    /// 得到支持的语言名字
    /// </summary>
    /// <returns></returns>
    public List<string> GetLanguagesName()
    {
        return lanCfg.languages.ToList();
    }
    #endregion

    #region 语言数据

    /// <summary>
    /// 得到语言数据的Key
    /// </summary>
    /// <returns></returns>
    public string[] GetLanguageKeys()
    {
        return lanCfg.languages.ToArray();
    }

    /// <summary>
    /// 通过Key得到语言数据
    /// </summary>
    /// <param name="key"></param>
    /// <param name="defaultValue"></param>
    /// <returns></returns>
    public string GetLanguage(string key, string defaultValue = null)
    {
        if (curLangData.TryGetValue(key, out var data)) return data;
        Debug.unityLogger.Log(LogType.Warning, $"键值不存在:{key}");
        return defaultValue;
    }

    public bool GetLanguage(string key, out string value)
    {
        if (curLangData.TryGetValue(key, out value)) return true;
        Debug.unityLogger.Log(LogType.Warning, $"键值不存在:{key}");
        return false;
    }

    #endregion

    public static string GetTransPath(Transform self)
    {
        var names = new List<string>();
        var tf = self;
        while (tf)
        {
            names.Add(tf.name);
            tf = tf.parent;
        }

        names.Reverse();

        var builder = new StringBuilder();
        foreach (var s in names)
        {
            builder.Append(s).Append(".");
        }

        var fullName = builder.ToString();
        return fullName.Substring(0, fullName.Length - 1).Replace("Canvas (Environment).", "");
    }
}
