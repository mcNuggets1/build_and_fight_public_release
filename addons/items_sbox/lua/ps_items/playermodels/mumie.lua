ITEM.Name = 'Mumie'
ITEM.Price = 74000
ITEM.Model = 'models/player/corpse1.mdl'
ITEM.PlayerModel = true

function ITEM:OnEquip(ply, modifications)
	PS_GivePlayerModel(ply, self.Model, modifications)
end

function ITEM:OnHolster(ply)
	PS_RemovePlayerModel(ply)
end