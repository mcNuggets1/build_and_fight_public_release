ITEM.Name = 'Makima'
ITEM.Price = 200000
ITEM.Model = 'models/dih/makima.mdl'
ITEM.PlayerModel = true

function ITEM:OnEquip(ply, modifications)
	PS_GivePlayerModel(ply, self.Model, modifications)
end

function ITEM:OnHolster(ply)
	PS_RemovePlayerModel(ply)
end