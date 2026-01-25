ITEM.Name = 'SCP-049'
ITEM.Price = 110000
ITEM.Model = 'models/vinrax/player/scp049_player.mdl'
ITEM.PlayerModel = true

function ITEM:OnEquip(ply, modifications)
	PS_GivePlayerModel(ply, self.Model, modifications)
end

function ITEM:OnHolster(ply)
	PS_RemovePlayerModel(ply)
end