ITEM.Name = 'Counter-Terrorist: Gasmask'
ITEM.Price = 77000
ITEM.Model = 'models/player/gasmask.mdl'
ITEM.PlayerModel = true

function ITEM:OnEquip(ply, modifications)
	PS_GivePlayerModel(ply, self.Model, modifications)
end

function ITEM:OnHolster(ply)
	PS_RemovePlayerModel(ply)
end