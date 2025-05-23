using TMPro;
using UnityEngine;

namespace Language
{
    [RequireComponent (typeof (TMP_Text))]
    [AddComponentMenu ("Language/LanguageTextMeshPro")] //添加组建菜单
    public class LanguageTextMeshPro : LanguageBase
    {
        private TMP_Text _text;
        protected override void Awake()
        {
            _text = GetComponent<TMP_Text>();
            base.Awake();
        }

        // ReSharper disable Unity.PerformanceAnalysis
        protected override void OnSet () 
        {
            if (_text == null)
            {
                _text = GetComponent<TMP_Text>();
                Debug.Assert(_text != null);
            }
            ApplyFallbackFont();
            _text.SetLang(key);
        }
        
        private void ApplyFallbackFont()
        {
            if (LanguageManager.Instance.FallbackFont == null)
                return;
            if (_text.font.fallbackFontAssetTable.Count == 0)
                _text.font.fallbackFontAssetTable.Add(LanguageManager.Instance.FallbackFont);
            else
                _text.font.fallbackFontAssetTable[0] = LanguageManager.Instance.FallbackFont;
        }
    }
}