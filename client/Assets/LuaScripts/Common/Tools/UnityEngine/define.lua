------------------unity常用系统类重定义
---
---
---@type FileUtil
FileUtil = CS.FileUtil
---@type JiuJiuPrincess.Util
Util = CS.JiuJiuPrincess.Util
---@type AssetManager
resMgr = CS.AssetManager.Instance
---@type LocalData
LocalData=CS.LocalData.Instance
---@type DG.Tweening.DOTween
DOTween = CS.DG.Tweening.DOTween
---@type DG
DG=CS.DG
---@type UnityEngine.QualitySettings
QualitySettings=CS.UnityEngine.QualitySettings
---@type UnityEngine.Application
Application = CS.UnityEngine.Application
---@type UnityEngine
UnityEngine=CS.UnityEngine
---@type UnityEngine.Debug
Debug = CS.UnityEngine.Debug
---@type UnityEngine.GameObject
GameObject = CS.UnityEngine.GameObject
---@type UnityEngine.Transform
Transform = CS.UnityEngine.Transform
---@type UnityEngine.RectTransform
RectTransform = CS.UnityEngine.RectTransform
---@type UnityEngine.Sprite
Sprite = CS.UnityEngine.Sprite
---@type UnityEngine.Texture2D
Texture2D = CS.UnityEngine.Texture2D
---@type UnityEngine.Texture
Texture = CS.UnityEngine.Texture
---@type UnityEngine.Renderer
Renderer = CS.UnityEngine.Renderer
---@type UnityEngine.Material
Material = CS.UnityEngine.Material
---@type UnityEngine.Animator
Animator = CS.UnityEngine.Animator
---@type UnityEngine.RuntimeAnimatorController
RuntimeAnimatorController = CS.UnityEngine.Networking.RuntimeAnimatorController
---@type UnityEngine.Animation
Animation = CS.UnityEngine.Animation
---@type UnityEngine.AnimationClip 
AnimationClip = CS.UnityEngine.AnimationClip
---@type UnityEngine.Networking.UnityWebRequest Unity UnityWebRequest
UnityWebRequest = CS.UnityEngine.Networking.UnityWebRequest
---@type UnityEngine.Font
Font = CS.UnityEngine.Font
---@type JiuJiuPrincess.AppConst 应用程序自定义数据
AppConst = CS.JiuJiuPrincess.AppConst
---@type UnityEngine.Random
Random = CS.UnityEngine.Random
---@type UnityEngine.Shader
Shader = CS.UnityEngine.Shader
---@type UnityEngine.LineRenderer
LineRenderer = CS.UnityEngine.LineRenderer
---@type UnityEngine.Camera
Camera = CS.UnityEngine.Camera
---@type UnityEngine.PlayerPrefs
PlayerPrefs = CS.UnityEngine.PlayerPrefs
----------------UGUI----------------------
---@type UnityEngine.UI.Image
Image = CS.UnityEngine.UI.Image
---@type UnityEngine.UI.RawImage
RawImage = CS.UnityEngine.UI.RawImage
---@type UnityEngine.UI.Text
Text = CS.UnityEngine.UI.Text
---@type UnityEngine.UI.Button
Button = CS.UnityEngine.UI.Button
---@type TMPro.TMP_Dropdown
TMP_Dropdown = CS.TMPro.TMP_Dropdown
---@type TMPro.TMP_InputField
TMP_InputField = CS.TMPro.TMP_InputField
---@type TMPro.TMP_Text
TMP_Text = CS.TMPro.TMP_Text
---@type TMPro
TMPro=CS.TMPro
---@type JiuJiuPrincess.LuaBytes
LuaBytes=CS.JiuJiuPrincess.LuaBytes.Instance
---@type JiuJiuPrincess.CommonConfigManager
CommonConfigManager=CS.JiuJiuPrincess.CommonConfigManager.Instance
---@type JiuJiuPrincess.UpdateAssets
UpdateAssets=CS.JiuJiuPrincess.UpdateAssets
-----------------------------------------end

Mathf = require "Common.Tools.UnityEngine.Mathf" -- CS.UnityEngine.Mathf
Vector2 = require "Common.Tools.UnityEngine.Vector2" -- CS.UnityEngine.Vector2
Vector3 = require "Common.Tools.UnityEngine.Vector3" -- CS.UnityEngine.Vector3
Vector4 = require "Common.Tools.UnityEngine.Vector4" -- CS.UnityEngine.Vector4
Quaternion = require "Common.Tools.UnityEngine.Quaternion" -- CS.UnityEngine.Quaternion
Color = require "Common.Tools.UnityEngine.Color" -- CS.UnityEngine.Color
Ray = require "Common.Tools.UnityEngine.Ray" -- CS.UnityEngine.Ray
Bounds = require "Common.Tools.UnityEngine.Bounds"
RaycastHit = require "Common.Tools.UnityEngine.RaycastHit" -- CS.UnityEngine.RaycastHit
Touch = require "Common.Tools.UnityEngine.Touch"
LayerMask = require "Common.Tools.UnityEngine.LayerMask"
Plane = require "Common.Tools.UnityEngine.Plane"
---@type UnityEngine.Time
Time = CS.UnityEngine.Time -- require "Common.Tools.UnityEngine.Time"            --CS.UnityEngine.Time
---@class Object
Object = require "Common.Tools.UnityEngine.Object"
---@type UnityEngine.Rect
Rect = CS.UnityEngine.Rect
---@type SoundManager
SoundManager=CS.SoundManager.Instance

