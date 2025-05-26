using System;
using System.Collections;
using System.IO;
using System.Text;
using JiuJiuPrincess;
using UnityEngine;
using UnityEngine.Networking;
using XLua;

public class HttpHelper : SingletonMono<HttpHelper>
{
    public void PostUri(string url, string md5String, Action<string> call, string header = null)
    {
        StartCoroutine(Post(url, md5String, call, header));
    }

    IEnumerator Post(string url, string data, Action<string> callback, string header = null)
    {
        UnityWebRequest request = PostJson(url, data, header);
        yield return request.SendWebRequest();
        if (request.result == UnityWebRequest.Result.Success)
        {
            callback?.Invoke(request.downloadHandler.text);
            yield break;
        }
        Debug.LogError("UnityWebRequest请求错误：" + request.error);
        callback?.Invoke("FailPost");
    }

    private UnityWebRequest PostJson(string url, string data, string header = null)
    {
        UnityWebRequest request = new UnityWebRequest(url, "POST");
        request.SetRequestHeader("Content-Type", "application/json;charset=utf-8");
        if (header != null)
            request.SetRequestHeader("Authorization", header);
        request.downloadHandler = new DownloadHandlerBuffer();
        request.uploadHandler = new UploadHandlerRaw(Encoding.UTF8.GetBytes(data));
        return request;
    }
    public void RequestUrlTex(string url, Action<Texture2D> callback)
    {
        StartCoroutine(DownloadPic(url, callback));
    }


    IEnumerator DownloadPic(string url, Action<Texture2D> callback)
    {
        using (UnityWebRequest request = UnityWebRequestTexture.GetTexture(url))
        {
            yield return request.SendWebRequest();
            if (request.result == UnityWebRequest.Result.Success)
            {
                Texture2D texture = (request.downloadHandler as DownloadHandlerTexture)?.texture;
                callback?.Invoke(texture);
            }
            else
            {
                Debug.LogError(string.Format("{0}--->{1}", request.error, url));
            }
        }
    }

    public void DownLoadFile(string url, string savePath, Action<object> call = null)
    {
        StartCoroutine(IDownLoadFile(url, savePath, call));
    }

    private IEnumerator IDownLoadFile(string url, string savePath, Action<object> call = null)
    {
        UnityWebRequest webRequest = UnityWebRequest.Get(url);
        yield return webRequest.SendWebRequest();
        if (webRequest.result == UnityWebRequest.Result.Success)
        {
            string localPath = savePath;
            string dirName = Path.GetDirectoryName(localPath);
            if (!Directory.Exists(dirName))
                Directory.CreateDirectory(dirName);
            File.WriteAllBytes(localPath, webRequest.downloadHandler.data); //写入磁盘
            call?.Invoke(webRequest.downloadHandler.data);
        }
        else
        {
            Debug.LogError(webRequest.error);
        }
    }
}