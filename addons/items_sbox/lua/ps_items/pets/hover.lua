ITEM.Name = 'Hover'
ITEM.Price = 120000
ITEM.Model = 'models/combine_dropship.mdl'
ITEM.PetName = 'hover'
ITEM.NoPreview = true

function ITEM:OnEquip(ply)
	if ply:Alive() then
		ply:CreatePet(self.PetName)
	end
end

function ITEM:OnHolster(ply)
	ply:RemovePet()
end