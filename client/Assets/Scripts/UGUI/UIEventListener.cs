using System;
using System.Collections.Generic;
using UnityEngine;
using UnityEngine.EventSystems;
using UnityEngine.UI;

public class UIEventListener
{
    public static UIEventListener Get()
    {
        return new UIEventListener();
    }

    // 按照事件类型定义不同字典，避免混用
    private Dictionary<string, Action<GameObject>> map_click = new Dictionary<string, Action<GameObject>>();
    private Dictionary<string, Action<bool>> map_toggle = new Dictionary<string, Action<bool>>();
    private Dictionary<string, Action<float>> map_slider = new Dictionary<string, Action<float>>();
    private Dictionary<string, Action<Vector2>> map_scroll = new Dictionary<string, Action<Vector2>>();
    private Dictionary<string, Action> map_longpress = new Dictionary<string, Action>();
    private Dictionary<string, Action> map_pressdown = new Dictionary<string, Action>();
    private Dictionary<string, Action> map_pressup = new Dictionary<string, Action>();
    private Dictionary<string, Action<string>> map_input = new Dictionary<string, Action<string>>();
    private Dictionary<string, Action<int>> map_dropdown = new Dictionary<string, Action<int>>();
    private Dictionary<string, Action<string>> map_input_endedit = new Dictionary<string, Action<string>>();
    private Dictionary<string, Action<PointerEventData>> map_begindrag = new Dictionary<string, Action<PointerEventData>>();
    private Dictionary<string, Action<PointerEventData>> map_drag = new Dictionary<string, Action<PointerEventData>>();
    private Dictionary<string, Action<PointerEventData>> map_enddrag = new Dictionary<string, Action<PointerEventData>>();

    private T GetOrAddComponent<T>(GameObject go) where T : Component
    {
        if (go == null) return null;
        T t = go.GetComponent<T>();
        if (t == null)
            t = go.AddComponent<T>();
        return t;
    }

    private void AddFuncToMap<T>(GameObject go, T func, Dictionary<string, T> dic)
    {
        string key = go.GetInstanceID().ToString();
        if (dic.ContainsKey(key))
        {
            if (EqualityComparer<T>.Default.Equals(dic[key], func)) return;
            else
            {
                // 可以在此添加资源释放逻辑，如订阅/取消事件等
                dic[key] = func;
            }
        }
        else
        {
            dic.Add(key, func);
        }
    }

    private void RemoveFuncByMap<T>(GameObject go, Dictionary<string, T> dic)
    {
        string key = go.GetInstanceID().ToString();
        if (dic.TryGetValue(key, out var action))
        {
            dic.Remove(key);
        }
    }

    #region 添加事件

    public void AddClick(GameObject go, Action<GameObject> callback)
    {
        if (go == null || callback == null) return;
        AddFuncToMap(go, callback, map_click);
        Button btn = GetOrAddComponent<Button>(go);
        btn.onClick.AddListener(() => callback(go));
    }

    public void AddToggle(GameObject go, Action<bool> callback)
    {
        if (go == null || callback == null) return;
        AddFuncToMap(go, callback, map_toggle);
        Toggle toggle = GetOrAddComponent<Toggle>(go);
        toggle.onValueChanged.AddListener((b) => callback(b));
    }

    public void AddSlider(GameObject go, Action<float> callback)
    {
        if (go == null || callback == null) return;
        AddFuncToMap(go, callback, map_slider);
        Slider slider = GetOrAddComponent<Slider>(go);
        slider.onValueChanged.AddListener((v) => callback(v));
    }

    private Vector2 srb;
    public void AddScrollRect(GameObject go, Action<Vector2> callback)
    {
        if (go == null || callback == null) return;
        AddFuncToMap(go, callback, map_scroll);
        ScrollRect scrollRect = GetOrAddComponent<ScrollRect>(go);
        scrollRect.onValueChanged.AddListener((v) =>
        {
            if (srb == v) return;
            srb = v;
            callback(v);
        });
    }

    public void AddLongPress(GameObject go, Action callback)
    {
        if (go == null || callback == null) return;
        AddFuncToMap(go, callback, map_longpress);
        ButtonLongPress btn = GetOrAddComponent<ButtonLongPress>(go);
        btn.onLongPress.AddListener(() => callback());
    }

    public void AddPressDown(GameObject go, Action callback)
    {
        if (go == null || callback == null) return;
        AddFuncToMap(go, callback, map_pressdown);
        ButtonPressDown btn = GetOrAddComponent<ButtonPressDown>(go);
        btn.onLongPress.AddListener(() => callback());
    }

    public void AddPressUp(GameObject go, Action callback)
    {
        if (go == null || callback == null) return;
        AddFuncToMap(go, callback, map_pressup);
        ButtonPressUp btn = GetOrAddComponent<ButtonPressUp>(go);
        btn.onLongPress.AddListener(() => callback());
    }

    public void AddInputChange(GameObject go, Action<string> callback)
    {
        if (go == null || callback == null) return;
        AddFuncToMap(go, callback, map_input);
        InputField input = GetOrAddComponent<InputField>(go);
        input.onValueChanged.AddListener((v) => callback(v));
    }

    public void AddDropdownSelect(GameObject go, Action<int> callback)
    {
        if (go == null || callback == null) return;
        AddFuncToMap(go, callback, map_dropdown);
        Dropdown dropdown = GetOrAddComponent<Dropdown>(go);
        dropdown.onValueChanged.AddListener((v) => callback(v));
    }

