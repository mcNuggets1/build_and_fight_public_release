ITEM.Name = 'Verkohlte Leiche'
ITEM.Price = 79000
ITEM.Model = 'models/player/charple.mdl'
ITEM.PlayerModel = true

function ITEM:OnEquip(ply, modifications)
	PS_GivePlayerModel(ply, self.Model, modifications)
end

function ITEM:OnHolster(ply)
	PS_RemovePlayerModel(ply)
end