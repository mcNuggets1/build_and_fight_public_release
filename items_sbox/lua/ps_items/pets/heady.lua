ITEM.Name = 'Heady'
ITEM.Price = 70000
ITEM.Model = 'models/Gibs/Antlion_gib_Large_2.mdl'
ITEM.PetName = 'heady'
ITEM.NoPreview = true

function ITEM:OnEquip(ply)
	if ply:Alive() then
		ply:CreatePet(self.PetName)
	end
end

function ITEM:OnHolster(ply)
	ply:RemovePet()
end