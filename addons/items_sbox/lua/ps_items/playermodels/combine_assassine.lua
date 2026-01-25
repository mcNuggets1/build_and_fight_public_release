ITEM.Name = 'Combine-Assassine'
ITEM.Price = 61000
ITEM.Model = 'models/player/e3assassin.mdl'
ITEM.PlayerModel = true

function ITEM:OnEquip(ply, modifications)
	PS_GivePlayerModel(ply, self.Model, modifications)
end

function ITEM:OnHolster(ply)
	PS_RemovePlayerModel(ply)
end