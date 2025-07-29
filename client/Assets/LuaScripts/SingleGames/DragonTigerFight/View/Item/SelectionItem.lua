local UICommonSelectionItem=Class("UICommonSelectionItem")

function UICommonSelectionItem:ctor(trs,ctrl)
    self.transform=trs
    self.gameObject=trs.gameObject
    --self.tmp_name=ComponentUtilGet.TextMeshProUGUI(self.transform,"name")
    --self.tmp_limitgold=ComponentUtilGet.TextMeshProUGUI(self.transform,"limitgold")
    --self.tmp_limitVip=ComponentUtilGet.TextMeshProUGUI(self.transform,"limitVip")
    --self.tmp_pool=ComponentUtilGet.Text(self.transform,"num")
    self.txt_bet=ComponentUtilGet.TextMeshProUGUI(self.transform,"btn_car/Text (TMP)")
    ---@type UICommonSelectionCtrl
    self.ctrl=ctrl
end

function UICommonSelectionItem:InitData(wareHouse)
    --[limitGoldMin] = 0,
    --[wareId] = 1,
    --[limitVipMin] = 0,
    --[pool] = 99999,
    --[name] = 基础场,
    --self.tmp_name.text=wareHouse.name
    --self.tmp_limitgold.text="limitVipMin:"..wareHouse.limitGoldMin
    --self.tmp_limitVip.text="limitVipMin"..wareHouse.limitVipMin
    --self.tmp_pool.text="pool"..wareHouse.pool
    self.txt_bet.text=string.upper(LocalManager.GetStrById(15009)).." "..StringUtil.FormatNumber(wareHouse.defaultBet)
end

function UICommonSelectionItem:SetActive(bl)
    self.gameObject:SetActive(bl)
end

function UICommonSelectionItem:AddClick()
    self.ctrl.uiEventListener:AddClick(self.gameObject, function
    ()
        logError("进入游戏------》")
    end)
end

return UICommonSelectionItem