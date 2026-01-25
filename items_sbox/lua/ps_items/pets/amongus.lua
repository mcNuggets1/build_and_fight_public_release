ITEM.Name = 'Imposter'
ITEM.Price = 150000
ITEM.Model = 'models/amongus/amongus.mdl'
ITEM.PetName = 'amongus'
ITEM.NoPreview = true

function ITEM:OnEquip(ply)
	if ply:Alive() then
		ply:CreatePet(self.PetName)
	end
end

function ITEM:OnHolster(ply)
	ply:RemovePet()
end