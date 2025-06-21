---@class 存储消息Id与pb名字
PbMsg={}
---@class
PBHelper = {}
local this = PBHelper
local parser =require("Logic/Protoc/protoc").new()
local pb = require "pb"

function this.LoadPB(pbPath,pbName)
    local protoString = resMgr:LoadTextAssetStr(pbPath,pbName..".proto.bytes")
    parser:load(protoString, pbName..".proto")
end

function this.EnCode(msg_id, tb)
    local pbInfo=PbMsg[msg_id]
    if pbInfo then
        local data={}
        data.cmd=msg_id
        data.data=assert(pb.encode(pbInfo, tb))
        return assert(pb.encode("Pack", data))
    else
        logError("消息对应的pb为空！msg_id:"..msg_id)
    end
    
end


function this.Decode(bytes)
    local pack=assert(pb.decode("Pack", bytes))
    local msgId=pack.cmd
    local subBytes=pack.data
    local pbInfo=PbMsg[msgId]
    if pbInfo then
        return msgId,assert(pb.decode(pbInfo, subBytes))
    else
        logError("消息对应的pb为空！msg_id:"..msgId)
        return msgId,nil
    end
    
end

function this.Enum(enumType, enumValue)

    return pb.enum(enumType, enumValue)
end
