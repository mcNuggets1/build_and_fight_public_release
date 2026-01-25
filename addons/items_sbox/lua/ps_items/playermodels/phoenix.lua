ITEM.Name = 'Terrorist: Phönix'
ITEM.Price = 52000
ITEM.Model = 'models/player/phoenix.mdl'
ITEM.PlayerModel = true

function ITEM:OnEquip(ply, modifications)
	PS_GivePlayerModel(ply, self.Model, modifications)
end

function ITEM:OnHolster(ply)
	PS_RemovePlayerModel(ply)
end