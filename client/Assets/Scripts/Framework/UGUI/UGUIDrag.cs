using System;
using System.Collections;
using System.Collections.Generic;
using UnityEngine;
using UnityEngine.EventSystems;

public class UGUIDrag : MonoBehaviour, IBeginDragHandler, IDragHandler, IEndDragHandler
{
    public Action beginDrag;
    public Action<Vector2> drag;
    public Action endDrag;

    public void OnBeginDrag(PointerEventData eventData)
    {
        beginDrag?.Invoke();
    }

    public void OnDrag(PointerEventData eventData)
    {
        drag?.Invoke(eventData.delta);
    }

    public void OnEndDrag(PointerEventData eventData)
    {
        endDrag?.Invoke();
    }
}
