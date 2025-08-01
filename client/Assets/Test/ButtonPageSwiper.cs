using UnityEngine;
using UnityEngine.UI;
using DG.Tweening;

public class ButtonPageSwiper : MonoBehaviour
{
    public RectTransform pageContainer;   // 拖这个横向容器
    public Button leftButton;
    public Button rightButton;

    public int totalPages = 3;            // 总页数
    public float pageWidth = 1080f;       // 每页宽度（根据分辨率设置）
    public float tweenTime = 0.3f;        // 动画时间

    private int currentPage = 0;
    private Tween moveTween;

    void Start()
    {
        leftButton.onClick.AddListener(PrevPage);
        rightButton.onClick.AddListener(NextPage);
        UpdateButtonState();
        
    }

    public void NextPage()
    {
        if (currentPage >= totalPages - 1) return;
        currentPage++;
        MoveToPage(currentPage);
    }

    public void PrevPage()
    {
        if (currentPage <= 0) return;
        currentPage--;
        MoveToPage(currentPage);
    }

    void MoveToPage(int pageIndex)
    {
        float targetX = -pageWidth * pageIndex;

        moveTween?.Kill(); // 防止并发Tween
        moveTween = pageContainer.DOAnchorPosX(targetX, tweenTime).SetEase(Ease.OutCubic);

        UpdateButtonState();
    }

    void UpdateButtonState()
    {
        leftButton.interactable = currentPage > 0;
        rightButton.interactable = currentPage < totalPages - 1;
    }
}