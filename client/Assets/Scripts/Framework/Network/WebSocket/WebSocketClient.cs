using System;
using System.Collections;
using System.Collections.Generic;
using System.IO;
using UnityEngine;
using WebSocketSharp;
using System.Threading;
using NetClient;
using XLua;
using YooAsset;
public class WebSocketClient : SingletonMono<WebSocketClient>
{
    
    private WebSocket webSocket;
    private object msgLock;
    private string Url;
    public bool isConnect { get; private set; }
    

    private Action<int,byte[]> luaCall=null;
    private Action<string> onWebState=null;
    public int maxMsgCount=60;
    public int MaxSize = 1024 * 64;
    private object lock_sendbuffer = new object();
    private Queue<byte[]> sendBufferPool;

    private Queue<string> StateError = new Queue<string>();

    
    //消息接收解析
    private ReveiveByteBuffer reveiveByteBuffer;
    //消息分发
    private DispatchMessage dispatchMessage;
    
    private Thread threadConnect;
    
    void Awake()
    {
        msgLock = new object();
        sendBufferPool = new Queue<byte[]>();
        reveiveByteBuffer = new ReveiveByteBuffer(MaxSize, OnReceiveCallback);
        dispatchMessage = new DispatchMessage(OnReceive);
    }
    public void Run(string url, Action<int,byte[]> fallback,Action<string> onWebState, string[] prms = null)
    {
        luaCall = fallback;
        this.onWebState = onWebState;
        this.Url = url;
        if (webSocket != null)
            this.Close();
        webSocket = new WebSocket(this.Url, prms);
        webSocket.OnOpen += OnOpen;
        webSocket.OnError += OnError;
        webSocket.OnClose += OnClose;
        webSocket.OnMessage += OnMessage;
        
        threadConnect = new Thread(() =>
        {
            try
            {
                webSocket.Connect();
            }
            catch (Exception e)
            {
                Debug.LogError("连接失败！:"+e.Message.ToString());
            }
        });
        threadConnect.Start();
    }


    private void OnReceive(int msgId,byte[] byteBuffer)
    {
        luaCall?.Invoke(msgId,byteBuffer);
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
            this.reveiveByteBuffer.OnRead(e.RawData, e.RawData.Length);
        }
    }

    public void Send(int msgId, byte[] byteBuffer)
    {
        if (!isConnect)
        {
            Debug.LogError("WebSocket连接未打开");
            return;
        }
        int msgLen = byteBuffer.Length;
        byte[] sendBuffer = GetSendBuffer();
        //消息长度转为byte
        sendBuffer[0] = (byte)((msgLen >> 24) & 0xff);
        sendBuffer[1] = (byte)((msgLen >> 16) & 0xff);
        sendBuffer[2] = (byte)((msgLen >> 8) & 0xff);
        sendBuffer[3] = (byte)(msgLen & 0xff);

        sendBuffer[4] = (byte)((msgId >> 24) & 0xff);
        sendBuffer[5] = (byte)((msgId >> 16) & 0xff);
        sendBuffer[6] = (byte)((msgId >> 8) & 0xff);
        sendBuffer[7] = (byte)(msgId & 0xff);
            
        Array.Copy(byteBuffer, 0, sendBuffer, 8, msgLen);
        try
        {
            webSocket.SendAsync(ConvertToStream(sendBuffer),msgLen + 8, (isSucceed) =>
            {

            });
        }
        catch (Exception e)
        {
            Debug.LogError(e.ToString());
        }
    }
    
    private Stream ConvertToStream(byte[]bytes)
    {
        Stream result;
        try
        {
            Stream stream =  new  MemoryStream(bytes);
            result = stream;
        }
        catch (Exception ex)
        {
            throw ex;
        }
        return result;
    }

    private byte[] GetSendBuffer()
    {
        if (sendBufferPool.Count > 0)
        {
            lock (lock_sendbuffer)
            {
                return sendBufferPool.Dequeue();
            }
        }
        return new byte[MaxSize];
    }
    
    //消息解析完成返回
    private void OnReceiveCallback(int msgId,byte[] bts)
    {
        int len = dispatchMessage.OnReceive(msgId,bts);
        //判断消息是否溢出
        if (len > maxMsgCount)
        {
            Debug.LogError("LimitMax:" + maxMsgCount + "  ReceiveCount:" + len);
        }
    }
    
    public void Update()
    {
        dispatchMessage.Update();
        if (StateError.Count>0)
        {
            onWebState.Invoke(StateError.Dequeue());
        }
    }

    public void Close()
    {
        if (threadConnect != null)
        {
            threadConnect.Abort();
            threadConnect = null;
        }
        if (webSocket != null)
        {           
            webSocket.Close();
            webSocket.OnOpen -= OnOpen;
            webSocket.OnError -= OnError;
            webSocket.OnClose -= OnClose;
            webSocket.OnMessage -= OnMessage;
        }
        webSocket = null;
        luaCall = null;
        isConnect = false;
    }

    public void OnDestroy()
    {
        this.Close();
    }
}
