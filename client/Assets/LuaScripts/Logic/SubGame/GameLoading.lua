---游戏加载
---@class GameLoading
local GameLoading=Class("SubGameLoading")

function GameLoading:ctor(panelPath)
    self.panelPath=panelPath;
    self:InitPanel();
    self:AddListener();
    self.curProValue=0;
    self.tempProValue=0;
end

function GameLoading:InitPanel()
    self.gameObject=PanelManager.CreatePanel(self.panelPath,nil,4);
    self.transform=self.gameObject.transform;
    self.sli_por=ComponentUtilGet.Image(self.transform,"content/Img_proFill")
    self.txt_por=ComponentUtilGet.TextMeshProUGUI(self.transform,"content/tmp_pro")
end

function GameLoading:AddListener()
    GlobalEvent.AddListener(SubGame.EventName.LoadError,self.LoadError,self);
    GlobalEvent.AddListener(SubGame.EventName.LoadProgress,self.LoadProgress,self);

    UpdateManager.AddUpdate(self,self.Update)
end

function GameLoading:RemoveListener()
    UpdateManager.ReMoveAllUpdate(self)
    GlobalEvent.RemoveAllTo(self);
end

function GameLoading:LoadError()
    self:Close();
end

function GameLoading:LoadProgress(v)
    self.curProValue=v;
end

function GameLoading:Update()
    if self.tempProValue<self.curProValue then
        self.tempProValue=self.tempProValue+0.02;
        self.sli_por.fillAmount=self.tempProValue;
        self.txt_por.text=math.floor(self.tempProValue*100).."%";
    end
end

function GameLoading:Close()
    self:RemoveListener();
    CorManager.StartCor(self,function ()
        if self.tempProValue<1 then
            local dt=1-self.tempProValue;
            for i = 1, 5 do
                local  v=Tools.Lerp(self.tempProValue,1,i/5);
                self.sli_por.fillAmount=v;
                self.txt_por.text=math.floor(v*100).."%";
                coroutine.wait(0)
            end
            self.sli_por.fillAmount=1;
            self.txt_por.text="100%";
            coroutine.wait(0.1)
        end

        self.curProValue=nil;
        self.tempProValue=nil;
        Tools.Destroy(self.gameObject);
    end)
end

return GameLoading;