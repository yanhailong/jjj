
using System.Collections;
using System.Collections.Generic;
using UnityEngine;
using UnityEditor;
using UnityEditor.SceneManagement;
using UnityEngine.UI;

public class changeFont : EditorWindow
{
    [MenuItem("Tools/美术专用:更换字体")]
    public static void changefont()
    {
        changeFont.Open();
    }

    UPDATE_TYPE updateType = UPDATE_TYPE.填充遗漏字库;
    public enum UPDATE_TYPE
    {
        填充遗漏字库 = 0,
        更换所有字库 = 1,
        替换某一字库 = 2,
    }
    public static void Open()
    {
        EditorWindow.GetWindow(typeof(changeFont));
    }

    Font getFont;
    Font setFont;

    Font toChange;
    static Font toChangeFont;
    FontStyle toFontStyle;
    static FontStyle toChangeFontStyle;

    void OnGUI()
    {
        updateType = (UPDATE_TYPE)EditorGUILayout.EnumPopup(updateType);

        if (UPDATE_TYPE.替换某一字库 == updateType)
        {
            EditorGUILayout.Space();
            EditorGUILayout.BeginHorizontal();
            EditorGUILayout.LabelField("替换前字体", GUILayout.MinWidth(56f));
            getFont = (Font)EditorGUILayout.ObjectField(getFont, typeof(Font), true, GUILayout.MaxWidth(600f));
            EditorGUILayout.EndHorizontal();

            EditorGUILayout.BeginHorizontal();
            EditorGUILayout.LabelField("替换后字体", GUILayout.MinWidth(56f));
            setFont = (Font)EditorGUILayout.ObjectField(setFont, typeof(Font), true, GUILayout.MaxWidth(600f));
            EditorGUILayout.EndHorizontal();
            EditorGUILayout.Space();

            if (GUILayout.Button("替换"))
            {
                ChangeAllPrefab();
            }
        }
        else
        {
            toChange = (Font)EditorGUILayout.ObjectField(toChange, typeof(Font), true, GUILayout.MinWidth(100f));
            string path = AssetDatabase.GetAssetPath(toChange);
            toChangeFont = toChange;
            toFontStyle = (FontStyle)EditorGUILayout.EnumPopup(toFontStyle, GUILayout.MinWidth(100f));
            toChangeFontStyle = toFontStyle;
            if (GUILayout.Button("更换"))
            {
                ChangeAllPrefab();
            }
        }
    }
    void ChangeAllPrefab()
    {
        Debug.LogError("getFont--:" + getFont.name + "_______" + "setFont - " + setFont.name);
        var allAssets = AssetDatabase.GetAllAssetPaths();
        Object obj;
        GameObject go;
        int i = 0;
        foreach (var assetPath in allAssets)
        {
            i++;
            UpdateProgress(i, allAssets.Length, assetPath);
            if (assetPath.LastIndexOf(".prefab") < 0) continue;

            obj = AssetDatabase.LoadMainAssetAtPath(assetPath);
            go = obj as GameObject;
            if (go != null)
            {
                Change(go);
            }
        }
        EditorUtility.ClearProgressBar();
        EditorUtility.DisplayDialog("提示", "完成", "确定");
    }
    public void Change(GameObject go)
    {
        Transform[] tArray = go.GetComponentsInChildren<Transform>(true);
        for (int i = 0; i < tArray.Length; i++)
        {
            Text t = tArray[i].GetComponent<Text>();
            if (t)
            {
                bool isChange = false;
                //这个很重要，博主发现如果没有这个代码，unity是不会察觉到编辑器有改动的，自然设置完后直接切换场景改变是不被保存
                //的  如果不加这个代码  在做完更改后 自己随便手动修改下场景里物体的状态 在保存就好了 
                if (updateType == UPDATE_TYPE.填充遗漏字库)
                {
                    if (t.font == null)
                    {
                        Undo.RecordObject(t, t.gameObject.name);
                        t.font = toChangeFont;
                        isChange = true;
                    }
                }
                else if (UPDATE_TYPE.替换某一字库 == updateType)
                {
                    if (null == t.font)
                    {
                        continue;
                    }
                    else
                    {
                        if (t.font.name == getFont.name)
                        {
                            Undo.RecordObject(t, t.gameObject.name);
                            t.font = setFont;
                            isChange = true;
                        }
                    }
                }
                else
                {
                    Undo.RecordObject(t, t.gameObject.name);
                    t.font = toChangeFont;
                    isChange = true;
                }
                if (isChange)
                {
                    //相当于让他刷新下 不然unity显示界面还不知道自己的东西被换掉了  还会呆呆的显示之前的东西
                    EditorUtility.SetDirty(t);
                }
            }

            TextMesh textmesh = tArray[i].GetComponent<TextMesh>();
            if (textmesh)
            {
                Debug.Log(go.name);
                bool isChange = false;
                if (updateType == UPDATE_TYPE.填充遗漏字库)
                {

                    if (textmesh.font == null || textmesh.font.name == "Arial")
                    {
                        Undo.RecordObject(textmesh, textmesh.gameObject.name);
                        textmesh.font = toChangeFont;
                        isChange = true;
                    }
                }
                else if (UPDATE_TYPE.替换某一字库 == updateType)
                {
                    if (null == textmesh.font)
                    {
                        continue;
                    }
                    else
                    {
                        if (textmesh.font.name == getFont.name)
                        {
                            Undo.RecordObject(textmesh, textmesh.gameObject.name);
                            textmesh.font = setFont;
                            isChange = true;
                        }
                    }
                }
                else
                {
                    Undo.RecordObject(textmesh, textmesh.gameObject.name);
                    textmesh.font = toChangeFont;
                    isChange = true;
                }

                if (isChange)
                {
                    //相当于让他刷新下 不然unity显示界面还不知道自己的东西被换掉了  还会呆呆的显示之前的东西
                    EditorUtility.SetDirty(textmesh);
                }
            }
        }

    }
    void UpdateProgress(int progress, int progressMax, string desc)
    {
        string title = "Processing...[" + progress + " - " + progressMax + "]";
        float value = (float)progress / (float)progressMax;
        EditorUtility.DisplayProgressBar(title, desc, value);
    }
}

