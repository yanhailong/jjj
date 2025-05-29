require("Common/Utils/StringUtil")
Tools = {}
local this = Tools

---是否显示游戏对象
function this.SetActive(go, active)
    if go == nil then
        return
    end
    if go.activeSelf == nil then
        logError("activeSelf is nil")
        return
    end

    if go.activeSelf ~= active then
        go:SetActive(active)
    end
end

function this.SetParent(t, parent, isReset)
    if t == nil then
        logError("transform is nil")
        return
    end
    if t.parent ~= parent then
        t:SetParent(parent)
    end
    if isReset then
        t.localPosition = Vector3.zero
        t.localScale = Vector3.one
        t.localEulerAngles = Vector3.zero
    end
end

---@return UnityEngine.GameObject
function this.Instance(obj)
    local newObj = GameObject.Instantiate(obj)
    if newObj.transform ~= nil then
        this.SetParent(newObj.transform, obj.transform.parent)
        newObj.transform.localScale = obj.transform.localScale
        newObj.transform.localEulerAngles = obj.transform.localEulerAngles
        newObj.transform.localPosition = obj.transform.localPosition
        Tools.SetActive(newObj.gameObject, true)
        newObj.gameObject.name = obj.gameObject.name
    end
    return newObj
end
function this.Instance(obj, parent)
    local newObj = GameObject.Instantiate(obj)
    this.SetParent(newObj.transform, parent, true)
    Tools.SetActive(newObj.gameObject, true)
    newObj.gameObject.name = obj.gameObject.name
    return newObj
end

---设置Image的Sprite
function this.SetImageSprite(img, sprite, isNotReset)
    if img.sprite == sprite then
        return
    end
    img.sprite = sprite
    if not isNotReset then
        img:SetNativeSize()
    end
end

function this.SetRawImage(rawImg, tex, isNotReset)
    if rawImg.texture == tex then
        return
    end
    rawImg.texture = tex
    if not isNotReset then
        rawImg:SetNativeSize()
    end
end

---销毁游戏对象
function this.Destroy(obj, time)
    if isnull(obj) then
        return
    end
    if time and type(time) == "number" then
        GameObject.Destroy(obj, time)
    else
        GameObject.Destroy(obj)
    end
    DOTween.KillAll()
end

---@return UnityEngine.Transform
function this.TransFind(obj, path)
    return obj:TransFind(path)
end

---数字分割
function this.NumberFormat(num, deperator)
    local startStr = ""

    if num < 0 then
        num = -num
        startStr = "-"
    end

    local str1 = ""
    local str = tostring(num)
    local strLen = string.len(str)

    if deperator == nil then
        deperator = ","
    end
    deperator = tostring(deperator)

    for i = 1, strLen do
        str1 = string.char(string.byte(str, strLen + 1 - i)) .. str1
        if i % 3 == 0 then
            if strLen - i ~= 0 then
                str1 = "," .. str1
            end
        end
    end
    return startStr .. str1
end

function this.GoldNumberTextFormat(num)
    return tostring(num)
end

-- 数字转换成字符串 如 10000=>1万
function Tools.NumberConvertStr(number, fl, ext)
    if number < 10000 and number > -10000 then
        return number .. ""
    end
    fl = fl or 10
    if number < 100000000 then
        return (math.floor((number / 10000) * fl) / fl) .. "万"
    else
        return (math.floor((number / 100000000) * fl) / fl) .. "亿"
    end
end

-- 数字转换成字符串 如 10000=>1万
function Tools.NumberConvertExt(number, fl, ext)
    if number < 10000 and number > -10000 then
        return number .. ""
    end
    fl = fl or 10
    ext = ext or "万"
    return (math.floor((number / 10000) * fl) / fl) .. ext
end

---字符限制 超过限制的用deperator显示
function this.TextLimit(text, limit, deperator)
    if text == nil then
        return ""
    end
    if deperator == nil then
        deperator = "..."
    end
    local count = 0
    local str = string.gmatch(text, "([%z\1-\127\194-\244][\128-\191]*)")
    local newStr = ""
    for uchar in str do
        if #uchar ~= 1 then
            count = count + 2
        else
            count = count + 1
        end
        if limit < count then
            return newStr .. deperator
        end
        newStr = newStr .. uchar
    end
    return newStr
end

---取两位小数
function this.NumberConvertDot2Str(number)
    if number == nil then
        return "0"
    end
    local int = math.floor(number)
    if string.len(tostring(int)) - string.len(tostring(number)) > -2 then
        return tostring(number)
    end
    return string.format("%.2f", number)
