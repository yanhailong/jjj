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

--请求进入房间
function SicBoMainModel:ReqEnterRoom()
    WebNetworkManager.SendMsg(pb_comonFight.ReqRoomBaseInfo)
end

--玩家下注
function SicBoMainModel:ReqBet()
    -- //请求押注的bean
    --[[ message ReqBetBean {
    int64 betValue = 1;  //请求下注的金额
    int32 betAreaIdx = 2;  //百家乐下注区域，1: 庄对 2: 和 3: 闲对 4: 闲 5: 庄 其他游戏走游戏区域配置ID
    }]]
    WebNetworkManager.SendMsg(pb_comonFight.ReqBet)
end

-- 进入房间返回 NotifyLoongTigerWarInfo
function SicBoMainModel:OnEnterRoom(msg)
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
end

--状态改变
function SicBoMainModel:ChangeState(msg)
    --[[//响应,msgID=0x20089
    message NotifyPhaseChangInfo {
    enum E_MsgID {def = 0; msgID = 131209;};
    int32 code = 1;  //状态码
    EGamePhase gamePhase = 2;  //当前阶段
    int64 endTime = 3;  //结束时间戳
    }]]
end

--玩家下注
function SicBoMainModel:PlayerBet(msg)
    if msg.code == ErrorCode.SUCCESS then


        --[[ //响应,msgID=0x20081,desc=请求下注返回
        message NotifyPlayerBet {
        enum E_MsgID {def = 0; msgID = 131201;};
        int32 code = 1;  //状态码
        int64 playerId = 2;  //玩家ID
        int64 playerCurGold = 3;  //下注玩家当前金币
        repeated BetTableInfo betTableInfoList = 4;  //玩家押注信息列表

        //押注信息
message BetTableInfo {
  int32 betIdx = 1;  //下标
  int64 playerBetTotal = 2;  //玩家总押注
  int64 betIdxTotal = 3;  //区域下标的总的押注数量
  int64 betValue = 4;  //玩家此次下注的金币数量
  repeated int32 betGoldList = 5;  //区域押注金币列表
}
        }]]
    else
        logError("下注失败: "..tostring(msg.code))
    end
end

--游戏结算
function SicBoMainModel:Settlement(msg)
    --[[ //响应,msgID=0x19082,desc=通知骰宝结算信息
    message NotifyDiceTreasureSettlement {
    enum E_MsgID {def = 0; msgID = 102530;};
    int32 code = 1;  //状态码
    DiceTreasureSettlementInfo settlementInfo = 2;  //结算信息
    }]]
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
end

function SicBoMainModel:RemoveEvent()
    WebNetEvent.RemoveAllTo(self)
end

--region 事件方法

--endregion


return SicBoMainModel
