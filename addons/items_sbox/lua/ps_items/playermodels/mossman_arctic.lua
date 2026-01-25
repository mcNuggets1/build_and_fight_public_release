ITEM.Name = 'Dr. Judith Mossman (Arctic)'
ITEM.Price = 37000
ITEM.Model = 'models/player/mossman_arctic.mdl'
ITEM.PlayerModel = true

function ITEM:OnEquip(ply, modifications)
	PS_GivePlayerModel(ply, self.Model, modifications)
end

function ITEM:OnHolster(ply)
	PS_RemovePlayerModel(ply)
end