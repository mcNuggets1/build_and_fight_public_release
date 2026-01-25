ITEM.Name = 'Combine-Elite'
ITEM.Price = 50000
ITEM.Model = 'models/player/combine_super_soldier.mdl'
ITEM.PlayerModel = true

function ITEM:OnEquip(ply, modifications)
	PS_GivePlayerModel(ply, self.Model, modifications)
end

function ITEM:OnHolster(ply)
	PS_RemovePlayerModel(ply)
end