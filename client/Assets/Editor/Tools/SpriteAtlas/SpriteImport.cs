using System;
using UnityEngine;
using UnityEditor;
using UnityEngine.UI;
using System.Collections;
using System.Reflection;
using Object = UnityEngine.Object;

public class SpriteImport : ScriptableWizard
{
    private const string m_androidPlatform = "Android";
    private const string m_iPhonePlatform = "IOS";
    private const string m_standalonePlatform = "Standalone";
    private const string m_WebGL = "WebGL";


    private const string s_gamesFolder = "ArtsBase/";
    private static bool split = false;//是否拆分透明值
    
    #region 设置
    
    static string curPlatform = "";
    static bool autoSet = false;
    static TextureImporterFormat selectFormatType = TextureImporterFormat.ASTC_8x8;
    static string selectFormatTypeName = "";
    static string LogStr = "";
    Vector2 scrollPos;
    
    
    /// <summary>
    /// 压缩格式,需与TextureImporterFormat里的值保持一致
    /// 暂时列举常用的几个
    /// ETC：不支持透明通道，图片宽高必须是2的整数次幂
    /// ETC2：是ETC的扩展，支持透明通道，且图片宽高只要是4的倍数即可
    /// ASTC是Android和IOS平台下的一种高质量压缩方式，支持Android5.0和iPhone6以上机型
    ///无Alpha通道的贴图建议压缩格式为ASTC 8x8。如果贴图为法线贴图，建议压缩格式为ASTC 5x5。
    ///有更高要求的贴图（比如面部、场景地面），可以设置压缩格式为ASTC 6x6，法线贴图为ASTC 4x4。
    /// </summary>
    enum FormatType
    {
        RGBA32 = TextureImporterFormat.RGBA32,
        ETC_RGB4 = TextureImporterFormat.ETC_RGB4,
        ETC2_RGB4 = TextureImporterFormat.ETC2_RGB4,
        ETC2_RGBA8 = TextureImporterFormat.ETC2_RGBA8,

        ASTC_4x4 = TextureImporterFormat.ASTC_4x4,
        ASTC_5x5 = TextureImporterFormat.ASTC_5x5,
        ASTC_6x6 = TextureImporterFormat.ASTC_6x6,
        ASTC_8x8 = TextureImporterFormat.ASTC_8x8,
        ASTC_10x10 = TextureImporterFormat.ASTC_10x10,
    }
    
    [MenuItem("Assets/设置游戏UI图片", false, 10)]
    public static void CreateWindow()
    {
        selectFormatTypeName = Enum.GetName(typeof(FormatType), selectFormatType);
        DisplayWizard<SpriteImport>("设置图片压缩格式", "完成", "设置");
        GetPlatform();
    }

    void OnWizardCreate()
    {
        Debug.Log("完成！");
    }
       
    void OnWizardOtherButton()
    {
        Debug.Log("开始设置图片格式！");
        SetGameUIPicAttribute();
    }
    
    /// <summary>
    /// 获取当前平台
    /// </summary>
    static void GetPlatform()
    {
    #if UNITY_EDITOR && UNITY_ANDROID
        curPlatform = "Android";
    #elif UNITY_EDITOR && UNITY_IOS
            curPlatform = "iOS";
    #elif UNITY_EDITOR && UNITY_WEBGL
            curPlatform = "WebGl";
    #elif UNITY_EDITOR && UNITY_STANDALONE
            curPlatform = "Standalone";
    #endif
     
    }
    
