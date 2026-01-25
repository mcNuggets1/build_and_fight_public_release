ITEM.Name = 'Shoe'
ITEM.Price = 73000
ITEM.Model = 'models/props_junk/shoe001a.mdl'
ITEM.PetName = 'shoe'
ITEM.NoPreview = true

function ITEM:OnEquip(ply)
	if ply:Alive() then
		ply:CreatePet(self.PetName)
	end
end

function ITEM:OnHolster(ply)
	ply:RemovePet()
end