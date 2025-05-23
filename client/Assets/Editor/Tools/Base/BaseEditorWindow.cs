using System.Collections;
using System.Collections.Generic;
using UnityEngine;
using UnityEditor;

public class BaseEditorWindow : EditorWindow
{
    private GUIStyle textField;
    public GUIStyle TextField
    {
        get
        {
            if (textField == null)
            {
                textField = new GUIStyle(GUI.skin.textField);
            }
            return textField;
        }
    }

    //复制和粘贴
    private string HandleCopyPaste(int controlID)
    {
        if (controlID == GUIUtility.keyboardControl)
        {
            if (Event.current.type == UnityEngine.EventType.KeyUp && (Event.current.modifiers == EventModifiers.Control || Event.current.modifiers == EventModifiers.Command))
            {
                if (Event.current.keyCode == KeyCode.C)
                {
                    Event.current.Use();
                    TextEditor editor = (TextEditor)GUIUtility.GetStateObject(typeof(TextEditor), GUIUtility.keyboardControl);
                    editor.Copy();
                }
                else if (Event.current.keyCode == KeyCode.V)
                {
                    Event.current.Use();
                    TextEditor editor = (TextEditor)GUIUtility.GetStateObject(typeof(TextEditor), GUIUtility.keyboardControl);
                    editor.Paste();
#if UNITY_5_3_OR_NEWER || UNITY_5_3
                    return editor.text; //以及更高的unity版本中editor.content.text已经被废弃，需使用editor.text代替
#else
                    return editor.content.text;
#endif
                }
                else if (Event.current.keyCode == KeyCode.A)
                {
                    Event.current.Use();
                    TextEditor editor = (TextEditor)GUIUtility.GetStateObject(typeof(TextEditor), GUIUtility.keyboardControl);
                    editor.SelectAll();
                }
            }
        }
        return null;
    }

    private void Label(string v, int width, int height)
    {
        if (height != 0)
            GUILayout.Label(v, GUILayout.Width(width), GUILayout.Height(height));
        else
            GUILayout.Label(v, GUILayout.Width(width));
    }

    private float DrawFloat_t(string name, float value, int width, int height)
    {
        float f = EditorGUILayout.FloatField(name, value, TextField);
        return f;
    }

    public virtual float DrawFloat(string name, float value, int width = 75, int height = 0)
    {
        int textFieldID = GUIUtility.GetControlID("FloatField".GetHashCode(), FocusType.Keyboard) + 1;
        if (textFieldID == 0)
        {
            return DrawFloat_t(name, value, width, height);
        }
        string str = HandleCopyPaste(textFieldID);
        if (str != null)
            float.TryParse(str, out value);
        return DrawFloat_t(name, value, width, height);
    }

    private int DrawInt_t(string name, int value, int width, int height)
    {
        int v = EditorGUILayout.IntField(name, value);
        return v;
    }

    public virtual int DrawInt(string name, int value, int width = 75, int height = 0)
    {
        int textFieldID = GUIUtility.GetControlID("IntField".GetHashCode(), FocusType.Keyboard) + 1;
        if (textFieldID == 0)
        {
            return DrawInt_t(name, value, width, height);
        }
        string str = HandleCopyPaste(textFieldID);
        if (str != null)
            int.TryParse(str, out value);
        return DrawInt_t(name, value, width, height);

    }

    private string DrawTextField_t(string name, string value, int width, int height, params GUILayoutOption[] options)
    {
        GUILayout.BeginHorizontal();
        Label(name, width, height);
        string str = GUILayout.TextField(value, options);
        GUILayout.EndHorizontal();
        return str;
    }

    public virtual string DrawTextField(string name, string value, int width = 75, int height = 0, params GUILayoutOption[] options)
    {
        int textFieldID = GUIUtility.GetControlID("TextField".GetHashCode(), FocusType.Keyboard) + 1;
        if (textFieldID == 0)
        {
            return DrawTextField_t(name, value, width, height, options);
        }
        //处理复制粘贴的操作
        value = HandleCopyPaste(textFieldID) ?? value;
        return DrawTextField_t(name, value, width, height, options);
    }

    public virtual T ObjField<T>(string name, T t, int width = 75, int height = 15) where T : Object
    {
        GUILayout.BeginHorizontal();
        Label(name, width, height);
        t = (T)EditorGUILayout.ObjectField(t, typeof(T), true, GUILayout.Height(height));
        GUILayout.EndHorizontal();

        return t;

    }

    public virtual bool DrawToggle(string name, bool b, int width = 75, int height = 0)
    {
        GUILayout.BeginHorizontal();
        Label(name, width, height);
        b = EditorGUILayout.Toggle(b);
        GUILayout.EndHorizontal();
        return b;
    }

    public class SelfGUIStyle
    {
        public GUIStyle line;
        public GUIStyle item;
        public GUIStyle delItem;
        public GUIStyle newItem;
        public GUIStyle label;
        public GUIStyle delButton;

        public Texture2D blackTex;
        public Texture2D grayTex;
        public Texture2D radTex;
        public Texture2D greenTex;

        public SelfGUIStyle()
        {
            blackTex = CreateTexture(new Color(0.12f, 0.12f, 0.12f, 1));
            grayTex = CreateTexture(new Color(0.3f, 0.3f, 0.3f, 1));
            radTex = CreateTexture(new Color(0.6f, 0.3f, 0.3f, 1));
            greenTex= CreateTexture(new Color(0.3f, 0.5f, 0.4f, 1));

            line = new GUIStyle();
            line.normal = new GUIStyleState { background = blackTex };

            item = new GUIStyle();
            item.alignment = TextAnchor.MiddleLeft;
            item.normal = new GUIStyleState { background = grayTex };

            delItem = new GUIStyle();
            delItem.alignment = TextAnchor.MiddleLeft;
            delItem.normal = new GUIStyleState { background = radTex };

            newItem = new GUIStyle();
            newItem.alignment = TextAnchor.MiddleLeft;
            newItem.normal = new GUIStyleState { background = greenTex };

            label = new GUIStyle();
            label.normal = new GUIStyleState { textColor = Color.white };

            delButton = new GUIStyle();
            delButton.normal = new GUIStyleState { textColor = Color.red };

        }

        private Texture2D CreateTexture(Color color)
        {
            Texture2D t2d = new Texture2D(1, 1);
            t2d.SetPixel(0, 0, color);
            t2d.Apply();
            return t2d;
        }
    }
}
