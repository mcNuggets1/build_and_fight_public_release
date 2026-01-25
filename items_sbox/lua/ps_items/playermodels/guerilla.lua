ITEM.Name = 'Terrorist: Guerilla'
ITEM.Price = 39000
ITEM.Model = 'models/player/guerilla.mdl'
ITEM.PlayerModel = true

function ITEM:OnEquip(ply, modifications)
	PS_GivePlayerModel(ply, self.Model, modifications)
end

function ITEM:OnHolster(ply)
	PS_RemovePlayerModel(ply)
end