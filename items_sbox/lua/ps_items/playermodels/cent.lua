ITEM.Name = '50 Cent'
ITEM.Price = 76000
ITEM.Model = 'models/code_gs/50cent/50centplayer.mdl'
ITEM.PlayerModel = true

function ITEM:OnEquip(ply, modifications)
	PS_GivePlayerModel(ply, self.Model, modifications)
end

function ITEM:OnHolster(ply)
	PS_RemovePlayerModel(ply)
end