ITEM.Name = 'Snow White'
ITEM.Price = 76000
ITEM.Model = 'models/props/cs_office/Snowman_face.mdl'
ITEM.PetName = 'snow_white'
ITEM.NoPreview = true

function ITEM:OnEquip(ply)
	if ply:Alive() then
		ply:CreatePet(self.PetName)
	end
end

function ITEM:OnHolster(ply)
	ply:RemovePet()
end