end

---获取整形随机数 包含max
function this.RandomInt(min, max)
    return math.floor(UnityEngine.Random.Range(min, max + 1))
end

function this.Random(min, max)
    return UnityEngine.Random.Range(min, max + 1)
end

-- 获取保存的字符串
function this.GetString(key)
    if UnityEngine.PlayerPrefs.HasKey(key) then
        return UnityEngine.PlayerPrefs.GetString(key)
    else
        return nil
    end
end

-- 保存字符串
function this.SaveString(key, value)
    UnityEngine.PlayerPrefs.SetString(key, value)
    UnityEngine.PlayerPrefs.Save()
end

function this.DeletePlayerPrefs(key)
    UnityEngine.PlayerPrefs.DeleteKey(key)
end

-- 获取保存的整形值
function this.GetInt(key)
    if UnityEngine.PlayerPrefs.HasKey(key) then
        return UnityEngine.PlayerPrefs.GetInt(key)
    else
        return nil
    end
end
-- 保存整形值
function this.SaveInt(key, value)
    UnityEngine.PlayerPrefs.SetInt(key, value)
    UnityEngine.PlayerPrefs.Save()
end

-- 保存Float值
function this.SaveFloat(key, value)
    UnityEngine.PlayerPrefs.SetFloat(key, value)
    UnityEngine.PlayerPrefs.Save()
end

-- 保存Float值
function this.GetFloat(key)
    if UnityEngine.PlayerPrefs.HasKey(key) then
        return UnityEngine.PlayerPrefs.GetFloat(key)
    else
        return nil
    end
end

local numChar = {
    [0] = "零",
    "壹",
    "贰",
    "叁",
    "肆",
    "伍",
    "陆",
    "柒",
    "捌",
    "玖",
    "拾"
}
local numChar1 = {
    "",
    "拾",
    "佰",
    "仟",
    "万",
    "拾",
    "佰",
    "仟",
    "亿",
    "拾",
    "佰",
    "仟",
    "兆",
    "拾",
    "佰",
    "仟"
}
function Tools.NumConvertChinese(number)
    local numStr = tostring(number)
    local len = string.len(numStr)
    if len == 1 or number == 10 then
        if number == 0 then
            return "零"
        end
        return numChar[number]
    end
    local lastSubNum

    local cStr = ""
    for i = 1, len do
        local wi = len - i + 1
        local subNum = tonumber(string.sub(numStr, i, i))
        if subNum ~= 0 then
            if lastSubNum == 0 then
                cStr = cStr .. "零"
            end
            cStr = cStr .. numChar[subNum] .. numChar1[wi]
        else
            if wi == 1 or wi == 5 or wi == 9 or wi == 13 then
                cStr = cStr .. numChar1[wi]
            end
        end
        lastSubNum = subNum
    end
    return cStr
end

-- region 坐标转换
local mCanvasTrans
local mCanvasScaler
local screenWidth = 1920
local screenHeight = 1080
local ReferenceScreenWidth = 960
local ReferenceScreenHeight = 640
local mScaleFactorW = -1
local mScaleFactorH = -1
local rawUIWidth
local rawUIHeight

function this.ConvertPosInit()
    if mCanvasScaler == nil then
        screenWidth = UnityEngine.Screen.width
        screenHeight = UnityEngine.Screen.height
        mCanvasScaler = UnityEngine.GameObject.Find("Global_UI/Canvas"):GetComponent("CanvasScaler")
        mCanvasTrans = UnityEngine.GameObject.Find("Global_UI/Canvas").transform
        ReferenceScreenWidth = mCanvasScaler.referenceResolution.x
        ReferenceScreenHeight = mCanvasScaler.referenceResolution.y
        mScaleFactorW = ReferenceScreenWidth / screenWidth
        mScaleFactorH = ReferenceScreenHeight / screenHeight
        rawUIWidth = ReferenceScreenWidth * mScaleFactorW
        rawUIHeight = ReferenceScreenHeight * mScaleFactorH
    end
end

function this.GetUISceneScale()
    this.ConvertPosInit()
    local f = (1 - mCanvasScaler.matchWidthOrHeight) * mScaleFactorW + mCanvasScaler.matchWidthOrHeight * mScaleFactorH
    return f
end

