ITEM.Name = 'Nevermore'
ITEM.Price = 60000
ITEM.Model = 'models/crow.mdl'
ITEM.PetName = 'nevermore'
ITEM.NoPreview = true

function ITEM:OnEquip(ply)
	if ply:Alive() then
		ply:CreatePet(self.PetName)
	end
end

function ITEM:OnHolster(ply)
	ply:RemovePet()
end