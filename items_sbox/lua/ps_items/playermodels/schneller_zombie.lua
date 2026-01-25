ITEM.Name = 'Schneller Zombie'
ITEM.Price = 180000
ITEM.Model = 'models/player/zombie_fast.mdl'
ITEM.PlayerModel = true

function ITEM:OnEquip(ply, modifications)
	PS_GivePlayerModel(ply, self.Model, modifications)
end

function ITEM:OnHolster(ply)
	PS_RemovePlayerModel(ply)
end