function this.MousePosToUIPos(pos)
    this.ConvertPosInit()
    pos.y =
        (pos.y - screenHeight * 0.5) *
        ((1 - mCanvasScaler.matchWidthOrHeight) * mScaleFactorW + mCanvasScaler.matchWidthOrHeight * mScaleFactorH)
    pos.x =
        (pos.x - screenWidth * 0.5) *
        ((1 - mCanvasScaler.matchWidthOrHeight) * mScaleFactorW + mCanvasScaler.matchWidthOrHeight * mScaleFactorH)
    return pos
end

-- 世界坐标转屏幕坐标
function this.WorldToUIPos(pos)
    if mCanvasTrans == nil then
        mCanvasTrans = UnityEngine.GameObject.Find("Global_UI/Canvas").transform
    end
    return pos / mCanvasTrans.localScale.x
end

function this.GetUIWidth()
    this.ConvertPosInit()
    return this.GetCanvasSize().x
end

function this.GetUIHeight()
    this.ConvertPosInit()
    return this.GetCanvasSize().y
end

function this:InitDateDrop(drop)
    local curYear, curMonth = this.GetCurrTime()
    local year1, month1 = this.AddMouth(curYear, curMonth, -1)
    local year2, month2 = this.AddMouth(curYear, curMonth, -2)
    local date = {
        {
            year = curYear,
            month = curMonth
        },
        {
            year = year1,
            month = month1
        },
        {
            year = year2,
            month = month2
        }
    }
    drop:AddStringOptions(
        {
            curYear .. "年" .. curMonth .. "月",
            year1 .. "年" .. month1 .. "月",
            year2 .. "年" .. month2 .. "月"
        }
    )
    return date
end

-- endregion

---深度拷贝table
function this.CopyTable(obj)
    local lookup_table = {}
    local function _copy(object)
        if type(object) ~= "table" then
            return object
        elseif lookup_table[object] then
            return lookup_table[object]
        end
        local new_table = {}
        lookup_table[object] = new_table
        for key, value in pairs(object) do
            new_table[_copy(key)] = _copy(value)
        end
        return new_table
    end
    return _copy(obj)
end

---浅拷贝table
function this.CopyTableTo(obj)
    if type(obj) ~= "table" then
        return nil
    end
    local newTable = {}
    for key, value in pairs(obj) do
        newTable[key] = value
    end
    return newTable
end

function this.SetImageTextNum(txt, num, fontMax, fontMinus)
    if num >= 0 then
        txt.font = fontMax
        if num == 0 then
            txt.text = tostring(num)
        else
            txt.text = "+" .. tostring(num)
        end
    else
        txt.font = fontMinus
        txt.text = tostring(num)
    end
end

-- 获取UICamera
---@return UnityEngine.Camera
function this.GetUICamera()
    if this.uiCamera == nil then
        this.uiCamera = GameObject.Find("Global/UICamera"):GetComponent("Camera")
    end
    return this.uiCamera
end

-- 截取UI全屏图
function this.CaptureUI(w, h, scale)
    local targetCamera = this.GetUICamera()
    scale = scale or 1
    if w == nil then
        w = UnityEngine.Screen.width * scale
    else
        w = w * scale
    end
    if h == nil then
        h = UnityEngine.Screen.height * scale
    else
        h = h * scale
    end
    local myRenderTexture = UnityEngine.RenderTexture.GetTemporary(w, h, 24)
    targetCamera.targetTexture = myRenderTexture
    targetCamera:Render()
    UnityEngine.RenderTexture.active = myRenderTexture
    local CaptureImage = UnityEngine.Texture2D.New(w, h, UnityEngine.TextureFormat.RGB24, false)
    CaptureImage:ReadPixels(UnityEngine.Rect.New(0, 0, w, h), 0, 0)
    CaptureImage:Apply()

    targetCamera.targetTexture = nil
    UnityEngine.RenderTexture.active = nil
    UnityEngine.RenderTexture.ReleaseTemporary(myRenderTexture)

    return CaptureImage, w, h
end

function this.Clamp(value, min, max)
    if value < min then
        return min
    end
    if value > max then
        return max
    end
    return value
end

-- a到b的差值
function this.Lerp(a, b, t)
    t = this.Clamp(t, 0, 1)
    return a + (b - a) * t
end

---获取平台类型
function this.GetPlatformType()
    local platformName = AppConst.PlatformName
    local accountType=-1
    if platformName == "Android" then
        accountType = 1
    elseif platformName == "iOS" then
        accountType = 2
    elseif platformName == "webgl" then
        accountType = 3
    end
    return accountType
