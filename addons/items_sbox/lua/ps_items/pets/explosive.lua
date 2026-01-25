ITEM.Name = 'Ze Explosive'
ITEM.Price = 50000
ITEM.Model = 'models/props_c17/oildrum001_explosive.mdl'
ITEM.PetName = 'explosive'
ITEM.NoPreview = true

function ITEM:OnEquip(ply)
	if ply:Alive() then
		ply:CreatePet(self.PetName)
	end
end

function ITEM:OnHolster(ply)
	ply:RemovePet()
end