ITEM.Name = 'Link'
ITEM.Price = 140000
ITEM.Model = 'models/player/hw_link.mdl'
ITEM.PlayerModel = true

function ITEM:OnEquip(ply, modifications)
	PS_GivePlayerModel(ply, self.Model, modifications)
end

function ITEM:OnHolster(ply)
	PS_RemovePlayerModel(ply)
end

function ITEM:Modify(modifications)
	PS:ShowSkinChooser(self, modifications)
end

function ITEM:OnModify(ply, modifications)
	self:OnEquip(ply, modifications)
end