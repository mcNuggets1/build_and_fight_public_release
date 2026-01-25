ITEM.Name = 'Le Boat'
ITEM.Price = 100000
ITEM.Model = 'models/props_canal/boat002b.mdl'
ITEM.PetName = 'le_boat'
ITEM.NoPreview = true

function ITEM:OnEquip(ply)
	if ply:Alive() then
		ply:CreatePet(self.PetName)
	end
end

function ITEM:OnHolster(ply)
	ply:RemovePet()
end