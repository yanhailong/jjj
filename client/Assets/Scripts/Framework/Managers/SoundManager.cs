using UnityEngine;
using System.Collections;
using System.Collections.Generic;
using System.IO;
using YooAsset;

public class SoundManager : SingletonMono<SoundManager>
    {

        private AudioSource musicAudioSource;
        private AudioSource soundAudioSource;
        private Dictionary<string, AudioClip> sounds = new Dictionary<string, AudioClip>();

        public float musicVolume = 0.5f;
        public float soundVolume = 1f;


        void Start()
        {
            musicAudioSource = GetComponent<AudioSource>();
            if (musicAudioSource == null)
            {
                musicAudioSource = gameObject.AddComponent<AudioSource>();
            }
            musicAudioSource.loop = true;
            musicAudioSource.rolloffMode = AudioRolloffMode.Linear;

            soundAudioSource = new GameObject("soundAudioSource").AddComponent<AudioSource>();
            soundAudioSource.transform.SetParent(transform);
            soundAudioSource.loop = false;
            soundAudioSource.playOnAwake = false;
            soundAudioSource.rolloffMode = AudioRolloffMode.Linear;
            musicAudioSource.volume = musicVolume;
            soundAudioSource.volume = soundVolume;
        }

        /// <summary>
        /// 播放音效
        /// </summary>
        public void PlayClip(string name)
        {
            AudioClip clip = LoadClip(name);
            PlayClipByClip(clip);
        }

        /// <summary>
        /// 播放音效
        /// </summary>
        public void PlayClipByClip(AudioClip clip, bool isShot = true)
        {
            if (clip == null)
                return;
            if (isShot)
                soundAudioSource.PlayOneShot(clip);
            else
            {
                soundAudioSource.clip = clip;
                soundAudioSource.Play();
            }
        }

        public void StopSound()
        {
            soundAudioSource.clip = null;
            soundAudioSource.Stop();
        }

        public void PauseSound()
        {
            soundAudioSource.Pause();
        }

        public void UnPauseSound()
        {
            soundAudioSource.UnPause();
        }

        /// <summary>
        /// 切换背景音乐
        /// </summary>
        public void ChangeBg(string Abname)
        {
            AudioClip clip = LoadClip(Abname);
            ChangeBgClip(clip);
        }

        /// <summary>
        /// 切换背景音乐
        /// </summary>
        public void ChangeBgClip(AudioClip clip)
        {
            if (clip == null)
                return;
            if (musicAudioSource.clip != clip)
            {
                musicAudioSource.clip = clip;
                musicAudioSource.Play();
            }
        }

        /// <summary>
        /// 页面关闭时关闭当前页面背景音乐调用这个
        /// </summary>
        /// <param name="bundle"></param>
        public void CloseBg() 
        {
            musicAudioSource.Stop();
            musicAudioSource.clip = null;
        }

        /// <summary>
        /// 加载一个声音
        /// </summary>
        public AudioClip LoadClip(string Abname)
        {
            Abname = Abname.ToLower();
            if (sounds.ContainsKey(Abname))
            {
                if (sounds[Abname] == null)
                    sounds.Remove(Abname);
                else
                    return sounds[Abname];
            }
            string audname = Path.GetFileNameWithoutExtension(Abname);
            AudioClip aud =AssetsManager.Instance.LoadAsset<AudioClip>(Abname, audname);
            if (aud == null)
            {
                Debug.LogWarning(Abname + ":audio clip not fond！");
                return null;
            }
            sounds.Add(Abname, aud);
            return aud;
        }

        //设置音乐音量
        public void SetMusicVolume(float v)
        {
            musicVolume = v;
            musicAudioSource.volume = musicVolume;
        }

        //设置音效音量
        public void SetSoundVolume(float v)
        {
            soundVolume = v;
            soundAudioSource.volume = soundVolume;
        }
    }