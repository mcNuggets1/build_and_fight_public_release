ITEM.Name = 'Train'
ITEM.Price = 95000
ITEM.Model = 'models/props_trainstation/train001.mdl'
ITEM.PetName = 'train'
ITEM.NoPreview = true

function ITEM:OnEquip(ply)
	if ply:Alive() then
		ply:CreatePet(self.PetName)
	end
end

function ITEM:OnHolster(ply)
	ply:RemovePet()
end