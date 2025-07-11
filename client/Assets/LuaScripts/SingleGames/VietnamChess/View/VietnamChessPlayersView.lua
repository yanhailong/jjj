---
---Create by Administrator
---DateTime: 2025-07-10 15:47:41
---
---@class VietnamChessPlayersView:BaseView
local VietnamChessPlayersView=Class("VietnamChessPlayersView",BaseView)

---初始化panel
function VietnamChessPlayersView:InitView()
	---@type VietnamChessPlayersCtrl
    self.ctrl=self.ctrl
	self:InitComponents()
end

---获取组件
function VietnamChessPlayersView:InitComponents()
    self.img_title=ComponentUtilGet.Image(self.transform,"content/BackGround/img_title");
    self.btn_close=ComponentUtilGet.Button(self.transform,"content/BackGround/btn_close");
    self.img_rank=ComponentUtilGet.Image(self.transform,"content/ScrollView/Viewport/item/PlayerRankItem/img_rank");
    self.txt_rank=ComponentUtilGet.Text(self.transform,"content/ScrollView/Viewport/item/PlayerRankItem/txt_rank");
    self.tmp_name=ComponentUtilGet.TextMeshProUGUI(self.transform,"content/ScrollView/Viewport/item/PlayerRankItem/info/tmp_name");
    self.tmp_coin=ComponentUtilGet.TextMeshProUGUI(self.transform,"content/ScrollView/Viewport/item/PlayerRankItem/info/coin/tmp_coin");
    self.tmp_game=ComponentUtilGet.TextMeshProUGUI(self.transform,"content/ScrollView/Viewport/item/PlayerRankItem/info/tmp_game");
    self.tmp_xiazhu=ComponentUtilGet.TextMeshProUGUI(self.transform,"content/ScrollView/Viewport/item/PlayerRankItem/info/tmp_xiazhu");
    self.tmp_sucnum=ComponentUtilGet.TextMeshProUGUI(self.transform,"content/ScrollView/Viewport/item/PlayerRankItem/info/tmp_sucnum");
end

---清空组件
function VietnamChessPlayersView:ClearComponents()
    self.img_title=nil;
    self.btn_close=nil;
    self.img_rank=nil;
    self.txt_rank=nil;
    self.tmp_name=nil;
    self.tmp_coin=nil;
    self.tmp_game=nil;
    self.tmp_xiazhu=nil;
    self.tmp_sucnum=nil;
end

---初始化View数据
function VietnamChessPlayersView:InitPanelData(args)
	
end

---关闭界面
function VietnamChessPlayersView:Close()   
    self.super.Close(self);
end

return VietnamChessPlayersView

