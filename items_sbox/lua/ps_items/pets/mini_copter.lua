ITEM.Name = 'Mini Copter'
ITEM.Price = 80000
ITEM.Model = 'models/Gibs/helicopter_brokenpiece_06_body.mdl'
ITEM.PetName = 'small_copter'
ITEM.NoPreview = true

function ITEM:OnEquip(ply)
	if ply:Alive() then
		ply:CreatePet(self.PetName)
	end
end

function ITEM:OnHolster(ply)
	ply:RemovePet()
end