ITEM.Name = 'Lammar'
ITEM.Price = 50000
ITEM.Model = 'models/headcrabclassic.mdl'
ITEM.PetName = 'lammar'
ITEM.NoPreview = true

function ITEM:OnEquip(ply)
	if ply:Alive() then
		ply:CreatePet(self.PetName)
	end
end

function ITEM:OnHolster(ply)
	ply:RemovePet()
end