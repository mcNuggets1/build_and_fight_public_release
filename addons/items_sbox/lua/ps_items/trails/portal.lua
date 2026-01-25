ITEM.Name = 'Portal 2-Logo'
ITEM.Price = 18000
ITEM.Material = 'trails/portal.vmt'

function ITEM:OnEquip(ply, modifications)
	PS_GiveTrail(ply, self.Material, modifications)
end

function ITEM:OnHolster(ply)
	PS_RemoveTrail(ply)
end

function ITEM:Modify(modifications)
	PS:ShowColorChooser(self, modifications)
end

function ITEM:OnModify(ply, modifications)
	self:OnHolster(ply)
	self:OnEquip(ply, modifications)
end