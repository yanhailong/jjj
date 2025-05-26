using System.Collections;
using System.Collections.Generic;
using UnityEngine;
using UnityEditor;
using System.IO;
using UnityEditor.U2D;
using UnityEngine.U2D;

public class SpriteAtlasTools
{
    static string rootPath = (Application.dataPath + "/").Replace("\\", "/");
    static string alatsArtBasePath = "AssetsPackage/ArtsBase/Alats";
    static string pngExtension = ".png";
    static string spineExtension = ".asset";
    static string fontExtension = ".fontsettings";
    static string atlasExtension = ".spriteatlas";
    static string atlasNamePre = "atlas_";
    static string fileSearchPattern = "*.*";
    static int createAtlasCount = 0;
    static int deleteAtlasCount = 0;
    static List<AtlasInfo> atlasInfos = new List<AtlasInfo>();

    static SpriteAtlasPackingSettings packSet = new SpriteAtlasPackingSettings()
    {
        blockOffset = 1,
        enableRotation = false,
        enableTightPacking = false,
        padding = 2,
    };
    static SpriteAtlasTextureSettings textureSet = new SpriteAtlasTextureSettings()
    {
        readable = false,
        generateMipMaps = false,
        sRGB = true,
        filterMode = FilterMode.Bilinear,
    };
    static TextureImporterPlatformSettings defaultPlatformSet = new TextureImporterPlatformSettings()
    {
        name = "DefaultTexturePlatform",
        format = TextureImporterFormat.Automatic,
        //compressionQuality = 100,
    };
    static TextureImporterPlatformSettings standalonePlatformSet = new TextureImporterPlatformSettings()
    {
        name = "Standalone",
        overridden = true,
        format = TextureImporterFormat.RGBA32,
        //compressionQuality = 100,
    };
    static TextureImporterPlatformSettings iPhonePlatformSet = new TextureImporterPlatformSettings()
    {
        name = "iPhone",
        overridden = true,
        format = TextureImporterFormat.ASTC_6x6,
        //compressionQuality = 100,
    };
    static TextureImporterPlatformSettings androidPlatformSet = new TextureImporterPlatformSettings()
    {
        name = "Android",
        overridden = true,
        format = TextureImporterFormat.ASTC_6x6,
        //compressionQuality = 100,
    };
    class AtlasInfo {
        public string atlasName;
        public string atlasPath;
        public List<string> texturePaths = new List<string>();
    }

    [MenuItem("Assets/图集操作/创建选择文件夹的SpriteAtlas",false,1)]
    static void AtlasCreate()
    {
        createAtlasCount = 0;
        atlasInfos.Clear();
        Object[] selects = Selection.GetFiltered(typeof(Object), SelectionMode.Assets);
        for (int i = 0; i < selects.Length; ++i)
        {
            Object selected = selects[i];
            string path = AssetDatabase.GetAssetPath(selected);
            if (!path.Contains(alatsArtBasePath))
            {
                if (EditorUtility.DisplayDialog("提示", "请选择ArtBase/Alats目录或其子目录打包图集!", "确定"))
                {
                    return;
                }
                return;
            }
            if (Directory.Exists(path))
            {
                AtlasCreateByFloder(path);
            }
        }
        AtlasCreateByinfo();
        AssetDatabase.Refresh();
        Debug.Log("图集创建完毕！总计：" + createAtlasCount.ToString());
    }

    [MenuItem("Assets/图集操作/删除选择文件夹的SpriteAtlas", false, 2)]
    static void AtlasDelete()
    {
        deleteAtlasCount = 0;
        Object[] selects = Selection.GetFiltered(typeof(Object), SelectionMode.Assets);
        for (int i = 0; i < selects.Length; ++i)
        {
            Object selected = selects[i];
            string path = AssetDatabase.GetAssetPath(selected);
            if (Directory.Exists(path))
            {
                AtlasDeleteByFloder(path);
            }
        }
        AssetDatabase.Refresh();
        Debug.Log("图集删除完毕！总计：" + deleteAtlasCount.ToString());
    }

