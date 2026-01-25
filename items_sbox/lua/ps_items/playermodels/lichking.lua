ITEM.Name = 'Lichking'
ITEM.Price = 240000
ITEM.Model = 'models/player/Lich_King_WoW_maskless.mdl'
ITEM.PlayerModel = true

function ITEM:OnEquip(ply, modifications)
	PS_GivePlayerModel(ply, self.Model, modifications)
end

function ITEM:OnHolster(ply)
	PS_RemovePlayerModel(ply)
end