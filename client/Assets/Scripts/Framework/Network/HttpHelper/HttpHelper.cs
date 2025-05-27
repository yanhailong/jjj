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
    public void PostUri(string url, string data, Action<string> callback, string header = null)
    {
        StartCoroutine(PostCoroutine(url, data, callback, header));
    }

    private IEnumerator PostCoroutine(string url, string data, Action<string> callback, string header = null)
    {
        using (UnityWebRequest request = new UnityWebRequest(url, "POST"))
        {
            byte[] bodyRaw = Encoding.UTF8.GetBytes(data);
            request.uploadHandler = new UploadHandlerRaw(bodyRaw);
            request.downloadHandler = new DownloadHandlerBuffer();
            request.SetRequestHeader("Content-Type", "application/json;charset=utf-8");
            if (!string.IsNullOrEmpty(header))
                request.SetRequestHeader("Authorization", header);

            yield return request.SendWebRequest();

            if (request.result == UnityWebRequest.Result.Success)
            {
                callback?.Invoke(request.downloadHandler.text);
            }
            else
            {
                Debug.LogError($"HTTP POST Error: {request.error} - {url}");
                callback?.Invoke("FailPost");
            }
        }
    }

    public void RequestUrlTex(string url, Action<Texture2D> callback)
    {
        StartCoroutine(DownloadTextureCoroutine(url, callback));
    }

    private IEnumerator DownloadTextureCoroutine(string url, Action<Texture2D> callback)
    {
        using (UnityWebRequest request = UnityWebRequestTexture.GetTexture(url))
        {
            yield return request.SendWebRequest();

            if (request.result == UnityWebRequest.Result.Success)
            {
                Texture2D texture = ((DownloadHandlerTexture)request.downloadHandler).texture;
                callback?.Invoke(texture);
            }
            else
            {
                Debug.LogError($"Download Texture Failed: {request.error} - {url}");
                callback?.Invoke(null);
            }
        }
    }

    public void DownLoadFile(string url, string savePath, Action<object> callback = null)
    {
        StartCoroutine(DownloadFileCoroutine(url, savePath, callback));
    }

    private IEnumerator DownloadFileCoroutine(string url, string savePath, Action<object> callback = null)
    {
        using (UnityWebRequest webRequest = UnityWebRequest.Get(url))
        {
            yield return webRequest.SendWebRequest();

            if (webRequest.result == UnityWebRequest.Result.Success)
            {
                string dirName = Path.GetDirectoryName(savePath);
                if (!Directory.Exists(dirName))
                    Directory.CreateDirectory(dirName);

                File.WriteAllBytes(savePath, webRequest.downloadHandler.data);
                callback?.Invoke(savePath);
            }
            else
            {
                Debug.LogError($"Download File Failed: {webRequest.error} - {url}");
                callback?.Invoke(null);
            }
        }
    }
}
