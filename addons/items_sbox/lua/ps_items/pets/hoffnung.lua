ITEM.Name = 'Hoffnung'
ITEM.Price = 45000
ITEM.Model = 'models/pigeon.mdl'
ITEM.PetName = 'hope'
ITEM.NoPreview = true

function ITEM:OnEquip(ply)
	if ply:Alive() then
		ply:CreatePet(self.PetName)
	end
end

function ITEM:OnHolster(ply)
	ply:RemovePet()
end