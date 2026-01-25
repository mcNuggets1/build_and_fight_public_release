ITEM.Name = 'Kylo Ren'
ITEM.Price = 130000
ITEM.Model = 'models/grealms/characters/kyloren/kyloren.mdl'
ITEM.PlayerModel = true

function ITEM:OnEquip(ply, modifications)
	PS_GivePlayerModel(ply, self.Model, modifications)
end

function ITEM:OnHolster(ply)
	PS_RemovePlayerModel(ply)
end