    [MenuItem("Assets/图集操作/格式化选择文件夹的SpriteAtlas", false, 3)]
    static void SetAllAtlases()
    {
        Object[] selects = Selection.GetFiltered(typeof(Object), SelectionMode.Assets);
        for (int i = 0; i < selects.Length; ++i)
        {
            Object selected = selects[i];
            string path = AssetDatabase.GetAssetPath(selected);
            if (!path.Contains(alatsArtBasePath))
            {
                if (EditorUtility.DisplayDialog("提示", "请选择ArtBase/Alats目录或其子目录格式化!", "确定"))
                {
                    return;
                }
                return;
            }
            if (Directory.Exists(path))
            {
                AtlasSetByFloder(path);
            }
        }
        AssetDatabase.Refresh();
    }

    [MenuItem("Assets/图集操作/Pack所有SpriteAtlas", false, 4)]
    static void PackAllAtlases()
    {
#if UNITY_ANDROID
        SpriteAtlasUtility.PackAllAtlases(BuildTarget.Android);
#elif UNITY_IOS
        SpriteAtlasUtility.PackAllAtlases(BuildTarget.iOS);
#endif
        Debug.Log("Pack所有SpriteAtlas 完毕！");
    }

    // static string GetAtlasName(string dirFullName,string basePath)
    // {
    //     string alatName = "";
    //     string tempAlatName = dirFullName.Replace("\\", "/");;
    //     string tempAlats = rootPath + basePath;
    //     tempAlatName = atlasNamePre+tempAlatName.Replace(tempAlats, "").Replace("/","_");
    //     alatName=tempAlatName + atlasExtension;
    //     return alatName;
    // }
    static string GetAtlasName(string dirName)
    {
        string alatName = "";
        alatName=atlasNamePre +dirName+ atlasExtension;
        return alatName;
    }

    static string GetAssetsPath(string path)
    {
        string name = path.Replace("\\", "/");
        name = name.Replace(rootPath, "Assets/");
        return name;
    }

    static void AtlasCreateByFloder(string path)
    {
        DirectoryInfo dir = new DirectoryInfo(path);
        DirectoryInfo[] dirs = dir.GetDirectories();
        for (int i = 0; i < dirs.Length; ++i)
        {
            AtlasCreateByFloder(dirs[i].FullName);
        }
        FileInfo[] files = dir.GetFiles(fileSearchPattern, SearchOption.TopDirectoryOnly);
        List<string> textures = new List<string>();
        for (int i = 0; i < files.Length; ++i)
        {
            FileInfo f = files[i];
            if (f.Extension.Equals(pngExtension))
            {
                string spinePath = f.FullName.Replace(pngExtension, spineExtension);
                string fontPath = f.FullName.Replace(pngExtension, fontExtension);
                if (!File.Exists(spinePath) && !File.Exists(fontPath))
                {
                    textures.Add(f.FullName);
                }
            }
        }
        if (textures.Count > 0)
        {

            string atlasName = GetAtlasName(dir.Name);
            string atlasPath = Path.Combine(dir.FullName, atlasName);
            atlasPath = GetAssetsPath(atlasPath);
            AtlasInfo atlasInfo = new AtlasInfo()
            {
                atlasName = atlasName,
                atlasPath = atlasPath,
                texturePaths = textures,
            };
            atlasInfos.Add(atlasInfo);
        }
    }

