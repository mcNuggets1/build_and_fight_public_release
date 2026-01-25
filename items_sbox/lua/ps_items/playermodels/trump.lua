ITEM.Name = 'Donald Trump'
ITEM.Price = 150000
ITEM.Model = 'models/player/donald_trump.mdl'
ITEM.PlayerModel = true

function ITEM:OnEquip(ply, modifications)
	PS_GivePlayerModel(ply, self.Model, modifications)
end

function ITEM:OnHolster(ply)
	PS_RemovePlayerModel(ply)
end