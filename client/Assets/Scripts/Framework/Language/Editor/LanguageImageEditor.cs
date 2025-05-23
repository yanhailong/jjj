using System;
using Language;
using UnityEditor;
using UnityEngine;

namespace Language.Editor {
    [CustomEditor (typeof (LanguageImage), true)]
    public class LanguageImageEditor : UnityEditor.Editor {
        private LanguageImage _self;
        public override void OnInspectorGUI () {
            base.OnInspectorGUI ();

            _self = target as LanguageImage;

            if (!_self || Application.isPlaying)
                return;

            var manager = LanguageManager.Instance; //实例化语言管理对象

            var languages = manager.GetLanguagesName ().ToArray (); //得到所支持的语言名字
            var languageIdx = Array.IndexOf (languages, manager.Language); //得到被选中语言在集合中的下标
            var language = EditorGUILayout.Popup ("Language", languageIdx, languages);
            var isRefresh = false;
            if (language != languageIdx) {
                isRefresh = true;
                manager.Language = languages[language];
                EditorUtility.SetDirty (_self);
            }

            var sKey = EditorGUILayout.TextField ("Keys", _self.key);
            if (string.IsNullOrEmpty (sKey)) {
                sKey = LanguageManager.GetTransPath(_self.transform);
            }
            if (sKey != _self.key || isRefresh) {
                isRefresh = true;
                _self.key = sKey;
            }

            var data = manager.GetLanguage (_self.key);
            if (data != null) {
                EditorGUILayout.LabelField ("Path ", data);
                if (isRefresh) _self.SetContents (_self.key);
            } else {
                var errorStyle = new GUIStyle {normal = {textColor = Color.red}};
                EditorGUILayout.LabelField ("Path ", "键值不存在", errorStyle);
            }
        }
    }
}