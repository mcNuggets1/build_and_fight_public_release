ITEM.Name = 'Joker'
ITEM.Price = 160000
ITEM.Model = 'models/player/bobert/aojoker.mdl'
ITEM.PlayerModel = true

function ITEM:OnEquip(ply, modifications)
	PS_GivePlayerModel(ply, self.Model, modifications)
end

function ITEM:OnHolster(ply)
	PS_RemovePlayerModel(ply)
end