end
---@param tex UnityEngine.Texture2D
---@return UnityEngine.Texture2D
function this.TextureResizer(tex, size)
    -- tex.filterMode = CS.UnityEngine.FilterMode.Point
    -----@type UnityEngine.RenderTexture
    -- local rt = CS.UnityEngine.RenderTexture.GetTemporary(size.x, size.y)
    -- rt.filterMode = CS.UnityEngine.FilterMode.Point
    -- CS.UnityEngine.RenderTexture.active = rt
    -- CS.UnityEngine.Graphics.Blit(tex, rt)
    -- local newTex = Texture2D(size.x, size.y)
    -- newTex:ReadPixels(Rect(0, 0, size.x, size.y), 0, 0)
    -- newTex:Apply()
    -- CS.UnityEngine.RenderTexture.active = nil
    -- return newTex
    local min = tex.width > tex.height and tex.height or tex.width
    local resultTexture = Texture2D(min, min, UnityEngine.TextureFormat.RGBA4444, true)
    local texStartPos = UnityEngine.Vector2Int()
    texStartPos.x = tex.width / 2 - min / 2
    texStartPos.y = tex.height / 2 - min / 2
    texStartPos.x = texStartPos.x < 0 and 0 or texStartPos.x
    texStartPos.y = texStartPos.y < 0 and 0 or texStartPos.y
    local m_Colors = tex:GetPixels(texStartPos.x, texStartPos.y, resultTexture.width, resultTexture.height)
    resultTexture:SetPixels(m_Colors)
    resultTexture:Apply()
    return resultTexture
end

---@param tex UnityEngine.Texture2D
---@return Vector2
function this.GetTextureFullScreenSize(tex)
    local texSize = Vector2.New(tex.width, tex.height)
    local screenSize = Vector2.New(UnityEngine.Screen.width, UnityEngine.Screen.height)
    local widthRatio, heightRatio = texSize.x / screenSize.x, texSize.y / screenSize.y
    if widthRatio > heightRatio then
        return Vector2.New(screenSize.x, texSize.y / widthRatio)
    else
        return Vector2.New(texSize.x / heightRatio, screenSize.y)
    end
end

function this.GetOSTimeInterval(osTime1, osTime2)
    -- 两个时间戳（以秒为单位）
    local timestamp1 = math.floor(osTime1 * 0.001)
    local timestamp2 = math.floor(osTime2 * 0.001)
    -- 计算时间差异（以秒为单位）
    local diffSeconds = os.difftime(timestamp2, timestamp1)
    -- 转换为天、小时和秒
    local days = math.floor(diffSeconds / (24 * 60 * 60))
    diffSeconds = diffSeconds % (24 * 60 * 60)
    local hours = math.floor(diffSeconds / (60 * 60))
    diffSeconds = diffSeconds % (60 * 60)
    local minutes = math.floor(diffSeconds / 60)
    local seconds = math.floor(diffSeconds % 60)
    return days, hours, minutes, seconds
end

function this.GetTimeInterval(osTime1, osTime2)
    local osTime = math.abs(tonumber(osTime1) - tonumber(osTime2))
    local stepTime = osTime / (24 * 3600 * 1000)
    return math.ceil(stepTime)
end

function this.GetTimeIntervalSeconds(osTime1, osTime2)
    local timestamp1 = math.floor(osTime1 * 0.001)
    local timestamp2 = math.floor(osTime2 * 0.001)
    local osTime = math.abs(tonumber(timestamp1) - tonumber(timestamp2))
    return math.ceil(osTime)
end

function this.AddMouth(year, mouth, add)
    local resultYear, resultMouth = year, mouth
    resultMouth = mouth + add
    if resultMouth > 12 then
        resultYear = resultYear + resultMouth // 12
        resultMouth = resultMouth % 12
    elseif resultMouth < 1 then
        resultYear = resultYear - resultMouth // -12 - 1
        resultMouth = resultMouth % -12 + 12
    end
    return resultYear, resultMouth
end

function this.GetCurrTime()
    local year = tonumber(os.date("%Y", os.time()))
    local mouth = tonumber(os.date("%m", os.time()))
    local day = tonumber(os.date("%d", os.time()))
    local hour = tonumber(os.date("%H", os.time()))
    local min = tonumber(os.date("%M", os.time()))
    local sec = tonumber(os.date("%S", os.time()))
    return year, mouth, day, hour, min, sec
end
--- 默认%Y-%m-%d %H:%M  全部%Y-%m-%d %H:%M:%S
function this.GetDateStr(millisecond, format)
    return os.date(format or "%Y-%m-%d %H:%M", math.modf(millisecond / 1000))
