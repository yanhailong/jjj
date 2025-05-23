---@class BaseModel
BaseModel=Class("BaseModel")

function BaseModel:ctor()

end

function BaseModel:Awake()
    self:AddEvent();
end

function BaseModel:AddEvent()

end

function BaseModel:RemoveEvent()

end

function BaseModel:Close()
    self:RemoveEvent();
    self.view=nil;
    self.ctrl=nil;
end