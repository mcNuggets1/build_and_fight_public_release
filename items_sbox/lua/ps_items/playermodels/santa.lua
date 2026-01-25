ITEM.Name = 'Santa Claus'
ITEM.Price = 170000
ITEM.Model = 'models/player/christmas/santa.mdl'
ITEM.PlayerModel = true

function ITEM:OnEquip(ply, modifications)
	PS_GivePlayerModel(ply, self.Model, modifications)
end

function ITEM:OnHolster(ply)
	PS_RemovePlayerModel(ply)
end