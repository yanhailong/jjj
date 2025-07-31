local SicBoSounds = {}

local soundPath = "SingleGames/SicBo/audios/"
--下注
function SicBoSounds.PlayBetSoundEffic()
    SoundManager:PlayClip(soundPath .. "choumaxiazhu")
end
--下注
function SicBoSounds.PlaySettlement()
    SoundManager:PlayClip(soundPath .. "choumajiesuan")
end
--下注
function SicBoSounds.PlayRollDice()
    SoundManager:PlayClip(soundPath .. "toubao_touzi")
end

--背景
function SicBoSounds.PlayBackgroudSound()
    SoundManager:ChangeBg(soundPath .. "toubao_bgm")
end


--关闭背景
function SicBoSounds.StopSoundMusic()
    SoundManager:CloseBg()
end

return SicBoSounds
