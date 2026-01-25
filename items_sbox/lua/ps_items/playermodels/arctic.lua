ITEM.Name = 'Terrorist: Arctic'
ITEM.Price = 50000
ITEM.Model = 'models/player/arctic.mdl'
ITEM.PlayerModel = true

function ITEM:OnEquip(ply, modifications)
	PS_GivePlayerModel(ply, self.Model, modifications)
end

function ITEM:OnHolster(ply)
	PS_RemovePlayerModel(ply)
end