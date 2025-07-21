using UnityEngine;
using UnityEngine.UI;
using System.Collections.Generic;
using TMPro;
using UnityEditor;

[AddComponentMenu("UI/ButtonMultiTarget", 30)]
public class ButtonMultiTarget : Button
{
    [SerializeField]
    private List<Graphic> m_TargetGraphics = new List<Graphic>();
    [SerializeField]
    private List<Text> m_TargetTxts = new List<Text>();
    [SerializeField]
    private List<TextMeshProUGUI> m_TargetTxtPros = new List<TextMeshProUGUI>();

    [SerializeField] private Material m_GrayMaterial;
    [SerializeField] private Color m_GrayTextColor = new Color(0.52f,0.52f,0.52f);
    
    public List<Graphic> TargetGraphics
    {
        get { return m_TargetGraphics; }
        set { m_TargetGraphics = value; }
    }
    
    public List<Text> TargetTxts
    {
        get { return m_TargetTxts; }
        set { m_TargetTxts = value; }
    }
    
    public List<TextMeshProUGUI> TargetTxtPros
    {
        get { return m_TargetTxtPros; }
        set { m_TargetTxtPros = value; }
    }

    public Material GrayMaterial
    {
        get { return m_GrayMaterial; }
        set { m_GrayMaterial = value; }
    }

    public Color GrayTextColor
    {
        get { return m_GrayTextColor; }
        set { m_GrayTextColor = value; }
    }
    
    protected override void DoStateTransition(SelectionState state, bool instant)
    {
        Color tintColor;
        switch (state)
        {
            case SelectionState.Normal:
                tintColor = colors.normalColor;
                break;
            case SelectionState.Highlighted:
                tintColor = colors.highlightedColor;
                break;
            case SelectionState.Pressed:
                tintColor = colors.pressedColor;
                break;
            case SelectionState.Selected:
                tintColor = colors.selectedColor;
                break;
            case SelectionState.Disabled:
                tintColor = colors.disabledColor;
                ShowGray(true);
                return;
            default:
                tintColor = Color.black;
                break;
        }
        ShowGray(false);
        // 让每个 target graphic 都变色
        foreach (var graphic in m_TargetGraphics)
        {
            if (graphic == null) continue;
            graphic.CrossFadeColor(tintColor * colors.colorMultiplier, instant ? 0f : colors.fadeDuration, true, true);
        }
        foreach (var graphic in m_TargetTxts)
        {
            if (graphic == null) continue;
            graphic.CrossFadeColor(tintColor * colors.colorMultiplier, instant ? 0f : colors.fadeDuration, true, true);
        }
        foreach (var graphic in m_TargetTxtPros)
        {
            if (graphic == null) continue;
            graphic.CrossFadeColor(tintColor * colors.colorMultiplier, instant ? 0f : colors.fadeDuration, true, true);
        }
    }

    private void ShowGray(bool show)
    {
        foreach (var graphic in m_TargetGraphics)
        {
            if (graphic == null) continue;
            graphic.material = show?m_GrayMaterial:null;
        }
        foreach (var graphic in m_TargetTxts)
        {
            if (graphic == null) continue;
            if (graphic.fontSize == 0)
            {
                graphic.material = show?m_GrayMaterial:null;
            }
            else
            {
                graphic.color = show?m_GrayTextColor:Color.white;
            }
            
        }
        foreach (var graphic in m_TargetTxtPros)
        {
            if (graphic == null) continue;
            graphic.color = show?m_GrayTextColor:Color.white;
        }
    }
}

#if UNITY_EDITOR
[CustomEditor(typeof(ButtonMultiTarget))]
public class ButtonMultiTargetEditor : UnityEditor.UI.ButtonEditor
{
    public override void OnInspectorGUI()
    {
        base.OnInspectorGUI();

        var multiTargetButton = (ButtonMultiTarget)target;
        var serializedObject = new SerializedObject(multiTargetButton);
        var targetGraphics = serializedObject.FindProperty("m_TargetGraphics");
        var targetTxts = serializedObject.FindProperty("m_TargetTxts");
        var targetTxtPros = serializedObject.FindProperty("m_TargetTxtPros");
        var grayMaterial = serializedObject.FindProperty("m_GrayMaterial");
        var grayTextColor = serializedObject.FindProperty("m_GrayTextColor");
        EditorGUILayout.PropertyField(targetGraphics, true);
        EditorGUILayout.PropertyField(targetTxts, true);
        EditorGUILayout.PropertyField(targetTxtPros, true);
        EditorGUILayout.PropertyField(grayMaterial, true);
        EditorGUILayout.PropertyField(grayTextColor, true);
        serializedObject.ApplyModifiedProperties();
        if (multiTargetButton.GrayMaterial == null)
        {
            string materialPath  = "Assets/AssetsPackage/Common/Material/UIImageGray.mat";
            multiTargetButton.GrayMaterial = AssetDatabase.LoadAssetAtPath<Material>(materialPath);
        }
    }
}
#endif