    static void AtlasCreateByinfo()
    {
        AtlasInfo[] atlasInfosArr = atlasInfos.ToArray();
        for (int i = 0; i < atlasInfosArr.Length; ++i)
        {
            AtlasInfo atlasInfo = atlasInfosArr[i];
            string atlasPath = atlasInfo.atlasPath;
            SpriteAtlas atlas=null;
            bool isNewAtlas = true;
            if (File.Exists(atlasPath))
            {
                atlas = AssetDatabase.LoadAssetAtPath<SpriteAtlas>(atlasPath);
                atlas.Remove(atlas.GetPackables());
                File.Delete(atlasPath);
                File.Delete(atlasPath+".meta");
                isNewAtlas = false;
            }
            if (isNewAtlas)
            {
                atlas = new SpriteAtlas();
                atlas.SetIncludeInBuild(true);
                atlas.SetPackingSettings(packSet);
                atlas.SetTextureSettings(textureSet);
                atlas.SetPlatformSettings(defaultPlatformSet);
                atlas.SetPlatformSettings(standalonePlatformSet);
                atlas.SetPlatformSettings(iPhonePlatformSet);
                atlas.SetPlatformSettings(androidPlatformSet);
            }
            
            List<Sprite> sp_list = new List<Sprite>();
            string[] pathArr = atlasInfo.texturePaths.ToArray();
            for (int j = 0; j < pathArr.Length; ++j)
            {
                string tPath = pathArr[j];
                Sprite sp = AssetDatabase.LoadAssetAtPath<Sprite>(GetAssetsPath(tPath));
                if (sp != null)
                {
                    int width = sp.texture.width;
                    int height = sp.texture.height;
                    if (width <= 1024 & height <= 1024)
                    {
                        sp_list.Add(sp);
                    }
                    else
                    {
                        Debug.LogError("图片过大请检查图片:"+tPath);
                    }
                }
            }
            if (sp_list.Count > 0)
            {
                atlas.Add(sp_list.ToArray());
                if (isNewAtlas)
                {
                    if (!Directory.Exists(atlasPath))
                    {
                        Directory.CreateDirectory(atlasPath);
                    }
                    AssetDatabase.CreateAsset(atlas, atlasPath);
                }
                AssetDatabase.SaveAssets();
                createAtlasCount++;
            }
        }
    }

    static void AtlasDeleteByFloder(string path)
    {
        DirectoryInfo dir = new DirectoryInfo(path);
        DirectoryInfo[] dirs = dir.GetDirectories();
        for (int i = 0; i < dirs.Length; ++i)
        {
            AtlasDeleteByFloder(dirs[i].FullName);
        }

        FileInfo[] files = dir.GetFiles(fileSearchPattern, SearchOption.TopDirectoryOnly);
        for (int i = 0; i < files.Length; ++i)
        {
            FileInfo f = files[i];
            string atlasName = GetAtlasName(dir.Name);
            if (f.FullName.EndsWith(atlasName))
            {
                File.Delete(f.FullName);
                File.Delete(f.FullName+".meta");
                deleteAtlasCount++;
            }
        }
    }

    /// <summary>
    /// 格式化选择文件夹得所有图集
    /// </summary>
    /// <param name="path"></param>
    static void AtlasSetByFloder(string path)
    {
        DirectoryInfo dir = new DirectoryInfo(path);
        DirectoryInfo[] dirs = dir.GetDirectories();
        for (int i = 0; i < dirs.Length; ++i)
        {
            AtlasSetByFloder(dirs[i].FullName);
        }

        FileInfo[] files = dir.GetFiles(fileSearchPattern, SearchOption.TopDirectoryOnly);
        for (int i = 0; i < files.Length; ++i)
        {
            FileInfo f = files[i];
            string atlasName = GetAtlasName(dir.Name);
            if (f.FullName.EndsWith(atlasName))
            {
                SpriteAtlas atlas = AssetDatabase.LoadAssetAtPath<SpriteAtlas>(GetAssetsPath(f.FullName));
                atlas.SetIncludeInBuild(true);
                atlas.SetPackingSettings(packSet);
                atlas.SetTextureSettings(textureSet);
                atlas.SetPlatformSettings(defaultPlatformSet);
                atlas.SetPlatformSettings(standalonePlatformSet);
                atlas.SetPlatformSettings(iPhonePlatformSet);
                atlas.SetPlatformSettings(androidPlatformSet);
                AssetDatabase.SaveAssets();
            }
        }
        Debug.Log("格式化图集完成！");
    }
}

