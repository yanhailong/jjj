using System.Collections;
using System.Collections.Generic;
using UnityEngine;
using UnityEngine.EventSystems;
using System;
using System.Threading.Tasks;
using UnityEngine.Events;
using UnityEngine.UI;


[RequireComponent(typeof(Button))]
public class UIButton : MonoBehaviour, IPointerClickHandler, IPointerDownHandler, IPointerUpHandler, IPointerEnterHandler, IPointerExitHandler
{
    [HideInInspector]
    public UnityEvent OnClick = new UnityEvent();
    [HideInInspector]
    public UnityEvent OnPressDown = new UnityEvent();
    [HideInInspector]
    public UnityEvent OnPressUp = new UnityEvent();
    [HideInInspector]
    public UnityEvent OnLongPress = new UnityEvent();
    [HideInInspector]
    public UnityEvent OnEnter = new UnityEvent();
    [HideInInspector]
    public UnityEvent OnExit = new UnityEvent();
    [HideInInspector]
    public Button baseBtn;
    private void Awake()
    {
        baseBtn = transform.GetComponent<Button>();
        baseBtn.transition = Selectable.Transition.None;
    }
    
    private bool isSelected;
    private bool isDisabled;
    private bool isPressed = false;  //是否按下
    private bool isLongPressed = false;  //是否长按
    private bool isClicked = false;  //是否点击
    private float pressTime = 0f;  //按下的时间

    public bool isPlayerScaleAni = false;
    public float scaleDuration = 0.1f;  //缩放动画的持续时间
    public float clickTime = 0.2f;  //点击的最短时间
    public float longPressTime = 1f;  //长按的最短时间
    
    private async Task ScaleDown()  //缩小按钮的方法
    {
        float scale = 0.9f;  //缩小的比例
        Vector3 originalScale = transform.localScale;  //记录原始的比例
        Vector3 targetScale = originalScale * scale;  //计算目标比例
        float startTime = Time.time;  //记录开始时间
        while (Time.time - startTime < scaleDuration)  //在规定的时间内循环执行
        {
            transform.localScale = Vector3.Lerp(originalScale, targetScale, (Time.time - startTime) / scaleDuration);  //根据时间差计算当前比例
            await Task.Yield();  //等待一帧
        }
    }
    
    private async Task ScaleUp()  //放大按钮的方法
    {
        Vector3 originalScale = transform.localScale;  //记录原始的比例
        Vector3 targetScale = Vector3.one;  //计算目标比例
        float startTime = Time.time;  //记录开始时间
        while (Time.time - startTime < scaleDuration)  //在规定的时间内循环执行
        {
            transform.localScale = Vector3.Lerp(originalScale, targetScale, (Time.time - startTime) / scaleDuration);  //根据时间差计算当前比例
            await Task.Yield();  //等待一帧
        }
    }

    /// <summary>
    /// 点击事件的回调函数
    /// </summary>
    /// <param name="eventData"></param>
    public void OnPointerClick(PointerEventData eventData)
    {
        if (isPressed && !isLongPressed)  //如果是点击事件
        {
            isClicked = true;  //标记为点击
        }
        OnClick?.Invoke();
    }

    public async void OnPointerDown(PointerEventData eventData)  //按下事件的回调函数
    {
        isPressed = true;  //标记为按下
        pressTime = Time.time;  //记录按下时间
        isLongPressed = false;  //重置长按标记
        if (isPlayerScaleAni)
        {
            await ScaleDown();  //缩小按钮
        }
        OnPressDown?.Invoke();
    }

    public async void OnPointerUp(PointerEventData eventData)  //松开事件的回调函数
    {
        isPressed = false;  //标记为松开
        if (Time.time - pressTime > clickTime && !isClicked)  //如果按下时间超过最短点击时间且不是点击事件
        {
            isLongPressed = true;  //标记为长按
        }
        if (isPlayerScaleAni)
        {
            await ScaleUp();  //放大按钮
        }
        isClicked = false;  //重置点击标记
    }

    /// <summary>
    /// 进入按钮区域的回调函数
    /// </summary>
    /// <param name="eventData"></param>
    public void OnPointerEnter(PointerEventData eventData)
    {
        OnEnter?.Invoke();
    }

    /// <summary>
    /// 离开按钮区域的回调函数
    /// </summary>
    /// <param name="eventData"></param>
    public async void OnPointerExit(PointerEventData eventData)
    {
        isPressed = false;  //标记为松开
        if (isPlayerScaleAni)
        {
            await ScaleUp();  //放大按钮
        }
        OnExit?.Invoke();
        isClicked = false;  //重置点击标记
    }

    private void OnDestroy()
    {
        OnClick.RemoveAllListeners();
        OnPressDown.RemoveAllListeners();
        OnPressUp.RemoveAllListeners();
        OnLongPress.RemoveAllListeners();
        OnEnter.RemoveAllListeners();
        OnExit.RemoveAllListeners();
    }
}

