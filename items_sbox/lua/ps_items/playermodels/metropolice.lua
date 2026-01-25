ITEM.Name = 'Metro Police'
ITEM.Price = 57000
ITEM.Model = 'models/player/police.mdl'
ITEM.PlayerModel = true

function ITEM:OnEquip(ply, modifications)
	PS_GivePlayerModel(ply, self.Model, modifications)
end

function ITEM:OnHolster(ply)
	PS_RemovePlayerModel(ply)
end