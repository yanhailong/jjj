using DG.Tweening;
using UnityEngine;

public class QuadraticBezierArc : MonoBehaviour
{
    public Transform target;
    public Transform controlPoint; // 贝塞尔控制点（决定弧线弯曲程度）
    public float duration = 2f;

    void Start()
    {
        Vector3 startPos = target.position;
        Vector3 endPos = startPos + new Vector3(5f, 0f, 0f); // 终点

        // 使用 DOTween 的插值计算贝塞尔曲线
        DOTween.To(
            t => // t ∈ [0, 1]
            {
                // 二次贝塞尔公式：B(t) = (1-t)²P0 + 2(1-t)tP1 + t²P2
                float u = 1 - t;
                Vector3 position =
                    u * u * startPos +
                    2 * u * t * controlPoint.position +
                    t * t * endPos;
                target.position = position;
            },
            0f, 1f, duration
        ).SetEase(Ease.Linear);
    }
}