ITEM.Name = 'Spiderman'
ITEM.Price = 95000
ITEM.Model = 'models/mario8251_pm/advanced_suit.mdl'
ITEM.PlayerModel = true

function ITEM:OnEquip(ply, modifications)
	PS_GivePlayerModel(ply, self.Model, modifications)
end

function ITEM:OnHolster(ply)
	PS_RemovePlayerModel(ply)
end