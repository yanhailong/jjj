using System;
using System.Collections;
using System.Collections.Generic;
using TMPro;
using UnityEngine;
using UnityEngine.UI;
public class TMPClick : MonoBehaviour
{
    private Button _button;
    private TMP_Text _text;
    private void Awake()
    {
        _text=this.GetComponent<TMP_Text>();
        _button = this.GetComponent<Button>();
        if (_button==null)
        {
            _button = this.gameObject.AddComponent<Button>();
        }
        _button.onClick.AddListener(() =>
        {
            XLuaManager.Instance.OnClickTMPTips(_text);
        });
    }
}
