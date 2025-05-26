using UnityEngine;
public abstract class UGUIBaseTabGroup : MonoBehaviour
{
    public virtual bool IsMultiple { get { return false; } }

    public abstract void SetTabOn(UGUITab tab);
}
