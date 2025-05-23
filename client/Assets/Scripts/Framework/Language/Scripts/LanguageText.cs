using UnityEngine;
using UnityEngine.UI;

namespace Language {
    [RequireComponent (typeof (Text))] //像Obj上添加该脚本时，会先检测是否有Text这个组件，如果没有就不能添加。在删除Text组件时，如果这个脚本在obj上，就不能删除
    [AddComponentMenu ("Language/LanguageText")] //添加组建菜单
    [DisallowMultipleComponent]
    public class LanguageText : LanguageBase
    {
        private Text _text;
        protected override void Awake()
        {
            _text = GetComponent<Text>();
            base.Awake();
        }

        // ReSharper disable Unity.PerformanceAnalysis
        protected override void OnSet () {
#if UNITY_EDITOR
            _text ??= GetComponent<Text>();
#endif
            _text.SetLang(key);
        }
    }
}