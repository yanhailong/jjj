local ChipManager = {}
ChipManager.__index = ChipManager

function ChipManager.New(root, prefab, icons)
    local self = setmetatable({}, ChipManager)
    self.root = root
    self.chipIcons = icons
    local ObjectPool = require "Common/Pool/ObjectPoolUtil"
    self.ChipObjectPool = ObjectPool:CreatePool("ChipPool", prefab, 10, 100, root.transform)
    return self
end

--回收
function ChipManager:MoveTargetPos(Chip_obj, target)
    Chip_obj.transform:DOMove(target.transform.position, 0.4, false):SetEase(CS.DG.Tweening.Ease.OutQuad):OnComplete(function()
        self:Unspawn(Chip_obj)
    end)
end

function ChipManager:PlayerBet(playerTranform, BetArea, BetAmount)
    local Chip_obj = self.ChipObjectPool:Spawn(self.root.transform)
    Chip_obj.transform.position = playerTranform.transform.position
    if not self.chipComponents then self.chipComponents = {} end
    if not self.chipComponents[Chip_obj] then
        self.chipComponents[Chip_obj] = {
            icon = Chip_obj.transform:Find("Icon"):GetComponent(typeof(CS.UnityEngine.UI.Image)),
            number = Chip_obj.transform:Find("Number"):GetComponent(typeof(CS.UnityEngine.UI.Text))
        }
    end
    local comp = self.chipComponents[Chip_obj]
    comp.icon.sprite = self.chipIcons[BetAmount / 100]
    comp.number.text = tostring(BetAmount)
    Chip_obj.transform:DOMove(BetArea, 0.2, false):SetEase(CS.DG.Tweening.Ease.OutQuad)
    Chip_obj.transform:SetAsLastSibling()
    return Chip_obj
end

function ChipManager:Unspawn(obj)
    self.ChipObjectPool:Unspawn(obj)
end

function ChipManager:DestroyAll()
    self.chipComponents = nil;
    self.ChipObjectPool:DestroyAll()
end

return ChipManager
