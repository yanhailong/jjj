using System;
using System.Collections.Generic;
using System.IO;
using System.Linq;
using System.Text;
// using App.Config;
// using FQDev.AssetBundles;
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

    public string Language
    {
        get => _curLanguage;
        set
        {
            if (!string.IsNullOrEmpty(_curLanguage) && 
                _curLanguage.Equals(value)) 
                return;
            if (!_cfgs.ContainsKey(value))
            {
                Debug.unityLogger.Log(LogType.Error, "不支持该语言 " + value);
                _curLanguage = SystemLanguage.English.ToString();
            }
            else
            {
                _curLanguage = value;
            }

            //设置推送的语言
            // Lang.L = (SystemLanguage) System.Enum.Parse (typeof (SystemLanguage), _curLanguage);

            languagesData = LoadJson<Dictionary<string, string>>(_curLanguage);
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
            if (Path.GetFileNameWithoutExtension(fontPath).Equals(fontName, StringComparison.InvariantCultureIgnoreCase))
            {
                alterFont = fontPath;
                break;
            }
        }

        if (string.IsNullOrEmpty(alterFont))
            foreach (var fontPath in fontPaths)
            {
                if (Path.GetFileNameWithoutExtension(fontPath).Contains(fontName, StringComparison.InvariantCultureIgnoreCase))
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
    public delegate void EventFunc();

    private event EventFunc _handler;

    private readonly Dictionary<string, ConfigurationData> _cfgs = new Dictionary<string, ConfigurationData>();

    // private Dictionary<string, LanguageData> languagesData;
    private Dictionary<string, string> languagesData;

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
        languagesData ??= new Dictionary<string, string>();

        var cfgData = LoadJson<List<ConfigurationData>>("LanguageConfig");
        foreach (var item in cfgData)
        {
            _cfgs[item.name] = item;
        }

        var language = "";
        if (language == "")
        {
            var systemLanguage = Application.systemLanguage.ToString();
            if (_cfgs.ContainsKey(systemLanguage))
            {
                language = systemLanguage;
            }
            else
            {
                var value = cfgData.Find(d => d.index == 0);
                if (value != null) language = value.name;
                else
                {
                    language = SystemLanguage.English.ToString();
                    Debug.unityLogger.Log(LogType.Error, "语言种类配置文件中，没有Default标识!");
                }
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
        _cfgs.Clear();
        languagesData.Clear();
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
        return _cfgs.Keys.ToList();
    }

    /// <summary>
    /// 得到支持的语言描述
    /// </summary>
    /// <returns></returns>
    public List<string> GetLanguagesDescribe()
    {
        var describes = new List<string>();
        foreach (var item in _cfgs) describes.Add(item.Value.describe);
        return describes;
    }

    public Dictionary<string, ConfigurationData> Cfgs => _cfgs;

    /// <summary>
    /// 得到语言名字通过下标(传入的下标如果没有找到数据，则返回"en")
    /// </summary>
    /// <param name="theIndex">下标</param>
    /// <returns></returns>
    public string GetLanguageName(int theIndex)
    {
        foreach (var item in _cfgs)
        {
            if (item.Value.index == theIndex)
                return item.Key;
        }

        return "en";
    }

    #endregion

    #region 语言数据

    /// <summary>
    /// 得到语言数据的Key
    /// </summary>
    /// <returns></returns>
    public string[] GetLanguageKeys()
    {
        return languagesData.Keys.ToArray();
    }

    /// <summary>
    /// 通过Key得到语言数据
    /// </summary>
    /// <param name="key"></param>
    /// <param name="defaultValue"></param>
    /// <returns></returns>
    public string GetLanguage(string key, string defaultValue = null)
    {
        // if (!languagesData.ContainsKey (key)) return null;
        // var data = languagesData[key];
        // var content = data.Replace ("\\u3000", "\u3000");
        // content = content.Replace ("\\n", "\n");
        // data = content;
        // return data;
        if (languagesData.TryGetValue(key, out var data)) return data;
        Debug.unityLogger.Log(LogType.Warning, $"键值不存在:{key}");
        return defaultValue;
    }

    public bool GetLanguage(string key, out string value)
    {
        if (languagesData.TryGetValue(key, out value)) return true;
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
