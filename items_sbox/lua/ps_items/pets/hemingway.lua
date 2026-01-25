ITEM.Name = 'Hemingway'
ITEM.Price = 80000
ITEM.Model = 'models/props_c17/statue_horse.mdl'
ITEM.PetName = 'hemingway'
ITEM.NoPreview = true

function ITEM:OnEquip(ply)
	if ply:Alive() then
		ply:CreatePet(self.PetName)
	end
end

function ITEM:OnHolster(ply)
	ply:RemovePet()
end