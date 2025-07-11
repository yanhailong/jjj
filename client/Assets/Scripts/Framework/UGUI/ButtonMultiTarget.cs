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
                break;
            default:
                tintColor = Color.black;
                break;
        }

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
}

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
        EditorGUILayout.PropertyField(targetGraphics, true);
        EditorGUILayout.PropertyField(targetTxts, true);
        EditorGUILayout.PropertyField(targetTxtPros, true);
        serializedObject.ApplyModifiedProperties();
    }
}