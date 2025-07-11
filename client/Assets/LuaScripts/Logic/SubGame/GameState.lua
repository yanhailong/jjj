---游戏状态
---@class GameState
GameState={
    Error=-1,
    Normal=1,--可正常进入游戏
    NotOpen=2,--游戏未开放
    Maintenance=3,--游戏维护中
    Update=4,--游戏需要更新
    WaitUpdate=5,--等待更新中
    Updating=6,--游戏更新中
}