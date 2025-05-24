using System;
using System.Collections;
using System.Collections.Generic;
using UnityEngine;
using UnityEditor;
using System.IO;
using XLua;
using System.Linq;
using System.Text.RegularExpressions;
using Newtonsoft.Json;

public class MessageIdMapEditor : Editor
{
    private static string rootPath;
    
    [MenuItem("Assets/消息ID映射", false, 0)]
    static void Create()
    {
        var obj = Selection.assetGUIDs;
        if (obj == null || obj.Length == 0)
        {
            Debug.LogError("选择pb所在的文件夹目录");
            return;
        }
        string guid = obj[0];
        string path = AssetDatabase.GUIDToAssetPath(guid);
        string[] files = Directory.GetFiles(path, "*.proto.bytes");
        // MoveValueToFront(files,"bean.proto");
        
        if (files.Length == 0)
        {
            Debug.LogError("没有找到协议文件");
            return;
        }
        allMsgItems.Clear();
        List<Root> protoDatas = new List<Root>();
        foreach (var file in files)
        {
            string content = File.ReadAllText(file);
            GeneratedZhushi(content);
            string json = ParseProto(content, Path.GetFileNameWithoutExtension(file));

            if (string.IsNullOrEmpty(json))
            {
                Debug.LogError("解析proto文件错误:" + content);
                return;
            }
            Root protoData = JsonConvert.DeserializeObject<Root>(json);
            protoDatas.Add(protoData);
        }

        rootPath = Application.dataPath + "/LuaScripts/Logic/Protoc/MsgId.lua";
        GeneratedMap(protoDatas);
    }
    
    
    public static void MoveValueToFront(string[] array, string value)
    {
        // 查找值的索引
        int index = -1;
        string file = "";
        for (int i = 0; i < array.Length; i++)
        {
            if (Path.GetFileNameWithoutExtension(array[i])==value)
            {
                index = i;
                file = array[i];
                break;
            }
        }
        if (index >= 0)
        {
            // 将值及其后面的元素向前移动
            for (int i = index; i > 0; i--)
            {
                array[i] = array[i - 1];
            }
            // 将原来数组的第一个位置设置为该值
            array[0] = file;
        }
    }
    
    
    private static string E_MsgID = "E_MsgID";
    private static string _msgID = "msgID";
    public class PBData
    {
        public string msgName;
        public long msgId;
    }
    
    public class PBZhuShi
    {
        public string msgName;
        public string zhushi;
    }

    private static Dictionary<string, PBZhuShi> allMsgItems = new Dictionary<string, PBZhuShi>();
    private static void GeneratedZhushi(string textContent)
    {
        Regex regex = new Regex(@"(?m)^\s*//\s*(.*?)\r?\n^\s*message\s+(\w+)\s*\{", RegexOptions.Multiline);
        MatchCollection matches = regex.Matches(textContent);

        foreach (Match match in matches)
        {
            string comment = match.Groups[1].Value.Trim();
            string messageName = match.Groups[2].Value;
            PBZhuShi zhushi = new PBZhuShi();
            zhushi.msgName = messageName;
            zhushi.zhushi = comment;
            if (!allMsgItems.ContainsKey(messageName))
            {
                allMsgItems.Add(messageName,zhushi);
            }
        }
    }
    
    
    static void GeneratedMap(List<Root> protoDatas)
    {
        List<PBData> msgIdDatas = new List<PBData>();
        List<int> msgIdNumbers = new List<int>();
        List<string> msgIdNames = new List<string>();
        List<string> pbNames=new List<string>();

        //Dictionary<string, List<ProtoField>> enumMap = new Dictionary<string, List<ProtoField>>();
    
        foreach (var protoData in protoDatas)
        {
            string pName = protoData.name.Replace(".proto","");
            if (!pbNames.Contains(pName))
            {
                pbNames.Add(pName);
            }
            if (protoData.message_type==null)
            {
                Debug.LogError("未找到定义的message_type:" + protoData.name);
                continue;
            }
            foreach (Message_typeItem messageItem in protoData.message_type)
            {
                if (messageItem.enum_type==null)
                {
                    Debug.LogError("未找到定义的enum_type:" + protoData.name+" --messageName："+messageItem.name);
                    continue;
                }
                
                Enum_typeItem item=messageItem.enum_type.FirstOrDefault(o => E_MsgID.Equals(o.name));
                if (item==null)
                {
                    Debug.LogError("未找到定义的enum_type:" + protoData.name+" --messageName："+messageItem.name);
                    return;
                }

                int msgID = item.value.FirstOrDefault((o => _msgID.Equals(o.name))).number;
                if (msgID == 0) continue;
                string msgName = messageItem.name;
                if (msgIdNames.Contains(msgName))
                {
                    Debug.LogError("重复的消息Id名字:" + msgName);
                    return;
                }
                if (msgIdNumbers.Contains(msgID))
                {
                    Debug.LogError("重复的消息Id值:" + msgName + "=" + msgID);
                    return;
                }
                msgIdNames.Add(msgName);
                msgIdNumbers.Add(msgID);
                PBData data = new()
                {
                    msgName = msgName,
                    msgId = msgID,
                };
                msgIdDatas.Add(data);
                
            }
        }
    
        string msgIdContent = "\n";
        string msgMapConent = "\n";
        string msgFileContent = "\n";
        if (msgIdDatas.Count == 0)
        {
            Debug.LogError("没有找到消息id");
            return;
        }
        msgIdDatas = msgIdDatas.OrderBy(a => a.msgId).ToList();
        foreach (var v in msgIdDatas)
        {
            string zs = v.msgName;
            if (allMsgItems.ContainsKey(v.msgName))
            {
                PBZhuShi pbzhus = allMsgItems[v.msgName];
                if (pbzhus!=null)
                    zs = pbzhus.zhushi;
            }
            zs = "--- " + zs;
            string msgId ="\n"+ zs+"\nMsgId." + v.msgName + " = " + v.msgId;
            string map = string.Format("\nPbMsg[{0}] = '{1}'", v.msgId, v.msgName);
            msgIdContent += msgId;
            msgMapConent += map;
        }

        foreach (var v in pbNames)
        {
            string msg = string.Format("\nPBHelper.LoadPB('{0}')", v);
            msgFileContent += msg;
        }
        
        string content = "--生成的代码不要手动去修改!"+"\nMsgId={}"+ msgIdContent +"\nPbMsg={}"+ msgMapConent+msgFileContent;
        if (File.Exists(rootPath))
        {
            File.Delete(rootPath);
        }
        File.WriteAllText(rootPath, content);
        AssetDatabase.Refresh();
        Debug.Log("生成完成");
    }


    
    static string ParseProto(string content, string name)
    {
        var luaEnv = XLuaManager.Instance.InitEditorLuaEnv();
        string luacode = "json = require 'xLua/json/json' function load(content,name) return json.encode(require('Logic/Protoc/protoc'):parse(content,name)) end";
        luaEnv.DoString(luacode);
        var func = luaEnv.Global.Get<LuaFunction>("load");
        object[] objs = func.Call(content, name);
        if (objs == null || objs.Length == 0)
            return string.Empty;
        return objs[0].ToString();
    }


}