using System;
using System.Collections;
using System.Collections.Generic;
using System.IO;
using UnityEngine;
using WebSocketSharp;
using XLua;
using JiuJiuPrincess;

public class WebSocketClient : SingletonMono<WebSocketClient>
{
    private WebSocket webSocket;
    private object msgLock;
    private static string Url = @"ws://127.0.0.1"; //for test;
    public bool isConnect { get; private set; }
    
    private Queue<byte[]> queue;
    private Action<byte[]> onReceive;
    
     private Action<string> onWebState=null;
     private Queue<string> StateError;
    

    protected override void Init()
    {
        queue = new Queue<byte[]>();
        msgLock = new object();
        StateError = new Queue<string>();
    }

    public WebSocket Run(string url,Action<byte[]> onReceive,Action<string> onWebState)
    {
        this.onReceive = onReceive;
        this.onWebState = onWebState;
        WebSocketClient.Url = url;
        if (webSocket != null)
            this.Close();

        webSocket = new WebSocket(Url);
        webSocket.OnOpen += OnOpen;
        webSocket.OnError += OnError;
        webSocket.OnClose += OnClose;
        webSocket.OnMessage += OnMessage;
        return webSocket; 
    }

    public void ConnectAsync()
    {
        webSocket.ConnectAsync();
    }


    private void OnOpen(object sender, EventArgs e)
    {
         isConnect = true;
         StateError.Enqueue("Success");
    }

    private void OnClose(object sender, EventArgs e)
    {
         if (isConnect==true)
         {
             isConnect = false;
             StateError.Enqueue("ReOpen");
         }
         isConnect = false;
         StateError.Enqueue("OnClose");
    }

    private void OnError(object sender, EventArgs e)
    {
         string msg = "OnError " + e.ToString();
         StateError.Enqueue(msg);
    }

    private void OnMessage(object sender, MessageEventArgs e)
    {
        lock (msgLock)
        {
            queue.Enqueue(e.RawData);
        }
    }

    public void Send(byte[] byteBuffer)
    {
        if (!isConnect)
        {
            Debug.LogError("WebSocket未连接！");
            return;
        }
        try
        {
            webSocket.SendAsync(byteBuffer);
        }
        catch (Exception e)
        {
            Debug.LogError(e.ToString());
        }
    }

    public void Update()
    {
        if (StateError.Count>0)
         {
             this.onWebState?.Invoke(StateError.Dequeue());
         }
        
        if (queue.Count == 0)
            return;
        lock (msgLock)
        {
            this.onReceive?.Invoke(queue.Dequeue());
        }
    }

    public void DisConnect()
    {
        this.webSocket.CloseAsync();
    }

    public void Close()
    {
        if (webSocket != null)
        {           
            webSocket.CloseAsync();
            webSocket.OnOpen -= OnOpen;
            webSocket.OnError -= OnError;
            webSocket.OnClose -= OnClose;
            webSocket.OnMessage -= OnMessage;
        }
        this.queue.Clear();
        this.StateError.Clear();
        this.webSocket = null;
        this.onReceive = null;
        this.onWebState = null;
        this.isConnect = false;
    }

    public void OnDestroy()
    {
        this.Close();
    }
}
