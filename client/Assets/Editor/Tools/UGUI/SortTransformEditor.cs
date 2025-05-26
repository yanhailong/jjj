using System.Collections;
using System.Collections.Generic;
using UnityEditor;
using UnityEngine;

public class SortTransform : BaseEditorWindow
{
    [MenuItem("Tools/SetTransform")]
    static void Get()
    {
        Rect wr = new Rect(0, 0, 300, 200);
        SortTransform window = (SortTransform)GetWindowWithRect(typeof(SortTransform), wr, true, "SortTransform");
        window.Show();
        window.Init();
    }

    float x, tx = 0;
    float y, ty = 0;
    int lineCount = 1;
    string rename = "";
    private Transform rootTrans, tempRoot;
    private List<Transform> list;

    public void Init()
    {
        rootTrans = Selection.activeTransform;
        if (rootTrans == null)
        {
            Debug.LogError("没有选择对象");
            Close();
            return;
        }
        list = new List<Transform>();
    }

    private void SetSortList()
    {
        list.Clear();
        Transform[] ts = rootTrans.GetComponentsInChildren<Transform>();
        foreach (var v in ts)
        {
            if (v == rootTrans)
                continue;
            if (v.parent == rootTrans)
                list.Add(v);
        }
        if (list.Count <= 1)
            return;

        Vector3 dtPos = list[1].localPosition - list[0].localPosition;
        x = dtPos.x;
        y = dtPos.y;

        tx = x;
        ty = y;

        lineCount = list.Count;
    }

    private Vector3 startPos;
    private void OnGUI()
    {
        if (rootTrans == null)
            return;
        rootTrans = ObjField("root", rootTrans);
        if (rootTrans != tempRoot)
        {
            tempRoot = rootTrans;
            SetSortList();
        }
        if (list.Count == 0)
        {
            GUILayout.Label("Root下根节点数量为0");
            return;
        }
        x = DrawFloat("x:", x);
        y = DrawFloat("y:", y);
        lineCount = DrawInt("count:", lineCount);
        GUILayout.BeginHorizontal();
        rename = DrawTextField("rename", rename);
        if (GUILayout.Button("rename"))
        {
            Rename();
        }
        GUILayout.EndHorizontal();

        if (x != tx || y != ty)
        {
            tx = x;
            ty = y;

            startPos = list[0].localPosition;
            int count = lineCount == 0 ? 1 : lineCount;
            for (int i = 1; i < list.Count; i++)
            {
                int dy = i / count;
                float yy = dy * y;
                float xx = (i % count) * x;

                Vector3 offectPos = startPos + new Vector3(xx, yy, startPos.z);
                list[i].localPosition = offectPos;
            }
        }
    }

    private void Rename()
    {
        for (int i = 0; i < list.Count; i++)
        {
            var t = list[i];
            t.gameObject.name = rename + (i + 1);
        }
    }
}