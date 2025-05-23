---@class BaseCtrl
BaseCtrl = Class("BaseCtrl")

function BaseCtrl:ctor(ctrlName,param)
    self.ctrlName=ctrlName;
    --关系绑定
    self.view=param.view.New(self.ctrlName);
    self.model=param.model.New();
    self.view.ctrl=self;
    self.view.model=self.model;
    self.model.ctrl=self;
    self.model.view=self.view;

    self.isPlayAni=false
    --UI事件管理器
    ---@type  UIEventListener
    self.uiEventListener=UIEventListener.Get();
    if  self.layer == nil then
        self.layer = 2;
    end
end

function BaseCtrl:OpenAni()
    if (self.content) then
        CorManager.StartCor(self, function()
            self.content.localScale = Vector3.Zero()
            self.content:DOScale(Vector3.New(1, 1, 1), 0.2)
        end)
    else
        logError("self.content==nil")
    end
end

---绑定游戏对象
function BaseCtrl:BindGameObject(go)
    ---@type UnityEngine.GameObject
    self.gameObject = go;
    ---@type UnityEngine.Transform
    self.transform = go.transform;
    self.content=ComponentUtilGet.Transform(self.transform,"content")
    self.isBindGameObject=true;
end

function BaseCtrl:Awake()
    self.view:Awake(self.gameObject);
    self.model:Awake();
    self:AddUIEvent();
    if self.isPlayAni==true then
        self:AddActiveCallback(Handler(self,self.OpenAni))
    end
end

--每次打开调用
function BaseCtrl:CtrlInit(args)
    if self._asyncOpenFunc then
        self._asyncOpenFunc();
        self._asyncOpenFunc=nil;
    end
    self.view:InitPanelData(args);
end

--二次打开初始化
function BaseCtrl:SecondInit(args)
    self.view:SecondInitData(args);
end

function BaseCtrl:AddUIEvent(args)

end

function BaseCtrl:OnCtrlActive(bol)
    if self.view==nil then return end
    self.view:OnActive(bol);
end

function BaseCtrl:Show()
    --//当前对象是否显示
    self.isActive = true;
    self:OnCtrlActive(true);
    if self.isPlayAni and self._activeFunc then
        self._activeFunc();
    end
end

function BaseCtrl:Close()
    if self.view==nil then return end
    CtrlManager.RemoveCtrl(self.ctrlName);
    self:OnDestroy()
    self:RealCloseDestroy();
end

function BaseCtrl:Hiden()
    if not self.isActive then return end
    self.isActive = false;
    self:OnCtrlActive(false);
    if self.isPlayAni and self._hideFunc then
        self._hideFunc();
    end
end

-- 销毁调用
function BaseCtrl:RealCloseDestroy()
    self.isActive = false;
    self:RemoveEvent();
    self.view:Close();
    self.model:Close();
    self.ctrlName=nil;
    self.name = nil;
    self.view=nil;
    self.model=nil;
    self.isBindGameObject=nil;
    ---界面关闭回调
    if self._closeFunc then
        self._closeFunc();
        self._closeFunc=nil;
    end
    self._hideFunc=nil;
    self._activeFunc=nil;
end

function BaseCtrl:RemoveEvent()
    self.uiEventListener:Clear();
    self.uiEventListener=nil;
end

function BaseCtrl:OnDestroy()

end

---添加异步打开回调
function BaseCtrl:AddAsyncOpenCallback(func)
    self._asyncOpenFunc=func;
    return self;
end
---添加关闭回调
function BaseCtrl:AddCloseCallback(func)
    self._closeFunc=func;
    return self;
end
---添加界面隐藏回调
function BaseCtrl:AddHideCallback(func)
    self._hideFunc=func;
    return self;
end
---界面激活回调
function BaseCtrl:AddActiveCallback(func)
    self._activeFunc=func;
    return self;
end
