ITEM.Name = 'Terrorist: Leet'
ITEM.Price = 43000
ITEM.Model = 'models/player/leet.mdl'
ITEM.PlayerModel = true

function ITEM:OnEquip(ply, modifications)
	PS_GivePlayerModel(ply, self.Model, modifications)
end

function ITEM:OnHolster(ply)
	PS_RemovePlayerModel(ply)
end