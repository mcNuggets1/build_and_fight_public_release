ITEM.Name = 'Brummi'
ITEM.Price = 67000
ITEM.Model = 'models/props_vehicles/car002a_physics.mdl'
ITEM.PetName = 'brummi'
ITEM.NoPreview = true

function ITEM:OnEquip(ply)
	if ply:Alive() then
		ply:CreatePet(self.PetName)
	end
end

function ITEM:OnHolster(ply)
	ply:RemovePet()
end