ITEM.Name = 'Vorti'
ITEM.Price = 150000
ITEM.Model = 'models/vortigaunt.mdl'
ITEM.PetName = 'vorti'
ITEM.NoPreview = true

function ITEM:OnEquip(ply)
	if ply:Alive() then
		ply:CreatePet(self.PetName)
	end
end

function ITEM:OnHolster(ply)
	ply:RemovePet()
end