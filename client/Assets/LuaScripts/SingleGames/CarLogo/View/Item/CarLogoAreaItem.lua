--
--time:{time}
--{paramdesc} 
--@desc 
--
---@class CarLogoAreaItem
local CarLogoAreaItem=Class("CarLogoAreaItem")

function CarLogoAreaItem:ctor(transform)
	self.transform = transform
	self.gameObject= transform.gameObject
    self.choose1 = ComponentUtilGet.Image(self.transform,"Choose1")
	self.choose2 =ComponentUtilGet.Image(self.transform,"Choose2")
	self.totalNum=ComponentUtilGet.TextMeshProUGUI(self.transform,"totalNum")
	self.starRoot=ComponentUtilGet.Transform(self.transform,"Star")
	self.noteRoot=ComponentUtilGet.RectTransform(self.transform,"NoteRoot")
	self.selfNum=ComponentUtilGet.TextMeshProUGUI(self.transform,"selfNum")
	self.rateImg=ComponentUtilGet.Image(self.transform,"rate")
	
	self.choose1.gameObject:SetActive(false)
	self.choose2.gameObject:SetActive(false)
end

function CarLogoAreaItem:ShowWinFlashAnim(callFunc)
	self.choose1.gameObject:SetActive(true);
	self.choose2.gameObject:SetActive(true);
	Tools.DOFade_Repeat(self.choose1,0.5,2,0,1,function()
		self.choose1.gameObject:SetActive(false);
		if callFunc then callFunc() end
	end)
	Tools.DOFade_Repeat(self.choose2,0.5,2,0,1,function()
		self.choose2.gameObject:SetActive(false);
	end)
end

function CarLogoAreaItem:UpdateTotal(num)
	self.totalNum.text = num
	self.totalNum.gameObject:SetActive(num>0)
end

function CarLogoAreaItem:UpdateSelf(num)
	self.selfNum.text=num
	self.selfNum.gameObject:SetActive(num>0)
end

return CarLogoAreaItem