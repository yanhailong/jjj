using DG.Tweening;
using UnityEngine;

public class UpwardParabola : MonoBehaviour
{
    public Transform target; // 要移动的物体
    public float jumpHeight = 3f; // 跳跃高度
    public float moveDistance = 5f; // 水平移动距离
    public float duration = 1.5f; // 动画时长

    void Start()
    {
        Vector3 endPos = target.position + new Vector3(moveDistance, 0f, 0f); // 目标位置（X轴移动）

        // 从当前位置向上抛，沿X轴移动
        target.DOJump(endPos, jumpHeight, 1, duration)
            .SetEase(Ease.OutQuad); // 缓动曲线
    }
}