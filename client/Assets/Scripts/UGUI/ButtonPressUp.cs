using UnityEngine;
using UnityEngine.Events;
using UnityEngine.EventSystems;
using UnityEngine.UI;


    public class ButtonPressUp : UIBehaviour, IPointerUpHandler, IPointerExitHandler
    {
        public UnityEvent onLongPress = new UnityEvent();

        public void OnPointerUp(PointerEventData eventData)
        {
            OnLongPress();
        }
        public void OnPointerExit(PointerEventData eventData)
        {
            CancelInvoke("OnLongPress");
        }
        protected override void OnDisable()
        {
            CancelInvoke("OnLongPress");
        }
        protected override void OnDestroy()
        {
            CancelInvoke("OnLongPress");
        }
        void OnLongPress()
        {
            onLongPress.Invoke();
        }
    }
