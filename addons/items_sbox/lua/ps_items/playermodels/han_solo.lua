ITEM.Name = 'Han Solo'
ITEM.Price = 100000
ITEM.Model = 'models/player/han_solo.mdl'
ITEM.PlayerModel = true

function ITEM:OnEquip(ply, modifications)
	PS_GivePlayerModel(ply, self.Model, modifications)
end

function ITEM:OnHolster(ply)
	PS_RemovePlayerModel(ply)
end