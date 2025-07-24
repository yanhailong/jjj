local BirdsAnimalsSounds = {}

local soundPath = "SingleGames/BirdsAnimals/audio/"

local SOUND_NAMES = {
    "Sound_Status_Start",  --开始下注
    "Sound_Status_End",  --停止下注
    "Sound_Begin",  --旋转
    "Sound_Countdown3",  --倒计时音效
    "Sound_Countdown32",  --停止下注吹哨
    "Sound_End",  --转轴停止的音效
    "Sound_Running",  --转轴旋转
    "Sound_Win_bet",  --筹码赢奖
    "Sound_Getgold",  --筹码音效
}

local SOUND_ANIMAL ={
    "Sound_animate1",  --燕子
    "Sound_animate2",  --鸽子
    "Sound_animate3",  --孔雀
    "Sound_animate4",  --老鹰
    "Sound_animate5",  --兔子
    "Sound_animate6",  --熊猫
    "Sound_animate7",  --猴子
    "Sound_animate8",  --狮子
    "Sound_animate9",  --通杀
    "Sound_animate10",  --通赔
    "Sound_animate11",  --银鲨鱼
    "Sound_animate12",  --金鲨鱼
}

--音乐特效
function BirdsAnimalsSounds.PlaySoundEffic(key)
    local soundName = SOUND_NAMES[key]
    SoundManager:PlayClip(soundPath..soundName)
end

--动物声音
function BirdsAnimalsSounds.PlaySoundAnimal(logoId)
    local soundName = SOUND_ANIMAL[logoId]
    SoundManager:PlayClip(soundPath..soundName)
end

--背景音乐
function BirdsAnimalsSounds.PlaySoundMusic()
    local soudName = "bgm_sound"
    SoundManager:ChangeBg(soundPath..soudName)
end

return BirdsAnimalsSounds;