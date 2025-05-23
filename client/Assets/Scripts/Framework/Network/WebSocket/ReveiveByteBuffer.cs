using System;
using System.Collections;
using System.Collections.Generic;
using UnityEngine;
using System.Text;
namespace NetClient
{

    public class ReveiveByteBuffer
    {
        private byte[] buffer;
        private int msgLen = 0;
        private int curBufferLen = 0;
        private Action<int, byte[]> receiveCallback;

        public ReveiveByteBuffer(int size, Action<int, byte[]> receiveCallback)
        {
            buffer = new byte[size];
            this.receiveCallback = receiveCallback;
        }

        //前4个字节为消息长度,第5到8个字节为消息id(不计入消息长度)
        public bool OnRead(byte[] bytes, int len)
        {
            if (curBufferLen + len > buffer.Length)
            {
                Debug.LogError("当前消息超过最大消息限制!");
                return false;
            }
            Array.Copy(bytes, 0, buffer, curBufferLen, len);
            curBufferLen += len;
            if (msgLen == 0 && curBufferLen >= 4)
            {
                msgLen = ReadInt(buffer, 0) + 4;
                if (msgLen <= 0)
                {
                    Debug.LogError("当前读取的消息长度为0");
                    return false;
                }
            }
            if (msgLen > 0)
            {
                int dt = curBufferLen - 4 - msgLen;
                int tempMsgLen = msgLen;
                if (dt >= 0)
                {
                    curBufferLen = 0;
                    MessageParsing();
                }
                if (dt > 0)
                {
                    Array.Copy(buffer, tempMsgLen + 4, bytes, 0, dt);
                    OnRead(bytes, dt);
                }
            }
            return true;
        }

        //消息解析
        private void MessageParsing()
        {
            //防止解析消息报错而没有重置msgLen
            int tempMsgLen = msgLen - 4;
            msgLen = 0;
            string msg = string.Empty;

            int msgId = ReadInt(buffer, 4);

            byte[] bts = new byte[tempMsgLen];
            Array.Copy(buffer, 8, bts, 0, bts.Length);
            receiveCallback(msgId, bts);
        }

        private int ReadInt(byte[] bts, int startIndex)
        {
            int length = (bts[startIndex + 3] & 0xff) << 0 | (bts[startIndex + 2] & 0xff) << 8 | (bts[startIndex + 1] & 0xff) << 16 | (bts[startIndex] & 0xff) << 24;
            return length;
        }


        public void Clear()
        {

        }
    }
}