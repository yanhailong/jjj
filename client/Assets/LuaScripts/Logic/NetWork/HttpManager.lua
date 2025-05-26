---@type HttpHelper
HttpHelper = CS.HttpHelper.Instance

---@class HttpManager
HttpManager = {}
local this = HttpManager

HttpApi = {
    Guestlogin="http://192.168.3.31:9001/account/guestlogin",--游客登录接口
}

function this.SendHttpPost(url, data, callFunc, header)
    HttpHelper:PostUri(url, data, callFunc, header)
end

return HttpManager
