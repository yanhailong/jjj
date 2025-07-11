---游戏更新事件通知
---@class UpdateGameEvent
UpdateGameEvent={
    updateError="UpdateGameEvent.UpdateError",--更新错误 param:int,err
    updateProgress="UpdateGameEvent.UpdateProgress",--更新进度 param:int,int
    updateFinished="UpdateGameEvent.UpdateFinished",--更新完成
    waitUpdate="UpdateGameEvent.WaitUpdate",--等待更新
    cancelWaitUpdate="UpdateGameEvent.CancelWaitUpdate",--等待更新
}