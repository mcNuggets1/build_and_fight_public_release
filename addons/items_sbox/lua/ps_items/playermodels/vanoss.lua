ITEM.Name = 'Vanoss'
ITEM.Price = 80000
ITEM.Model = 'models/player/vanoss/evan.mdl'
ITEM.PlayerModel = true

function ITEM:OnEquip(ply, modifications)
	PS_GivePlayerModel(ply, self.Model, modifications)
end

function ITEM:OnHolster(ply)
	PS_RemovePlayerModel(ply)
end