    protected override bool DrawWizardGUI()
    {
        //打印当前平台
        GUILayout.Label("当前平台是:" + curPlatform);
        GUILayout.Label("===========================");
        GUILayout.Space(10);
        autoSet = GUILayout.Toggle(autoSet, "自动设置");
        if (!autoSet)
        {
            GenericMenu formatType = new GenericMenu();
            foreach (var type in Enum.GetValues(typeof(FormatType)))
            {
                string s = Enum.GetName(typeof(FormatType), type);
                formatType.AddItem(new GUIContent(s), false, SelsetFormat, (int)type);
            }
 
            GUILayout.Label("ETC：不支持透明通道，图片宽高必须是2的整数次幂" +
                            "\nETC2：是ETC的扩展，支持透明通道，且图片宽高只要是4的倍数即可" +
                            "\nASTC: 是Android和IOS平台下的一种高质量压缩方式，支持Android5.0和iPhone6以上机型");
            if (GUILayout.Button("选择压缩格式 " + selectFormatTypeName))
            {
                formatType.ShowAsContext();
            }
            
        }
        GUILayout.Space(10);
        split = GUILayout.Toggle(split, "是否拆分透明值");
        //添加卷轴内打印
        GUILayout.BeginHorizontal();
        GUILayout.Space(50);
        scrollPos = GUILayout.BeginScrollView(scrollPos, GUILayout.Width(500),GUILayout.Height(300));
        GUILayout.Label(LogStr);
        GUILayout.EndScrollView();
        GUILayout.EndHorizontal();
 
        GUILayout.Space(150);
 
        return base.DrawWizardGUI();
    }
    //获取正式的压缩类型
    static void SelsetFormat(object type)
    {
        selectFormatType = (TextureImporterFormat)type;
        selectFormatTypeName = Enum.GetName(typeof(FormatType), selectFormatType);
        Debug.Log("selectFormatType = " + selectFormatType);
    }
    

    #endregion


    

    private void SetGameUIPicAttribute()
    {
        Object[] textures = Selection.GetFiltered(typeof(Texture2D), SelectionMode.DeepAssets);
        if (null == textures || textures.Length <= 0)
        {
            EditorUtility.DisplayDialog("错误", "这个目录没有任何图片！", "确定");
            return;
        }
        string rootPath = AssetDatabase.GetAssetPath(textures[0]);
        if (!rootPath.Contains(s_gamesFolder))
        {
            EditorUtility.DisplayDialog("错误", "你选择的目录不是子游戏UI图片目录！", "确定");
            return;
        }

        Selection.objects = new Object[0];
        Texture2D oneTexture = null;
        float currentProgress = 0;
        for (int i = 0; i < textures.Length; i++)
        {
            oneTexture = textures[i] as Texture2D;
            SetOneTexture(oneTexture);
            EditorUtility.DisplayProgressBar("正在统一设置UI图片的属性参数", oneTexture.name, currentProgress);
        }
        EditorUtility.ClearProgressBar();
        EditorUtility.DisplayDialog("提示", "UI图片的属性设置完毕！", "确定");
    }
  
    private static bool HasAlpha(Color[] aColors)
    {
        for (int i = 0; i < aColors.Length; i++)
            if (aColors[i].a < 1f)
                return true;
        return false;
    }
    
    private static void SetOneTexture(Texture2D tex)
    {
        string localPath = AssetDatabase.GetAssetPath(tex);
        if (!localPath.Contains(s_gamesFolder))
        {
            Debug.LogError("图片必须放入:" + s_gamesFolder + "下才能进行操作！！！！！");
            return;
        }
        SetTextureFormat(localPath);
    }
    
