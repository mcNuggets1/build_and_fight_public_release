ITEM.Name = 'Luke Skywalker'
ITEM.Price = 120000
ITEM.Model = 'models/player/luke_skywalker.mdl'
ITEM.PlayerModel = true

function ITEM:OnEquip(ply, modifications)
	PS_GivePlayerModel(ply, self.Model, modifications)
end

function ITEM:OnHolster(ply)
	PS_RemovePlayerModel(ply)
end