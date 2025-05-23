---@class BaseView
BaseView = Class("BaseView");

function BaseView:ctor(name)
    self.name = name;
end

function BaseView:Awake(obj)
    self.gameObject = obj;
    ---@type UnityEngine.Transform
    self.transform = obj.transform;
    self:InitView();
end

function BaseView:InitView()

end

function BaseView:ClearComponents()

end

--//初始化panel数据
function BaseView:InitPanelData(args)

end

--二次打开初始化
function BaseView:SecondInitData(args)

end

function BaseView:OnActive(bol)
    if self.gameObject ~= nil then
        Tools.SetActive(self.gameObject,bol);
    else
        logWarn("panel为空"..tostring(self.name));
    end
end

function BaseView:Hiden()
    self:OnActive(false);
end

function BaseView:Close()
    self:ClearComponents();
    self.name = nil;
    destroy(self.gameObject);
    self.transform = nil;
    self.gameObject = nil;
    self.ctrl=nil;
    self.model=nil;
end

--获取游戏对象
function BaseView:GetGameObject(name)
    return CommpontUtilGet.GameObject(self.transform,name);
end

