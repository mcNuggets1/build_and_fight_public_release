ITEM.Name = 'Mr. Bubbles'
ITEM.Price = 93000
ITEM.Model = 'models/props/de_tides/Vending_turtle.mdl'
ITEM.PetName = 'bubbles'
ITEM.NoPreview = true

function ITEM:OnEquip(ply)
	if ply:Alive() then
		ply:CreatePet(self.PetName)
	end
end

function ITEM:OnHolster(ply)
	ply:RemovePet()
end