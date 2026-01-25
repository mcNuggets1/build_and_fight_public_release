ITEM.Name = 'Counter-Terrorist: Urban'
ITEM.Price = 75000
ITEM.Model = 'models/player/urban.mdl'
ITEM.PlayerModel = true

function ITEM:OnEquip(ply, modifications)
	PS_GivePlayerModel(ply, self.Model, modifications)
end

function ITEM:OnHolster(ply)
	PS_RemovePlayerModel(ply)
end