local DragonTigerFightSounds = {}

local soundPath = "SingleGames/DragonTigerFight/audio/"


local SOUND_NAMES = {
    "add_chip",     --玩家自己筹码下注飞行音效 -->有筹码下注时就播放一次
    "bet_ready",     --准备阶段音效 -->播放logo图时播放该音效
    "betEnd",     --下注阶段结束音效 -->弹出提示文本同步播放
    "betStart",     --下注阶段开始音效 -->弹出提示文本同步播放
    "countdown3",     --倒计时音效 -->倒计时出现数字3、2、1时播放
    "countdown32",     --倒计时结束音效 -->弹出提示文本同步播放
    "deal",     --发牌音效 -->发牌时同步播放
    "ding",     --结算阶段分筹码音效 -->筹码飞回时播放该音效
    "flipcard",     --翻牌音效 -->揭开牌面时播放该音效
}

local SOUND_CARD = {
    "res_1",     --牌面点数播报 -->翻开牌面为A时播放该语音
    "res_2",     --牌面点数播报 -->翻开牌面为2时播放该语音
    "res_3",     --牌面点数播报 -->翻开牌面为3时播放该语音
    "res_4",     --牌面点数播报 -->翻开牌面为4时播放该语音
    "res_5",     --牌面点数播报 -->翻开牌面为5时播放该语音
    "res_6",     --牌面点数播报 -->翻开牌面为6时播放该语音
    "res_7",     --牌面点数播报 -->翻开牌面为7时播放该语音
    "res_8",     --牌面点数播报 -->翻开牌面为8时播放该语音
    "res_9",     --牌面点数播报 -->翻开牌面为9时播放该语音
    "res_10",     --牌面点数播报 -->翻开牌面为10时播放该语音
    "res_11",     --牌面点数播报 -->翻开牌面为J时播放该语音
    "res_12",     --牌面点数播报 -->翻开牌面为Q时播放该语音
    "res_13",     --牌面点数播报 -->翻开牌面为K时播放该语音
}
local SOUND_WIN ={
    "win_1",     --龙嬴音效 -->出现结算旗帜时播放该音效
    "win_2",     --虎嬴音效 -->出现结算旗帜时播放该音效
    "win_3",     --和牌音效 -->出现结算旗帜时播放该音效
}
local SOUND_WIN_EF={
    "longhudou_hu",     --虎嬴音效 -->下注区出现虎特效时播放该音效
    "longhudou_long",     --龙嬴音效 -->下注区出现龙特效时播放该音效
    "",
}

local SOUND_BET_ROM = {
    "lhxiazhu1",     --其余玩家筹码下注飞行音效 -->有筹码下注时就播放一次（四选一随机）
    "lhxiazhu2",     --其余玩家筹码下注飞行音效 -->有筹码下注时就播放一次（四选一随机）
    "lhxiazhu3",     --其余玩家筹码下注飞行音效 -->有筹码下注时就播放一次（四选一随机）
    "lhxiazhu4",     --其余玩家筹码下注飞行音效 -->有筹码下注时就播放一次（四选一随机）
}


--音乐特效
function DragonTigerFightSounds.PlaySoundEffic(key)
    local soundName = SOUND_NAMES[key]
    SoundManager:PlayClip(soundPath..soundName)
end

--牌型声音
function DragonTigerFightSounds.PlaySoundCard(cardId)
    local index = cardId%13
    local soundName = SOUND_CARD[index]
    if not soundName then
        logError(cardId)
        return
    end
    SoundManager:PlayClip(soundPath..soundName)
end
--结果音效
function DragonTigerFightSounds.PlaySoundWin(result,isEF)
    local soundName = SOUND_WIN[result]
    if isEF then soundName = SOUND_WIN_EF[result] end
    SoundManager:PlayClip(soundPath..soundName)
end
--其余玩家筹码下注飞行音效
function DragonTigerFightSounds.OtherFlyBet()
    local index = Tools.RandomInt(1,4)
    local soundName = SOUND_BET_ROM[index]
    SoundManager:PlayClip(soundPath..soundName)
end
--背景音乐
function DragonTigerFightSounds.PlaySoundMusic()
    local soudName = "bgm_sound"
    SoundManager:ChangeBg(soundPath..soudName)
end
--关闭背景音乐
function DragonTigerFightSounds.StopSoundMusic()
    SoundManager:CloseBg()
end

return DragonTigerFightSounds;