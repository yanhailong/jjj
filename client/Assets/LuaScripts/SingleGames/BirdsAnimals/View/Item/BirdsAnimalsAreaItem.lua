--
--time:{time}
--{paramdesc} 
--@desc 
--
---@class BirdsAnimalsAreaItem
local BirdsAnimalsAreaItem=Class("BirdsAnimalsAreaItem")
local BirdsAnimalsConfig=require("SingleGames/BirdsAnimals/BirdsAnimalsConfig")
local BirdsAnimalsHelper=require("SingleGames/BirdsAnimals/BirdsAnimalsHelper")

function BirdsAnimalsAreaItem:ctor(transform,index)
	self.index = index;
	self.logo_id = BirdsAnimalsConfig.ANIMA_HISTORY[index]
	self.transform = transform
	self.gameObject= transform.gameObject
    self.choose1 = ComponentUtilGet.Image(self.transform,"Choose1")
	self.animal =ComponentUtilGet.Image(self.transform,"animal")
	self.pic=ComponentUtilGet.Image(self.transform,"pic")
	self.totalNum=ComponentUtilGet.TextMeshProUGUI(self.transform,"totalNum")
	self.starRoot=ComponentUtilGet.Transform(self.transform,"Star")
	self.noteRoot=ComponentUtilGet.RectTransform(self.transform,"NoteRoot")
	self.selfNum=ComponentUtilGet.TextMeshProUGUI(self.transform,"selfNum")
	self.bg = ComponentUtilGet.GameObject(self.transform,"bg")
	self.rateTxt=ComponentUtilGet.Text(self.transform,"rate")
	self.name =ComponentUtilGet.Text(self.transform,"name")
	
	self.choose1.gameObject:SetActive(false)
	self.pic.gameObject:SetActive(false)
	
	self:InitUI()
end

function BirdsAnimalsAreaItem:InitUI()
 	self.name.text = BirdsAnimalsHelper.LoadNameLanguage(self.logo_id)
	self.rateTxt.text = "X"..BirdsAnimalsConfig.ODDS[self.logo_id]
	if self.logo_id==BirdsAnimalsConfig.ANIMAL_TYPE.FeiQin then
		self.pic.gameObject:SetActive(true)
		self.animal.gameObject:SetActive(false)
		self.pic.sprite=BirdsAnimalsHelper.LoadTxtSprite("fqzs_txt_Poultry")
		self.pic:SetNativeSize()
	elseif self.logo_id==BirdsAnimalsConfig.ANIMAL_TYPE.ZouShou then
		self.pic.gameObject:SetActive(true)
		self.animal.gameObject:SetActive(false)
		self.pic.sprite=BirdsAnimalsHelper.LoadTxtSprite("fqzs_txt_Beast")
		self.pic:SetNativeSize()
	else
		self.animal.sprite = BirdsAnimalsHelper.LoadLogoSprite(self.logo_id)
	end
end

function BirdsAnimalsAreaItem:ShowWinFlashAnim()
	self.choose1.gameObject:SetActive(true);
	Tools.DOFade_Repeat(self.choose1,0.5,2,0,function()
		self.choose1.gameObject:SetActive(false);
	end)
end

function BirdsAnimalsAreaItem:UpdateTotal(num)
	self.totalNum.text = num
	--self.totalNum.gameObject:SetActive(num>0)
end

function BirdsAnimalsAreaItem:UpdateSelf(num)
	self.selfNum.text=num
	--self.selfNum.gameObject:SetActive(num>0)
	--self.bg:SetActive(num>0)
end

return BirdsAnimalsAreaItem