end

function this.GetServerTime()
    return math.modf(ServerTimeSync:GetTimeStamp() / 1000)
end

function this.GetServerTimeMillisecond()
    return ServerTimeSync:GetTimeStamp()
end

function this.MD5BodyStr(body, sessionPre16)
    -- 序列化body
    local function sortFunc(tab)
        local keyList = {}
        for k in pairs(tab) do
            table.insert(keyList, k)
        end
        table.sort(
            keyList,
            function(a, b)
                return (a < b)
            end
        )
        local str = ""
        for _, key in pairs(keyList) do
            local k = type(key) == "number" and "" or key
            local val = tab[key]
            if type(val) == "table" then
                str = str .. k .. sortFunc(val)
            elseif type(val) == "boolean" then
                if tab[k] then
                    str = str .. k .. "true"
                else
                    str = str .. k .. "false"
                end
            else
                str = str .. k .. val
            end
        end
        return str
    end
    local str = sortFunc(body)
    local sessionPre16 = sessionPre16 -- session前16位
    local perMd5Str = str .. sessionPre16
    -- look("perMd5Str",perMd5Str)
    local sign = Util.md5(perMd5Str)
    return sign
end

function this.AddSecretKey(data)
    if data.phoneId then
        return data.phoneId .. StringUtil.SubUTF8String(data.phoneId, 1, 5)
    end
    if data.session then
        return StringUtil.SubUTF8String(data.session, 1, 16)
    end
    if data.deviceId then
        return StringUtil.SubUTF8String(data.deviceId, 1, 16)
    end
end
function this.DicToTable(CSharpDic)
    -- 将C#的Dic转成Lua的Table
    local dic = {}
    if CSharpDic then
        local iter = CSharpDic:GetEnumerator()
        while iter:MoveNext() do
            local k = iter.Current.Key
            local v = iter.Current.Value
            dic[k] = v
        end
    end
    return dic
end
function this.ListToTable(CSharpList)
    -- 将C#的List转成Lua的Table
    local list = {}
    if CSharpList then
        local index = 1
        local iter = CSharpList:GetEnumerator()
        while iter:MoveNext() do
            local v = iter.Current
            list[index] = v
            index = index + 1
        end
    else
        logError("Error,CSharpList is null")
    end
    return list
end

function this.copyToClipboard(str)
    CS.UnityEngine.GUIUtility.systemCopyBuffer = str
end

---@param parent UnityEngine.Transform
---@param rectSize Vector2
---@param rectPos Vector2
---@param rectScale Vector2
---@return UnityEngine.GameObject
function this.createUI(path, name, parent, rectPos, rectScale, rectSize)
    local uiItem = resMgr:CreateGameObject(path, name)
    uiItem.transform:SetParent(parent)
    if rectPos then
        uiItem:SetRectPos(rectPos)
    end
    if rectSize then
        uiItem:SetRectSize(rectSize)
    end
    if rectScale then
        uiItem:SetScale(rectScale)
    end
    return uiItem
end

---@param obj UnityEngine.GameObject
---@param parent UnityEngine.Transform
function this.setParent(obj, parent, pos, rot, scale)
    obj.transform:SetParent(parent)
    obj:SetLocalPos(pos or Vector3.New())
    obj:SetLocalRot(rot or Vector3.New())
    obj:SetScale(scale or Vector3.One())
end

---@param rect UnityEngine.RectTransform
---@param parent UnityEngine.Transform
function this.setRectParent(rect, parent, pos, rot, scale)
    rect:SetParent(parent)
    rect.anchoredPosition3D = (pos or Vector3.New())
    rect.localEulerAngles = (rot or Vector3.New())
    rect.localScale = (scale or Vector3.One())
end

function this.RichTextColor(text, color)
    return "<color=#" .. color .. ">" .. text .. "</color>"
end

function this.GetRandom()
    return math.random(1, 100000)
end

function this.GetDateDes(millisecond)
    local time = math.modf(millisecond / 1000)
    local currTime =math.modf(Util.GetTimeStamp()/1000) --this.GetServerTime()
    local dis = currTime - time
    local m = 60
    if dis < m then
        return "刚刚"
    elseif dis < m * 60 then
        return math.modf(dis / m) .. "分钟前"
    elseif dis < m * 60 * 24 then
        return math.modf(dis / m / 60) .. "小时前"
    elseif dis < m * 60 * 24 * 30 then
        return math.modf(dis / m / 60 / 24) .. "天前"
    elseif dis < m * 60 * 24 * 30 * 12 then
        return math.modf(dis / m / 60 / 24 / 30) .. "月前"
    else
        return "1年前"
    end
