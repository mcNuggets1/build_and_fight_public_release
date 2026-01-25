ITEM.Name = 'Dr. Magnusson'
ITEM.Price = 46000
ITEM.Model = 'models/player/magnusson.mdl'
ITEM.PlayerModel = true

function ITEM:OnEquip(ply, modifications)
	PS_GivePlayerModel(ply, self.Model, modifications)
end

function ITEM:OnHolster(ply)
	PS_RemovePlayerModel(ply)
end