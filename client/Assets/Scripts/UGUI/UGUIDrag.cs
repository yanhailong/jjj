using System;
using System.Collections;
using System.Collections.Generic;
using UnityEngine;
using UnityEngine.EventSystems;

public class UGUIDrag : MonoBehaviour, IBeginDragHandler, IDragHandler, IEndDragHandler
{
    public Action<PointerEventData> beginDrag;
    public Action<PointerEventData> drag;
    public Action<PointerEventData> endDrag;

    public void OnBeginDrag(PointerEventData eventData)
    {
        beginDrag?.Invoke(eventData);
    }

    public void OnDrag(PointerEventData eventData)
    {
        drag?.Invoke(eventData);
    }

    public void OnEndDrag(PointerEventData eventData)
    {
        endDrag?.Invoke(eventData);
    }
}
