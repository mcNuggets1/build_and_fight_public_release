ITEM.Name = 'Half'
ITEM.Price = 88000
ITEM.Model = 'models/Zombie/Classic_torso.mdl'
ITEM.PetName = 'half'
ITEM.NoPreview = true

function ITEM:OnEquip(ply)
	if ply:Alive() then
		ply:CreatePet(self.PetName)
	end
end

function ITEM:OnHolster(ply)
	ply:RemovePet()
end