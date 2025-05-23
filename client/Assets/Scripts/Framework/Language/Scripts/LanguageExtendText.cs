using Language;
using UnityEngine;
using UnityEngine.UI;

namespace Language
{
    public static class LanguageExtendText {
        // ReSharper disable Unity.PerformanceAnalysis
        public static void SetLangKey(this Text self, string key, bool set = true)
        {
            var language = self.GetComponent<LanguageBase>();
            if (language == null) return;
            if (set) language.SetContents(key);
            else language.key = key;
        }

        private static void SetLanguageText (Text self, string data, params object[] param)
        {
            self.text = param.Length > 0 ? string.Format (data, param) : data;
            // if (data.fontSize != -1) self.fontSize = data.fontSize;
            // if (data.fontIndex != -1) self.font = LanguageManager.Instance.font.GetFont (data.fontIndex);
        }
        public static void SetLang (this Text self, string key, params object[] param) {
            var data = LanguageManager.Instance.GetLanguage (key);
            if (data == null)
            {
                Debug.unityLogger.Log(LogType.Warning, $"Text键值不存在:{key}");
                data = key;
            }
            SetLanguageText (self, data, param);
        }
        // ReSharper disable Unity.PerformanceAnalysis
        public static void SetLangBy (this Text self, params object[] param) {
            var language = self.GetComponent<LanguageBase> ();
            if (!language) return;
            var data = LanguageManager.Instance.GetLanguage (language.key);
            if (data == null) {
                Debug.unityLogger.Log(LogType.Warning, $"Text键值不存在:{language.key}");
                data = language.key;
            }
            // Debug.unityLogger.Log(LogType.Warning, $"===SetLBy data:{data.value}  key:{language.key}");
            SetLanguageText (self, data, param);
        }
        // ReSharper disable Unity.PerformanceAnalysis
        public static string GetLang(this Text self)
        {
            var language = self.GetComponent<LanguageBase> ();
            if (!language) return null;
            var data = LanguageManager.Instance.GetLanguage (language.key);
            if (data == null) {
                Debug.unityLogger.Log(LogType.Warning, $"Text键值不存在:{language.key}");
                data = language.key;
            }
            return data;
        }
        
        // ReSharper disable Unity.PerformanceAnalysis
        public static void SetLang (this Image self) {
            var language = self.GetComponent<LanguageBase> ();
            if (!language) return;
            var data = LanguageManager.Instance.GetLanguage (language.key);
            if (data == null) {
                Debug.unityLogger.Log(LogType.Warning, $"Image键值不存在:{language.key}");
                return;
            }
            self.sprite = UnityEngine.Resources.Load<UnityEngine.Sprite> ("Language/Picture/" + data);
            self.SetNativeSize ();
        }
        
        // ReSharper disable Unity.PerformanceAnalysis
        public static void OnLangEvent (this Text self, LanguageManager.EventFunc callback) {
            var language = self.GetComponent<LanguageBase> ();
            if (language == null) return;
            language.SetEventFunc (callback);
        }
        // ReSharper disable Unity.PerformanceAnalysis
        public static void ExecuteLangEvent (this Text self) {
            var language = self.GetComponent<LanguageBase> ();
            if (language == null) return;
            language.ExecuteEventFunc ();
        }
    }
}