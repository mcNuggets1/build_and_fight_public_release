ITEM.Name = 'Sensor'
ITEM.Price = 110000
ITEM.Model = 'models/dav0r/hoverball.mdl'
ITEM.PetName = 'sensor'
ITEM.NoPreview = true

function ITEM:OnEquip(ply)
	if ply:Alive() then
		ply:CreatePet(self.PetName)
	end
end

function ITEM:OnHolster(ply)
	ply:RemovePet()
end