using System;
using UnityEditor;
using UnityEngine;

namespace Language.Editor {
    [CustomEditor(typeof(LanguageText), true)]
    public class LanguageTextEditor : LanguageBaseEditor<LanguageText>
    {
    }
}