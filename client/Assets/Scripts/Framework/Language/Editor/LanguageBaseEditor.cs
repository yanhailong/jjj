using System;
using UnityEditor;
using UnityEngine;

namespace Language.Editor {
    public class LanguageBaseEditor<T> : UnityEditor.Editor where T : LanguageBase
    {
        private T _self;
        private bool? _isRefresh = null;
        private readonly string[] _conditions = { "None", "OnlySet", "OnlyListener", "SetAndListener" };

        public override void OnInspectorGUI()
        {
            base.OnInspectorGUI();

            _self = target as T;

            if (!_self || Application.isPlaying)
                return;

            var manager = LanguageManager.Instance; //实例化语言管理对象
            
            _self.condition = EditorGUILayout.Popup("Condition", _self.condition, _conditions);

            var languages = manager.GetLanguagesName().ToArray(); //得到所支持的语言名字
            var languageIdx = Array.IndexOf(languages, manager.Language); //得到被选中语言在集合中的下标
            var language = EditorGUILayout.Popup("Language", languageIdx, languages);
            if (language != languageIdx)
            {
                _isRefresh = true;
                manager.Language = languages[language];
            }

            var sKey = EditorGUILayout.TextField("Keys", _self.key);
            if (string.IsNullOrEmpty(sKey))
            {
                sKey = LanguageManager.GetTransPath(_self.transform);
            }

            if (sKey != _self.key)
            {
                _isRefresh = true;
                _self.key = sKey;
            }

            if (GUI.changed)
            {
                EditorUtility.SetDirty(target);
            }

            var data = manager.GetLanguage(_self.key);
            if (data != null)
            {
                EditorGUILayout.LabelField("Value ", data);
                if (_isRefresh == null || _isRefresh == true) _self.SetContents(_self.key);
            }
            else
            {
                var errorStyle = new GUIStyle {normal = {textColor = Color.red}};
                EditorGUILayout.LabelField("Value ", "键值不存在", errorStyle);
            }
        }
    }
}