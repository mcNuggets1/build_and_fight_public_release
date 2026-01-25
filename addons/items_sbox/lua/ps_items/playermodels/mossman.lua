ITEM.Name = 'Dr. Judith Mossman'
ITEM.Price = 34000
ITEM.Model = 'models/player/mossman.mdl'
ITEM.PlayerModel = true

function ITEM:OnEquip(ply, modifications)
	PS_GivePlayerModel(ply, self.Model, modifications)
end

function ITEM:OnHolster(ply)
	PS_RemovePlayerModel(ply)
end