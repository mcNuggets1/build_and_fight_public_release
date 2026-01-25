ITEM.Name = 'Real Copter'
ITEM.Price = 100000
ITEM.Model = 'models/combine_helicopter.mdl'
ITEM.PetName = 'real_copter'
ITEM.NoPreview = true

function ITEM:OnEquip(ply)
	if ply:Alive() then
		ply:CreatePet(self.PetName)
	end
end

function ITEM:OnHolster(ply)
	ply:RemovePet()
end