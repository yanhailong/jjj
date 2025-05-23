---非阻塞调用当前方法
function Fire(func,...)
	local co=coroutine.create(func)
	local flag,err=coroutine.resume(co,...)
	if not flag then
		logError(debug.traceback(co, err))
	end
end

---@class GlobalEvent
local GlobalEvent = {}
local this=GlobalEvent
local events = {}

function this.AddListener(event,handle,cls,isNoticeSelf)
	if not event then
		logError( "event is null")
	end
	if not handle or type(handle)~="function" then
		logError("handle not is function ")
	end

	local hds;
	if events[event]==nil then
		hds={}
		events[event]=hds;
	else
		hds=events[event];
	end

	--for _,v in ipairs(hds) do
	--	if v.handle==handle then
	--		if cls and v.cls~=cls then
	--			logError("重复添加的的handle但是cls不同")
	--		end
	--		--return;
	--	end
	--end

	local tab={};
	tab.cls=cls;
	tab.handle=handle;
	tab.isOnce=isOnce;
	table.insert(hds,tab);
	if cls then
		if cls._global_event_auto_add==nil then
			cls._global_event_auto_add={};
		end
		cls._global_event_auto_add[event]=handle;
	end
end

function this.AddListenerOnce(event,handle,cls)
	this.AddListener(event,handle,cls,true);
end

function this.Notify(event,...)
	local hds=events[event];
	if hds==nil then
		logWarn("事件："..event.." 未监听！")
		return 
	end
	local removeOnce;
	local arr={...}
	for _,v in ipairs(hds) do
		if not v.cls then
			Fire(v.handle,...)
		else
			Fire(v.handle,v.cls,...)
		end
		if v.isOnce then
			if removeOnce==nil then
				removeOnce={};
			end
			table.insert(removeOnce,v.handle)
		end
	end

	if removeOnce then
		for _,v in ipairs(removeOnce) do
			this.Remove(event,v)
		end
	end

end

function this.RemoveAllTo(cls)
	if cls._global_event_auto_add==nil then
		return;
	end
	for k,v in pairs(cls._global_event_auto_add) do
		this.Remove(k,v)
	end
	cls._global_event_auto_add=nil;
end

function this.Remove(event,handle)
	local hds=events[event];
	if hds==nil then return end
	local index=-1;
	for i = 1, #hds do
		local v=hds[i];
		if v.handle==handle then
			index=i;
			break;
		end
	end
	if index~=-1 then
		table.remove(hds,index)
	end
end

function this.RemoveAllByEventName(event)
	if events[event] then
		events[event]=nil	
	end
end

function this.RemoveAllEvent()
	for k,v in pairs(events) do
		if v then
			events[k]=nil
		end
	end
end

return GlobalEvent