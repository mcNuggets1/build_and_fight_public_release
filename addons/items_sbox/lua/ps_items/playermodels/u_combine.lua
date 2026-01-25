ITEM.Name = 'Unbewaffneter Combine-Soldat'
ITEM.Price = 83000
ITEM.Model = 'models/player/soldier_stripped.mdl'
ITEM.PlayerModel = true

function ITEM:OnEquip(ply, modifications)
	PS_GivePlayerModel(ply, self.Model, modifications)
end

function ITEM:OnHolster(ply)
	PS_RemovePlayerModel(ply)
end