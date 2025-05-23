using System;
using System.Collections;
using System.IO;
using UnityEngine;
using UnityEngine.UI;
using YooAsset;
public class PreLoading
{
    private GameLancher gameLanucher;
    private AssetBundle loadingBundle=null;
    private LoadingPanel loadingPanel;
    private TipsPanel tipsPanel;

    private float curUpdateProgress = 0;//当前更新进度
    private float tempUpdateProgress = 0;//当前更新进度
    private Coroutine updateProgressCor;

    public PreLoading(GameLancher gameLanucher)
    {
        this.gameLanucher = gameLanucher;
        this.gameLanucher.StartCoroutine(InitPanel());
    }
    /// <summary>
    /// 设置版本信息
    /// </summary>
    /// <param name="version"></param>
    public void SetVersion(string version)
    {
        loadingPanel.SetVersion(version);
    }

    /// <summary>
    /// 设置loading文本描述
    /// </summary>
    /// <param name="desc"></param>
    /// <param name="activePorText">是否隐藏进度Text</param>
    public void SetDesc(string desc, int state, bool activePorText = false)
    {
        loadingPanel.SetDesc(desc, state, activePorText);
    }
    /// <summary>
    /// 设置进度条
    /// </summary>
    /// <param name="v"></param>
    public void SetSlider(float v)
    {
        loadingPanel.SetSlider(v);
    }

    /// <summary>
    /// 更新进度
    /// </summary>
    /// <param name="updateFinishedSize"></param>
    /// <param name="updateTotalSize"></param>
    public void UpdateProgress(int updateFinishedSize, int updateTotalSize)
    {
        if (updateProgressCor != null)
        {
            curUpdateProgress = tempUpdateProgress;
            this.gameLanucher.StopCoroutine(updateProgressCor);
        }
        updateProgressCor = this.gameLanucher.StartCoroutine(UpdateProgressCor(updateFinishedSize, updateTotalSize));
    }

    private IEnumerator UpdateProgressCor(int updateFinishedSize, int updateTotalSize)
    {
        
        float time = Time.time;
        while (true)
        {
            float dt = Time.time - time;
            if (dt >= UpdateAssets.updateSizeTime) break;
            tempUpdateProgress = Mathf.Lerp(curUpdateProgress, updateFinishedSize, dt / UpdateAssets.updateSizeTime);
            loadingPanel.SetSlider(tempUpdateProgress / updateTotalSize);
            yield return null;
        }
        updateProgressCor = null;
        tempUpdateProgress = updateFinishedSize;
        curUpdateProgress = tempUpdateProgress;
        loadingPanel.SetSlider(tempUpdateProgress / updateTotalSize);
    }

    /// <summary>
    /// 设置显示提示信息
    /// </summary>
    /// <param name="msg"></param>
    /// <param name="sure"></param>
    /// <param name="close"></param>
    public void SetTipsInfo(string msg, Action sure, Action close)
    {
        tipsPanel.SetInfo(msg, sure, close);
    }
    
    /// <summary>
    /// 关闭界面
    /// </summary>
    /// <param name="delay"></param>
    public void Close(float delay = 0)
    {
        if (updateProgressCor != null)
        {
            this.gameLanucher.StopCoroutine(updateProgressCor);
        }
        if (delay == 0)
        {
            Destory();
        }
        else
        {
            gameLanucher.StartCoroutine(DelayClose(delay));
        }
    }
    private IEnumerator DelayClose(float delay)
    {
        yield return new WaitForSeconds(delay);
        Destory();
    }
    private void Destory()
    {
        GameObject.Destroy(this.loadingPanel.GetLoadingObj());
        if (loadingBundle != null)
        {
            loadingBundle.Unload(true);
            loadingBundle = null;
        }
    }
    
