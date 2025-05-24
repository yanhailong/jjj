---@class
PBHelper = {}
local this = PBHelper
local parser =require("Logic/Protoc/protoc").new()
local pb = require "pb"
local pbPath="ProtoFiles";


function this.LoadPB(pbName)
    local protoString = resMgr:LoadTextAssetStr(pbPath,pbName..".proto.bytes")
    parser:load(protoString, pbName..".proto")
end

function this.EnCode(msg_id, tb)
    local pbInfo=PbMsg[msg_id]
    if pbInfo then
        return assert(pb.encode(pbInfo, tb))
    else
        logError("消息对应的pb为空！msg_id:"..msg_id)
    end
    
end

function this.Decode(msg_id, bytes)
    local pbInfo=PbMsg[msg_id]
    if pbInfo then
        return assert(pb.decode(pbInfo, bytes))
    else
        logError("消息对应的pb为空！msg_id:"..msg_id)
    end
    
end

function this.Enum(enumType, enumValue)

    return pb.enum(enumType, enumValue)
end
