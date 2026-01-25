ITEM.Name = 'TV Head'
ITEM.Price = 180000
ITEM.Model = 'models/player/stanmcg/tvhead/tvhead_playermodel.mdl'
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