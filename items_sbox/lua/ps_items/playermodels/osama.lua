ITEM.Name = 'Osama Bin Laden'
ITEM.Price = 100000
ITEM.Model = 'models/jessev92/kuma/characters/osama_ply.mdl'
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