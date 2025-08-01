---
---Create by Administrator
---DateTime: 2025-07-30 10:29:58
---
---@class SicBoMainModel:BaseModel
local SicBoMainModel = Class("SicBoMainModel", BaseModel)

function SicBoMainModel:Awake()
    self.super.Awake(self);
    ---@type SicBoMainCtrl
    self.ctrl = self.ctrl
    --保存玩家的数据
    self.betPointList = { 100, 200, 300, 400, 500, 600, 700 } --假的下注
    self.CurrentSelectBetChip = 1;
end

function SicBoMainModel:Close()
    self.super.Close(self);
end

function SicBoMainModel:AddEvent()
    --WebNetEvent.AddListener(pb_comonFight.NotifyDiceTreasureTableInfo, self.OnEnterRoom, self)
    --WebNetEvent.AddListener(pb_comonFight.NotifyPhaseChangInfo, self.ChangeState, self)
    --WebNetEvent.AddListener(pb_comonFight.NotifyPlayerBet, self.PlayerBet, self)
    --WebNetEvent.AddListener(pb_comonFight.NotifyDiceTreasureSettlement, self.Settlement, self)
    --WebNetEvent.AddListener(pb_comonFight.NotifyTableRoomPlayerInfoChange, self.PlayerInfoChange, self)
end

--请求进入房间,开始游戏是请求
function SicBoMainModel:ReqEnterRoom()
    WebNetworkManager.SendMsg(pb_comonFight.ReqRoomBaseInfo)
end

--玩家下注  参数1：请求下注的金额  参数2：游戏区域配置ID
function SicBoMainModel:ReqBet(BetAmount, AreaIdx)
    local data = {
        betValue = BetAmount,
        betAreaIdx = AreaIdx
    }
    WebNetworkManager.SendMsg(pb_comonFight.ReqBet, data)
end

--[[ //响应,msgID=0x19081,desc=骰宝桌面信息，下注，结算，断线重连
  message NotifyDiceTreasureTableInfo {
  enum E_MsgID {def = 0; msgID = 102529;};
  int32 code = 1;  //状态码
  EGamePhase gamePhase = 2;  //场上阶段信息
  int64 tableCountDownTime = 3;  //场上倒计时结束时间戳
  repeated BetTableInfo tableAreaInfos = 4;  //区域下注信息
  repeated int32 betPointList = 5;  //押分分值列表
  TablePlayerInfo playerInfo = 6;  //当前玩家信息
  int32 totalPlayerNum = 7;  //房间总人数
  repeated DiceTreasureHistoryBean settlementHistory = 8;  //结算历史，首次进入时发送，下注区域id列表
  DiceTreasureSettlementInfo settlementInfo = 9;  //结算信息，当阶段为结算时发送
  }]]

--- //牌桌玩家信息
--[[message TablePlayerInfo {
int64 playerId = 1;  //玩家ID
string playerName = 2;  //玩家名
string local = 3;  //玩家地址
int32 vipLevel = 4;  //VIP等级
int64 goldNum = 5;  //玩家当前金币
int64 totalBet = 6;  //近20局下注金币总数
int32 winCount = 7;  //近20局赢的总局数
}]]
-- 进入房间返回 NotifyLoongTigerWarInfo
function SicBoMainModel:OnEnterRoom(msg)
    self.playerInfo = msg.playerInfo                   --保存当前玩家信息
    self.betPointList = msg.betPointList               --玩家下注列表
    self.settlementHistoryList = msg.settlementHistory --保存历史开奖
    if msg.settlementInfo then
        table.insert(self.settlementHistoryList, msg.settlementInfo)
    end
    self.ctrl:EnterGame(msg)
end

--状态改变
function SicBoMainModel:ChangeState(msg)
    if msg.code == ErrorCode.SUCCESS then
        self.ctrl:ChangeState(msg.gamePhase, msg.endTime)
    else
        logError("改变游戏状态失败: " .. tostring(msg.code))
    end
end

--玩家下注
function SicBoMainModel:PlayerBet(msg)
    if msg.code == ErrorCode.SUCCESS then
        self.ctrl:PlayerBet(msg.playerId, msg.playerCurGold, msg.betTableInfoList)
    else
        logError("下注失败: " .. tostring(msg.code))
    end
end

--游戏结算,主动推送
function SicBoMainModel:Settlement(msg)
    --[[ //响应,msgID=0x19082,desc=通知骰宝结算信息
    message NotifyDiceTreasureSettlement {
    enum E_MsgID {def = 0; msgID = 102530;};
    int32 code = 1;  //状态码
    DiceTreasureSettlementInfo settlementInfo = 2;  //结算信息
    }]]
    self.ctrl:Settlement(msg.settlementInfo)
end

--玩家进出房间
function SicBoMainModel:PlayerInfoChange(msg)
    --[[//响应,msgID=0x20088,desc=通知押注类房间玩家信息变化
    message NotifyTableRoomPlayerInfoChange {
    enum E_MsgID {def = 0; msgID = 131208;};
    int32 code = 1;  //状态码
    int64 changedPlayerId = 2;  //产生变化的玩家ID
    int32 totalPlayerNum = 3;  //总人数
    repeated TablePlayerInfo tableChangedPlayerInfos = 4;  //变化后的场上玩家信息
    }]]
    self.tableChangedPlayerInfos = msg.tableChangedPlayerInfos --桌子上的玩家
    for i, v in ipairs(self.tableChangedPlayerInfos) do
        if msg.changedPlayerId == msg.playerId then
            self.ctrl:UpdatePlayerInfo(msg.changedPlayerId, v)
        end
    end
end

--获取玩家筹码
function SicBoMainModel:GetBetChip()
        return self.betPointList[self.CurrentSelectBetChip]
end

function SicBoMainModel:RemoveEvent()
    WebNetEvent.RemoveAllTo(self)
end

--region 事件方法

--endregion


return SicBoMainModel
