ITEM.Name = 'Dr. Wallace Breen'
ITEM.Price = 43000
ITEM.Model = 'models/player/breen.mdl'
ITEM.PlayerModel = true

function ITEM:OnEquip(ply, modifications)
	PS_GivePlayerModel(ply, self.Model, modifications)
end

function ITEM:OnHolster(ply)
	PS_RemovePlayerModel(ply)
end