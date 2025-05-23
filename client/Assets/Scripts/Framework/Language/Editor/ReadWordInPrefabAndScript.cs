using System;
using System.Collections.Generic;
using System.IO;
using System.Text;
using System.Text.RegularExpressions;
using Language;
using Newtonsoft.Json;
using UnityEditor;
using UnityEngine;
using UnityEngine.UI;

namespace Language.Editor
{
    public class ReadWordInPrefabAndScript : UnityEditor.Editor {
        //UIPrefab文件夹目录
        private static readonly string UIPrefabPath = Application.dataPath + "/UI";
        //脚本的文件夹目录
        private static readonly string ScriptPath = Application.dataPath + "/Scripts";
        //导出的中文KEY路径
        private static readonly string OutPath = Application.dataPath + "/out.txt";

        private static List<string> Localization = null;
        private static string staticWriteText = "";

        [MenuItem ("Tools/清除管理类实例")]
        private static void Clear () {
            LanguageManager.Instance.Clear ();
        }

        // [MenuItem ("Tools/导出预制体和脚本中文字")]
        // private static void ExportChinese () {
        //     Localization = new List<string> ();
        //     staticWriteText = "";
        //
        //     //提取Prefab上的中文
        //     staticWriteText += "----------------Prefab----------------------\n";
        //     LoadDirectoryPrefab (new DirectoryInfo (UIPrefabPath));
        //
        //     //提取CS中的中文
        //     staticWriteText += "----------------Script----------------------\n";
        //     LoadDirectoryCS (new DirectoryInfo (ScriptPath));
        //
        //     //最终把提取的中文生成出来
        //     var textPath = OutPath;
        //     if (System.IO.File.Exists (textPath)) {
        //         File.Delete (textPath);
        //     }
        //     using (var writer = new StreamWriter (textPath, false, Encoding.UTF8)) {
        //         writer.Write (staticWriteText);
        //     }
        //     AssetDatabase.Refresh ();
        // }

        //递归所有UI Prefab
        public static void LoadDirectoryPrefab (DirectoryInfo directoryInfo) {
            if (!directoryInfo.Exists) return;
            var fileInfos = directoryInfo.GetFiles ("*.prefab", SearchOption.AllDirectories);
            foreach (var files in fileInfos) {
                var path = files.FullName;
                var assetPath = path.Substring (path.IndexOf (@"Assets\", StringComparison.Ordinal));
                var prefab = AssetDatabase.LoadAssetAtPath (assetPath, typeof (GameObject)) as GameObject;
                var instance = GameObject.Instantiate (prefab) as GameObject;
                SearchPrefabString (instance.transform);
                GameObject.DestroyImmediate (instance);
            }
        }

        //递归所有C#代码
        public static void LoadDirectoryCS (DirectoryInfo directoryInfo) {

            if (!directoryInfo.Exists) return;
            var fileInfos = directoryInfo.GetFiles ("*.cs", SearchOption.AllDirectories);
            foreach (var files in fileInfos) {
                var path = files.FullName;
                var assetPath = path.Substring (path.IndexOf (@"Assets\", StringComparison.Ordinal));
                var textAsset = AssetDatabase.LoadAssetAtPath (assetPath, typeof (TextAsset)) as TextAsset;
                var text = textAsset.text;
                //用正则表达式把代码里面两种字符串中间的字符串提取出来。
                var reg = new Regex ("(?<=text\\s*=[\\s\\S]*\"\\s*)[\\s\\S]*(?=\\s*\")"); //(?<=text\\s*=\\s*\"\\s*)[\\s\\S]*?(?=\\s*\")
                //<.*?>
                //(?<=StrUtil.GetText\s*\(\s*)
                var mc = reg.Matches (text);
                foreach (Match m in mc) {
                    var format = m.Value;
                    if (Localization.Contains(format) || string.IsNullOrEmpty(format)) continue;
                    Localization.Add (format);
                    staticWriteText += format + "\n";
                }
            }
        }

        //提取Prefab上的中文
        public static void SearchPrefabString (Transform root) {
            foreach (Transform child in root) {
                var label = child.GetComponent<Text> ();
                if (label != null) {
                    var text = label.text;
                    if (!Localization.Contains (text) && !string.IsNullOrEmpty (text)) {
                        Localization.Add (text);
                        text = text.Replace ("\n", @"\n");
                        staticWriteText += text + "\n";
                    }
                }
                if (child.childCount > 0)
                    SearchPrefabString (child);
            }
        }

        /// ///////////////////////////////////////////////////////////////////////////////////////////
        private static Dictionary<string, LanguageData> languagesData;
        // [MenuItem ("多语言/键值导出")]
        // private static void ExportKey () {
            // languagesData = new Dictionary<string, LanguageData>();
            // staticWriteText = "";
            //
            // //提取Prefab上的中文
            // var directoryInfo = new DirectoryInfo (Application.dataPath);
            // var fileInfos = directoryInfo.GetFiles ("*.prefab", SearchOption.AllDirectories);
            // foreach (var files in fileInfos) {
            //     var path = files.FullName;
            //     var assetPath = path.Substring (path.IndexOf (@"Assets\", StringComparison.Ordinal));
            //     var prefab = AssetDatabase.LoadAssetAtPath (assetPath, typeof (GameObject)) as GameObject;
            //     var instance = GameObject.Instantiate (prefab) as GameObject;
            //     SearchPrefabKey (instance.transform);
            //     GameObject.DestroyImmediate (instance);
            // }
            //
            //
            // //最终把提取的中文生成出来
            // var textPath = Application.dataPath + "/out.json";
            // if (System.IO.File.Exists (textPath)) {
            //     File.Delete (textPath);
            // }
            // using (var writer = new StreamWriter (textPath, false, Encoding.UTF8)) {
            //     writer.Write (JsonConvert.SerializeObject(languagesData));
            // }
            // AssetDatabase.Refresh ();
        // }
        public static void SearchPrefabKey (Transform root) {
            // foreach (Transform child in root) {
            //     var language = child.GetComponent<LanguageBase> ();
            //     if (language != null) {
            //         if (!string.IsNullOrEmpty (language.key) && !languagesData.ContainsKey (language.key)) {
            //             var data = new LanguageData {value = language.value};
            //             languagesData.Add (language.key, data);
            //         }
            //     }
            //     if (child.childCount > 0)
            //         SearchPrefabKey (child);
            // }
        }
    }
}