    public void AddInputEndEdit(GameObject go, Action<string> callback)
    {
        if (go == null || callback == null) return;
        AddFuncToMap(go, callback, map_input_endedit);
        InputField input = GetOrAddComponent<InputField>(go);
        input.onEndEdit.AddListener((v) => callback(v));
    }

    public void AddBeginDrag(GameObject go, Action<PointerEventData> callback)
    {
        if (go == null || callback == null) return;
        AddFuncToMap(go, callback, map_begindrag);
        UGUIDrag drag = GetOrAddComponent<UGUIDrag>(go);
        drag.beginDrag += callback;
    }

    public void AddDrag(GameObject go, Action<PointerEventData> callback)
    {
        if (go == null || callback == null) return;
        AddFuncToMap(go, callback, map_drag);
        UGUIDrag drag = GetOrAddComponent<UGUIDrag>(go);
        drag.drag += callback;
    }

    public void AddEndDrag(GameObject go, Action<PointerEventData> callback)
    {
        if (go == null || callback == null) return;
        AddFuncToMap(go, callback, map_enddrag);
        UGUIDrag drag = GetOrAddComponent<UGUIDrag>(go);
        drag.endDrag += callback;

        Camera.main.ScreenToWorldPoint(new Vector3(Input.mousePosition.x, Input.mousePosition.y, 0));
    }

    #endregion

    #region 移除事件

    public void RemoveClick(GameObject go)
    {
        if (go == null) return;
        Button btn = go.GetComponent<Button>();
        if (btn != null) btn.onClick.RemoveAllListeners();
        RemoveFuncByMap(go, map_click);
    }

    public void RemoveToggle(GameObject go)
    {
        if (go == null) return;
        Toggle toggle = go.GetComponent<Toggle>();
        if (toggle != null) toggle.onValueChanged.RemoveAllListeners();
        RemoveFuncByMap(go, map_toggle);
    }

    public void RemoveSlider(GameObject go)
    {
        if (go == null) return;
        Slider slider = go.GetComponent<Slider>();
        if (slider != null) slider.onValueChanged.RemoveAllListeners();
        RemoveFuncByMap(go, map_slider);
    }

    public void RemoveScrollRect(GameObject go)
    {
        if (go == null) return;
        ScrollRect rect = go.GetComponent<ScrollRect>();
        if (rect != null) rect.onValueChanged.RemoveAllListeners();
        RemoveFuncByMap(go, map_scroll);
    }

    public void RemovedLongPress(GameObject go)
    {
        if (go == null) return;
        ButtonLongPress et = go.GetComponent<ButtonLongPress>();
        if (et != null) et.onLongPress.RemoveAllListeners();
        RemoveFuncByMap(go, map_longpress);
    }

    public void RemovedPressDown(GameObject go)
    {
        if (go == null) return;
        ButtonPressDown et = go.GetComponent<ButtonPressDown>();
        if (et != null) et.onLongPress.RemoveAllListeners();
        RemoveFuncByMap(go, map_pressdown);
    }

    public void RemovedPressUp(GameObject go)
    {
        if (go == null) return;
        ButtonPressUp et = go.GetComponent<ButtonPressUp>();
        if (et != null) et.onLongPress.RemoveAllListeners();
        RemoveFuncByMap(go, map_pressup);
    }

    public void RemovedInputChange(GameObject go)
    {
        if (go == null) return;
        InputField et = go.GetComponent<InputField>();
        if (et != null) et.onValueChanged.RemoveAllListeners();
        RemoveFuncByMap(go, map_input);
    }

    public void RemovedDropdownSelect(GameObject go)
    {
        if (go == null) return;
        Dropdown et = go.GetComponent<Dropdown>();
        if (et != null) et.onValueChanged.RemoveAllListeners();
        RemoveFuncByMap(go, map_dropdown);
    }

    public void RemovedInputEndEdit(GameObject go)
    {
        if (go == null) return;
        InputField et = go.GetComponent<InputField>();
        if (et != null) et.onEndEdit.RemoveAllListeners();
        RemoveFuncByMap(go, map_input_endedit);
    }

    public void RemovedBeginDrag(GameObject go)
    {
        if (go == null) return;
        UGUIDrag et = go.GetComponent<UGUIDrag>();
        if (et != null) et.beginDrag = null;
        RemoveFuncByMap(go, map_begindrag);
    }

    public void RemovedDrag(GameObject go)
    {
        if (go == null) return;
        UGUIDrag et = go.GetComponent<UGUIDrag>();
        if (et != null) et.drag = null;
        RemoveFuncByMap(go, map_drag);
    }

    public void RemovedEndDrag(GameObject go)
    {
        if (go == null) return;
        UGUIDrag et = go.GetComponent<UGUIDrag>();
        if (et != null) et.endDrag = null;
        RemoveFuncByMap(go, map_enddrag);
    }

    #endregion

    public void Clear()
    {
        map_click.Clear();
        map_toggle.Clear();
        map_slider.Clear();
        map_scroll.Clear();
        map_longpress.Clear();
        map_pressdown.Clear();
        map_pressup.Clear();
        map_input.Clear();
        map_dropdown.Clear();
        map_input_endedit.Clear();
        map_begindrag.Clear();
        map_drag.Clear();
        map_enddrag.Clear();
    }
}
