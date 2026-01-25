ITEM.Name = 'Maskierter Lichking'
ITEM.Price = 260000
ITEM.Model = 'models/player/Lich_King_WoW_masked.mdl'
ITEM.PlayerModel = true

function ITEM:OnEquip(ply, modifications)
	PS_GivePlayerModel(ply, self.Model, modifications)
end

function ITEM:OnHolster(ply)
	PS_RemovePlayerModel(ply)
end