using System;
using System.Collections;
using System.Collections.Generic;
using Unity.VisualScripting;
using UnityEngine;
using UnityEngine.UI;

public class UIAdaptSefaArea : UIAdaptBase
{
    private void Awake()
    {
        Adapt();
    }
    
    public override void Adapt()
    {
        FitSafeArea(this.transform);
    }
    
    
    /// <summary>
    /// 适配safeArea
    /// </summary>
    void FitSafeArea(Transform obj)
    {
        Rect safeArea = Screen.safeArea;
        float y = Screen.height - safeArea.height;
        RectTransform rectTrans = obj.GetComponent<RectTransform>();
        SafeAreaOffect(rectTrans, y/2);
    }

    /// <summary>
    /// 设置便宜
    /// </summary>
    /// <param name="rectTrans"></param>
    /// <param name="size"></param>
    void SafeAreaOffect(RectTransform rectTrans, float size)
    {
        rectTrans.offsetMax = new Vector2(rectTrans.offsetMax.x, -size);
    }

}
