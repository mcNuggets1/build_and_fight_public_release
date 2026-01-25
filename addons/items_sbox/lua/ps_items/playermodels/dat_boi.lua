ITEM.Name = 'Dat Boi'
ITEM.Price = 300000
ITEM.Model = 'models/datboi/datboi_reference.mdl'
ITEM.PlayerModel = true

function ITEM:OnEquip(ply, modifications)
	PS_GivePlayerModel(ply, self.Model, modifications)
end

function ITEM:OnHolster(ply)
	PS_RemovePlayerModel(ply)
end