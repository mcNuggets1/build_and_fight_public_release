ITEM.Name = 'Scannie'
ITEM.Price = 45000
ITEM.Model = 'models/combine_scanner.mdl'
ITEM.PetName = 'scannie'
ITEM.NoPreview = true

function ITEM:OnEquip(ply)
	if ply:Alive() then
		ply:CreatePet(self.PetName)
	end
end

function ITEM:OnHolster(ply)
	ply:RemovePet()
end