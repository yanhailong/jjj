using TMPro;
using UnityEngine;
using UnityEngine.UI;

namespace Language
{
    public static class LanguageExtendTextMeshPro {
        public static void SetLangKey(this TMP_Text self, string key, bool set = true)
        {
            var language = self.GetComponent<LanguageBase>();
            if (language == null) return;
            if (set) language.SetContents(key);
            else language.key = key;
        }
        private static void SetLanguageText (TMP_Text self, string data, params object[] param)
        {
            self.text = param.Length > 0 ? string.Format (data, param) : data;
        }
        public static void SetLang (this TMP_Text self, string key, params object[] param) {
            var data = LanguageManager.Instance.GetLanguage (key);
            if (data == null) {
                Debug.unityLogger.Log(LogType.Warning, $"Text键值不存在:{key}");
                data = key;
            }
            SetLanguageText (self, data, param);
        }
        public static void SetLangBy (this TMP_Text self, params object[] param) {
            var language = self.GetComponent<LanguageBase> ();
            if (!language) return;
            var data = LanguageManager.Instance.GetLanguage (language.key);
            if (data == null) {
                Debug.unityLogger.Log(LogType.Warning, $"Text键值不存在:{language.key}");
                data = language.key;
            }
            // MDebug.Log ($"===SetLBy data:{data.value}  key:{language.key}");
            SetLanguageText (self, data, param);
        }
        public static void OnLangEvent (this TMP_Text self, LanguageManager.EventFunc callback) {
            var language = self.GetComponent<LanguageBase> ();
            if (language == null) return;
            language.SetEventFunc (callback);
        }
        public static void ExecuteLangEvent (this TMP_Text self) {
            var language = self.GetComponent<LanguageBase> ();
            if (language == null) return;
            language.ExecuteEventFunc ();
        }
    }
}