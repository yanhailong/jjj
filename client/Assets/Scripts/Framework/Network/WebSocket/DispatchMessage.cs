using System;
using System.Collections;
using System.Collections.Generic;
using UnityEngine;
using XLua;

namespace NetClient
{
    //消息分发
    public class DispatchMessage
    {
        private Queue<KeyValuePair<int,byte[]>> msgQueue;
        private object lockObj = new object();
        private Action<int,byte[]> onReceive;
        
        
        public DispatchMessage(Action<int,byte[]> onReceive)
        {
            msgQueue = new Queue<KeyValuePair<int, byte[]>>();
            this.onReceive = onReceive;
        }

        //接收消息，不在主线程
        public int OnReceive(int msgId,byte[] bts)
        {
            lock (lockObj)
            {
                KeyValuePair<int, byte[]> keyValue = new KeyValuePair<int, byte[]>(msgId, bts);
                msgQueue.Enqueue(keyValue);
                return msgQueue.Count;
            }
        }

        //消息分发到lua
        private void Dispatch()
        {
            KeyValuePair<int, byte[]> msg = msgQueue.Dequeue();
            onReceive?.Invoke(msg.Key,msg.Value);
        }

        public void Update()
        {
            while (msgQueue.Count > 0)
            {
                Dispatch();
            }
        }

        public void Clear()
        {
            msgQueue.Clear();
            this.onReceive = null;
        }

    }
}
