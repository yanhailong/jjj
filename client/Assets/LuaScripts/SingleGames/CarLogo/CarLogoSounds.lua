local CarLogoSounds = {}

local soundPath = "SingleGames/CarLogo/audio/"


local SOUND_NAMES = {
    "Sound_Status_Start",     --开始下注时播放，单次
    "Sound_Status_End",     --停止下注时播报，单次
    "Sound_Running_Bg_car",     --开奖时游戏奔跑的音效，与倒计时3秒时同时播放，单次
    "Sound_Countdown3",     --倒计时音效，倒计时时播放，单次
    "Sound_Countdown32",     --停止下注播放完毕，播放音效，单次
    "Sound_Running_zb",     --开始下注播放完毕，播放该音效，单次
    "Sound_Getgold",     --下注筹码飞的音效，单次
    "Sound_Win_bet",     --赢奖结算时筹码飞回的音效，单次
}

local SOUND_ANIMAL ={
    "Sound_Car_BENZ",     --中奔驰车标播报音效，单次
    "Sound_Car_BMW",     --中宝马车标播报音效，单次
    "Sound_Car_FERRARI",     --中法拉利车标播放音效，单次
    "Sound_Car_KAIDI",     --中凯迪拉克车标播放音效，单次
    "Sound_Car_MASHA",     --中兰博基尼车标播放音效，单次
    "Sound_Car_MAZIDA",     --中布加迪车标播放该音效，单次
    "Sound_Car_PORSCHE",     --中保时捷车标播放音效，单次
    "Sound_Car_VW",     --中捷豹车标播放音效，单次
}

--音乐特效
function CarLogoSounds.PlaySoundEffic(key)
    local soundName = SOUND_NAMES[key]
    SoundManager:PlayClip(soundPath..soundName)
end

--动物声音
function CarLogoSounds.PlaySoundAnimal(logoId)
    local soundName = SOUND_ANIMAL[logoId]
    SoundManager:PlayClip(soundPath..soundName)
end

--背景音乐
function CarLogoSounds.PlaySoundMusic()
    local soudName = "bgm_sound"
    SoundManager:ChangeBg(soundPath..soudName)
end
--关闭背景音乐
function CarLogoSounds.StopSoundMusic()
    SoundManager:CloseBg()
end

return CarLogoSounds;