using System;
using UnityEditor;
using UnityEngine;

namespace Language.Editor {
    [CustomEditor (typeof (LanguagePrefab), true)]
    public class LanguagePrefabEditor : UnityEditor.Editor {
        private LanguagePrefab _self;
        public override void OnInspectorGUI () {
            base.OnInspectorGUI ();

            _self = target as LanguagePrefab;

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

            var words = manager.GetLanguageKeys ();
            var index = Array.IndexOf (words, _self.key);
            var i = EditorGUILayout.Popup ("Keys", index, words);
            if (i != index) {
                isRefresh = true;
                _self.key = words[i];
                EditorUtility.SetDirty (_self);
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