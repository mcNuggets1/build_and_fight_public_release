ITEM.Name = 'Kermit der Frosch'
ITEM.Price = 130000
ITEM.Model = 'models/player/kermit.mdl'
ITEM.PlayerModel = true

function ITEM:OnEquip(ply, modifications)
	PS_GivePlayerModel(ply, self.Model, modifications)
end

function ITEM:OnHolster(ply)
	PS_RemovePlayerModel(ply)
end