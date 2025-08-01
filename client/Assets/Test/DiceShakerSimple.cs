using UnityEngine;
using DG.Tweening;

public class DiceShakerSimple : MonoBehaviour
{
    [Header("Shaker Settings")]
    public Transform shaker; // 筛盅模型
    public float shakeHeight = 0.3f; // 上下震动高度
    public float shakeDuration = 1.0f; // 单次震动持续时间
    public int shakeCount = 5; // 震动次数

    [Header("Easing Settings")]
    public Ease upEase = Ease.OutQuad; // 向上运动缓动类型
    public Ease downEase = Ease.InQuad; // 向下运动缓动类型

    private Vector3 originalPosition; // 初始位置
    private Sequence shakeSequence; // 动画序列

    void Start()
    {
        // 保存初始位置
        originalPosition = shaker.position;
        StartShaking();
    }

    // 开始上下摇晃动画
    public void StartShaking()
    {
        // 如果已有动画在运行，先停止
        if (shakeSequence != null && shakeSequence.IsActive())
        {
            shakeSequence.Kill();
        }

        // 创建新的动画序列
        shakeSequence = DOTween.Sequence();

        // 添加多次震动循环
        for (int i = 0; i < shakeCount; i++)
        {
            if (i % 2 == 0)
            {
                // 向上运动
                shakeSequence.Append(shaker.DOMoveY(
                    originalPosition.y + shakeHeight,
                    shakeDuration / 2
                ).SetEase(upEase));
            }
            else
            {
                // 向下运动（回到原始位置）
                shakeSequence.Append(shaker.DOMoveY(
                    originalPosition.y,
                    shakeDuration / 2
                ).SetEase(downEase));
            }
        }
        shakeSequence.AppendInterval(0.2f);
        shakeSequence.Append(shaker.DOMoveY(
                   originalPosition.y,
                   0.1f
               ).SetEase(downEase));
        // 添加一点随机性使动画更自然
        shakeSequence.Append(shaker.DOShakePosition(
         0.5f,
        new Vector3(0.05f, 0.02f, 0.05f),
         5,
        90
        ));
    }

    // 停止摇晃并回到原位
    public void StopShaking()
    {
        //if (shakeSequence != null && shakeSequence.IsActive())
        // {
        // shakeSequence.Kill();
        // }

        // 平滑回到原位
        // shaker.DOMove(originalPosition, 0.3f).SetEase(Ease.OutBack);
    }

    // 当脚本被禁用时停止动画
    void OnDisable()
    {
        StopShaking();
    }
}