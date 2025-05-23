
---@class Queue
Queue = {};

function Queue:ctor()
    self.queue = {};
    self.size_ = 0;
    self.head = 0;
    self.rear = 0;
end

function Queue:Enqueue(element)
	self.queue[self.rear] = element;
	self.rear = self.rear + 1;
	self.size_ = self.size_ + 1;
end

function Queue:Dequeue()
    if self:IsEmpty() then
        return nil;
    end
	self.head = self.head + 1;
    self.size_ = self.size_ - 1;
	local obj = self.queue[self.head-1]
	self.queue[self.head-1] = nil;
    return obj;
end

function Queue:Clear()
    self.queue = nil;
    self.queue = {};
    self.size_ = 0;
    self.head = 0;
    self.rear = 0;
end

function Queue:IsEmpty()
    if self:Count() == 0 then
        return true
    end
    return false
end

function Queue:Count()
    return self.size_
end

function Queue.New()
    local temp = {}
    setmetatable(temp, {__index = Queue})
    temp:ctor()
    return temp
end
