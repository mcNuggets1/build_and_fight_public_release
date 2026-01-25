ITEM.Name = 'Rick Sanchez'
ITEM.Price = 160000
ITEM.Model = 'models/player/rick/rick.mdl'
ITEM.PlayerModel = true

function ITEM:OnEquip(ply, modifications)
	PS_GivePlayerModel(ply, self.Model, modifications)
end

function ITEM:OnHolster(ply)
	PS_RemovePlayerModel(ply)
end