ITEM.Name = 'Das Gehirn'
ITEM.Price = 200000
ITEM.Model = 'models/nseven/the_brain.mdl'
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