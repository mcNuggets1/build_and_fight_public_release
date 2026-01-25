ITEM.Name = 'Voldemort'
ITEM.Price = 140000
ITEM.Model = 'models/player/lord_voldemort.mdl'
ITEM.PlayerModel = true

function ITEM:OnEquip(ply, modifications)
	PS_GivePlayerModel(ply, self.Model, modifications)
end

function ITEM:OnHolster(ply)
	PS_RemovePlayerModel(ply)
end