    private IEnumerator InitPanel()
    {
        Transform uiRoot = GameObject.Find("Global_UI/Canvas/Layer2").transform;
        string panelPath = "preloading/uipreloading.unity3d";
        string dataPath = null;
        //判断是否释放资源到磁盘
        GameObject panel = null;
        dataPath = AppConst.AssetLocalPath;
        if (File.Exists(dataPath + panelPath))
        {
            //加载loading界面
            AssetBundleCreateRequest www = AssetBundle.LoadFromFileAsync(dataPath + panelPath);
            yield return www;
            loadingBundle = www.assetBundle;
            if (loadingBundle != null)
                panel = loadingBundle.LoadAsset<GameObject>("uipreloading");
            else
            {
                Debug.LogError("初始化资源出错");
                panel = Resources.Load<GameObject>("PreLoading/UIPreloading");
            }
        }
        else
        {
            panel = Resources.Load<GameObject>("PreLoading/UIPreloading");
        }
        GameObject m_loadingpanel= GameObject.Instantiate(panel, uiRoot);
        m_loadingpanel.transform.localScale = Vector3.one;
        m_loadingpanel.transform.localPosition = Vector3.zero;
        m_loadingpanel.transform.localEulerAngles = Vector3.zero;
        if (loadingBundle!=null)
        {
            loadingBundle.Unload(false);
        }
        loadingPanel = new LoadingPanel(m_loadingpanel.transform);
        tipsPanel = new TipsPanel(loadingPanel.GetTipsPanel());
        gameLanucher.LoadingPanelLoadFinished(this);
    }



    //资源加载界面
    private class LoadingPanel
    {
        private Text txt_version;
        private Text txt_por;
        private Text txt_desc;
        private Slider sli_por;
        private Transform trans;
        private GameObject obj_bottomSilder;
        private Transform obj_tipsPanel;
        private bool isGetComponentSuccess = false;

        public LoadingPanel(Transform panel)
        {
            this.trans = panel;
            txt_version = trans.Find("txt_version").GetComponent<Text>();
            txt_desc = trans.Find("bottom/txt_desc").GetComponent<Text>();
            txt_por = trans.Find("bottom/txt_por").GetComponent<Text>();
            sli_por = trans.Find("bottom/sli_por").GetComponent<Slider>();
            obj_bottomSilder = panel.Find("bottom").gameObject;
            obj_tipsPanel = trans.Find("tipsPanel");
            isGetComponentSuccess = true;
        }

        public void SetVersion(string version)
        {
            if (!this.isGetComponentSuccess)
                return;
            this.txt_version.text = version;
        }

        public void SetDesc(string desc, int state, bool activePorText = false)
        {
            if (!this.isGetComponentSuccess)
                return;
            obj_bottomSilder.SetActive(state != 0);
            this.txt_desc.text = desc;
            if (activePorText)
                txt_por.text = "";
        }

        public void SetSlider(float v)
        {
            if (!this.isGetComponentSuccess)
                return;
            this.sli_por.value = v;
            this.txt_por.text = (v * 100).ToString("F1") + "%";
        }
        public Transform GetTipsPanel()
        {
            return obj_tipsPanel;
        }
        public GameObject GetLoadingObj()
        {
            return this.trans.gameObject;
        }
    }

    //提示界面
    private class TipsPanel
    {
        public Text txt_msg;
        public Button btn_close;
        public Button btn_sure;
        private Action sure;
        private Action close;
        private Transform trans;

        public TipsPanel(Transform panel)
        {
            this.trans = panel;
            txt_msg = trans.Find("view/txt_msg").GetComponent<Text>();
            btn_sure= trans.Find("view/btn_sure").GetComponent<Button>();
            btn_sure.onClick.AddListener(ClickSure);
            //btn_close.onClick.AddListener(ClickClose);
        }

        private void ClickClose()
        {
            this.trans.gameObject.SetActive(false);
            if (this.close != null)
                this.close();

        }

        private void ClickSure()
        {
            this.trans.gameObject.SetActive(false);
            if (this.sure != null)
                this.sure();
        }

        public void SetInfo(string msg, Action sure, Action close)
        {
            this.trans.gameObject.SetActive(true);
            this.txt_msg.text = msg;
            this.sure = sure;
            this.close = close;
        }
    }
}
