ITEM.Name = 'Counter-Terrorist: S.W.A.T'
ITEM.Price = 65000
ITEM.Model = 'models/player/swat.mdl'
ITEM.PlayerModel = true

function ITEM:OnEquip(ply, modifications)
	PS_GivePlayerModel(ply, self.Model, modifications)
end

function ITEM:OnHolster(ply)
	PS_RemovePlayerModel(ply)
end