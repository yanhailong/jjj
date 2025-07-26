
local BirdsAnimalsConfig = require("SingleGames/BirdsAnimals/BirdsAnimalsConfig")
local BirdsAnimalsHelper = {}

local atlasPath = "SingleGames/BirdsAnimals/atlas"
---加载Logo
function BirdsAnimalsHelper.LoadLogoSprite(logo_id)
    if BirdsAnimalsConfig.ANIMA_ICON_IMAGES[logo_id] == nil then look("xxxxxxxxxxxxx"..logo_id) return nil end
    return resMgr:LoadSprite(atlasPath.."/animal",BirdsAnimalsConfig.ANIMA_ICON_IMAGES[logo_id]);
end

---加載图片文字
function BirdsAnimalsHelper.LoadTxtSprite(name)
    return resMgr:LoadSprite(atlasPath.."/art",name)
end

function BirdsAnimalsHelper.LoadNameLanguage(logo_id)
    return LocalManager.GetStrById(BirdsAnimalsConfig.ANIMA_NAME_LANGUAGE[logo_id])
end

function BirdsAnimalsHelper.is_certain_type(animal_type, animal_id)
    return nil ~= BirdsAnimalsConfig.ANIMAL_GROUP[animal_type][animal_id];
end

--是否是飞禽类
function BirdsAnimalsHelper.IsFeiQinType(logo_id)
    return BirdsAnimalsHelper.is_certain_type(BirdsAnimalsConfig.ANIMAL_TAG.FeiQin, logo_id);
end

--是否是走兽类
function BirdsAnimalsHelper.IsZouShouType(logo_id)
    return BirdsAnimalsHelper.is_certain_type(BirdsAnimalsConfig.ANIMAL_TAG.ZouShou, logo_id);
end

--获取id对应点击区域index
function BirdsAnimalsHelper.FindIndexById(logo_id)
    for i=1,#BirdsAnimalsConfig.ANIMA_HISTORY do
        if BirdsAnimalsConfig.ANIMA_HISTORY[i]==logo_id then
            return i
        end
    end
    return nil    
end

return BirdsAnimalsHelper;