end

function this.Seconds_to_hms(seconds)
    local hours = math.floor(seconds / 3600)
    local minutes = math.floor((seconds % 3600) / 60)
    local secs = seconds % 60
    return string.format("%02d:%02d:%02d", hours, minutes, secs)
end

function this.Seconds_to_dhms(secs)
    local days = math.floor(secs / (24 * 3600))
    local hours = math.floor((secs % (24 * 3600)) / 3600)
    local minutes = math.floor((secs % 3600) / 60)
    local seconds = secs % 60
    return string.format("%02d:%02d:%02d:%02d", days, hours, minutes, seconds)
end


function this.GetFileExtension(fileName)
    local strLen = #fileName
    local po = string.find(fileName, "%.", -4)
    return string.sub(fileName, po + 1, strLen)
end

function FileIsVideo(extension)
    return extension == "mp4" or extension == "avi"
end
---@param camComp UnityEngine.Camera
---@param rawImage UnityEngine.UI.RawImage
function this.camViewRenderToRawImage(camComp, rawImage)
    local size = rawImage.rectTransform.rect.size
    local rt =
        UnityEngine.RenderTexture(
        Util.Int(size.x),
        Util.Int(size.y),
        UnityEngine.Experimental.Rendering.GraphicsFormat.D32_SFloat_S8_UInt.value__
    )
    -- rt.depthStencilFormat = UnityEngine.Experimental.Rendering.GraphicsFormat.D32_SFloat_S8_UInt
    camComp.targetTexture = rt
    rawImage.texture = rt
    rawImage.color = ColorDefine.white
end
---@param bg UnityEngine.RectTransform
function this.playUIStartWidthAnim(bg, isClose, onComplete, offset)
    local width = bg.rect.width + (offset or 0)
    if isClose then
        bg:DOAnchorPos(Vector3.New(-width, 0, 0), 0.3):OnComplete(
            function()
                if onComplete then
                    onComplete()
                end
            end
        )
    else
        bg.anchoredPosition3D = Vector3.New(-width, 0, 0)
        bg:DOAnchorPos(Vector3.New(), 0.3):OnComplete(
            function()
                if onComplete then
                    onComplete()
                end
            end
        )
    end
end
---@param bg UnityEngine.RectTransform
function this.playUIStartHeightAnim(bg, isClose, onComplete, offset)
    local height = bg.rect.height + (offset or 0)
    if isClose then
        bg:DOAnchorPos(Vector3.New(0, -height, 0), 0.3):OnComplete(
            function()
                if onComplete then
                    onComplete()
                end
            end
        )
    else
        bg.anchoredPosition3D = Vector3.New(0, -height, 0)
        bg:DOAnchorPos(Vector3.New(), 0.3):OnComplete(
            function()
                if onComplete then
                    onComplete()
                end
            end
        )
    end
end
---@return DG.Tweening.Sequence
function this.CreateSequence(loop)
    local seq = DOTween.Sequence()
    if loop then
        seq:SetLoops(-1)
    end
    seq:SetAutoKill(false):Pause()
    return seq
end

function this.Toast(msg)
    NativeCallUtil.ShowToast(msg)
end

---@param cam UnityEngine.Camera
---@param rect UnityEngine.Rect
---@return UnityEngine.Texture2D
function this.screenShot(cam, rect)
    coroutine.yield(CS.UnityEngine.WaitForEndOfFrame())
    local tex = UnityEngine.Texture2D(rect.width, rect.height, UnityEngine.TextureFormat.RGB24, false)
    tex:ReadPixels(rect, 0, 0)
    tex:Apply()
    return tex
end

---@param rectTransform UnityEngine.RectTransform
function this.CaptureScreenshot(rectTransform)
    local rect = rectTransform.rect
    local screenPos = this.GetUICamera():WorldToScreenPoint(rectTransform.position)
    local newRect =
        UnityEngine.Rect(screenPos.x - math.abs(rect.x), screenPos.y - math.abs(rect.y), rect.width, rect.height)
    coroutine.yield(UnityEngine.WaitForEndOfFrame())
    local texture = UnityEngine.Texture2D(newRect.width, newRect.height, UnityEngine.TextureFormat.RGB24, false)
    texture:ReadPixels(newRect, 0, 0)
    texture:Apply()
    return texture
end

