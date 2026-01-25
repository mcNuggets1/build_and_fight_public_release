ITEM.Name = 'Skully'
ITEM.Price = 90000
ITEM.Model = 'models/Gibs/HGIBS.mdl'
ITEM.PetName = 'skully'
ITEM.NoPreview = true

function ITEM:OnEquip(ply)
	if ply:Alive() then
		ply:CreatePet(self.PetName)
	end
end

function ITEM:OnHolster(ply)
	ply:RemovePet()
end