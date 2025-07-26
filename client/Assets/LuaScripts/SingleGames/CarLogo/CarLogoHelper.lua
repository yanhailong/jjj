
local CarLogoConfig = require("SingleGames/CarLogo/CarLogoConfig")
local CarLogoHelper = {}

local atlasPath = "SingleGames/CarLogo/atlas"
local atlasPath2 = "Con/CarLogo/atlas"
local effectPath = "SingleGames/CarLogo/effects/prefab"
---加载Logo
function CarLogoHelper.LoadLogoSprite(type)
    return resMgr:LoadSprite(atlasPath.."/logos","Car_cb_"..CarLogoConfig.LOGO_IMAGES[type]);
end

---加载Logo
function CarLogoHelper.LoadLogoResultSprite(index)
    return resMgr:LoadSprite(atlasPath.."/results","Car_"..CarLogoConfig.LOGO_IMAGES[index]);
end

---加载Name
function CarLogoHelper.LoadLogoNameSprite(index)
    return resMgr:LoadSprite(atlasPath.."/txt","Car_"..CarLogoConfig.LOGO_IMAGES[index]);
end
---加载汽车特效
function CarLogoHelper.LoadLogoResultCar(index)
    return resMgr:LoadGameObject(effectPath,"effect_CarLogo_Car_"..CarLogoConfig.LOGO_IMAGES[index]);
end
function CarLogoHelper.LoadLogoResultLogo(index)
    return resMgr:LoadGameObject(effectPath,"effect_CarLogo_Car_"..CarLogoConfig.LOGO_IMAGES[index].."_logo");
end
--获取id对应点击区域index
function CarLogoHelper.FindIndexById(logo_id)
    for i=1,#CarLogoConfig.LOGO_HISTORY do
        if CarLogoConfig.LOGO_HISTORY[i]==logo_id then
            return i
        end
    end
    return nil
end

return CarLogoHelper;