using UnityEngine;

namespace Language
{
    [AddComponentMenu("Language/LanguagePrefab")]
    public class LanguagePrefab : LanguageBase
    {
        [Header("需要替换的预制体，必须是该脚本所在Gameobject的子节点。注意：该脚本所在Gameobjec只能有一个子节点")]
        public Transform targetTransform;

        protected override void OnSet()
        {
            var obj = LanguageManager.Instance.GetPrefab(key);
            if (!obj) return;
            var objTransform = Instantiate(obj.transform, transform, false);
            DestroyImmediate(targetTransform.gameObject);
            targetTransform = objTransform;
        }
    }
}


