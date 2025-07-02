
local CarLogoConfig = require("SingleGames/CarLogo/CarLogoConfig")
local CarLogoHelper = {}

local atlasPath = "SingleGames/CarLogo/atlas"
---加载Logo
function CarLogoHelper.LoadLogoSprite(type)
    return resMgr:LoadSprite(atlasPath.."/carlogo/logos",CarLogoConfig.LOGO_IMAGES[type]);
end

---加載Logo背景
function CarLogoHelper.LoadLogoBgSprite(type)
    return resMgr:LoadSprite(atlasPath.."/carlogo/backs",CarLogoConfig.LOGO_BG[type])
end

---加載Logo燈
function CarLogoHelper.LoadLogoLightSprite(type)
    return resMgr:LoadSprite(atlasPath.."/carlogo/choose",CarLogoConfig.LOGO_LIGHT[type])
end

---加載選中圓圈
function CarLogoHelper.LoadLogoChooseSprite(type)
    return resMgr:LoadSprite(atlasPath.."/carlogo/choose",CarLogoConfig.LOGO_CHOOSE[type])
end

---加载Logo
function CarLogoHelper.LoadLogoResultSprite(index,type)
    return resMgr:LoadSprite(atlasPath.."/results",CarLogoConfig.LOGO_RESULT[index]..type);
end

function CarLogoHelper.LoadLogoResultTexture2D(index)
    return resMgr:LoadTexture2D(atlasPath.."/results",CarLogoConfig.LOGO_RESULT[index].."1");
end

--是否为特殊效果
function CarLogoHelper.IsSpecialResult(result)
    return result.spec_show_info ~= nil and result.spec_show_info.spec_id ~= 0;
end

--获取结算时间
function CarLogoHelper.GetSettlementTime(result)
    if(CarLogoHelper.IsSpecialResult(result)) then
        return CarLogoConfig.BaseTime + CarLogoConfig.SpecTimes[result.spec_show_info.spec_id]
    else
        return CarLogoConfig.BaseTime;
    end
end

return CarLogoHelper;