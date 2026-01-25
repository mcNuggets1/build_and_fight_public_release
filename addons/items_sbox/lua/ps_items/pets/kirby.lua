ITEM.Name = 'Kirby'
ITEM.Price = 160000
ITEM.Model = 'models/kirby/kirby.mdl'
ITEM.PetName = 'kirby'
ITEM.NoPreview = true

function ITEM:OnEquip(ply)
	if ply:Alive() then
		ply:CreatePet(self.PetName)
	end
end

function ITEM:OnHolster(ply)
	ply:RemovePet()
end