using UnityEngine;
using UnityEngine.UI;

namespace Language {
    [RequireComponent (typeof (Image))]
    [AddComponentMenu ("Language/LanguageImage")]
    public class LanguageImage : LanguageBase {
        // ReSharper disable Unity.PerformanceAnalysis
        protected override void OnSet () {
            var image = GetComponent<Image> ();
            image.SetLang();
        }
    }
}