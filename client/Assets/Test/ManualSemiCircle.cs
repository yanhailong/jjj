using DG.Tweening;
using UnityEngine;

public class ManualSemiCircle : MonoBehaviour
{
    public Transform target;
    public float radius = 2f;
    public float duration = 2f;

    void Start()
    {
        Vector3 center = target.position + new Vector3(radius, 0f, 0f); // 圆心

        DOTween.To(
            t => // t 是 0~1 的插值
            {
                float angle = Mathf.Lerp(180f, 0f, t) * Mathf.Deg2Rad; // 180° → 0°（下半圆）
                float x = center.x + radius * Mathf.Cos(angle);
                float y = center.y + radius * Mathf.Sin(angle);
                target.position = new Vector3(x, -y, target.position.z);
            },
            0f, 1f, duration
        ).SetEase(Ease.Linear);
    }
}