---@param rectTrans UnityEngine.RectTransform
------@param localSize UnityEngine.Vector2
---@param targetSize UnityEngine.Vector2
function this.setImgSizeFit(rectTrans, localSize, targetSize)
    local largeEdge
    local largeFitEgde
    if localSize.x > localSize.y then
        largeEdge = localSize.x
        largeFitEgde = targetSize.x
        rectTrans.sizeDelta = Vector2.New(largeFitEgde, largeFitEgde / largeEdge * localSize.y)
    else
        largeEdge = localSize.y
        largeFitEgde = targetSize.y
        rectTrans.sizeDelta = Vector2.New(largeFitEgde / largeEdge * localSize.x, largeFitEgde)
    end
end

---@param rawImage UnityEngine.UI.RawImage
---@param tex UnityEngine.Texture2D
function this.setTexToRawImage(rawImage, tex)
    rawImage.texture = tex
    rawImage.color = Color.white
end
function this.setOSSTexToRawImage(relativePath, rawImage)
    OSS.DownloadTex(
        relativePath,
        function(tex)
            this.setTexToRawImage(rawImage, tex)
        end
    )
end
---@param tog UnityEngine.UI.Toggle
function this.setTogInteractable(tog, interactable)
    tog.transition = UnityEngine.UI.Selectable.Transition.None
    tog.interactable = interactable
    local targetColor = interactable and ColorDefine.white or ColorDefine.disabled
    tog.targetGraphic.color = targetColor
    tog.graphic.color = targetColor
    ---@type System.Array
    local texts = tog:GetComponentsInChildren(typeof(UnityEngine.UI.Text), true)
    for i = 0, texts.Length - 1 do
        ---@type UnityEngine.UI.Text
        local v = texts[i]
        v.color = targetColor
    end
end

function this.CreateCommonComp(prefabName)
    return ObjectPoolUtil:SpawnPrefab(nil, prefabName, "OutPut/UI/CommonComp")
end

---@param btn UnityEngine.UI.Button
function this.setBtnInteractable(btn, interactable)
    btn.transition = UnityEngine.UI.Selectable.Transition.None
    btn.interactable = interactable
    local targetColor = interactable and ColorDefine.white or ColorDefine.disabled
    btn.targetGraphic.color = targetColor
    ---@type System.Array
    local texts = btn:GetComponentsInChildren(typeof(UnityEngine.UI.Text), true)
    for i = 0, texts.Length - 1 do
        ---@type UnityEngine.UI.Text
        local v = texts[i]
        v.color = targetColor
    end
end

function this.confuseName(name)
    local len = string.utf8len(name)
    local last = string.sub(name, (len * 3) - 2)
    local result = "*" .. last
    return result
end

function this.PlayerSpineAniByName(SkeletonGraphic, aniName, isLoop, needClearTrack)
    if needClearTrack then
        SkeletonGraphic.Skeleton:SetToSetupPose()
        SkeletonGraphic.AnimationState:ClearTracks()
    end
    SkeletonGraphic.AnimationState:SetAnimation(0, aniName, isLoop)
    return SkeletonGraphic.AnimationState:GetCurrent().Animation.Duration
end
function this.NumJump(form, to, time, func1, func2)
    DOTween.To(
        function()
            return form
        end,
        function(v)
            func1(v)
        end,
        to,
        time
    ):OnComplete(
        function()
            if func2 then
                func2()
            end
        end
    )
end
function this.TextJump(txt, from, to, time, str, cb)
    str = str or ""
    this.NumJump(
        tonumber(from),
        to,
        time,
        function(v)
            txt.text = str .. math.floor(v)
        end,
        function()
            if cb then
                cb()
            end
        end
    )
end

function this.SetSprite(img, path, spriteName, notSetNative)
    local sprite = resMgr:LoadSprite(path, spriteName)
    img.sprite = sprite
    if notSetNative then
    else
        img:SetNativeSize()
    end
end
function this.SetEpSprite(img, spriteName, notSetNative)
    local path = "ArtsBase/Alats/common/icon_equip"
    local sprite = resMgr:LoadSprite(path, spriteName)
    img.sprite = sprite
    if notSetNative then
    else
        img:SetNativeSize()
    end
end
function this.SetEpBgSprite(img, spriteName, notSetNative)
    local path = "ArtsBase/Alats/common/bg_Items"
    local sprite = resMgr:LoadSprite(path, spriteName)
    img.sprite = sprite
    if notSetNative then
    else
        img:SetNativeSize()
    end