    private static void SetTextureFormat(string localPath)
    {
        TextureImporter textureImporter = AssetImporter.GetAtPath(localPath) as TextureImporter;
        textureImporter.isReadable = true;
        textureImporter.mipmapEnabled = false;
        int maxSize = GetMaxSize(textureImporter);
        TextureImporterFormat defaultAlpha;
        TextureImporterFormat defaultNoAlpha;
        
        
        TextureImporterPlatformSettings settings_Android = new TextureImporterPlatformSettings();
        //标识平台为Android 大小写都可以
        settings_Android.name = m_androidPlatform;
        settings_Android.overridden = true;
        settings_Android.maxTextureSize = maxSize;
        settings_Android.allowsAlphaSplitting = split;
        if (autoSet)
        {
            bool divisibleOf4 = IsDivisibleOf4(textureImporter);
            defaultAlpha = divisibleOf4 ? TextureImporterFormat.ETC2_RGBA8 : TextureImporterFormat.ASTC_4x4;
            defaultNoAlpha = divisibleOf4 ? TextureImporterFormat.ETC2_RGB4  : TextureImporterFormat.ASTC_4x4;
            settings_Android.format = textureImporter.DoesSourceTextureHaveAlpha() ? defaultAlpha : defaultNoAlpha;
        }
        else
        {
            settings_Android.format = selectFormatType;
        }
        textureImporter.SetPlatformTextureSettings(settings_Android);
        //这里设置要放在对应的平台代码块内，否则改变的就是默认的平台 
        
        
        TextureImporterPlatformSettings settings_IOS = new TextureImporterPlatformSettings();
        settings_IOS.name = m_iPhonePlatform;
        settings_IOS.overridden = true;
        settings_IOS.allowsAlphaSplitting = split;
        settings_IOS.maxTextureSize = maxSize / 4;
        if (autoSet)
        {
            
            bool powerOfTwo = IsPowerOfTwo(textureImporter);
            defaultAlpha = powerOfTwo ? TextureImporterFormat.PVRTC_RGBA4 : TextureImporterFormat.ASTC_4x4;
            defaultNoAlpha = powerOfTwo ? TextureImporterFormat.PVRTC_RGB4 : TextureImporterFormat.ASTC_4x4;
            settings_IOS.format = textureImporter.DoesSourceTextureHaveAlpha() ? defaultAlpha : defaultNoAlpha;
        }
        else
        {
            settings_IOS.format = selectFormatType;
        }
        textureImporter.SetPlatformTextureSettings(settings_IOS);
        
        
        TextureImporterPlatformSettings settings_WebGl = new TextureImporterPlatformSettings();
        settings_WebGl.name = m_WebGL;
        settings_WebGl.overridden = true;
        settings_WebGl.maxTextureSize = (maxSize / 4) <= 32 ? 32 : maxSize / 4;
        settings_WebGl.allowsAlphaSplitting = split;
        if (autoSet)
        {
            bool wdivisibleOf4 = IsDivisibleOf4(textureImporter);
            defaultAlpha = wdivisibleOf4 ? TextureImporterFormat.DXT5Crunched : TextureImporterFormat.ASTC_4x4;
            defaultNoAlpha = wdivisibleOf4 ? TextureImporterFormat.DXT1Crunched : TextureImporterFormat.ASTC_4x4;
            settings_WebGl.format = textureImporter.DoesSourceTextureHaveAlpha() ? defaultAlpha : defaultNoAlpha;
        }
        else
        {
            settings_WebGl.format = selectFormatType;
        }
        
        textureImporter.SetPlatformTextureSettings(settings_WebGl);
        
        
        //保存更改并重新导入图片
        textureImporter.isReadable = false;
        textureImporter.SaveAndReimport();
    }

    
    //private static int[] sizes = {32, 64, 128, 256, 512, 1024, 2048, 4096};
    private static int[] sizes = {32, 64, 128, 256, 512, 1024, 2048};
    private static int GetMaxSize(TextureImporter textureImporter)
    {
        (int width, int height) = GetTextureImporterSize(textureImporter);
        int tempMax = Mathf.Max(height, width);
        foreach (var size in sizes)
        {
            if (tempMax <= size)
                return size;
        }

        return 2048;
    }
    
    
    //获取导入图片的宽高
    static (int, int) GetTextureImporterSize(TextureImporter textureImporter)
    {
        if (textureImporter != null)
        {
            object[] args = new object[2];
            MethodInfo mi = typeof(TextureImporter).GetMethod("GetWidthAndHeight", BindingFlags.NonPublic | BindingFlags.Instance);
            mi.Invoke(textureImporter, args);
            return ((int)args[0], (int)args[1]);
        }
        return (0, 0);
    }


    //长宽都被4整除
    static bool IsDivisibleOf4(TextureImporter textureImporter)
    {
        (int width, int height) = GetTextureImporterSize(textureImporter);
        return (width % 4 == 0 && height % 4 == 0);
    }
    
     //2的整数次幂
     static bool IsPowerOfTwo(TextureImporter textureImporter)
     {
         (int width, int height) = GetTextureImporterSize(textureImporter);
         return (width == height) && (width > 0) && ((width & (width - 1)) == 0);
     }
}


