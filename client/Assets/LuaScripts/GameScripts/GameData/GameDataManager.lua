
---@class GameDataManager
local GameDataManager = {}

GameDataManager.ProductState = 
{
    None = 0,
    Locked = 1 << 0,
    Mergeable = 1 << 1,
    Visible = 1 << 2,
}

local GameData = {
    Energy = 0,
    Gold = 0,
    DeckTileData = {} --DeckData[x][y] = { productId = 1, productState = ProductState.None }
}

function GameDataManager.AddEnergy(value)
    GameData.Energy = GameData.Energy + value
end

function GameDataManager.SubEnergy(value)

    GameData.Energy = GameData.Energy - value
end

function GameDataManager.GetEnergy()
    return GameData.Energy
end

function GameDataManager.AddGold(value)
    GameData.Gold = GameData.Gold + value
end

function GameDataManager.SubGold(value)
    GameData.Gold = GameData.Gold - value
end

function GameDataManager.GetGold()
    return GameData.Gold
end

function GameDataManager.SetDeckTileData(x,y,productId, productState)
    GameData.DeckTileData[x] = GameData.DeckTileData[x] or {}
    GameData.DeckTileData[x][y] = {
        productId = productId,
        productState = productState
    }
    GlobalEvent.Notify(EventID.OnTileDataChange, x,y)
end

function GameDataManager.GetDeckTileData(x,y)
    if GameData.DeckTileData[x] == nil then
        return nil
    end
    return GameData.DeckTileData[x][y]
end

function GameDataManager.SaveGameData()
    --todo 序列化
end

function GameDataManager.LoadGameData()
    --todo 反序列化
end

return GameDataManager






