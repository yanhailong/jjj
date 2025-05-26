using UnityEngine;
using UnityEngine.Events;
using UnityEngine.EventSystems;
using UnityEngine.UI;

public class ButtonPressDown : UIBehaviour, IPointerDownHandler, IPointerExitHandler
{
    public UnityEvent onLongPress = new UnityEvent();
    public void OnPointerDown(PointerEventData eventData)
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
