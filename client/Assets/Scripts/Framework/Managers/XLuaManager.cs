using System;
using System.Collections;
using System.Collections.Generic;
using System.IO;
using UnityEngine;
using UnityEngine.Networking;
using XLua;
using JiuJiuPrincess;
[CSharpCallLua]
public class XLuaManager : SingletonMono<XLuaManager>
{
    private LuaEnv env = null;
    private bool isGameStarted = false;
    private static string luaScriptsFolder = "LuaScripts";
    
    private Action update;
    private Action fixedUpdate;
    private Action lateUpdate;
    private void Awake()
    {
        this.InitLuaEnv();
    }
    
    public LuaEnv InitEditorLuaEnv()
    {
        return this.env;
    }
    private void InitLuaEnv()
    {
        this.env = new LuaEnv();
        this.env.AddLoader(this.LuaScriptLoader);
        
        this.isGameStarted = false;
    }
    public  byte[] LuaScriptLoader(ref string filePath)
    {
        if (filePath.Equals("emmy_core"))
        {
            return null;
        }
        string scriptPath = string.Empty;
        
#if UNITY_EDITOR  // 编辑器模式LuaScripts下面去读;
        filePath = filePath.Replace(".", "/") + ".lua";
        scriptPath = Path.Combine(Application.dataPath, luaScriptsFolder);
        scriptPath = Path.Combine(scriptPath, filePath); 
        scriptPath = RegularPath(scriptPath);
        byte[] data = File.ReadAllBytes(scriptPath);
        return data;
#else
        filePath = filePath.Replace(".", "/") + ".lua";
        byte[] data = LuaBytes.Instance.GetLuaByte(filePath);
        return data;
#endif
    }
    public void EnterGame(GameLancher lancher)
    {
        // 进入游戏逻辑, 跑Lua代码;
        this.env.DoString("require(\"Logic.ZLancher.main\")");
        LuaTable tab= this.env.Global.Get<LuaTable>("main");
        tab.Get<LuaFunction>("init").Call(null,lancher);
        
        //这里这三个回调方法从lua中的全局表里获取
        update = this.env.Global.Get<Action>("Update");
        fixedUpdate= this.env.Global.Get<Action>("FixedUpdate");
        lateUpdate=this.env.Global.Get<Action>("LateUpdate");
        
        this.isGameStarted = true; // 游戏正式开始了，
    }
    
    /// <summary>
    /// 路径归一化
    /// 注意：替换为Linux路径格式
    /// </summary>
    private string RegularPath(string path)
    {
        return path.Replace('\\', '/').Replace("\\", "/");
    }

    private void Update()
    {
        if (this.isGameStarted==true)
        {
            update?.Invoke();
        }
    }

    private void FixedUpdate()
    {
        if (this.isGameStarted==true)
        {
            fixedUpdate?.Invoke();
        }
    }

    private void LateUpdate()
    {
        if (this.isGameStarted==true)
        {
            lateUpdate?.Invoke();
        }
    }

    private void OnDestroy()
    {
        OnDispose();
    }
    public void OnDispose()
    {
        update = null;
        lateUpdate = null;
        fixedUpdate = null;
    }
}
