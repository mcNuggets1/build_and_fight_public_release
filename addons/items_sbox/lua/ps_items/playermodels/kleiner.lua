ITEM.Name = 'Dr. Isaac Kleiner'
ITEM.Price = 42000
ITEM.Model = 'models/player/kleiner.mdl'
ITEM.PlayerModel = true

function ITEM:OnEquip(ply, modifications)
	PS_GivePlayerModel(ply, self.Model, modifications)
end

function ITEM:OnHolster(ply)
	PS_RemovePlayerModel(ply)
end