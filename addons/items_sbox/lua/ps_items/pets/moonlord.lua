ITEM.Name = 'Moonlord'
ITEM.Price = 170000
ITEM.Model = 'models/lordcthulhu814/moonlord/moonlord.mdl'
ITEM.PetName = 'moonlord'
ITEM.NoPreview = true

function ITEM:OnEquip(ply)
	if ply:Alive() then
		ply:CreatePet(self.PetName)
	end
end

function ITEM:OnHolster(ply)
	ply:RemovePet()
end