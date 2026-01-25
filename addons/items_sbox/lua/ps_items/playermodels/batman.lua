ITEM.Name = 'Batman'
ITEM.Price = 92000
ITEM.Model = 'models/batman/slow/jamis/mkvsdcu/batman/slow_pub_v2.mdl'
ITEM.PlayerModel = true

function ITEM:OnEquip(ply, modifications)
	PS_GivePlayerModel(ply, self.Model, modifications)
end

function ITEM:OnHolster(ply)
	PS_RemovePlayerModel(ply)
end