ITEM.Name = 'Mad Moxxie'
ITEM.Price = 88000
ITEM.Model = 'models/player_moxxi.mdl'
ITEM.PlayerModel = true

function ITEM:OnEquip(ply, modifications)
	PS_GivePlayerModel(ply, self.Model, modifications)
end

function ITEM:OnHolster(ply)
	PS_RemovePlayerModel(ply)
end