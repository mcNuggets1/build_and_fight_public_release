ITEM.Name = 'Alyx Vance'
ITEM.Price = 38000
ITEM.Model = 'models/player/alyx.mdl'
ITEM.PlayerModel = true

function ITEM:OnEquip(ply, modifications)
	PS_GivePlayerModel(ply, self.Model, modifications)
end

function ITEM:OnHolster(ply)
	PS_RemovePlayerModel(ply)
end