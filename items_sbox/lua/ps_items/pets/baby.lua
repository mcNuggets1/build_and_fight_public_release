ITEM.Name = 'Baby Little'
ITEM.Price = 45000
ITEM.Model = 'models/props_c17/doll01.mdl'
ITEM.PetName = 'baby'
ITEM.NoPreview = true

function ITEM:OnEquip(ply)
	if ply:Alive() then
		ply:CreatePet(self.PetName)
	end
end

function ITEM:OnHolster(ply)
	ply:RemovePet()
end