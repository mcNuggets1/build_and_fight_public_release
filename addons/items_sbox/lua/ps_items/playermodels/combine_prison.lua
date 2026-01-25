ITEM.Name = 'Combine-Gefängniswärter'
ITEM.Price = 48000
ITEM.Model = 'models/player/combine_soldier_prisonguard.mdl'
ITEM.PlayerModel = true

function ITEM:OnEquip(ply, modifications)
	PS_GivePlayerModel(ply, self.Model, modifications)
end

function ITEM:OnHolster(ply)
	PS_RemovePlayerModel(ply)
end