-- added by wsh @ 2017-12-27

-- xlua对UntyEngine的Object判空不能直接判nil
-- https://github.com/Tencent/xLua/blob/master/Assets/XLua/Doc/faq.md
function IsNull(unity_object)
	if unity_object == nil then
		return true
	end
	if type(unity_object) == "userdata" then
		if unity_object.Equals then
			return unity_object:Equals(nil)
		end
		if unity_object.IsNull then
			return unity_object:IsNull()
		end
	end

	return false
end

function instantiate(obj,parent)
	if IsNull(obj) then return end
	return Object.Instantiate(obj,parent)
end

function destroy(obj)
	if IsNull(obj) then return end
	return Object.Destroy(obj)
end

return CS.UnityEngine.Object