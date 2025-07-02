using UnityEngine;
using UnityEditor;
using System.Collections.Generic;

public class FindMissingScriptsRecursively : EditorWindow
{
    [MenuItem("Window/Find Missing Scripts (All)")]
    public static void ShowWindow()
    {
        GetWindow<FindMissingScriptsRecursively>("Find Missing Scripts");
    }

    private void OnGUI()
    {
        if (GUILayout.Button("Find Missing Scripts"))
        {
            FindMissingScripts();
        }
    }

    private static void FindMissingScripts()
    {
        foreach (var go in SceneRoots())
        {
            FindInGO(go);
        }
    }

    private static void FindInGO(GameObject go)
    {
        if (go == null) return;

        Component[] components = go.GetComponents<Component>();
        foreach (Component component in components)
        {
            if (component == null)
            {
                Debug.LogWarning("Missing script on GameObject: " + GetGameObjectPath(go), go);
            }
        }

        foreach (Transform childT in go.transform)
        {
            FindInGO(childT.gameObject);
        }
    }

    private static string GetGameObjectPath(GameObject go)
    {
        var result = new System.Text.StringBuilder(go.name);
        while (go.transform.parent != null)
        {
            go = go.transform.parent.gameObject;
            result.Insert(0, go.name + "/");
        }
        return result.ToString();
    }

    static IEnumerable<GameObject> SceneRoots()
    {
        var prop = new HierarchyProperty(HierarchyType.GameObjects);
        var expanded = new int[0];
        while (prop.Next(expanded))
        {
            yield return prop.pptrValue as GameObject;
        }
    }
}