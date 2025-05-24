using System.Collections.Generic;
using UnityEngine;
using UnityEngine.UI;
using XLua;

public class UIEventListener
{
    public static UIEventListener Get()
    {
        return new UIEventListener();
    }

    private Dictionary<string, LuaFunction> map_func = new Dictionary<string, LuaFunction>();
    private Dictionary<string, LuaFunction> map_func1 = new Dictionary<string, LuaFunction>();
    private Dictionary<string, LuaFunction> map_func2 = new Dictionary<string, LuaFunction>();
    private Dictionary<string, LuaFunction> map_func3 = new Dictionary<string, LuaFunction>();

    private T GetOrAddComponent<T>(GameObject go) where T : Component
    {
        if (go == null) return null;
        T t = go.GetComponent<T>();
        if (t == null)
            t = go.AddComponent<T>();
        return t;
    }

    private void AddFuncToMap(GameObject go, LuaFunction func)
    {
        string key = go.GetInstanceID().ToString();
        if (map_func.ContainsKey(key))
        {
            if (map_func[key] == func)
                return;
            else
            {
                if (map_func[key] != null)
                    map_func[key].Dispose();
                map_func[key] = func;
                return;
            }
        }
        map_func.Add(key, func);
    }
    
    private void AddFuncToMap(GameObject go, LuaFunction func, Dictionary<string, LuaFunction> dic)
    {
        string key = go.GetInstanceID().ToString();
        if (dic.ContainsKey(key))
        {
            if (dic[key] == func)
                return;
            else
            {
                if (dic[key] != null)
                    dic[key].Dispose();
                dic[key] = func;
                return;
            }
        }
        dic.Add(key, func);
    }

    private void RemoveFuncByMap(GameObject go)
    {
        string key = go.GetInstanceID().ToString();
        LuaFunction func = null;
        if (!map_func.TryGetValue(key, out func)) return;
        map_func.Remove(key);
        func.Dispose();
        func = null;
    }
    private void RemoveFuncByMap(GameObject go, Dictionary<string, LuaFunction> dic)
    {
        string key = go.GetInstanceID().ToString();
        LuaFunction func = null;
        if (!dic.TryGetValue(key, out func)) return;
        dic.Remove(key);
        func.Dispose();
        func = null;
    }

    #region 添加事件
    public void AddClick(GameObject go, LuaFunction luafunc)
    {
        if (go == null || luafunc == null) return;
        AddFuncToMap(go, luafunc);
        Button btn = GetOrAddComponent<Button>(go);
        btn.onClick.AddListener(() =>
        {
            luafunc.Call(go);
        });
    }

    public void AddToggle(GameObject go, LuaFunction luafunc)
    {
        if (go == null || luafunc == null) return;
        AddFuncToMap(go, luafunc);
        GetOrAddComponent<Toggle>(go).onValueChanged.AddListener((b) =>
        {
            luafunc.Call(go, b);
        });
    }

    public void AddSlider(GameObject go, LuaFunction luafunc)
    {
        if (go == null || luafunc == null) return;
        AddFuncToMap(go, luafunc);
        GetOrAddComponent<Slider>(go).onValueChanged.AddListener((v) =>
        {
            luafunc.Call(go, v);
        });
    }

    private Vector2 srb;
    public void AddScrollRect(GameObject go, LuaFunction luafunc)
    {
        if (go == null || luafunc == null) return;
        AddFuncToMap(go, luafunc);
        GetOrAddComponent<ScrollRect>(go).onValueChanged.AddListener((b) =>
        {
            if (srb == b)
                return;
            srb = b;
            luafunc.Call(go, srb);
        });
    }

    public void AddLongPress(GameObject go, LuaFunction luafunc)
    {
        if (go == null || luafunc == null) return;
        AddFuncToMap(go, luafunc, map_func1);
        GetOrAddComponent<UIButton>(go).OnLongPress.AddListener(() =>
        {
            luafunc.Call(go);
        });
    }

    public void AddPressDown(GameObject go, LuaFunction luafunc)
    {
        if (go == null || luafunc == null) return;
        AddFuncToMap(go, luafunc, map_func2);
        GetOrAddComponent<UIButton>(go).OnPressDown.AddListener(() =>
        {
            luafunc.Call(go);
        });
    }

    public void AddPressUp(GameObject go, LuaFunction luafunc)
    {
        if (go == null || luafunc == null) return;
        AddFuncToMap(go, luafunc, map_func3);
        GetOrAddComponent<UIButton>(go).OnPressUp.AddListener(() =>
        {
            luafunc.Call(go);
        });
    }

    public void AddInputChange(GameObject go, LuaFunction luafunc)
    {
        if (go == null || luafunc == null) return;
        AddFuncToMap(go, luafunc);
        GetOrAddComponent<InputField>(go).onValueChanged.AddListener((v) =>
        {
            luafunc.Call(go, v);
        });

    }
    
    public void AddDropdownSelect(GameObject go, LuaFunction luafunc)
    {
        if (go == null || luafunc == null) return;
        AddFuncToMap(go, luafunc);
        GetOrAddComponent<Dropdown>(go).onValueChanged.AddListener((v) =>
        {
            luafunc.Call(go, v);
        });

    }
    
