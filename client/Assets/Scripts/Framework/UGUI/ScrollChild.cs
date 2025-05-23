using System;
using UnityEngine;
using UnityEngine.UI;
using UnityEngine.EventSystems;

public class ScrollChild : MonoBehaviour, IDragHandler, IBeginDragHandler, IEndDragHandler
{
    private ScrollRectExpand[] upperscroll;
    private bool Horizontal = true;
    
    private void Start()
    {
        upperscroll = transform.GetComponentsInParent<ScrollRectExpand>();
    }

    /// <summary>
    /// 开始拖拽
    /// </summary>
    /// <param name="eventData"></param>

    public void OnBeginDrag(PointerEventData eventData)
    {
        if (upperscroll != null)
        {
            Horizontal = Mathf.Abs(eventData.delta.x) > Mathf.Abs(eventData.delta.y) ? true : false;
            for (int i = 0; i < upperscroll.Length; i++)
            {
                if (Horizontal==upperscroll[i].horizontal)
                {
                    upperscroll[i].OnBeginDrag(eventData);
                }
            }
        }
    }

    public void OnDrag(PointerEventData eventData)
    {
        if (upperscroll != null)
        {
            for (int i = 0; i < upperscroll.Length; i++)
            {
                if (Horizontal==upperscroll[i].horizontal)
                {
                    upperscroll[i].OnDrag(eventData);
                }
            }
        }

    }

    /// <summary>
    /// 结束拖拽
    /// </summary>
    /// <param name="eventData"></param>
    public void OnEndDrag(PointerEventData eventData)
    {
        if (upperscroll != null)
        {
            for (int i = 0; i < upperscroll.Length; i++)
            {
                if (Horizontal==upperscroll[i].horizontal)
                {
                    upperscroll[i].OnEndDrag(eventData);
                }
            }
            
        }
    }
}