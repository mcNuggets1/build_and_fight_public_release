ITEM.Name = 'Barney Calhoun'
ITEM.Price = 32000
ITEM.Model = 'models/player/barney.mdl'
ITEM.PlayerModel = true

function ITEM:OnEquip(ply, modifications)
	PS_GivePlayerModel(ply, self.Model, modifications)
end

function ITEM:OnHolster(ply)
	PS_RemovePlayerModel(ply)
end