end
function this.SetEpNameByConfigID(txt, id)
    local qualityName = ConfigHelper.GetQualityNameByCfgId(id)
    txt.text = "[" .. qualityName .. "]" .. ConfigHelper.GetItemNameByConfigId(id)
    txt.color = ConfigHelper.GetColorByConfidId(id)
end
function this.SetItemNameByConfigID(txt, id)
    txt.text = ConfigHelper.GetItemNameByConfigId(id)
    txt.color = ConfigHelper.GetColorByConfidId(id)
end
function this.GetTimeUp(timeUp)
	--timeUp大于1天，b显示xx天xx小时xx分,timeUp小于一天，b显示xx小时xx分xx秒
	local tetimeUpRet =""
	if timeUp > 86400 then
		tetimeUpRet =  tostring(math.floor(timeUp/ 86400)).."天".. tostring(math.floor((timeUp % 86400) / 3600)).."小时".. tostring(math.floor((timeUp % 3600) / 60)).."分"
	else
        tetimeUpRet = os.date("!%X",math.floor(timeUp))
    end
	return tetimeUpRet
end
---@param 设置头像
function this.SetHeadSprite(img, spriteName, notSetNative)
    local path = "ArtsBase/Alats/common/head_icon"
    local sprite = resMgr:LoadSprite(path, spriteName)
    img.sprite = sprite
    if not notSetNative then
        img:SetNativeSize()
    end
end


function  this.numberToString(szNum)
    local szChMoney = ""
    local iLen = 0
    local iNum = 0
    local iAddZero = 0
    local hzUnit = {"", "十", "百", "千", "万", "十", "百", "千", "亿","十", "百", "千", "万", "十", "百", "千"}
    local hzNum = {"零", "一", "二", "三", "四", "五", "六", "七", "八", "九"}
    if nil == tonumber(szNum) then
        return tostring(szNum)
    end
    iLen =string.len(szNum)
    if iLen > 10 or iLen == 0 or tonumber(szNum) < 0 then
        return tostring(szNum)
    end
    for i = 1, iLen  do
        iNum = string.sub(szNum,i,i)
        if iNum == 0 and i ~= iLen then
            iAddZero = iAddZero + 1
        else
            if iAddZero > 0 then
                szChMoney = szChMoney..hzNum[1]
            end
            szChMoney = szChMoney..hzNum[iNum + 1] --//转换为相应的数字
            iAddZero = 0
        end
        if (iAddZero < 4) and (0 == (iLen - i) % 4 or 0 ~= tonumber(iNum)) then
            szChMoney = szChMoney..hzUnit[iLen-i+1]
        end
    end
    --用于记录，需要删除的0
    local msg = {}
    --删除目标0
    local function removeDestZero(num,msg)
        num = tostring(num)
        local inNum = num
        local szlen = string.len(num)
        for k,v in ipairs(msg) do
            szlen = string.len(inNum)
            inNum = string.sub(inNum,1,(v-(k-1)*3-1))..string.sub(inNum,(v-(k-1)*3+3),szlen)
        end
        return inNum
    end
    --删除尾部0
    local function removeLastZero(num)
        msg = {}
        num = tostring(num)
        local szLen = string.len(num)
        local zero_num = 0
        for i = szLen, 1, -3 do
            szNum = string.sub(num,i-2,i)
            if szNum == hzNum[1] and i == szLen then
                table.insert( msg, i-2)
            elseif szNum == "万" or szNum == "亿" then
                local inNum = string.sub(num,i-5,i-3)
                if inNum == hzNum[1] then
                    table.insert( msg,i-5)
                end
            end
        end
        return msg
    end
    --删除中间的0
    local function removeZero(num)
        msg = {}
        num = tostring(num)
        local szLen = string.len(num)
        local zero_num = 0
        for i = 1,szLen,3 do
            szNum = string.sub(num,i,i+2)
            local index = (i+2)/3
            if szNum == hzNum[1] then
                local ret = false
                for k = i+3,szLen,3 do
                    local inNum = string.sub(num,k,k+2)
                    if szNum == inNum then
                        ret = true
                        break
                    elseif  inNum ~= "十" and inNum ~= "百" and inNum ~= "千" and inNum ~= "万" and inNum ~= "亿" then
                        break
                    end

                end
                if ret then
                    table.insert(msg,i)
                end
            end
        end
        if next(msg) then
            num = removeDestZero(num,msg)
        end
        msg = removeLastZero(num)
        if next(msg) then
            num = removeDestZero(num,msg)
        end
        return num
    end
    return removeZero(szChMoney)
end
