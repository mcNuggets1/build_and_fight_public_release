ITEM.Name = 'Balloonicorn'
ITEM.Price = 140000
ITEM.Model = 'models/gmod_tower/balloonicorn_nojiggle.mdl'
ITEM.PetName = 'balloonicorn'
ITEM.NoPreview = true

function ITEM:OnEquip(ply)
	if ply:Alive() then
		ply:CreatePet(self.PetName)
	end
end

function ITEM:OnHolster(ply)
	ply:RemovePet()
end