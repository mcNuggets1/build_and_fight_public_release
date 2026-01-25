ITEM.Name = 'Rockety'
ITEM.Price = 25000
ITEM.Model = 'models/Items/AR2_Grenade.mdl'
ITEM.PetName = 'rockety'
ITEM.NoPreview = true

function ITEM:OnEquip(ply)
	if ply:Alive() then
		ply:CreatePet(self.PetName)
	end
end

function ITEM:OnHolster(ply)
	ply:RemovePet()
end