using UnityEngine;

namespace Language {
    public abstract class LanguageBase : MonoBehaviour {
        [HideInInspector] [SerializeField]
        public string key; //键
        [HideInInspector] [SerializeField]
        public int condition = 3;
        private LanguageManager.EventFunc func_event;

        protected virtual void Awake()
        {
            if ((condition & 0b0001) != 0)
                OnSet();
            if ((condition & 0b0010) != 0)
                SetEventFunc(OnSet);
        }

        protected virtual void OnDestroy() { this.RemoveFunc(); }

        private void RemoveFunc() {
            if (func_event != null) {
                LanguageManager.Instance.RemoveEventHandler(func_event);
            }
        }
        public void SetEventFunc(LanguageManager.EventFunc func) {
            this.RemoveFunc();
            func_event = func;
            LanguageManager.Instance.AddEventHandler(func_event);
        }
        public void ExecuteEventFunc() {
            func_event?.Invoke();
        }
        //设置
        protected abstract void OnSet();

        /// <summary>
        /// 设置内容
        /// </summary>
        /// <param name="theLanguageContentKey">语言内容的Key</param>
        public void SetContents(string theLanguageContentKey) {
            key = theLanguageContentKey;
            OnSet();
        }
    }
}