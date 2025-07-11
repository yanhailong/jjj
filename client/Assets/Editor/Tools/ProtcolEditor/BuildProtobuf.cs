using System;
using UnityEditor;
using UnityEngine;
using System.IO;
using System.Text;
using System.Collections.Generic;
using System.Diagnostics;

using Debug = UnityEngine.Debug;

public class BuildProtobuf : EditorWindow
{

    static List<string> paths = new List<string>();
    static List<string> files = new List<string>();
    
    /// <summary>
    /// 遍历目录及其子目录
    /// </summary>
    static void Recursive(string path, bool isGen = false)
    {
        string[] names = Directory.GetFiles(path);
        string[] dirs = Directory.GetDirectories(path);
        foreach (string filename in names)
        {
            string ext = Path.GetExtension(filename);
            if (isGen)
            {
                if (ext.EndsWith(".meta")) continue;
            }
            else
            {
                if (ext.EndsWith(".meta") || (ext.EndsWith(".proto")) || ext.Contains(".manifest")) continue;
            }
            files.Add(filename.Replace('\\', '/'));
        }
        foreach (string dir in dirs)
        {
            paths.Add(dir.Replace('\\', '/'));
            Recursive(dir, isGen);
        }
    }

    private const string luaRoot = "./Assets/AssetsPackage/";
    private const string protolRoot = "./Assets/_Protol/";
    [MenuItem("Assets/生成pb对应的消息ID文件", false, 1)]
    static void BuildProtobufDir()
    {
        var obj = Selection.activeObject;
        if (obj == null) return;
        string dir = Path.GetFullPath(AssetDatabase.GetAssetPath(obj));
        if (!Directory.Exists(dir))
            return;
        string[] fs = Directory.GetFiles(dir, "*.proto", SearchOption.AllDirectories);
        files.Clear();
        files.AddRange(fs);
        GetAllSubDir(dir);
        


        float count = files.Count - 1;
        int index = 0;

        StringBuilder sb = new StringBuilder();
        foreach (string f in files)
        {
            index++;
            string name = Path.GetFileName(f);
            string ext = Path.GetExtension(f);
            if (!ext.Equals(".proto")) continue;
            FileInfo fi = new FileInfo(f);
            EditorUtility.DisplayProgressBar("Building .... ", name, index / count);
        }
        EditorUtility.ClearProgressBar();
        string s = sb.ToString();
        if (s != "")
        {
            UnityEngine.Debug.LogError(s);
            EditorUtility.DisplayDialog("警告", "可能有生成失败，请查看日志", "OK");
        }
        else
        {
            EditorUtility.DisplayDialog("提示", "成功生成所有的protobuf文件", "OK");
        }
        CopyToDir(dir);
        AssetDatabase.Refresh();
    }

    /// <summary>
    /// 获取所以的子目录
    /// </summary>
    /// <param name="dir"></param>
    private static void GetAllSubDir(string dir)
    {
        List<string> allSubDirectories = new List<string>();
        FindBottomLevelFolders(dir, allSubDirectories);
        
        for (int i = 0; i < allSubDirectories.Count; i++)
        {
            // Debug.LogError("allSubDirectories:"+allSubDirectories[i]);
            MessageIdMapEditor.Create(allSubDirectories[i]);
        }
    }
    
    
    static void FindBottomLevelFolders(string path, List<string> resultList)
    {
        try
        {
            string[] subDirectories = Directory.GetDirectories(path);
            if (subDirectories.Length == 0)
            {
                // 当前文件夹没有子文件夹，是最底层
                resultList.Add(path);
            }
            else
            {
                // 递归检查每个子文件夹
                foreach (string dir in subDirectories)
                {
                    FindBottomLevelFolders(dir, resultList);
                }
            }
        }catch (Exception e)
        {
            Debug.LogError(e.Message);
        }
    }
    //拷贝lua文件
    private static void CopyToDir(string dir)
    {
        string[] luaFiles = Directory.GetFiles(dir, "*.proto", SearchOption.AllDirectories);
        string protolRootDir = Path.GetFullPath(protolRoot);
        string luaGenCode = "require \"#path\"";
        Dictionary<string, List<string>> map_luaCode = new Dictionary<string, List<string>>();

        foreach (var v in luaFiles)
        {
            FileInfo fi = new FileInfo(v);
            string pt = fi.Directory.FullName.Replace(protolRootDir, "");
            string pbDir = luaRoot + pt + "/Protol/";
            if (Directory.Exists(pbDir))
                Directory.Delete(pbDir, true);
            Directory.CreateDirectory(pbDir);
        }
        
        foreach (var v in luaFiles)
        {
            FileInfo fi = new FileInfo(v);
            string pt = fi.Directory.FullName.Replace(protolRootDir, "");
            string pbDir = luaRoot + pt + "/Protol/";

            string newPath = pbDir + fi.Name+".bytes";
            
            if (File.Exists(newPath))
                File.Delete(newPath);
            File.Copy(v, newPath);

            string code = luaGenCode.Replace("#path", pt + "/Protol/" + Path.GetFileNameWithoutExtension(fi.Name));
            List<string> list_code = null;
            if (map_luaCode.ContainsKey(pbDir))
                list_code = map_luaCode[pbDir];
            else
            {
                list_code = new List<string>();
                map_luaCode.Add(pbDir, list_code);
            }
            code = code.Replace(@"\", "/");
            list_code.Add(code);
        }
        //
        // foreach (var v in map_luaCode)
        // {
        //     File.WriteAllLines(v.Key + "ProtolHead.lua", v.Value.ToArray());
        // }
    }
}
