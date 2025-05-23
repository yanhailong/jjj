
using UnityEngine;
using UnityEngine.UI;
using UnityEditor;
using System.IO;

public class CopyPath : MonoBehaviour
{
    [MenuItem("Assets/Alt + C 拷贝路径 &c", false, 10)]
    public static void do_copy_path()
    {
        var go = Selection.activeObject;
        if (!AssetDatabase.IsNativeAsset(go)&&go as GameObject)
        {
            CopyUIComponentPath();
            return;
        }

        var path = AssetDatabase.GetAssetPath(go);
        var go2 = Selection.activeGameObject;
        if (go2 && go2.transform.parent != null)
        {
            var tf = go2.transform;
            path = tf.name;
            while (tf.parent != null)
            {
                tf = tf.parent;
                if (tf.GetComponent<Canvas>() != null && tf.GetComponent<CanvasScaler>() != null)
                {
                    break;
                }
                path = tf.name + "/" + path;
            }
        }

        FileInfo fi = new FileInfo(path);
        DirectoryInfo dir = fi.Directory;
        string newPath = string.Empty;
        while (true)
        {
            if (dir.Name == "Lua"||dir.Name== "AssetsPackage"||dir.Name=="Assets")
                break;
            newPath = dir.Name + "/" + newPath;
            dir = dir.Parent;
            if (dir == null) break;
        }
        if (newPath.EndsWith("/"))
            newPath = newPath.Substring(0, newPath.Length - 1);
        newPath = newPath + "/" + Path.GetFileNameWithoutExtension(path);
        Debug.Log(newPath);
        EditorGUIUtility.systemCopyBuffer = newPath;
    }

    static void CopyUIComponentPath()
    {
        var t = Selection.activeTransform;
        Transform parent = t.parent;
        string path = t.name;
        while (parent)
        {
            if (parent.parent == null || parent.parent.parent == null)
                break;
            if (parent.parent.name.StartsWith("Layer"))
                break;
            path = parent.name + "/" + path;
            parent = parent.parent;
        }
        EditorGUIUtility.systemCopyBuffer = path;
    }
}

