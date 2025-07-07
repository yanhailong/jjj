
local CarLogoConfig = require("SingleGames/CarLogo/CarLogoConfig")
local CarLogoHelper = {}

local atlasPath = "SingleGames/CarLogo/atlas"
local atlasPath2 = "Con/CarLogo/atlas"
---加载Logo
function CarLogoHelper.LoadLogoSprite(type)
    return resMgr:LoadSprite(atlasPath.."/logos",CarLogoConfig.LOGO_IMAGES[type]);
end

---加载Logo
function CarLogoHelper.LoadLogoResultSprite(index)
    return resMgr:LoadSprite(atlasPath.."/results",CarLogoConfig.LOGO_RESULT[index]);
end

---加载Name
function CarLogoHelper.LoadLogoNameSprite(index)
    return resMgr:LoadSprite(atlasPath.."/txt",CarLogoConfig.LOGO_RESULT[index]);
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