    public void AddInputEndEdit(GameObject go, LuaFunction luafunc)
    {
        if (go == null || luafunc == null) return;
        AddFuncToMap(go, luafunc);
        GetOrAddComponent<InputField>(go).onEndEdit.AddListener((v) =>
        {
            luafunc.Call(go, v);
        });

    }

    public void AddBeginDrag(GameObject go, LuaFunction luafunc)
    {
        if (go == null || luafunc == null) return;
        AddFuncToMap(go, luafunc);
        GetOrAddComponent<UGUIDrag>(go).beginDrag += () =>
          {
              luafunc.Call();
          };
    }

    public void AddDrag(GameObject go, LuaFunction luafunc)
    {
        if (go == null || luafunc == null) return;
        AddFuncToMap(go, luafunc, map_func1);
        GetOrAddComponent<UGUIDrag>(go).drag += (v) =>
        {
            luafunc.Call(v);
        };
    }

    public void AddEndDrag(GameObject go, LuaFunction luafunc)
    {
        if (go == null || luafunc == null) return;
        AddFuncToMap(go, luafunc, map_func2);
        GetOrAddComponent<UGUIDrag>(go).endDrag += () =>
        {
            luafunc.Call();
        };
    }

    #endregion

    #region 移除事件
    public void RemoveClick(GameObject go)
    {
        if (go == null) return;
        Button btn = go.GetComponent<Button>();
        if (btn == null) return;
        btn.onClick.RemoveAllListeners();
        RemoveFuncByMap(go);
    }

    public void RemoveToggle(GameObject go)
    {
        if (go == null) return;
        Toggle toggle = go.GetComponent<Toggle>();
        if (toggle == null) return;
        toggle.onValueChanged.RemoveAllListeners();
        RemoveFuncByMap(go);
    }

    public void RemoveSlider(GameObject go)
    {
        if (go == null) return;
        Slider slider = go.GetComponent<Slider>();
        if (slider == null) return;
        slider.onValueChanged.RemoveAllListeners();
        RemoveFuncByMap(go);
    }

    public void RemoveScrollRect(GameObject go)
    {
        if (go == null) return;
        ScrollRect rect = go.GetComponent<ScrollRect>();
        if (rect == null) return;
        rect.onValueChanged.RemoveAllListeners();
        RemoveFuncByMap(go);
    }

    public void RemovedLongPress(GameObject go)
    {
        if (go == null) return;
        UIButton et = go.GetComponent<UIButton>();
        if (et == null) return;
        et.OnLongPress.RemoveAllListeners();
        RemoveFuncByMap(go, map_func1);
    }

    public void RemovedPressDown(GameObject go)
    {
        if (go == null) return;
        UIButton et = go.GetComponent<UIButton>();
        if (et == null) return;
        et.OnPressDown.RemoveAllListeners();
        RemoveFuncByMap(go, map_func2);
    }

    public void RemovedPressUp(GameObject go)
    {
        if (go == null) return;
        UIButton et = go.GetComponent<UIButton>();
        if (et == null) return;
        et.OnPressUp.RemoveAllListeners();
        RemoveFuncByMap(go, map_func3);
    }

    public void RemovedInputChange(GameObject go)
    {
        if (go == null) return;
        InputField et = go.GetComponent<InputField>();
        if (et == null) return;
        et.onValueChanged.RemoveAllListeners();
        RemoveFuncByMap(go);
    }
    
    public void RemovedDropdownSelect(GameObject go)
    {
        if (go == null) return;
        Dropdown dd = go.GetComponent<Dropdown>();
        if (dd == null) return;
        dd.onValueChanged.RemoveAllListeners();
        RemoveFuncByMap(go);
    }
    
    public void RemovedInputEndEdit(GameObject go)
    {
        if (go == null) return;
        InputField et = go.GetComponent<InputField>();
        if (et == null) return;
        et.onEndEdit.RemoveAllListeners();
        RemoveFuncByMap(go);
    }

    public void RemovedBeginDrag(GameObject go)
    {
        if (go == null) return;
        UGUIDrag et = go.GetComponent<UGUIDrag>();
        if (et == null) return;
        et.beginDrag = null;
        RemoveFuncByMap(go);
    }

    public void RemovedDrag(GameObject go)
    {
        if (go == null) return;
        UGUIDrag et = go.GetComponent<UGUIDrag>();
        if (et == null) return;
        et.drag = null;
        RemoveFuncByMap(go,map_func1);
    }

    public void RemovedEndDrag(GameObject go)
    {
        if (go == null) return;
        UGUIDrag et = go.GetComponent<UGUIDrag>();
        if (et == null) return;
        et.endDrag = null;
        RemoveFuncByMap(go,map_func2);
    }

    #endregion

    public void Clear()
    {
        foreach (var v in map_func)
        {
            if (v.Value != null)
                v.Value.Dispose();
        }
        foreach (var item in map_func1)
        {
            if (item.Value != null)
                item.Value.Dispose();
        }
        foreach (var item in map_func2)
        {
            if (item.Value != null)
                item.Value.Dispose();
        }
        foreach (var item in map_func3)
        {
            if (item.Value != null)
                item.Value.Dispose();
        }
        map_func.Clear();
        map_func1.Clear();
        map_func2.Clear();
        map_func3.Clear();
    }
}
