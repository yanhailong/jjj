---@class SlotGlobal
SlotGlobal=Class("SlotGlobal")
local this=SlotGlobal

---游戏指令
this.gameEventName={
    StartSpin="StartSpin",--开始旋转
    BackHome="BackHome",--返回大厅
    OpenHelp="OpenHelp",--打开帮助
    NoticeAutoStart="NoticeAutoStart",--通知自动开始
    NoticeAuto="NoticeAuto",--通知自动次数
    NoticeStopAuto="NoticeStopAuto",--通知停止自动
    RollStop="RollStop",--转动k快速停止
    GameStateChange="GameStateChange",--游戏状态改变
    ChangeBetInfo="ChangeBetInfo",--切换下注信息
    AwardValue="AwardValue",--中奖信息
    
}

---游戏状态
this.gameState={
    Normal=1,--闲置状态
    RollState=2,--转动状态
    AutoState=3,--自动状态
    FreeState=4,--免费
    SmallGame=5,--小游戏
}