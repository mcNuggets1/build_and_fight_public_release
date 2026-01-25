ITEM.Name = 'Superman'
ITEM.Price = 85000
ITEM.Model = 'models/player/superheroes/superman.mdl'
ITEM.PlayerModel = true

function ITEM:OnEquip(ply, modifications)
	PS_GivePlayerModel(ply, self.Model, modifications)
end

function ITEM:OnHolster(ply)
	PS_RemovePlayerModel(ply)
end