ITEM.Name = 'Scouttrooper'
ITEM.Price = 110000
ITEM.Model = 'models/ninja/swbf3/scout.mdl'
ITEM.PlayerModel = true

function ITEM:OnEquip(ply, modifications)
	PS_GivePlayerModel(ply, self.Model, modifications)
end

function ITEM:OnHolster(ply)
	PS_RemovePlayerModel(ply)
end