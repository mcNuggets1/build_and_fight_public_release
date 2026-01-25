ITEM.Name = 'Fishy'
ITEM.Price = 60000
ITEM.Model = 'models/props/CS_militia/fishriver01.mdl'
ITEM.PetName = 'fishy'
ITEM.NoPreview = true

function ITEM:OnEquip(ply)
	if ply:Alive() then
		ply:CreatePet(self.PetName)
	end
end

function ITEM:OnHolster(ply)
	ply:RemovePet()
end