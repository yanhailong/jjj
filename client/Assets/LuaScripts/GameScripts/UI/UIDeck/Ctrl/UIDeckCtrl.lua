---
---Create by Administrator
---DateTime: 2025-05-07 16:45:54
---
---@class UIDeckCtrl:BaseCtrl
local UIDeckCtrl=Class("UIDeckCtrl",BaseCtrl)

local GameDataManager = require("GameScripts/GameData/GameDataManager")

---构造函数
function UIDeckCtrl:ctor(ctrlName,param)
    self.layer=2;
    self.abName="OutPut/UI/UIDeck/UIDeck";
    self.prefabName="UIDeck"
    self.super.ctor(self,ctrlName,param);
	---@type UIDeckView
	self.view = self.view
	---@type UIDeckModel
	self.model = self.model
	
	
	self.tileSize = 130
	self.tiles = {}
	self.sourceTile = nil
	self.targetTile = nil
	self.startPosition = Vector3(-402,-670,0)
	self.deckWeight = 7
	self.deckHeight = 9
end

---初始化
function UIDeckCtrl:CtrlInit(args)
	self.super.CtrlInit(self,args);
	self:InitDeckTileData()
	self:CreateGround();

	--
	-----@type Item
	--local obj=item.New(self.gameObject)
	--obj:Cheks()
end

function UIDeckCtrl:Close()
    self.super.Close(self);
end

---添加UI事件
function UIDeckCtrl:AddUIEvent()
	--GlobalEvent.AddListener(self,GlobalEventName.OnClickBackBtn,function()
	--	self:Close();
	--end)
	--GlobalEvent.Notify(GlobalEventName.OnClickBackBtn,GlobalEventName.OnClickBackBtn,0);
end

---移除UI事件
function UIDeckCtrl:RemoveEvent()
	self.super.RemoveEvent(self);
end

--region UI事件方法

--endregion

function UIDeckCtrl:InitDeckTileData()
	for i = 0,self.deckHeight - 1 do
		for j = 0, self.deckWeight - 1 do
			local x = j
			local y = i
			local productId = math.random(1, 10)
			local productState = GameDataManager.ProductState.None
			GameDataManager.SetDeckTileData(x,y,productId, productState)
		end
		
	end
end

function UIDeckCtrl:CreateGround()
	for i = 0,self.deckHeight - 1 do
		for j = 0, self.deckWeight - 1 do
			local x = j
			local y = i
			self:CreateTile(x,y)
		end
	end
end

function UIDeckCtrl:CreateTile(x,y)
	---@type UIDeckView
	local tileView = require("GameScripts/UI/UIDeck/View/UITile")

	local go = resMgr:CreateGameObject("OutPut/UI/UIDeck/UITile","UITile")
	go.name = "DeckTile_" .. x .. "_" .. y
	go.transform:SetParent(self.view.trans_tile_root)
	go.transform.localScale = Vector3(1, 1, 1)

	local tileData = 
	{
		x = x,
		y = y,
		tileSize = self.tileSize,
		startPosition = self.startPosition,
		onDrag = function(tile)
			self:OnTileDrag(tile)
		end,
		onPointerEnter = function(tile)
			self:OnTilePointerEnter(tile)
		end,
		onPointerExit = function(tile)
			self:OnTilePointerExit(tile)
		end,
		onPointerDown = function(tile)
			self:OnTilePointerDown(tile)
		end,
		onPointerUp = function(tile)
			self:OnTilePointerUp(tile)
		end,
		onBeginDrag = function(position)
			self:OnTileBeginDrag(position)
		end,
		
	}
	local tile = tileView.New(go) 
	tile:SetData(tileData)



	self.tiles[x] = self.tiles[x] or {}
	self.tiles[x][y] = tile

	
end

function UIDeckCtrl:OnTileBeginDrag(tile)
	--@type UITile
	self.sourceTile = tile
	self.view.img_drag.gameObject:SetActive(true)
	self.view.img_drag.sprite = self.sourceTile.productIcon.sprite
	self.sourceTile:DisableProduct()
	print("**OnTileBeginDrag**", self.sourceTile.gameObject.name)
end

function UIDeckCtrl:OnTileDrag(position)
	self.view.img_drag.gameObject.transform.localPosition = position
end

function UIDeckCtrl:OnTilePointerEnter(tile)
	self.targetTile = tile
end

function UIDeckCtrl:OnTilePointerExit(tile)
	self.targetTile = nil
end

function UIDeckCtrl:OnTilePointerDown(tile)
	self.sourceTile = tile
end

function UIDeckCtrl:OnTilePointerUp(tile)
	self.view.img_drag.gameObject:SetActive(false)
	if self.targetTile and self.sourceTile then
		print("**OnTilePointerUp**", self.sourceTile.gameObject.name, self.targetTile.gameObject.name)
	else
		self.sourceTile:EnableProduct()
	end
end

---销毁UI
function UIDeckCtrl:RealCloseDestroy()
	self.super.RealCloseDestroy(self);
end


return UIDeckCtrl