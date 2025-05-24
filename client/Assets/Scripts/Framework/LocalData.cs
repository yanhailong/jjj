using System;
using System.Collections;
using System.IO;
using JiuJiuPrincess;

public class LocalData : Singleton<LocalData>
{
    private Hashtable localDataDic = new Hashtable();
    private const string fileName = "localData.cfg";
    private string content;
    public LocalData()
    {
        string path = AppConst.AssetLocalPath + fileName;
        LoadLocalData(path);
    }

    private void LoadLocalData(string path)
    {
        if (!File.Exists(path))
        {
            localDataDic = new Hashtable();
            content = localDataDic.toJson();
        }
        else
        {
            byte[] bts = File.ReadAllBytes(path);
            bts = Encypt.Decrypt(bts);
            content = System.Text.Encoding.UTF8.GetString(bts);
            localDataDic = content.hashtableFromJson();
        }
    }
    
    public string GetJsonByKey(string key)
    {
        if (localDataDic.ContainsKey(key))
        {
            return localDataDic[key].ToString();
        }
        return "";
    }
    
    public void Remove(string key)
    {
        if (localDataDic.ContainsKey(key))
        {
             localDataDic.Remove(key);
        }
        content = localDataDic.toJson();
        SaveToLocalCfg(content);
    }
    
    public void Save(string key,string json)
    {
        if (string.IsNullOrEmpty(json))
        {
            return;
        }
        localDataDic[key] = json;
        content = localDataDic.toJson();
        SaveToLocalCfg(content);
    }

    private void SaveToLocalCfg(string jsonContent)
    {
        string path = AppConst.AssetLocalPath + fileName;
        if (!Directory.Exists(AppConst.AssetLocalPath))
            Directory.CreateDirectory(AppConst.AssetLocalPath);
        byte[] bts = System.Text.Encoding.UTF8.GetBytes(jsonContent);
        bts = Encypt.Encrypt(bts);
        File.WriteAllBytes(path, bts);
    }
    
}
